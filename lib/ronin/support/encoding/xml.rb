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

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping XML data.
      #
      # ## Features
      #
      # * Supports lowercase (ex: `&amp;`) and uppercase (ex: `&AMP;`) encoding.
      # * Supports decimal (ex: `&#65;`) and hexadecimal (ex: `&#x41;`)
      #   character encoding.
      # * Supports zero-padding (ex: `&#0000065;`).
      #
      # @api public
      #
      module XML
        # Special bytes and their escaped XML characters.
        ESCAPE_BYTES = {
          39 => '&#39;',
          38 => '&amp;',
          34 => '&quot;',
          60 => '&lt;',
          62 => '&gt;'
        }

        # Special bytes and their escaped XML characters, but in uppercase.
        ESCAPE_BYTES_UPPERCASE = {
          39 => '&#39;',
          38 => '&AMP;',
          34 => '&QUOT;',
          60 => '&LT;',
          62 => '&GT;'
        }

        #
        # Escapes the byte as a XML decimal character.
        #
        # @param [Integer] byte
        #   The byte to XML escape.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The XML decimal character.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::XML.escape_byte(0x41)
        #   # => "A"
        #   Encoding::XML.escape_byte(0x26)
        #   # => "&amp;"
        #
        # @example Uppercase encoding:
        #   Encoding::XML.escape_byte(0x26, case: :upper)
        #   # => "&AMP;"
        #
        def self.escape_byte(byte,**kwargs)
          table = case kwargs[:case]
                  when :upper      then ESCAPE_BYTES_UPPERCASE
                  when :lower, nil then ESCAPE_BYTES
                  else
                    raise(ArgumentError,"case (#{kwargs[:case].inspect}) keyword argument must be either :lower, :upper, or nil")
                  end

          table.fetch(byte) do
            if (byte >= 0 && byte <= 0xff)
              byte.chr(Encoding::ASCII_8BIT)
            else
              byte.chr(Encoding::UTF_8)
            end
          end
        end

        #
        # Encodes the byte as a XML decimal character.
        #
        # @param [Integer] byte
        #   The byte to XML encode.
        #
        # @param [:decimal, :hex] format
        #   The numeric format for the escaped characters.
        #
        # @param [Boolean] zero_pad
        #   Controls whether the escaped characters will be left-padded with
        #   up to seven `0` characters.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The XML decimal character.
        #
        # @raise [ArgumentError]
        #   The `format:` or `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::XML.encode_byte(0x41)
        #   # => "&#65;"
        #
        # @example Zero-padding:
        #   Encoding::XML.encode_byte(0x41, zero_pad: true)
        #   # => "&#0000065;"
        #
        # @example Hexadecimal escaped characters:
        #   Encoding::XML.encode_byte(0x41, format: :hex)
        #   # => "&#x41;"
        #
        # @example Uppercase hexadecimal escaped characters:
        #   Encoding::XML.encode_byte(0xff, format: :hex, case: :upper)
        #   # => "&#XFF;"
        #
        def self.encode_byte(byte, format: :decimal, zero_pad: false, **kwargs)
          case format
          when :decimal
            if zero_pad then "&#%.7d;" % byte
            else             "&#%d;" % byte
            end
          when :hex
            case kwargs[:case]
            when :upper
              if zero_pad then "&#X%.7X;" % byte
              else             "&#X%.2X;" % byte
              end
            when :lower, nil
              if zero_pad then "&#x%.7x;" % byte
              else             "&#x%.2x;" % byte
              end
            when
              raise(ArgumentError,"case (#{kwargs[:case].inspect}) keyword argument must be either :lower, :upper, or nil")
            end
          else
            raise(ArgumentError,"format (#{format.inspect}) must be :decimal or :hex")
          end
        end

        #
        # Encodes each character in the given data as an XML character.
        #
        # @param [String] data
        #   The data to XML encode.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:decimal, :hex] :format (:decimal)
        #   The numeric format for the escaped characters.
        #
        # @option kwargs [Boolean] :zero_pad (false)
        #   Controls whether the escaped characters will be left-padded with
        #   up to seven `0` characters.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The XML encoded String.
        #
        # @raise [ArgumentError]
        #   The `format:` or `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::XML.encode("abc")
        #   # => "&#97;&#98;&#99;"
        #
        # @example Zero-padding:
        #   Encoding::XML.encode("abc", zero_pad: true)
        #   # => "&#0000097;&#0000098;&#0000099;"
        #
        # @example Hexadecimal encoded characters:
        #   Encoding::XML.encode("abc", format: :hex)
        #   # => "&#x61;&#x62;&#x63;"
        #
        # @example Uppercase hexadecimal encoded characters:
        #   Encoding::XML.encode("abc\xff", format: :hex, case: :upper)
        #   # => "&#X61;&#X62;&#X63;&#XFF;"
        #
        def self.encode(data,**kwargs)
          encoded = String.new

          if data.valid_encoding?
            data.each_codepoint do |codepoint|
              encoded << encode_byte(codepoint,**kwargs)
            end
          else
            data.each_byte do |byte|
              encoded << encode_byte(byte,**kwargs)
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase XML special
        #   characters. Defaults to lowercase hexadecimal.
        #
        # @return [String]
        #   The XML escaped String.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument is invalid.
        #
        # @example
        #   Encoding::XML.escape("one & two")
        #   # => "one &amp; two"
        #
        # @example Uppercase escaped characters:
        #   Encoding::XML.encode("one & two", case: :upper)
        #   # => "one &AMP; two"
        #
        def self.escape(data,**kwargs)
          escaped = String.new

          if data.valid_encoding?
            data.each_codepoint do |codepoint|
              escaped << escape_byte(codepoint,**kwargs)
            end
          else
            data.each_byte do |byte|
              escaped << escape_byte(byte,**kwargs)
            end
          end

          return escaped
        end

        # XML escaped characters and their unescaped forms.
        ESCAPED_CHARS = {
          '&apos;' => "'",
          '&amp;'  => '&',
          '&quot;' => '"',
          '&lt;'   => '<',
          '&gt;'   => '>'
        }

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
          unescaped = String.new
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (named_char = scanner.scan(/&(?:apos|amp|quot|lt|gt);/i))
                           ESCAPED_CHARS.fetch(named_char.downcase)
                         elsif (decimal_char = scanner.scan(/&#\d+;/))
                           decimal_char[2..-2].to_i.chr(Encoding::UTF_8)
                         elsif (hex_char = scanner.scan(/&#x[a-f0-9]+;/i))
                           hex_char[3..-2].to_i(16).chr(Encoding::UTF_8)
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end
      end
    end
  end
end

require 'ronin/support/encoding/xml/core_ext'
