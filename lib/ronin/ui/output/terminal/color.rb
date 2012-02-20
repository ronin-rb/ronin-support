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

module Ronin
  module UI
    module Output
      module Terminal
        #
        # The handler for color output to the terminal.
        #
        class Color

          # ANSI Green code
          GREEN = "\e[32m"

          # ANSI Cyan code
          CYAN = "\e[36m"

          # ANSI Yellow code
          YELLOW = "\e[33m"

          # ANSI Red code
          RED = "\e[31m"

          # ANSI Clear code
          CLEAR = "\e[0m"

          #
          # Writes data to `STDOUT`.
          #
          # @param [String] data
          #   The data to write.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.write(data)
            $stdout.write(data)
          end

          #
          # Prints an `info` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.print_info(message)
            $stdout.puts "#{GREEN}[-] #{message}#{CLEAR}"
          end

          #
          # Prints a `debug` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.print_debug(message)
            $stdout.puts "#{CYAN}[=] #{message}#{CLEAR}"
          end

          #
          # Prints a `warning` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.print_warning(message)
            $stdout.puts "#{YELLOW}[*] #{message}#{CLEAR}"
          end

          #
          # Prints an `error` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.print_error(message)
            $stdout.puts "#{RED}[!] #{message}#{CLEAR}"
          end

        end
      end
    end
  end
end
