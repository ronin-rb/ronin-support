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
      # Contains methods for encoding/decoding escaping/unescaping HTML data.
      #
      # @api public
      #
      module XML
        #
        # Escapes the byte as a XML decimal character.
        #
        # @param [Integer] byte
        #   The byte to XML escape.
        #
        # @return [String]
        #   The XML decimal character.
        #
        # @example
        #   Encoding::XML.escape_byte(0x41)
        #   # => "A"
        #   Encoding::XML.escape_byte(0x26)
        #   # => "&amp;"
        #
        def self.escape_byte(byte)
          CGI.escapeHTML(byte.chr)
        end

        #
        # Encodes the byte as a XML decimal character.
        #
        # @param [Integer] byte
        #   The byte to XML encode.
        #
        # @return [String]
        #   The XML decimal character.
        #
        # @example
        #   Encoding::XML.encode_byte(0x41)
        #   # => "&#65;"
        #
        def self.encode_byte(byte)
          "&#%d;" % byte
        end

        #
        # Encodes each character in the given data as an XML character.
        #
        # @param [String] data
        #   The data to XML encode.
        #
        # @return [String]
        #   The XML encoded String.
        #
        # @example
        #   Encoding::XML.encode("abc")
        #   # => "&#97;&#98;&#99;"
        #
        def self.encode(data)
          encoded = String.new

          if data.valid_encoding?
            data.each_codepoint do |codepoint|
              encoded << encode_byte(codepoint)
            end
          else
            data.each_byte do |byte|
              encoded << encode_byte(byte)
            end
          end

          return encoded
        end

        #
        # Alias for {unescape}.
        #
        # @param [String] data
        #   The data to XML unescape.
        #
        # @return [String]
        #   The unescaped String.
        #
        # @see unescape
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # XML escapes the data.
        #
        # @param [String] data
        #   The data to XML escape.
        #
        # @return [String]
        #   The XML escaped String.
        #
        # @example
        #   Encoding::XML.escape("one & two")
        #   # => "one &amp; two"
        #
        # @see http://rubydoc.info/stdlib/cgi/CGI.escapeHTML
        #
        def self.escape(data)
          CGI.escapeHTML(data)
        end

        #
        # Unescapes the XML encoded data.
        #
        # @param [String] data
        #   The data to XML unescape.
        #
        # @return [String]
        #   The unescaped String.
        #
        # @example
        #   Encoding::XML.unescape("&lt;p&gt;one &lt;span&gt;two&lt;/span&gt;&lt;/p&gt;")
        #   # => "<p>one <span>two</span></p>"
        #
        # @see http://rubydoc.info/stdlib/cgi/CGI.unescapeHash
        #
        def self.unescape(data)
          CGI.unescapeHTML(data)
        end
      end
    end
  end
end

require 'ronin/support/encoding/xml/core_ext'
