#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes/aggregate_type'
require 'ronin/support/binary/ctypes/unbounded_array_type'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Represents a bounded array type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class ArrayType < AggregateType

          # The type of each element in the array type.
          #
          # @return [Type]
          attr_reader :type

          # The length of the array type.
          #
          # @return [Integer]
          attr_reader :length

          # The size of the array type.
          #
          # @return [Integer]
          attr_reader :size

          #
          # Initializes the array type.
          #
          # @param [Type] type
          #   The type of each element in the array type.
          #
          # @param [Integer] length
          #   The length of the array type.
          #
          # @param [Integer, nil] alignment
          #   Custom type alignment to override the type's alignment.
          #
          def initialize(type,length, alignment: nil)
            if type.class == UnboundedArrayType
              raise(ArgumentError,"cannot initialize an #{self.class} of #{UnboundedArrayType}")
            end

            @type   = type
            @length = length

            @size      = @type.size * @length
            @alignment = alignment

            super(
              pack_string: if @type.pack_string
                             @type.pack_string * @length
                           end
            )
          end

          #
          # Initializes an Array of uninitialized values.
          #
          # @return [::Array]
          #
          def uninitialized_value
            ::Array.new(@length) { @type.uninitialized_value }
          end

          #
          # The endianness of each element in the bounded array type.
          #
          # @return [:little, :big, nil]
          #   Indicates whether each element is little-endian, big-endian,
          #   or `nil` if each element has no endianness.
          #
          def endian
            @type.endian
          end

          #
          # The alignment, in bytes, for the array type.
          #
          # @return [Integer]
          #
          def alignment
            @alignment || @type.alignment
          end

          #
          # Creates a copy of the array type with a different {#alignment}.
          #
          # @param [Integer] new_alignment
          #   The new alignment for the new array type.
          #
          # @return [ScalarType]
          #   The new array type.
          #
          def align(new_alignment)
            self.class.new(@type,@length, alignment: new_alignment)
          end

          #
          # Indicates whether each element is signed.
          #
          # @return [Boolean]
          #
          def signed?
            @type.signed?
          end

          #
          # Indicates whether each element is unsigned.
          #
          # @return [Boolean]
          #
          def unsigned?
            @type.unsigned?
          end

          #
          # Packs an array of values into the type's binary format.
          #
          # @param [::Array<Integer, Float, String>] array
          #   The array to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          # @api public
          #
          def pack(array)
            if @pack_string
              super(array)
            else
              buffer = String.new("", encoding: Encoding::ASCII_8BIT)

              @length.times do |index|
                value = array[index] || @type.uninitialized_value

                buffer << @type.pack(value)
              end

              return buffer
            end
          end

          #
          # Unpacks an array of binary data.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [::Array<Integer, Float, String, nil>]
          #   The unpacked array.
          #
          # @api public
          #
          def unpack(data)
            if @pack_string
              super(data)
            else
              type_size = @type.size

              ::Array.new(@length) do |index|
                offset = index * type_size

                @type.unpack(data.byteslice(offset,type_size))
              end
            end
          end

          #
          # Enqueues an array of values onto the flat list of values.
          #
          # @param [::Array] values
          #   The flat array of values.
          #
          # @param [::Array] array
          #   The array to enqueue.
          #
          # @api private
          #
          def enqueue_value(values,array)
            @length.times do |index|
              value = array[index] || @type.uninitialized_value

              @type.enqueue_value(values,value)
            end
          end

          #
          # Dequeues an array from the flat list of values.
          #
          # @param [::Array] values
          #   The flat array of values.
          #
          # @return [::Array]
          #   The dequeued array.
          #
          # @api private
          #
          def dequeue_value(values)
            ::Array.new(@length) do
              @type.dequeue_value(values)
            end
          end

        end
      end
    end
  end
end
