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

require 'ronin/cli/ansi'

module Ronin
  module CLI
    #
    # Printing methods.
    #
    # @since 0.6.0
    #
    module Printing
      @mode = (($DEBUG || $VERBOSE) ? :verbose : nil)

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
      # @param [String] message
      #   The message to print.
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
      def print_info(message)
        return false if (Printing.silent? || Printing.quiet?)

        $stdout.puts ANSI.green("#{ANSI.bold('[-]')} #{message}")
        return true
      end

      #
      # Prints a `debug` message.
      #
      # @param [String] nessage
      #   The message to print.
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
      def print_debug(message)
        return false unless Printing.verbose?

        $stdout.puts ANSI.cyan("#{ANSI.bold('[?]')} #{message}")
        return true
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
      #
      # @example Print a formatted message:
      #   print_warning "Malformed input detected: %p", user_input
      #
      # @note
      #   Will return `false` if quiet printing is enabled.
      #
      # @api public
      #
      def print_warning(message)
        return false if (Printing.silent? || Printing.quiet?)

        $stdout.puts ANSI.yellow("#{ANSI.bold('[*]')} #{message}")
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
      #
      # @example Print a formatted message:
      #   print_error "%p: %s", error.class, error.message
      #
      # @api public
      #
      def print_error(message)
        return false if Printing.silent?

        $stdout.puts ANSI.red("#{ANSI.bold('[!]')} #{message}")
        return true
      end

      #
      # Prints a `success` message.
      #
      # @param [String] message
      #   The message to print.
      #
      # @return [Boolean]
      #   Specifies whether the messages were successfully printed.
      #
      # @example
      #   print_success "Password worked!"
      #
      # @example Print a formatted message:
      #   print_success "Valid ID: 0x%x", id
      #
      # @api public
      #
      # @since 0.6.0
      #
      def print_success(message)
        return false if Printing.silent?

        $stdout.puts ANSI.white("#{ANSI.bold('[+]')} #{message}")
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
    end
  end
end
