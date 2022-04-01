#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
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

module Ronin
  module Support
    module Binary
      module Types
        #
        # Base class for all types.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class Type

          # The String for `Array#pack` or `String#unpack`.
          #
          # @return [String, nil]
          #
          # @note
          #   May return `nil` if the type does not map to a Ruby pack-string.
          attr_reader :pack_string

          #
          # Initializes the type.
          #
          # @param [String, nil] pack_string
          #   The String for `Array#pack` or `String#unpack`.
          #
          def initialize(pack_string: )
            @pack_string = pack_string
          end

          #
          # Creates an Array type around the scalar type.
          #
          # @param [Integer, nil] length
          #   The length of the Array.
          #
          # @return [ArrayType, UnboundedArrayType]
          #   The new Array type or an unbounded Array type if `length` was not
          #   given.
          #
          def [](length=nil)
            if length then ArrayType.new(self,length)
            else           UnboundedArrayType.new(self)
            end
          end

          #
          # The default uniniitalized value for the type.
          #
          # @return [nil]
          #
          # @abstract
          #
          def uninitialized_value
            nil
          end

          #
          # Packs the value into the type's binary format.
          #
          # @param [Object] value
          #   The value to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          # @abstract
          #
          def pack(value)
            raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
          end

          #
          # Unpacks the binary data.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [Object]
          #   The unpacked value.
          #
          # @abstract
          #
          def unpack(data)
            raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
          end

          #
          # Enqueues a value onto the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [Object] value
          #   The value to enqueue.
          #
          # @abstract
          #
          # @api private
          #
          def enqueue_value(values,value)
            raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
          end

          #
          # Dequeues a value from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [Object]
          #   The dequeued value.
          #
          # @abstract
          #
          # @api private
          #
          def dequeue_value(values)
            raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
          end

        end
      end
    end
  end
end
