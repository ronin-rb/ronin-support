# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      # Contains methods for encoding/decoding UUEncoded data.
      #
      # ## Core-Ext Methods
      #
      # * {String#uu_encode}
      # * {String#uu_decode}
      #
      # @api public
      #
      # @see https://en.wikipedia.org/wiki/Uuencoding
      #
      module UUEncoding
        #
        # UUEncodes the String.
        #
        # @param [String] data
        #   The data to uuencode.
        #
        # @return [String]
        #   The UU encoded String.
        #
        # @example
        #   Encoding::UUEncoding.encode("hello world")
        #   # => "+:&5L;&\\@=V]R;&0`\n"
        #
        # @see https://en.wikipedia.org/wiki/Uuencoding
        #
        def self.encode(data)
          [data].pack('u')
        end

        #
        # Decodes the UUEncoded String.
        #
        # @param [String] data
        #   The data to uudecode.
        #
        # @return [String]
        #   The decoded String.
        #
        # @example
        #   Encoding::UUEncoding.encode("+:&5L;&\\@=V]R;&0`\n")
        #   # => "hello world"
        #
        # @see https://en.wikipedia.org/wiki/Uuencoding
        #
        def self.decode(data)
          data.unpack1('u')
        end
      end
    end
  end
end

require 'ronin/support/encoding/uuencoding/core_ext'
