#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/output/output'

module Ronin
  module UI
    module Output
      #
      # Helper methods for printing output.
      #
      module Helpers
        #
        # Writes data unless output has been silenced.
        #
        # @param [String, Object] data
        #   The data to write.
        #
        # @return [Integer, nil]
        #   The number of bytes written.
        #
        # @since 1.0.0
        #
        # @api public
        #
        def write(data)
          unless Output.silent?
            data = data.to_s

            Output.handler.write(data)
            return data.length
          end
        end

        #
        # Prints a character.
        #
        # @param [String, Integer] data
        #   The character or byte to print.
        #
        # @return [String, Integer]
        #   The byte or character.
        #
        # @since 1.0.0
        #
        # @api public
        #
        def putc(data)
          char = data.chr if data.kind_of?(Integer)

          write(data)
          return data
        end

        #
        # Prints one or more messages.
        #
        # @param [Array] arguments
        #   The messages to print.
        #
        # @example
        #   puts 'some data'
        #
        # @since 0.3.0
        #
        # @api public
        #
        def puts(*arguments)
          if arguments.empty?
            write($/)
            return nil
          end

          arguments.each do |argument|
            if argument.kind_of?(Array)
              argument.each { |element| puts(element) }
            else
              str = case argument
                    when nil
                      if RUBY_VERSION > '1.9' then ''
                      else                         'nil'
                      end
                    else
                      argument.to_s
                    end

              write("#{str}#{$/}")
            end
          end

          return nil
        end

        #
        # Prints formatted data.
        #
        # @param [String] format
        #   The format string.
        #
        # @param [Array] arguments
        #   The data to format.
        #
        # @return [nil]
        # 
        # @since 1.0.0
        #
        # @api public
        #
        def printf(format,*arguments)
          write(format % arguments)
          return nil
        end

        #
        # Prints an `info` message.
        #
        # @param [Array] message
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
        # @since 0.3.0
        #
        # @api public
        #
        def print_info(*message)
          unless Output.silent?
            Output.handler.print_info(Helpers.format(message))
            return true
          end

          return false
        end

        #
        # Prints a `debug` message.
        #
        # @param [Array, String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example Print a formatted message:
        #   print_debug "vars: %p %p", vars[0], vars[1]
        #
        # @since 0.3.0
        #
        # @api public
        #
        def print_debug(*message)
          if (Output.verbose? && !(Output.silent?))
            Output.handler.print_debug(Helpers.format(message))
            return true
          end

          return false
        end

        #
        # Prints a `warning` message.
        #
        # @param [Array, String] message
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
        # @since 0.3.0
        #
        # @api public
        #
        def print_warning(*message)
          unless Output.silent?
            Output.handler.print_warning(Helpers.format(message))
            return true
          end
          
          return false
        end

        #
        # Prints an `error` message.
        #
        # @param [Array, String] message
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
        # @since 0.3.0
        #
        # @api public
        #
        def print_error(*message)
          unless Output.silent?
            Output.handler.print_error(Helpers.format(message))
            return true
          end

          return false
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
        # @since 0.4.0
        #
        # @api public
        #
        def print_exception(exception)
          return false if Output.silent?

          print_error "#{exception.class}: #{exception.message}"

          if Output.verbose?
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
        def Helpers.format(arguments)
          unless arguments.length == 1
            arguments.first % arguments[1..-1]
          else
            arguments.first
          end
        end
      end
    end
  end
end
