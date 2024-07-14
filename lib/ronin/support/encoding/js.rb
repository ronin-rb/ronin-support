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

require 'strscan'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping JavaScript
      # data.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#js_escape}
      # * {Integer#js_encode}
      # * {String#js_escape}
      # * {String#js_unescape}
      # * {String#js_encode}
      # * {String#js_decode}
      # * {String#js_string}
      # * {String#js_unquote}
      #
      # @api public
      #
      module JS
        # Special JavaScript bytes and their escaped Strings.
        ESCAPE_BYTES = {
          0x00 => '\u0000',
          0x01 => '\u0001',
          0x02 => '\u0002',
          0x03 => '\u0003',
          0x04 => '\u0004',
          0x05 => '\u0005',
          0x06 => '\u0006',
          0x07 => '\u0007',
          0x08 => '\b',
          0x09 => '\t',
          0x0a => '\n',
          0x0b => '\u000b',
          0x0c => '\f',
          0x0d => '\r',
          0x0e => '\u000e',
          0x0f => '\u000f',
          0x10 => '\u0010',
          0x11 => '\u0011',
          0x12 => '\u0012',
          0x13 => '\u0013',
          0x14 => '\u0014',
          0x15 => '\u0015',
          0x16 => '\u0016',
          0x17 => '\u0017',
          0x18 => '\u0018',
          0x19 => '\u0019',
          0x1a => '\u001a',
          0x1b => '\u001b',
          0x1c => '\u001c',
          0x1d => '\u001d',
          0x1e => '\u001e',
          0x1f => '\u001f',
          0x22 => '\"',
          0x5c => '\\\\'
        }

        #
        # Escapes the byte as a JavaScript character.
        #
        # @param [Integer] byte
        #   The byte to escape.
        #
        # @return [String]
        #   The escaped JavaScript character.
        #
        # @example
        #   Encoding::JS.escape_byte(0x41)
        #   # => "A"
        #   Encoding::JS.escape_byte(0x22)
        #   # => "\\\""
        #   Encoding::JS.escape_byte(0x7f)
        #   # => "\\x7F"
        #
        def self.escape_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            ESCAPE_BYTES.fetch(byte) do
              if byte >= 0x20 && byte <= 0x7e
                byte.chr
              else
                encode_byte(byte)
              end
            end
          else
            encode_byte(byte)
          end
        end

        #
        # Encodes the byte as a JavaScript character.
        #
        # @param [Integer] byte
        #   The byte to encode.
        #
        # @return [String]
        #   The encoded JavaScript character.
        #
        # @example
        #   Encoding::JS.encode_byte(0x41)
        #   # => "\\x41"
        #
        def self.encode_byte(byte)
          if byte > 0xff then "\\u%.4X" % byte
          else                "\\x%.2X" % byte
          end
        end

        # JavaScript characters that must be back-slashed.
        BACKSLASHED_CHARS = {
          "\\b"  => "\b",
          "\\t"  => "\t",
          "\\n"  => "\n",
          "\\f"  => "\f",
          "\\r"  => "\r",
          "\\\"" => "\"",
          "\\'"  => "'",
          "\\\\" => "\\"
        }

        #
        # Escapes a String for JavaScript.
        #
        # @param [String] data
        #   The data to JavaScript escape.
        #
        # @return [String]
        #   The JavaScript escaped String.
        #
        # @example
        #   "hello\nworld\n".js_escape
        #   # => "hello\\nworld\\n"
        #
        def self.escape(data)
          escaped = String.new

          if data.valid_encoding?
            data.each_codepoint do |codepoint|
              escaped << escape_byte(codepoint)
            end
          else
            data.each_byte do |byte|
              escaped << escape_byte(byte)
            end
          end

          return escaped
        end

        #
        # Unescapes a JavaScript escaped String.
        #
        # @param [String] data
        #   The escaped JavaScript data.
        #
        # @return [String]
        #   The unescaped JavaScript String.
        #
        # @example
        #   Encoding::JS.unescape("\\u0068\\u0065\\u006C\\u006C\\u006F world")
        #   # => "hello world"
        #
        def self.unescape(data)
          unescaped = String.new(encoding: Encoding::UTF_8)
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (backslash_escape = scanner.scan(/\\[btnfr'"\\]/))
                           BACKSLASHED_CHARS[backslash_escape]
                         elsif (surrogate_pair = scanner.scan(/\\u[dD][890abAB][0-9a-fA-F]{2}\\u[dD][cdefCDEF][0-9a-fA-F]{2}/))
                           hi = surrogate_pair[2..6].to_i(16)
                           lo = surrogate_pair[8..12].to_i(16)

                           (0x1_0000 + ((hi - 0xd800) * 0x400) + (lo - 0xdc00))
                         elsif (unicode_escape = scanner.scan(/[\\%]u[0-9a-fA-F]{1,4}/))
                           unicode_escape[2..].to_i(16)
                         elsif (hex_escape     = scanner.scan(/[\\%][0-9a-fA-F]{1,2}/))
                           hex_escape[1..].to_i(16)
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # JavaScript escapes every character of the String.
        #
        # @param [String] data
        #   The data to JavaScript escape.
        #
        # @return [String]
        #   The JavaScript escaped String.
        #
        # @example
        #   Encoding::JS.encode("hello")
        #   # => "\\u0068\\u0065\\u006C\\u006C\\u006F"
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
        #   The escaped JavaScript data.
        #
        # @return [String]
        #   The unescaped JavaScript String.
        #
        # @see unescape
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Converts the String into a JavaScript string.
        #
        # @param [String] data
        #   The data to escape and quote.
        #
        # @return [String]
        #   The unquoted and unescaped String.
        #
        # @example
        #   Encoding::JS.quote("hello\nworld\n")
        #   # => "\"hello\\nworld\\n\""
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Removes the quotes an unescapes a JavaScript string.
        #
        # @param [String] data
        #   The JavaScript string to unquote.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::JS.unquote("\"hello\\nworld\"")
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

require 'ronin/support/encoding/js/core_ext'
