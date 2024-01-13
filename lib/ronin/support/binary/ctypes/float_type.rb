# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes/scalar_type'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Base class for all floating-point types.
        #
        class FloatType < ScalarType

          #
          # Initializes the float type.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {Type#initialize}.
          #
          # @option kwargs [Integer] :size
          #   The size in bytes of the type.
          #
          # @option kwargs [:little, :big, nil] :endian
          #   The endian-ness of the integer type.
          #
          # @option kwargs [String] :pack_string
          #   The String for `Array#pack` or `String#unpack`.
          #
          def initialize(**kwargs)
            super(signed: true, **kwargs)
          end

          #
          # Returns an uninitialized Float value.
          #
          # @return [0.0]
          #
          def uninitialized_value
            0.0
          end

        end
      end
    end
  end
end
