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

require 'strscan'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping Ruby strings.
      #
      # @api public
      #
      module Ruby
        #
        # Encodes a byte as a Ruby escaped character.
        #
        # @param [Integer] byte
        #   The byte value to encode.
        #
        # @return [String]
        #   The escaped Ruby character.
        #
        # @example
        #   Encoding::Ruby.encode_byte(0x41)
        #   # => "\\x41"
        #   Encoding::Ruby.encode_byte(0x100)
        #   # => "\\u100"
        #   Encoding::Ruby.encode_byte(0x10000)
        #   # => "\\u{10000}"
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            "\\x%.2X" % byte
          elsif byte >= 0x100 && byte <= 0xffff
            "\\u%.4X" % byte
          elsif byte >= 0x10000 && byte <= 0x10ffff
            "\\u{%.X}" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # Escapes a byte as a Ruby character.
        #
        # @param [Integer] byte
        #   The byte value to escape.
        #
        # @return [String]
        #   The escaped Ruby character.
        #
        # @raise [RangeError]
        #   The byte value isn't a valid ASCII or UTF byte.
        #
        def self.escape_byte(byte)
          char = if byte >= 0x00 && byte <= 0xff
                   byte.chr
                 else
                   byte.chr(Encoding::UTF_8)
                 end

          return char.dump[1..-2]
        end

        #
        # Encodes each byte of the given data as a Ruby escaped character.
        #
        # @param [String] data
        #   The given data to encode.
        #
        # @return [String]
        #   The encoded Ruby String.
        #
        # @example
        #   Encoding::Ruby.encode("hello")
        #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
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
        # Decodes the Ruby encoded data.
        #
        # @param [String] data
        #   The given Ruby data to decode.
        #
        # @return [String]
        #   The decoded data.
        #
        # @see unescape
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Escapes the Ruby string.
        #
        # @param [String] data
        #   The data to escape.
        #
        # @return [String]
        #   The Ruby escaped String.
        #
        def self.escape(data)
          data.dump[1..-2]
        end

        # Common escaped characters.
        UNESCAPE_CHARS = Hash.new do |hash,char|
          if char[0] == '\\' then char[1]
          else                    char
          end
        end
        UNESCAPE_CHARS['\0'] = "\0"
        UNESCAPE_CHARS['\a'] = "\a"
        UNESCAPE_CHARS['\b'] = "\b"
        UNESCAPE_CHARS['\t'] = "\t"
        UNESCAPE_CHARS['\n'] = "\n"
        UNESCAPE_CHARS['\v'] = "\v"
        UNESCAPE_CHARS['\f'] = "\f"
        UNESCAPE_CHARS['\r'] = "\r"

        #
        # Unescapes the escaped String.
        #
        # @param [String] data
        #   The given Ruby escaped data.
        #
        # @return [String]
        #   The unescaped version of the hex escaped String.
        #
        # @example
        #   Encoding::Ruby.unescape("\\x68\\x65\\x6c\\x6c\\x6f")
        #   # => "hello"
        #
        def self.unescape(data)
          unescaped = String.new
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (unicode_escape = scanner.scan(/\\(?:[0-7]{1,3}|[0-7])/))
                           unicode_escape[1,3].to_i(8).chr
                         elsif (hex_escape = scanner.scan(/\\u[0-9a-fA-F]{4,8}/))
                           hex_escape[2..-1].to_i(16).chr(Encoding::UTF_8)
                         elsif (hex_escape = scanner.scan(/\\x[0-9a-fA-F]{1,2}/))
                           hex_escape[2..-1].to_i(16).chr
                         elsif (escape = scanner.scan(/\\./))
                           UNESCAPE_CHARS[escape]
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # Escapes and quotes the given data as a Ruby string.
        #
        # @param [String] data
        #   The given data to escape and quote.
        #
        # @return [String]
        #   The quoted Ruby string.
        #
        # @example
        #   Encoding::Ruby.quote("hello\nworld\n")
        #   # => "\"hello\\nworld\\n\""
        #
        def self.quote(data)
          data.dump
        end

        #
        # Removes the quotes an unescapes a quoted string.
        #
        # @param [String] data
        #   The given Ruby string.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::Ruby.unquote("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #   Encoding::Ruby.unquote("'hello\\'world'")
        #   # => "hello'world"
        #
        def self.unquote(data)
          if (data[0] == '"' && data[-1] == '"')
            unescape(data[1..-2])
          elsif (data[0] == "'" && data[-1] == "'")
            data[1..-2].gsub(/\\(['\\])/,'\1')
          else
            data
          end
        end

      end
    end
  end
end

require 'ronin/support/encoding/ruby/core_ext'
