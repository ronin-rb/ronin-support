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

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding UUEncoded data.
      #
      # @api public
      #
      module UUEncoding
        #
        # [uuencodes][uuencoding] the String.
        #
        # [uuencoding]: https://en.wikipedia.org/wiki/Uuencoding
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
        def self.encode(data)
          [data].pack('u')
        end

        #
        # Decodes the [uuencoded][uuencoding] String.
        #
        # [uuencoding]: https://en.wikipedia.org/wiki/Uuencoding
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
        def self.decode(data)
          data.unpack1('u')
        end
      end
    end
  end
end

require 'ronin/support/encoding/uuencoding/core_ext'
