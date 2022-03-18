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

require 'ronin/support/binary/types/type'
require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/unbounded_array_type'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Base class for all scalar types.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class ScalarType < Type

          # The size in bytes of the type.
          #
          # @return [1, 2, 4, 8]
          attr_reader :size

          # The endian-ness of the type.
          #
          # @return [:little, :big, nil]
          attr_reader :endian

          # Indicates whether the type is signed.
          #
          # @return [Boolean]
          attr_reader :signed

          #
          # Initializes the scalar type.
          #
          # @param [:little, :big, nil] endian
          #   The endianness of the scalar type. `nil` indicates the type has no
          #   endianness.
          #
          # @param [1, 2, 4, 8] size
          #   The scalar type's size in bytes.
          #
          # @param [Boolean] signed
          #   Indicates whether the scalar type is signed or unsigned.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option kwargs [String] :pack_string
          #   The String for `Array#pack` or `String#unpack`.
          #
          def initialize(size: , endian: , signed: , **kwargs)
            super(**kwargs)

            @endian = endian
            @size   = size
            @signed = signed
          end

          # 
          # Whether the scalar type is signed.
          #
          # @return [Boolean]
          #
          def signed?
            @signed
          end

          # 
          # Whether the scalar type is unsigned.
          #
          # @return [Boolean]
          #
          def unsigned?
            !@signed
          end

          #
          # Creates an Array type around the type.
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

        end
      end
    end
  end
end
