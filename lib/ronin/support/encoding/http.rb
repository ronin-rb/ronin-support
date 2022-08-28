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

require 'cgi'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping HTTP data.
      #
      # @api public
      #
      module HTTP
        #
        # Encodes the byte as an escaped HTTP decimal character.
        #
        # @param [Integer] byte
        #   The byte toe HTTP encode.
        #
        # @return [String]
        #   The encoded HTTP byte.
        #
        # @example
        #   Encoding::HTTP.encode_byte(0x41)
        #   # => "%41"
        #
        def self.encode_byte(byte)
          "%%%X" % byte
        end

        #
        # HTTP escapes the Integer.
        #
        # @param [Integer] byte
        #   The byte toe HTTP escape.
        #
        # @return [String]
        #   The HTTP escaped form of the Integer.
        #
        # @example
        #   Encoding::HTTP.escape_byte(0x41)
        #   # => "A"
        #   Encoding::HTTP.escape_byte(62)
        #   # => "%3E"
        #
        def self.escape_byte(byte)
          CGI.escape(byte.chr)
        end

        #
        # HTTP escapes the special characters in the given data.
        #
        # @param [String] data
        #   The data to HTTP escape.
        #
        # @return [String]
        #   The HTTP escaped form of the String.
        #
        # @example
        #   Encoding::HTTP.escape("x > y")
        #   # => "x+%3E+y"
        #
        def self.escape(data)
          CGI.escape(data)
        end

        #
        # HTTP unescapes the String.
        #
        # @param [String] data
        #   The data to unescape.
        #
        # @return [String]
        #   The raw String.
        #
        # @example
        #   Encoding::HTTP.unescape("sweet+%26+sour")
        #   # => "sweet & sour"
        #
        def self.unescape(data)
          CGI.unescape(data)
        end

        #
        # HTTP encodes each byte of the String.
        #
        # @param [String] data
        #   The data to HTTP encode.
        #
        # @return [String]
        #   The HTTP hexadecimal encoded form of the String.
        #
        # @example
        #   "hello".http_encode
        #   # => "%68%65%6c%6c%6f"
        #
        def self.encode(data)
          encoded = String.new

          data.each_byte do |byte|
            encoded << encode_byte(byte)
          end

          return encoded
        end

        #
        # HTTP decodes the HTTP encoded String.
        #
        # @param [String] data
        #   The HTTP encoded data to decode.
        #
        # @return [String]
        #   The decoded String.
        #
        # @example
        #   Encoding::HTTP.decode("sweet+%26+sour")
        #   # => "sweet & sour"
        #
        def self.decode(data)
          unescape(data)
        end
      end
    end
  end
end

require 'ronin/support/encoding/http/core_ext'
