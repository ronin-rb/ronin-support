# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # [Base36] encoding.
      #
      # [Base36]: https://en.wikipedia.org/wiki/Base36
      #
      # ## Core-Ext Methods
      #
      # * {Integer#base36_encode}
      # * {String#base36_decode}
      #
      # @api public
      #
      # @since 1.1.0
      #
      module Base36
        #
        # Base36 encodes an integer.
        #
        # @param [Integer] int
        #   The integer to Base36 encode.
        #
        # @return [String]
        #   The Base36 encoded string.
        #
        def self.encode_int(int)
          int.to_s(36)
        end

        #
        # Base36 decodes the given String.
        #
        # @param [String] string
        #   The String to decode.
        #
        # @return [Integer]
        #   The Base36 decoded integer.
        #
        def self.decode(string)
          string.to_i(36)
        end
      end
    end
  end
end

require 'ronin/support/encoding/base36/core_ext'
