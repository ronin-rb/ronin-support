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

        #
        # Prints an `info` message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_info "Connecting ..."
        #   # [=] Connecting ...
        #
        # @note
        #   Will return `false` is quiet printing is enabled.
        #
        # @api public
        #
        def print_info(message)
          $stdout.puts "#{ANSI.white(ANSI.bold('[=]'))} #{message}"
          return true
        end

        #
        # Prints a `debug` message.
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
          if Printing.debug?
            $stdout.puts "#{ANSI.cyan(ANSI.bold('[?]'))} #{message}"
            return true
          else
            return false
          end
        end

        #
        # Prints a `warning` message.
        #
        # @param [String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_warning "Detecting a restricted character in the buffer"
        #   # [*] Detecting a restricted character in the buffer
        #
        # @note
        #   Will return `false` if quiet printing is enabled.
        #
        # @api public
        #
        def print_warning(message)
          $stdout.puts "#{ANSI.yellow(ANSI.bold('[*]'))} #{message}"
          return true
        end

        #
        # Prints an `error` message.
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
          $stdout.puts "#{ANSI.red(ANSI.bold('[!]'))} #{message}"
          return true
        end

        #
        # Prints a `positive` message.
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
        # @since 0.6.0
        #
        def print_positive(message)
          $stdout.puts "#{ANSI.green(ANSI.bold('[+]'))} #{message}"
          return true
        end

        alias print_success print_positive
      end
    end
  end
end
