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

require 'strscan'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for hex encoding/decoding and escaping/unescaping data.
      #
      module Hex
        #
        # Hex encodes the given byte.
        #
        # @param [Integer] byte
        #   The byte to hex encode.
        #
        # @return [String]
        #   The hex encoded version of the byte.
        #
        # @example
        #   Encoding::Hex.encode_byte(0x41)
        #   # => "41"
        #
        def self.encode_byte(byte)
          "%.2x" % byte
        end

        #
        # Hex escapes the given byte.
        #
        # @param [Integer] byte
        #   The byte value to hex escape.
        #
        # @return [String]
        #   The hex escaped version of the Integer.
        #
        # @raise [RangeError]
        #   The byte value is negative.
        #
        # @example
        #   Encoding::Hex.escape_byte(42)
        #   # => "\\x2a"
        #
        def self.escape_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            if    byte == 0x22
              "\\\""
            elsif byte == 0x5d
              "\\\\"
            elsif byte >= 0x20 && byte <= 0x7e
              byte.chr
            else
              "\\x%.2x" % byte
            end
          elsif byte > 0xff
            "\\x%x" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # Hex encodes the given data.
        #
        # @param [String] data
        #   The given data to hex encode.
        #
        # @return [String]
        #   The hex encoded version of the String.
        #
        # @example
        #   Encoding::Hex.encode("hello")
        #   # => "68656C6C6F"
        #
        def self.encode(data)
          encoded = String.new

          data.each_byte do |byte|
            encoded << encode_byte(byte)
          end

          return encoded
        end

        #
        # Hex decodes the String.
        #
        # @param [String] data
        #   The given data to hex decode.
        #
        # @return [String]
        #   The hex decoded version of the String.
        #
        # @example
        #   Encoding::Hex.decode("68656C6C6F")
        #   # => "hello"
        #
        def self.decode(data)
          decoded = String.new

          data.scan(/../) do |hex|
            decoded << hex.to_i(16).chr
          end

          return decoded
        end

        #
        # Hex-escapes the given data.
        #
        # @param [String] data
        #   The given data to hex escape.
        #
        # @return [String]
        #   The hex escaped version of the String.
        #
        # @example
        #   Encoding::Hex.escape("hello")
        #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
        #
        def self.escape(data)
          escaped = String.new

          data.each_codepoint do |codepoint|
            escaped << escape_byte(codepoint)
          end

          return escaped
        end

        # Backslash escaped characters.
        BACKSLASHED_CHARS = {
          "\\" => '\\',
          '"'  => '"',
          '0'  => "\0",
          'a'  => "\a",
          'b'  => "\b",
          't'  => "\t",
          'n'  => "\n",
          'v'  => "\v",
          'f'  => "\f",
          'r'  => "\r"
        }

        #
        # Removes the quotes an unescapes a quoted hex string.
        #
        # @param [String] data
        #   The quoted and hex escaped hex string.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::Hex.unescape("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #
        def self.unescape(data)
          buffer  = String.new
          scanner = StringScanner.new(data)

          until scanner.eos?
            buffer << case (char = scanner.getch)
                      when '\\'
                        if (hex_escape = scanner.scan(/x[0-9a-fA-F]{4,8}/))
                          hex_escape[1..].to_i(16).chr(Encoding::UTF_8)
                        elsif (hex_escape = scanner.scan(/x[0-9a-fA-F]{1,2}/))
                          hex_escape[1..].to_i(16).chr
                        elsif (char = scanner.getch)
                          BACKSLASHED_CHARS.fetch(char,char)
                        end
                      else
                        char
                      end
          end

          return buffer
        end

        #
        # Converts the given data into a double-quoted hex string.
        #
        # @param [String] data
        #   The given data to hex-escape and double-quote.
        #
        # @return [String]
        #   The double-quoted and hex escaped string.
        #
        # @example
        #   Encoding::Hex.quote("hello\nworld")
        #   # => "\"hello\\nworld\""
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Removes the quotes and unescapes a hex string.
        #
        # @param [String] data
        #   The quoted hex String to unescape and unquote.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::Hex.unquote("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #
        def self.unquote(data)
          if ((data[0] == '"' && data[-1] == '"') ||
              (data[0] == "'" && data[-1] == "'"))
            unescape(data[1..-2])
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/hex/core_ext'
