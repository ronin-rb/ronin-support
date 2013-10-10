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

require 'ronin/ui/repl'
require 'ronin/ui/printing'

require 'set'
require 'shellwords'

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
    # @since 0.3.0
    #
    class Shell < REPL

      include Printing

      # The commands available for the shell
      #
      # @return [Set[String]]
      attr_reader :commands

      # The command aliases
      #
      # @return [Hash{String => String}]
      attr_reader :aliases

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
      def initialize(options={})
        @commands = Set['help', 'exit']
        @aliases  = {
          '?'    => 'help',
          'quit' => 'exit'
        }

        self.class.ancestors.each do |subclass|
          if subclass < Shell
            subclass.protected_instance_methods(false).each do |name|
              @commands << name.to_s
            end
          end
        end

        super(options,&method(:run))
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
        arguments = Shellwords.split(line.strip)
        command   = arguments.shift
        command   = @aliases.fetch(command,command)

        case command
        when nil, 'run'  then return false
        else
          unless @commands.include?(command)
            print_error "Invalid command: #{arguments[0]}"
            return false
          end

          return send(command,*arguments)
        end
      end

      protected

      #
      # Method which is called before exiting the shell.
      #
      # @since 0.3.0
      #
      def exit
        raise Interrupt
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
