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
          # Packs the value into the scalar type's binary format.
          #
          # @param [Integer, Float, String] value
          #   The value to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          # @raise [NotImplementedError]
          #   {#pack_string} was not set.
          #
          def pack(value)
            if @pack_string
              [value].pack(@pack_string)
            else
              raise(NotImplementedError,"#{self.class} does not define a #pack_string")
            end
          end

          #
          # Unpacks the binary data.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [Integer, Float, String, nil]
          #   The unpacked value.
          #
          # @raise [NotImplementedError]
          #   {#pack_string} was not set.
          #
          def unpack(data)
            if @pack_string
              data.unpack1(@pack_string)
            else
              raise(NotImplementedError,"#{self.class} does not define a #pack_string")
            end
          end

          #
          # Enqueues a scalar value onto the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [Integer, Float, String, nil] value
          #   The scalar value to enqueue.
          #
          # @api private
          #
          def enqueue_value(values,value)
            values.push(value)
          end

          #
          # Dequeues a scalar value from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [Integer, Float, String, nil]
          #   The dequeued scalar value.
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
