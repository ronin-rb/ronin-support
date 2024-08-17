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
      # Contains methods for encoding/decoding escaping/unescaping Python data.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#python_escape}
      # * {Integer#python_encode}
      # * {String#python_escape}
      # * {String#python_unescape}
      # * {String#python_encode}
      # * {String#python_string}
      # * {String#python_unquote}
      #
      # @see https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals
      #
      # @api public
      #
      # @since 1.2.0
      #
      module Python
        #
        # Encodes a byte as a Python escaped String.
        #
        # @param [Integer] byte
        #   The byte value to encode.
        #
        # @return [String]
        #   The escaped Python character.
        #
        # @example
        #   Encoding::Python.encode_byte(0x41)
        #   # => "\\x41"
        #   Encoding::Python.encode_byte(0x100)
        #   # => "\\u1000"
        #   Encoding::Python.encode_byte(0x10000)
        #   # => "\\u100000"
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            "\\x%.2x" % byte
          elsif byte >= 0x100 && byte <= 0xffff
            "\\u%.4x" % byte
          elsif byte >= 0x10000 && byte <= 0x10ffff
            "\\U%.8x" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        # Special Python bytes and their escaped Strings.
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
        ESCAPE_BYTES = {
          0x00 => '\x00',
          0x07 => '\a',
          0x08 => '\b',
          0x09 => '\t',
          0x0a => '\n',
          0x0b => '\v',
          0x0c => '\f',
          0x0d => '\r',
          0x22 => '\"',
          0x5c => '\\\\'
        }

        #
        # Escapes a byte as a Python character.
        #
        # @param [Integer] byte
        #   The byte value to escape.
        #
        # @return [String]
        #   The escaped Python character.
        #
        # @raise [RangeError]
        #   The integer value is negative.
        #
        # @example
        #   Encoding::Python.escape_byte(0x41)
        #   # => "A"
        #   Encoding::Python.escape_byte(0x22)
        #   # => "\\\""
        #   Encoding::Python.escape_byte(0x7f)
        #   # => "\\x7f"
        #
        # @example Escaping unicode characters:
        #   Encoding::Python.escape_byte(0xffff)
        #   # => "\\uffff"
        #   Encoding::Python.escape_byte(0x10000)
        #   # => "\\U00100000"
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
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
        # Encodes each character of the given data as Python escaped characters.
        #
        # @param [String] data
        #   The given data to encode.
        #
        # @return [String]
        #   The Python encoded String.
        #
        # @example
        #   Encoding::Python.encode("hello")
        #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
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
        # Decodes the Python encoded data.
        #
        # @param [String] data
        #   The given Python data to decode.
        #
        # @return [String]
        #   The decoded data.
        #
        # @see unescape
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Escapes the Python encoded data.
        #
        # @param [String] data
        #   The data to Python escape.
        #
        # @return [String]
        #   The Python escaped String.
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
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

        # Python characters that must be back-slashed.
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
        BACKSLASHED_CHARS = {
          '\\0'   => "\0",
          '\\a'   => "\a",
          '\\b'   => "\b",
          '\\t'   => "\t",
          '\\n'   => "\n",
          '\\v'   => "\v",
          '\\f'   => "\f",
          '\\r'   => "\r",
          "\\\""  => '"',
          "\\'"   => "'",
          "\\\\"  => "\\"
        }

        #
        # Unescapes the given Python escaped data.
        #
        # @param [String] data
        #   The given Python escaped data.
        #
        # @return [String]
        #   The unescaped Python String.
        #
        # @example
        #   Encoding::Python.unescape("\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64")
        #   # => "hello world"
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
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
                           BACKSLASHED_CHARS.fetch(backslash_escape,backslash_escape)
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # Escapes and quotes the given data as a Python string.
        #
        # @param [String] data
        #   The given data to escape and quote.
        #
        # @return [String]
        #   The quoted Python string.
        #
        # @example
        #   Encoding::Python.quote("hello\nworld\n")
        #   # => "\"hello\\nworld\\n\""
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Unquotes and unescapes the given Python string.
        #
        # @param [String] data
        #   The given Python string.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::Python.unquote("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #   Encoding::Python.unquote("'hello\\nworld'")
        #   # => "hello\nworld"
        #   Encoding::Python.unquote("'''hello\\nworld'''")
        #   # => "hello\nworld"
        #   Encoding::Python.unquote("u'hello\\nworld'")
        #   # => "hello\nworld"
        #   Encoding::Python.unquote("r'hello\\nworld'")
        #   # => "hello\\nworld"
        #
        # @see https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals
        #
        def self.unquote(data)
          if (data.start_with?("'''") && data.end_with?("'''"))
            unescape(data[3..-4])
          elsif ((data.start_with?('"') && data.end_with?('"')) ||
                 (data.start_with?("'") && data.end_with?("'")))
            unescape(data[1..-2])
          elsif (data.start_with?("u'") && data.end_with?("'")) # unicode string
            unescape(data[2..-2])
          elsif (data.start_with?("r'") && data.end_with?("'")) # raw string
            data[2..-2]
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/python/core_ext'
