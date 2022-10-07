#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/cli/ansi'

module Ronin
  module Support
    module CLI
      #
      # Printing methods.
      #
      # @since 1.0.0
      #
      module Printing
        @@debug = false

        #
        # The current debug mode.
        #
        # @return [Boolean]
        #   The new debug mode.
        #
        # @api semipublic
        #
        def self.debug?
          @@debug
        end

        #
        # Sets the debug mode.
        #
        # @param [Boolean] debug_mode
        #   The new debug mode.
        #
        # @return [Boolean]
        #   The new debug mode.
        #
        # @api semipublic
        #
        def self.debug=(debug_mode)
          @@debug = debug_mode
        end

        # Enables or disables debug mode.
        #
        # @api semipublic
        attr_writer :debug

        #
        # Determines if debug mode has been enabled.
        #
        # @return [Boolean]
        #
        # @api public
        #
        def debug?
          @debug || Printing.debug?
        end

        #
        # Prints an info message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_info "Connecting ..."
        #   # [*] Connecting ...
        #
        # @api public
        #
        def print_info(message)
          $stdout.puts "#{ANSI.bold(ANSI.white('[*]'))} #{message}#{ANSI.reset}"
          return true
        end

        alias print_status print_info

        #
        # Prints a debug message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_debug "debug information here"
        #   # [?] debug information here
        #
        # @note
        #   Will return `false` unless verbose printing is enabled.
        #
        # @api public
        #
        def print_debug(message)
          if debug?
            $stdout.puts "#{ANSI.bold(ANSI.yellow('[?]'))} #{message}#{ANSI.reset}"
            return true
          else
            return false
          end
        end

        #
        # Prints a warning message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_warning "Rate limit exceeded, slowing down scanning."
        #   # [~] Rate limit exceeded, slowing down scanning.
        #
        # @api public
        #
        def print_warning(message)
          $stdout.puts "#{ANSI.bold(ANSI.yellow('[~]'))} #{message}#{ANSI.reset}"
          return true
        end

        #
        # Prints an error message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_error "Could not connect!"
        #   # [!] Could not connect!
        #
        # @api public
        #
        def print_error(message)
          $stdout.puts "#{ANSI.bold(ANSI.red('[!]'))} #{message}#{ANSI.reset}"
          return true
        end

        #
        # Prints a positive message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_positive "Password worked!"
        #   # [+] Password worked!
        #
        # @api public
        #
        # @since 1.0.0
        #
        def print_positive(message)
          $stdout.puts "#{ANSI.bold(ANSI.green('[+]'))} #{message}#{ANSI.reset}"
          return true
        end

        alias print_success print_positive
        alias print_good print_positive

        #
        # Prints a negative message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_negative "Password failed!"
        #   # [-] Password failed!
        #
        # @api public
        #
        # @since 1.0.0
        #
        def print_negative(message)
          $stdout.puts "#{ANSI.bold(ANSI.red('[-]'))} #{message}#{ANSI.reset}"
          return true
        end

        alias print_failure print_negative
        alias print_bad print_negative
      end
    end
  end
end
