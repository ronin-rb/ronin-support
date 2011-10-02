#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/output/helpers'

module Ronin
  module UI
    #
    # Spawns a ReadLine powered interactive Shell.
    #
    # @api semipublic
    #
    class Shell

      include Output::Helpers

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
        @name     = options.fetch(:name,'')
        @prompt   = options.fetch(:prompt,DEFAULT_PROMPT)
        @commands = protected_methods(false).map { |name| name.to_sym }

        @handler_block = block
      end

      #
      # Creates a new Shell object and starts it.
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
      # @return [nil]
      #
      # @example
      #   Shell.start(:prompt => '$') { |shell,line| system(line) }
      #
      def self.start(options={},&block)
        new(options,&block).start
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
            break
          elsif !(line.empty?)
            Readline::HISTORY << raw_line
            history_rollback += 1

            begin
              handler(line)
            rescue => e
              print_error "#{e.class.name}: #{e.message}"
            end
          end
        end

        history_rollback.times { Readline::HISTORY.pop }
        return nil
      end

      protected

      #
      # Handles input for the shell.
      #
      # @param [String] line
      #   A line of input received by the shell.
      # 
      # @since 0.3.0
      #
      def handler(line)
        if @handler_block
          @handler_block.call(self,line)
        else
          command, arguments = line.split(/\s+/)

          # ignore empty lines
          return unless command

          command = command.to_sym

          # no explicitly calling handler
          return if command == :handler

          unless @commands.include?(command)
            print_error "Invalid command: #{command}"
            return
          end

          send(command,*arguments)
        end
      end

    end
  end
end
