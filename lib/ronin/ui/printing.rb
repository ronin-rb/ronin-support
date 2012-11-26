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
    #
    # Printing methods.
    #
    # @since 0.6.0
    #
    module Printing

      # ANSI Green code
      GREEN = "\e[32m"

      # ANSI Cyan code
      CYAN = "\e[36m"

      # ANSI Yellow code
      YELLOW = "\e[33m"

      # ANSI Red code
      RED = "\e[31m"

      # ANSI Bright code
      BRIGHT = "\e[1m"

      # ANSI Bright-Off code
      BRIGHT_OFF = "\e[21m"

      # ANSI Clear code
      CLEAR = "\e[0m"

      #
      # Determines if verbose printing is enabled.
      #
      # @return [Boolean]
      #   Specifies whether verbose printing is enabled.
      #
      # @api semipublic
      #
      def self.verbose?
        @mode == :verbose
      end

      #
      # Enables verbose printing.
      #
      # @return [Printing]
      #
      # @api semipublic
      #
      def self.verbose!
        @mode = :verbose
        return self
      end

      #
      # Determines if normal printing is enabled.
      #
      # @return [Boolean]
      #   Specifies whether normal printing is enabled.
      #
      # @api semipublic
      #
      def self.normal?
        @mode.nil?
      end

      #
      # Enables normal printing.
      #
      # @return [Printing]
      #
      # @api semipublic
      #
      def self.normal!
        @mode = nil
        return self
      end

      #
      # Determines if quiet printing is enabled.
      #
      # @return [Boolean]
      #   Specifies whether quiet printing is enabled.
      #
      # @api semipublic
      #
      def self.quiet?
        @mode == :quiet
      end

      #
      # Enables quiet printing.
      #
      # @return [Printing]
      #
      # @api semipublic
      #
      def self.quiet!
        @mode = :quiet
        return self
      end

      #
      # Determines if silent printing is enabled.
      #
      # @return [Boolean]
      #   Specifies whether silent printing is enabled.
      #
      # @api semipublic
      #
      def self.silent?
        @mode == :silent
      end

      #
      # Enables silent printing.
      #
      # @return [Printing]
      #
      # @api semipublic
      #
      def self.silent!
        @mode = :silent
        return self
      end

      #
      # Prints an `info` message.
      #
      # @param [Array] arguments
      #   The arguments to print.
      #
      # @return [Boolean]
      #   Specifies whether the messages were successfully printed.
      #
      # @example
      #   print_info "Connecting ..."
      #
      # @example Print a formatted message:
      #   print_info "Connected to %s", host
      #
      # @note
      #   Will return `false` is quiet printing is enabled.
      #
      # @api public
      #
      def print_info(*arguments)
        return false if (Printing.silent? || Printing.quiet?)

        message = format(*arguments)

        if $stdout.tty?
          $stdout.puts "#{GREEN}#{BRIGHT}[-]#{BRIGHT_OFF} #{message}#{CLEAR}"
        else
          $stdout.puts "[-] #{message}"
        end

        return true
      end

      #
      # Prints a `debug` message.
      #
      # @param [Array, String] arguments
      #   The arguments to print.
      #
      # @return [Boolean]
      #   Specifies whether the messages were successfully printed.
      #
      # @example Print a formatted message:
      #   print_debug "vars: %p %p", vars[0], vars[1]
      #
      # @note
      #   Will return `false` unless verbose printing is enabled.
      #
      # @api public
      #
      def print_debug(*arguments)
        return false unless Printing.verbose?

        message = format(*arguments)

        if $stdout.tty?
          $stdout.puts "#{CYAN}#{BRIGHT}[?]#{BRIGHT_OFF} #{message}#{CLEAR}"
        else
          $stdout.puts "[?] #{message}"
        end

        return true
      end

      #
      # Prints a `warning` message.
      #
      # @param [Array] arguments
      #   The arguments to print.
      #
      # @return [Boolean]
      #   Specifies whether the messages were successfully printed.
      #
      # @example
      #   print_warning "Detecting a restricted character in the buffer"
      #
      # @example Print a formatted message:
      #   print_warning "Malformed input detected: %p", user_input
      #
      # @note
      #   Will return `false` if quiet printing is enabled.
      #
      # @api public
      #
      def print_warning(*arguments)
        return false if (Printing.silent? || Printing.quiet?)

        message = format(*arguments)

        if $stdout.tty?
          $stdout.puts "#{YELLOW}#{BRIGHT}[*]#{BRIGHT_OFF} #{message}#{CLEAR}"
        else
          $stdout.puts "[*] #{message}"
        end

        return true
      end

      #
      # Prints an `error` message.
      #
      # @param [Array] arguments
      #   The arguments to print.
      #
      # @return [Boolean]
      #   Specifies whether the messages were successfully printed.
      #
      # @example
      #   print_error "Could not connect!"
      #
      # @example Print a formatted message:
      #   print_error "%p: %s", error.class, error.message
      #
      # @api public
      #
      def print_error(*arguments)
        return false if Printing.silent?

        message = Printing.format(*arguments)

        if $stdout.tty?
          $stdout.puts "#{RED}#{BRIGHT}[!]#{BRIGHT_OFF} #{message}#{CLEAR}"
        else
          $stdout.puts "[!] #{message}"
        end

        return true
      end

      #
      # Prints an exception.
      #
      # @param [Exception] exception
      #   The exception to print.
      #
      # @return [Boolean]
      #   Specifies whether the exception was printed or not.
      #
      # @example
      #   begin
      #     socket.write(buffer)
      #   rescue => e
      #     print_exception(e)
      #   end
      #
      # @note
      #   Will printing a five line backtrace if verbose printing is enabled.
      #
      # @api public
      #
      def print_exception(exception)
        print_error "#{exception.class}: #{exception.message}"

        if Printing.verbose?
          exception.backtrace[0,5].each do |line|
            print_error "  #{line}"
          end
        end

        return true
      end

      protected

      #
      # Formats a message to be printed.
      #
      # @param [Array] arguments
      #   The message and additional Objects to format.
      #
      # @return [String]
      #   The formatted message.
      #
      # @api private
      #
      def Printing.format(*arguments)
        unless arguments.length == 1 then arguments.first % arguments[1..-1]
        else                              arguments.first
        end
      end
    end
  end
end
