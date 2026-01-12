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

require 'strscan'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping Java data.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#java_escape}
      # * {Integer#java_encode}
      # * {String#java_escape}
      # * {String#java_unescape}
      # * {String#java_encode}
      # * {String#java_string}
      # * {String#java_unquote}
      #
      # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
      #
      # @api public
      #
      # @since 1.2.0
      #
      module Java
        #
        # Encodes a byte as a Java escaped character.
        #
        # @param [Integer] byte
        #   The byte value to encode.
        #
        # @return [String]
        #   The escaped Java character.
        #
        # @example
        #   Encoding::Java.encode_byte(0x41)
        #   # => "\\u0041"
        #   Encoding::Java.encode_byte(0x221e)
        #   # => "\\u221E"
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xffff
            "\\u%.4X" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        # Special Java bytes and their escaped characters.
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
        ESCAPE_BYTES = {
          0x00 => '\0', # prefer \0 over \u0000
          0x08 => '\b',
          0x09 => '\t',
          0x0a => '\n',
          0x0b => '\v',
          0x0c => '\f',
          0x0d => '\r',
          0x22 => '\"',
          0x27 => "\\'",
          0x5c => '\\\\'
        }

        #
        # Escapes a byte as a Java character.
        #
        # @param [Integer] byte
        #   The byte value to escape.
        #
        # @return [String]
        #   The escaped Java character.
        #
        # @raise [RangeError]
        #   The integer value is negative.
        #
        # @example
        #   Encoding::Java.escape_byte(0x41)
        #   # => "A"
        #   Encoding::Java.escape_byte(0x22)
        #   # => "\\\""
        #   Encoding::Java.escape_byte(0x7f)
        #   # => "\\u007F"
        #
        # @example Escaping unicode characters:
        #   Encoding::Java.escape_byte(0xffff)
        #   # => "\\uFFFF"
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
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
        # Encodes each character of the given data as Java escaped characters.
        #
        # @param [String] data
        #   The given data to encode.
        #
        # @return [String]
        #   The Java encoded String.
        #
        # @example
        #   Encoding::Java.encode("hello")
        #   # => "\\u0068\\u0065\\u006C\\u006C\\u006F"
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
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
        # Decodes the Java encoded data.
        #
        # @param [String] data
        #   The given Java data to decode.
        #
        # @return [String]
        #   The decoded data.
        #
        # @see unescape
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Escapes the Java encoded data.
        #
        # @param [String] data
        #   The data to Java escape.
        #
        # @return [String]
        #   The Java escaped String.
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
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

        # Java characters that must be back-slashed.
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
        BACKSLASHED_CHARS = {
          '\\b'   => "\b",
          '\\t'   => "\t",
          '\\n'   => "\n",
          '\\f'   => "\f",
          '\\r'   => "\r",
          "\\\""  => '"',
          "\\'"   => "'",
          "\\\\"  => "\\"
        }

        #
        # Unescapes the given Java escaped data.
        #
        # @param [String] data
        #   The given Java escaped data.
        #
        # @return [String]
        #   The unescaped Java String.
        #
        # @raise [ArgumentError]
        #   An invalid Java backslach escape sequence was encountered while
        #   parsing the String.
        #
        # @example
        #   Encoding::Java.unescape("\\u0068\\u0065\\u006C\\u006C\\u006F\\u0020\\u0077\\u006F\\u0072\\u006C\\u0064")
        #   # => "hello world"
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
        #
        def self.unescape(data)
          unescaped = String.new(encoding: Encoding::UTF_8)
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (unicode_escape      = scanner.scan(/\\u[0-9a-fA-F]{4}/)) # \uXXXX
                           unicode_escape[2..].to_i(16).chr(Encoding::UTF_8)
                         elsif (octal_escape     = scanner.scan(/\\[0-7]{1,3}/)) # \N, \NN, or \NNN
                           octal_escape[1..].to_i(8).chr
                         elsif (backslash_escape = scanner.scan(/\\./)) # \[A-Za-z]
                           BACKSLASHED_CHARS.fetch(backslash_escape) do
                             raise(ArgumentError,"invalid Java backslash escape sequence: #{backslash_escape.inspect}")
                           end
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # Escapes and quotes the given data as a Java String.
        #
        # @param [String] data
        #   The given data to escape and quote.
        #
        # @return [String]
        #   The quoted Java String.
        #
        # @example
        #   Encoding::Java.quote("hello\nworld\n")
        #   # => "\"hello\\nworld\\n\""
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Unquotes and unescapes the given Java String.
        #
        # @param [String] data
        #   The given Java String.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::Java.unquote("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #
        # @see https://docs.oracle.com/javase/tutorial/java/data/characters.html
        #
        def self.unquote(data)
          if (data.start_with?('"') && data.end_with?('"'))
            unescape(data[1..-2])
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/java/core_ext'
