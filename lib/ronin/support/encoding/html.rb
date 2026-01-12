# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      # ## Features
      #
      # * Supports lowercase (ex: `&amp;`) and uppercase (ex: `&AMP;`) encoding.
      # * Supports decimal (ex: `&#65;`) and hexadecimal (ex: `&#x41;`)
      #   character encoding.
      # * Supports zero-padding (ex: `&#0000065;`).
      #
      # ## Core-Ext Methods
      #
      # * {Integer#html_escape}
      # * {Integer#html_encode}
      # * {String#html_escape}
      # * {String#html_unescape}
      # * {String#html_encode}
      # * {String#html_decode}
      #
      # @api public
      #
      # @since 1.0.0
      #
      module HTML
        #
        # Escapes the byte as a HTML decimal character.
        #
        # @param [Integer] byte
        #   The byte to HTML escape.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The HTML decimal character.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::HTML.escape_byte(0x41)
        #   # => "A"
        #   Encoding::HTML.escape_byte(0x26)
        #   # => "&amp;"
        #
        # @example Uppercase encoding:
        #   Encoding::HTML.escape_byte(0x26, case: :upper)
        #   # => "&AMP;"
        #
        def self.escape_byte(byte,**kwargs)
          XML.escape_byte(byte,**kwargs)
        end

        #
        # Encodes the byte as a HTML decimal character.
        #
        # @param [Integer] byte
        #   The byte to HTML encode.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:decimal, :hex] :format (:decimal)
        #   The numeric format for the escaped characters.
        #
        # @option kwargs [Boolean] :zero_pad
        #   Controls whether the escaped characters will be left-padded with
        #   up to seven `0` characters.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The HTML decimal character.
        #
        # @raise [ArgumentError]
        #   The `format:` or `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::HTML.encode_byte(0x41)
        #   # => "&#65;"
        #
        # @example Zero-padding:
        #   Encoding::HTML.encode_byte(0x41, zero_pad: true)
        #   # => "&#0000065;"
        #
        # @example Hexadecimal escaped characters:
        #   Encoding::HTML.encode_byte(0x41, format: :hex)
        #   # => "&#x41;"
        #
        # @example Uppercase hexadecimal escaped characters:
        #   Encoding::HTML.encode_byte(0xff, format: :hex, case: :upper)
        #   # => "&#XFF;"
        #
        def self.encode_byte(byte,**kwargs)
          XML.encode_byte(byte,**kwargs)
        end

        #
        # Encodes each character in the given data as an HTML character.
        #
        # @param [String] data
        #   The data to HTML encode.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:decimal, :hex] :format (:decimal)
        #   The numeric format for the escaped characters.
        #
        # @option kwargs [Boolean] :zero_pad
        #   Controls whether the escaped characters will be left-padded with
        #   up to seven `0` characters.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The HTML encoded String.
        #
        # @raise [ArgumentError]
        #   The `format:` or `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::HTML.encode("abc")
        #   # => "&#97;&#98;&#99;"
        #
        # @example Zero-padding:
        #   Encoding::HTML.encode("abc", zero_pad: true)
        #   # => "&#0000097;&#0000098;&#0000099;"
        #
        # @example Hexadecimal encoded characters:
        #   Encoding::HTML.encode("abc", format: :hex)
        #   # => "&#x61;&#x62;&#x63;"
        #
        # @example Uppercase hexadecimal encoded characters:
        #   Encoding::HTML.encode("abc\xff", format: :hex, case: :upper)
        #   # => "&#X61;&#X62;&#X63;&#XFF;"
        #
        def self.encode(data,**kwargs)
          XML.encode(data,**kwargs)
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The HTML escaped String.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::HTML.escape("one & two")
        #   # => "one &amp; two"
        #
        # @example Uppercase escaped characters:
        #   Encoding::HTML.encode("one & two", case: :upper)
        #   # => "one &AMP; two"
        #
        # @see http://rubydoc.info/stdlib/cgi/CGI.escapeHTML
        #
        def self.escape(data,**kwargs)
          XML.escape(data,**kwargs)
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
