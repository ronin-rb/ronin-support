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
      # Contains methods for encoding/decoding escaping/unescaping C data.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#c_escape}
      # * {Integer#c_encode}
      # * {String#c_escape}
      # * {String#c_unescape}
      # * {String#c_encode}
      # * {String#c_string}
      # * {String#c_unquote}
      #
      # @api public
      #
      module C
        #
        # Encodes a byte as a C escaped String.
        #
        # @param [Integer] byte
        #   The byte value to encode.
        #
        # @return [String]
        #   The escaped C character.
        #
        # @example
        #   Encoding::C.encode_byte(0x41)
        #   # => "\\x41"
        #   Encoding::C.encode_byte(0x100)
        #   # => "\\u1000"
        #   Encoding::C.encode_byte(0x10000)
        #   # => "\\U000100000"
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            "\\x%.2x" % byte
          elsif byte >= 0x100 && byte <= 0xffff
            "\\u%.4x" % byte
          elsif byte >= 0x10000
            "\\U%.8x" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        # Special C bytes and their escaped Strings.
        ESCAPE_BYTES = {
          0x00 => "\\0",
          0x07 => "\\a",
          0x08 => "\\b",
          0x09 => "\\t",
          0x0a => "\\n",
          0x0b => "\\v",
          0x0c => "\\f",
          0x0d => "\\r",
          0x22 => "\\\"", # \"
          0x1B => "\\e",
          0x5c => "\\\\" # \\
        }

        #
        # Escapes a byte as a C character.
        #
        # @param [Integer] byte
        #   The byte value to escape.
        #
        # @return [String]
        #   The escaped C character.
        #
        # @raise [RangeError]
        #   The integer value is negative.
        #
        # @example
        #   Encoding::C.escape_byte(0x41)
        #   # => "A"
        #   Encoding::C.escape_byte(0x22)
        #   # => "\\\""
        #   Encoding::C.escape_byte(0x7f)
        #   # => "\\x7F"
        #
        # @example Escaping unicode characters:
        #   Encoding::C.escape_byte(0xffff)
        #   # => "\\uFFFF"
        #   Encoding::C.escape_byte(0x10000)
        #   # => "\\U000100000"
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
        # Encodes each character of the given data as C escaped characters.
        #
        # @param [String] data
        #   The given data to encode.
        #
        # @return [String]
        #   The C encoded String.
        #
        # @example
        #   Encoding::C.encode("hello")
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
        # Decodes the C encoded data.
        #
        # @param [String] data
        #   The given C data to decode.
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
        # Escapes the C encoded data.
        #
        # @param [String] data
        #   The data to C escape.
        #
        # @return [String]
        #   The C escaped String.
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

        # C characters that must be back-slashed.
        BACKSLASHED_CHARS = {
          '\\0'  => "\0",
          '\\a'  => "\a",
          '\\b'  => "\b",
          '\\e'  => "\e",
          '\\t'  => "\t",
          '\\n'  => "\n",
          '\\v'  => "\v",
          '\\f'  => "\f",
          '\\r'  => "\r"
        }

        #
        # Unescapes the given C escaped data.
        #
        # @param [String] data
        #   The given C escaped data.
        #
        # @return [String]
        #   The unescaped C String.
        #
        # @example
        #   Encoding::C.unescape("\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64")
        #   # => "hello world"
        #
        def self.unescape(data)
          unescaped = String.new(encoding: Encoding::UTF_8)
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (hex_escape          = scanner.scan(/\\x[0-9a-fA-F]{1,2}/)) # \xXX
                           hex_escape[2..].to_i(16).chr
                         elsif (unicode_escape   = scanner.scan(/\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8}/)) # \uXXXX or \UXXXXXXXX
                           unicode_escape[2..].to_i(16).chr(Encoding::UTF_8)
                         elsif (octal_escape     = scanner.scan(/\\[0-7]{1,3}/)) # \N, \NN, or \NNN
                           octal_escape[1..].to_i(8).chr
                         elsif (backslash_escape = scanner.scan(/\\./)) # \[A-Za-z]
                           BACKSLASHED_CHARS.fetch(backslash_escape) do
                             backslash_escape[1]
                           end
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # Escapes and quotes the given data as a C string.
        #
        # @param [String] data
        #   The given data to escape and quote.
        #
        # @return [String]
        #   The quoted C string.
        #
        # @example
        #   Encoding::C.quote("hello\nworld\n")
        #   # => "\"hello\\nworld\\n\""
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Unquotes and unescapes the given C string.
        #
        # @param [String] data
        #   The given C string.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::C.unquote("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #
        def self.unquote(data)
          if ((data.start_with?('"') && data.end_with?('"')) ||
              (data.start_with?("'") && data.end_with?("'")))
            unescape(data[1..-2])
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/c/core_ext'
