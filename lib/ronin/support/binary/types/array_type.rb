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

module Ronin
  module Support
    module Binary
      module Types
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
          def initialize(type,length)
            @type   = type
            @length = length
            @size   = @type.size * @length

            super(pack_string: @type.pack_string * @length)
          end

          #
          # Initializes a new value for an array type.
          #
          # @return [Array]
          #
          def initialize_value
            Array.new(@length) { @type.initialize_value }
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
          # Packs multiple values into binary data.
          #
          # @param [Array<Integer, Float, String>] values
          #   The values to be packed.
          #
          # @return [String]
          #   The packed binary data.
          #
          def pack(*values)
            values.flatten.pack(@pack_string)
          end

          #
          # Unpacks binary data.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [Array<Integer, Float, String>]
          #   The unpacked values.
          #
          def unpack(data)
            partion_array(@type,data.unpack(@pack_string))
          end

          private

          #
          # Recursively partions the array of values based on whether the given
          # type is an {ArrayType} or not.
          #
          # @param [Type] type
          #   The type of the elements in the Array.
          #
          # @param [Array] values
          #   The array of values to partion.
          #
          def partion_array(type,values)
            case type
            when ArrayType
              # recursively partion the Array depth-first
              values = partion_array(type.type,values)
              values.each_slice(type.length).to_a
            else
              values
            end
          end

        end
      end
    end
  end
end
