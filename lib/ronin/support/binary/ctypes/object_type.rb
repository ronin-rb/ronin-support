# frozen_string_literal: true
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

require 'ronin/support/binary/ctypes/type'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Represents a object type that is memory mapped.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class ObjectType < Type

          # The size, in bytes, of the memory-mapped type.
          #
          # @return [Integer]
          attr_reader :size

          #
          # Initializes the memory-mapped type.
          #
          # @param [Integer] size
          #   The size, in bytes, of the memory-mapped type.
          #
          def initialize(size)
            @size = size

            super(pack_string: "a#{@size}")
          end

        end
      end
    end
  end
end
