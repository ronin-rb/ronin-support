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

require 'ronin/support/binary/types/aggregate_type'
require 'ronin/support/binary/types/scalar_type'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Represents an unbounded array type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class UnboundedArrayType < AggregateType

          # The type of each element in the unbounded array type.
          #
          # @return [Type]
          attr_reader :type

          #
          # Initializes the unbounded array type.
          #
          # @param [Type] type
          #   The type of each element in the unbounded array type.
          #
          # @raise [ArgumentError]
          #   Cannot initialize a nested {UnboundedArrayType}.
          #
          def initialize(type)
            if type.class == UnboundedArrayType
              raise(ArgumentError,"cannot initialize a nested #{UnboundedArrayType}")
            end

            @type = type

            super(
              # "T*" syntax only works on individual pack-string codes,
              # so we only set #pack_string for scalar types that also have
              # a #pack_string.
              pack_string: if @type.kind_of?(ScalarType) && @type.pack_string
                             "#{@type.pack_string}*"
                           end
            )
          end

          #
          # The "size" in bytes of the unbounded array type.
          #
          # @return [Float::INFINITY]
          #
          def size
            Float::INFINITY
          end

          #
          # The "length" of the unbounded array type.
          #
          # @return [Float::INFINITY]
          #
          def length
            Float::INFINITY
          end

          #
          # The endianness of each element in the unbounded array.
          #
          # @return [:little, :big, nil]
          #   Indicates whether each element is little-endian, big-endian,
          #   or `nil` if each element has no endianness.
          #
          def endian
            @type.endian
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
          # @param [Array<Integer, Float, String>] value
          #   The array to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          def pack(array)
            if @pack_string
              values = enqueue_value([],array)

              return super(values)
            else
              buffer = String.new('', encoding: Encoding::ASCII_8BIT)

              array.each do |element|
                buffer << @type.pack(element)
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
          # @return [Array<Integer, Float, String, nil>]
          #   The unpacked array.
          #
          def unpack(data)
            if @pack_string
              values = super(data)

              return dequeue_value(values)
            else
              case @type
              when StringType
                array = []
                offset = 0
                length = data.bytesize

                while offset < length
                  string = @type.unpack(data[offset..])
                  array  << string

                  offset += string.bytesize + 1
                end

                return array
              else
                type_size = @type.size

                (0...data.bytesize).step(type_size).map do |offset|
                  @type.unpack(data.byteslice(offset,type_size))
                end
              end
            end
          end

          #
          # Enqueues an array of values onto the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [Array] array
          #   The array to enqueue.
          #
          # @api private
          #
          def enqueue_value(values,array)
            array.each do |element|
              @type.enqueue_value(values,element)
            end
          end

          #
          # Dequeues an array from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [Array]
          #   The dequeued array.
          #
          # @api private
          #
          def dequeue_value(values)
            array = []

            until values.empty?
              array << @type.dequeue_value(values)
            end

            return array
          end

        end
      end
    end
  end
end
