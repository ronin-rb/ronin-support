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

require 'addressable/idna'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding [punycode] encoded Strings.
      #
      # [punycode]: https://en.wikipedia.org/wiki/Punycode
      #
      # ## Core-Ext Methods
      #
      # * {String#punycode_encode}
      # * {String#punycode_decode}
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Punycode
        #
        # Encodes a unicode String into [punycode].
        #
        # [punycode]: https://en.wikipedia.org/wiki/Punycode
        #
        # @param [String] data
        #   The unicode String to encode.
        #
        # @return [String]
        #   The punycode String.
        #
        # @example
        #   Encoding::Punycode.encode("詹姆斯")
        #   # => "xn--8ws00zhy3a"
        #
        def self.encode(data)
          Addressable::IDNA.to_ascii(data)
        end

        #
        # Decodes a [punycode] String back into unicode.
        #
        # [punycode]: https://en.wikipedia.org/wiki/Punycode
        #
        # @param [String] data
        #   The punycode String to decode.
        #
        # @return [String]
        #   The decoded unicode String.
        #
        # @example
        #   Encoding::Punycode.decode("xn--8ws00zhy3a")
        #   # => "詹姆斯"
        #
        def self.decode(data)
          Addressable::IDNA.to_unicode(data)
        end
      end
    end
  end
end

require 'ronin/support/encoding/punycode/core_ext'
