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

require 'ronin/support/binary/ctypes/object_type'
require 'ronin/support/binary/ctypes/array_type'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Represents a {Binary::Array} in memory.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class ArrayObjectType < ObjectType

          # The type used for packing literal {::Array} values.
          #
          # @return [ArrayType]
          attr_reader :array_type

          #
          # Initializes the memory-mapped array type.
          #
          # @param [ArrayType] array_type
          #   The array type.
          #
          def initialize(array_type)
            @array_type = array_type

            super(@array_type.size)
          end

          #
          # The type of the element in the memory-mapped array type.
          #
          # @return [Type]
          #
          def type
            @array_type.type
          end

          #
          # The number of elements in the memory-mapped array type.
          #
          # @return [Integer]
          #
          def length
            @array_type.length
          end

          #
          # The alignment, in bytes, of the memory-mapped array type.
          #
          # @return [Integer]
          #
          def alignment
            @array_type.alignment
          end

          #
          # Creates a copy of the array object type with a different
          # {#alignment}.
          #
          # @param [Integer] new_alignment
          #   The new alignment for the new array object type.
          #
          # @return [ArrayObjectType]
          #   The new array object type.
          #
          def align(new_alignment)
            self.class.new(@array_type.align(new_alignment))
          end

          #
          # Packs the memory-mapped array.
          #
          # @param [Binary::Array, ::Array] array
          #   The memory-mapped array.
          #
          # @return [String]
          #   The underlying binary data for the memory object.
          #
          def pack(array)
            case array
            when Binary::Array
              array.to_s
            when ::Array
              @array_type.pack(array)
            end
          end

          #
          # Unpacks the memory-mapped array.
          #
          # @param [String] data
          #   The raw binary data to unpack.
          #
          # @return [Binary::Array]
          #   the memory-mapped Array.
          #
          def unpack(data)
            Binary::Array.new(@array_type.type,data)
          end

          #
          # Enqueues the memory-mapped array into the list of values.
          #
          # @param [Binary::Array, ::Array] values
          #   The flat array of values.
          #
          # @param [Binary::Array, ::Array] array
          #   The memory-mapped array object to enqueue.
          #
          def enqueue_value(values,array)
            case array
            when Binary::Array
              values.push(array.to_s)
            when ::Array
              values.push(@array_type.pack(array))
            end
          end

          #
          # Dequeues a memory object from the flat list of values.
          #
          # @param [::Array] values
          #   The flat array of values.
          #
          # @return [Binary::Array]
          #   The dequeued memory-mapped array object.
          #
          def dequeue_value(values)
            Binary::Array.new(@array_type.type,values.shift)
          end

        end
      end
    end
  end
end
