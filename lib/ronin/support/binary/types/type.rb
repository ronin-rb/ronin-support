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

require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/unbounded_array_type'

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
          # @return [String]
          attr_reader :pack_string

          #
          # Initializes the type.
          #
          # @param [String] pack_string
          #   The String for `Array#pack` or `String#unpack`.
          #
          def initialize(pack_string: )
            @pack_string = pack_string
          end

          #
          # Packs the value into the type's binary format.
          #
          # @param [Integer, Float, String] value
          #   The value to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          def pack(value)
            [value].pack(@pack_string)
          end

          #
          # Unpacks the binary data.
          #
          # @param [String] data
          #
          # @return [Integer, Float, String, nil]
          #   The unpacked value.
          #
          def unpack(data)
            data.unpack1(@pack_string)
          end

        end
      end
    end
  end
end
