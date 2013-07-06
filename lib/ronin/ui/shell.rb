#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/ui/printing'

require 'readline'
require 'set'

module Ronin
  module UI
    #
    # Spawns a ReadLine powered interactive Shell.
    #
    # ## Simple Shell
    #
    #     require 'ronin/ui/shell'
    #     require 'ronin/network/tcp'
    #
    #     include Ronin::Network::TCP
    #
    #     tcp_session('victim.com',1337) do |socket|
    #       UI::Shell.new(name: 'bind_shell') do |shell,line|
    #         socket.puts "#{line}; echo 'EOC'"
    #
    #         socket.each_line do |output|
    #           puts output
    #
    #           break if output.chomp == 'EOC'
    #         end
    #       end
    #     end
    #
    # ## Shell with Commands
    #
    #     require 'ronin/ui/shell'
    #     require 'ronin/network/http'
    #
    #     class HTTPShell < Ronin::UI::Shell
    #
    #       include Ronin::Network::HTTP
    #
    #       def initialize(host)
    #         super(name: host)
    #
    #         @host = host
    #       end
    #
    #       protected
    #
    #       def get(path)
    #         print_response http_get(host: @host, path: path)
    #       end
    #
    #       def post(path,*params)
    #         print_response http_post(
    #           host:      @host,
    #           path:      path,
    #           post_data: Hash[params.map { |param| param.split('=') }]
    #         )
    #       end
    #
    #       private
    #
    #       def print_response(response)
    #         response.canonical_each do |name,value|
    #           puts "#{name}: #{value}"
    #         end
    #
    #         puts
    #
    #         puts response.body
    #       end
    #
    #     end
    #
    # @api semipublic
    #
    class Shell

      include Printing

      # Default shell prompt
      DEFAULT_PROMPT = '>'

      # The shell name
      attr_accessor :name

      # The shell prompt
      attr_accessor :prompt

      # The commands available for the shell
      attr_reader :commands

      #
      # Creates a new shell.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :name ('')
      #   The shell-name to use before the prompt.
      #
      # @option options [String] :prompt (DEFAULT_PROMPT)
      #   The prompt to use for the shell.
      #
      # @yield [shell, line]
      #   The block that will be passed every command entered.
      #
      # @yieldparam [Shell] shell
      #   The shell to use for output.
      #
      # @yieldparam [String] line
      #   The command entered into the shell.
      #
      # @api semipublic
      #
      # @since 0.3.0
      #
      def initialize(options={},&block)
        @name     = options[:name]
        @prompt   = options.fetch(:prompt,DEFAULT_PROMPT)

        @commands = Set['help', 'exit']

        self.class.ancestors.each do |subclass|
          if subclass < Shell
            subclass.protected_instance_methods(false).each do |name|
              @commands << name.to_s
            end
          end
        end


        @input_handler = block
      end

      #
      # Creates a new Shell object and starts it.
      #
      # @param [Array] arguments
      #   Arguments for {#initialize}.
      #
      # @yield [shell, line]
      #   The block that will be passed every command entered.
      #
      # @yieldparam [Shell] shell
      #   The shell to use for output.
      #
      # @yieldparam [String] line
      #   The command entered into the shell.
      #
      # @return [nil]
      #
      # @example
      #   Shell.start(prompt: '$') { |shell,line| system(line) }
      #
      def self.start(*arguments,&block)
        new(*arguments,&block).start
      end

      #
      # Starts the shell.
      #
      # @since 0.3.0
      #
      def start
        history_rollback = 0

        loop do
          unless (raw_line = Readline.readline("#{name}#{prompt} "))
            break # user exited the shell
          end

          line = raw_line.strip

          if (line == 'exit' || line == 'quit')
            exit
            break
          elsif !(line.empty?)
            Readline::HISTORY << raw_line
            history_rollback += 1

            begin
              run(line)
            rescue => e
              print_error "#{e.class.name}: #{e.message}"
            end
          end
        end

        history_rollback.times { Readline::HISTORY.pop }
        return nil
      end

      #
      # Handles input for the shell.
      #
      # @param [String] line
      #   A line of input received by the shell.
      # 
      # @since 0.6.0
      #
      # @api semipublic
      #
      def run(line)
        if @input_handler
          @input_handler.call(self,line)
        else
          arguments = line.split(/\s+/)
          command   = arguments.shift

          # ignore empty lines
          return false unless command

          # no explicitly calling handler
          return false if command == 'handler'

          unless @commands.include?(command)
            print_error "Invalid command: #{command}"
            return false
          end

          return send(command,*arguments)
        end
      end

      #
      # Writes output to the shell.
      #
      # @param [String] message
      #   The message to print.
      #
      def write(message)
        $stdout.write(message)
      end

      alias << write

      protected

      #
      # Method which is called before exiting the shell.
      #
      # @since 0.3.0
      #
      def exit
      end

      #
      # @see #exit
      #
      # @since 0.3.0
      #
      def quit
        exit
      end

      #
      # Prints the available commands and their arguments.
      #
      # @since 0.3.0
      #
      def help
        puts "Available commands:"
        puts

        @commands.sort.each do |name|
          command_method = method(name)
          arguments = command_method.parameters.map do |param|
            case param[0]
            when :opt  then "[#{param[1]}]"
            when :rest then "[#{param[1]} ...]"
            else                param[1]
            end
          end

          puts "  #{name} #{arguments.join(' ')}"
        end
      end

    end
  end
end
