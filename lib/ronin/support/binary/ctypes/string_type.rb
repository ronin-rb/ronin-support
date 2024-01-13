# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/support/binary/ctypes/type'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Represents a C string type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class StringType < Type

          #
          # Initializes the string type.
          #
          def initialize
            super(pack_string: 'Z*')
          end

          #
          # Indicates that Strings can have arbitrary size.
          #
          # @return [Float::INFINITY]
          #
          def size
            Float::INFINITY
          end

          alias length size

          #
          # The alignment for the string type
          #
          # @return [1]
          #
          def alignment
            1
          end

          #
          # Indicates that the String contains signed characters.
          #
          # @return [true]
          #
          def signed?
            true
          end

          #
          # Indicates that the String does not contains unsigned characters.
          #
          # @return [false]
          #
          def unsigned?
            false
          end

          #
          # Packs the String into a null-terminated C String.
          #
          # @param [String] value
          #   The String to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          # @api public
          #
          def pack(value)
            [value].pack(@pack_string)
          end

          #
          # Unpacks a null-terminated C String.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [String, nil]
          #   The unpacked String.
          #
          # @api public
          #
          def unpack(data)
            data.unpack1(@pack_string)
          end

          #
          # Enqueues a string onto the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [String, nil] value
          #   The string to enqueue.
          #
          # @api private
          #
          def enqueue_value(values,value)
            values.push(value)
          end

          #
          # Dequeues a string from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [String]
          #   The dequeued string.
          #
          # @api private
          #
          def dequeue_value(values)
            values.shift
          end

        end
      end
    end
  end
end
