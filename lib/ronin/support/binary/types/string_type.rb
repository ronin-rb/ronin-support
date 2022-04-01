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

require 'ronin/support/binary/types/unbounded_array_type'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Represents a C string type.
        #
        class StringType < UnboundedArrayType

          #
          # Packs the stirng into the string type's format.
          #
          # @param [String] string
          #   The value to pack.
          #
          # @return [String]
          #   The packed string.
          #
          def pack(string)
            [value].pack(@pack_string)
          end

          #
          # Unpacks the binary string.
          #
          # @param [String] data
          #
          # @return [String]
          #   The unpacked string.
          #
          def unpack(data)
            data.unpack1(@pack_string)
          end

        end
      end
    end
  end
end
