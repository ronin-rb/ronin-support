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

require 'ronin/support/encoding/xml'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping HTML data.
      #
      # @api public
      #
      module HTML
        #
        # Escapes the byte as a HTML decimal character.
        #
        # @param [Integer] byte
        #   The byte to HTML escape.
        #
        # @return [String]
        #   The HTML decimal character.
        #
        # @example
        #   Encoding::HTML.escape_byte(0x41)
        #   # => "A"
        #   Encoding::HTML.escape_byte(0x26)
        #   # => "&amp;"
        #
        def self.escape_byte(byte)
          XML.escape_byte(byte)
        end

        #
        # Encodes the byte as a HTML decimal character.
        #
        # @param [Integer] byte
        #   The byte to HTML encode.
        #
        # @return [String]
        #   The HTML decimal character.
        #
        # @example
        #   Encoding::HTML.encode_byte(0x41)
        #   # => "&#65;"
        #
        def self.encode_byte(byte)
          XML.encode_byte(byte)
        end

        #
        # Encodes each character in the given data as an HTML character.
        #
        # @param [String] data
        #   The data to HTML encode.
        #
        # @return [String]
        #   The HTML encoded String.
        #
        # @example
        #   Encoding::HTML.encode("abc")
        #   # => "&#97;&#98;&#99;"
        #
        def self.encode(data)
          XML.encode(data)
        end

        #
        # Decoded the HTML encoded data.
        #
        # @param [String] data
        #   The HTML encoded data to decode.
        #
        # @return [String]
        #   The decoded String.
        #
        def self.decode(data)
          XML.decode(data)
        end

        #
        # HTML escapes the data.
        #
        # @param [String] data
        #   The data to HTML escape.
        #
        # @return [String]
        #   The HTML escaped String.
        #
        # @example
        #   Encoding::HTML.escape("one & two")
        #   # => "one &amp; two"
        #
        # @see http://rubydoc.info/stdlib/cgi/CGI.escapeHTML
        #
        def self.escape(data)
          XML.escape(data)
        end

        #
        # Unescapes the HTML encoded data.
        #
        # @param [String] data
        #   The data to HTML unescape.
        #
        # @return [String]
        #   The unescaped String.
        #
        # @example
        #   Encoding::HTML.unescape("&lt;p&gt;one &lt;span&gt;two&lt;/span&gt;&lt;/p&gt;")
        #   # => "<p>one <span>two</span></p>"
        #
        # @see http://rubydoc.info/stdlib/cgi/CGI.unescapeHash
        #
        def self.unescape(data)
          XML.unescape(data)
        end
      end
    end
  end
end

require 'ronin/support/encoding/html/core_ext'
