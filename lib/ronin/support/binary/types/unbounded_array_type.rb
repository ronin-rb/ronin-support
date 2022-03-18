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
          def initialize(type)
            @type = type

            super(pack_string: "#{@type.pack_string}*")
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
          # The "size" in bytes of the unbounded array type.
          #
          # @return [Float::INFINITY]
          #
          def size
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
          # Packs multiple values into binary data.
          #
          # @param [Array<Integer, Float, String>] values
          #   The values to be packed.
          #
          # @return [String]
          #   The packed binary data.
          #
          def pack(*values)
            values.pack(@pack_string)
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
            data.unpack(@pack_string)
          end

        end
      end
    end
  end
end
