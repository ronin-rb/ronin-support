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

module Ronin
  module UI
    #
    # Spawns a ReadLine powered REPL.
    #
    #   REPL.start(prompt: '$') { |line| system(line) }
    #
    # @api semipublic
    #
    # @since 0.6.0
    #
    class REPL

      include Printing

      # Default shell prompt
      DEFAULT_PROMPT = '>'

      # The shell name
      attr_accessor :name

      # The shell prompt
      attr_accessor :prompt

      #
      # Initializes the REPL.
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
      # @raise [ArgumentError]
      #   No block was given.
      #
      def initialize(options={},&block)
        unless block
          raise(ArgumentError,"#{self.class}##{__method__} requires a block")
        end

        @name    = options[:name]
        @prompt  = options.fetch(:prompt,DEFAULT_PROMPT)
        @handler = block
      end

      #
      # Creates a new REPL object and starts it.
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
      # @yield [line]
      #   The block that will be passed every command entered.
      #
      # @yieldparam [String] line
      #   The command entered into the shell.
      #
      # @return [nil]
      #
      # @example
      #   REPL.start(prompt: '$') { |line| system(line) }
      #
      def self.start(options={},&block)
        new(options,&block).start
      end

      #
      # Starts the REPL.
      #
      def start
        previous_history = Readline::HISTORY.each.to_a
        Readline::HISTORY.clear

        loop do
          begin
            unless (line = Readline.readline("#{name}#{prompt} "))
              break
            end

            break unless line

            unless line.empty?
              Readline::HISTORY << line

              begin
                @handler.call(line)
              rescue => e
                print_error "#{e.class.name}: #{e.message}"
              end
            end
          rescue Interrupt
            break
          end
        end

      ensure
        stop

        Readline::HISTORY.clear
        previous_history.each { |line| Readline::HISTORY << line }
        return nil
      end

      #
      # Stops the REPL and cleans up.
      #
      # @abstract
      #
      def stop
      end

    end
  end
end
