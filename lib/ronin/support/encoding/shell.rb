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
      # Contains methods for encoding/decoding escaping/unescaping Shell data.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#shell_encode}
      # * {Integer#shell_escape}
      # * {String#shell_escape}
      # * {String#shell_unescape}
      # * {String#shell_encode}
      # * {String#shell_decode}
      # * {String#shell_string}
      # * {String#shell_unquote}
      #
      # @api public
      #
      module Shell
        # Special shell bytes and their escaped Strings.
        ESCAPE_BYTES = {
          0x00 => "\\0",  # $'\0'
          0x07 => "\\a",  # $'\a'
          0x08 => "\\b",  # $'\b'
          0x09 => "\\t",  # $'\t'
          0x0a => "\\n",  # $'\n'
          0x0b => "\\v",  # $'\v'
          0x0c => "\\f",  # $'\f'
          0x0d => "\\r",  # $'\r'
          0x1B => "\\e",  # $'\e'
          0x22 => "\\\"", # \"
          0x23 => "\\#",  # \#
          0x5c => "\\\\"  # \\
        }

        #
        # Encodes the byte as a shell character.
        #
        # @param [Integer] byte
        #   The byte value to encode.
        #
        # @return [String]
        #   The encoded shell character.
        #
        # @raise [RangeError]
        #   The byte value is negative.
        #
        # @example
        #   Encoding::Shell.encode_byte(0x41)
        #   # => "\\x41"
        #   Encoding::Shell.encode_byte(0x0a)
        #   # => "\\n"
        #
        # @example Encoding unicode characters:
        #   Encoding::Shell.encode_byte(1001)
        #   # => "\\u1001"
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            "\\x%.2x" % byte
          elsif byte > 0xff
            "\\u%x" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # Escapes the byte as a shell character.
        #
        # @param [Integer] byte
        #   The byte value to escape.
        #
        # @return [String]
        #   The escaped shell character.
        #
        # @raise [RangeError]
        #   The integer value is negative.
        #
        # @example
        #   Encoding::Shell.escape(0x41)
        #   # => "A"
        #   Encoding::Shell.escape(0x08)
        #   # => "\b"
        #   Encoding::Shell.escape(0xff)
        #   # => "\xff"
        #
        # @example Escaping unicode characters:
        #   Encoding::Shell.escape(1001)
        #   # => "\\u1001"
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

        # Shell characters that must be back-slashed.
        BACKSLASHED_CHARS = {
          '\0'  => "\0",
          '\a'  => "\a",
          '\b'  => "\b",
          '\e'  => "\e",
          '\t'  => "\t",
          '\n'  => "\n",
          '\v'  => "\v",
          '\f'  => "\f",
          '\r'  => "\r",
          "\\'"  => "'",
          '\\"'  => '"'
        }

        #
        # Shell escapes any special characters in the given data.
        #
        # @param [String] data
        #   The data to shell escape.
        #
        # @return [String]
        #   The shell escaped string.
        #
        # @example
        #   Encoding::Shell.escape("hello\nworld")
        #   # => "hello\\nworld"
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
        # Shell unescapes the given data.
        #
        # @param [String] data
        #   The data to shell unescape.
        #
        # @return [String]
        #   The shell unescaped string.
        #
        # @example
        #   "hello\\nworld".shell_unescape
        #   # => "hello\nworld"
        #
        def self.unescape(data)
          unescaped = String.new
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (backslash_char = scanner.scan(/\\[0abetnvfr\'\"]/)) # \n
                           BACKSLASHED_CHARS[backslash_char]
                         elsif (hex_char     = scanner.scan(/\\x[0-9a-fA-F]+/)) # \XX
                           hex_char[2..].to_i(16).chr
                         elsif (unicode_char = scanner.scan(/\\u[0-9a-fA-F]+/)) # \uXXXX
                           unicode_char[2..].to_i(16).chr(Encoding::UTF_8)
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # Shell encodes every character in the given data.
        #
        # @param [String] data
        #   The data to shell encode.
        #
        # @return [String]
        #   The shell encoded String.
        #
        # @example
        #   Encoding::Shell.encode("hello world")
        #   # => "\\x68\\x65\\x6c\\x6c\\x6f\\x0a\\x77\\x6f\\x72\\x6c\\x64"
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
        #   The data to shell unescape.
        #
        # @return [String]
        #   The shell unescaped string.
        #
        # @see unescape
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Converts the given data into a double-quoted shell escaped String.
        #
        # @param [String] data
        #   The given data to shell escape and quote.
        #
        # @return [String]
        #   The quoted and escaped shell string.
        #
        # @example
        #   Encoding::Shell.quote("hello world")
        #   # => "\"hello world\""
        #   Encoding::Shell.quote("hello\nworld")
        #   # => "$'hello\\nworld'"
        #
        def self.quote(data)
          if data =~ /[^[:print:]]/
            "$'#{escape(data)}'"
          else
            "\"#{escape(data)}\""
          end
        end

        #
        # Removes the quotes an unescapes a shell string.
        #
        # @param [String] data
        #   The quoted and escaped shell string to unquote and unescape.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::Shell.unquote("\"hello \\\"world\\\"\"")
        #   # => "hello \"world\""
        #   Encoding::Shell.unquote("'hello\\'world'")
        #   # => "hello'world"
        #   Encoding::Shell.unquote("$'hello\\nworld'")
        #   # => "hello\nworld"
        #
        def self.unquote(data)
          if (data[0,2] == "$'" && data[-1] == "'")
            unescape(data[2..-2])
          elsif (data[0] == '"' && data[-1] == '"')
            data[1..-2].gsub("\\\"",'"')
          elsif (data[0] == "'" && data[-1] == "'")
            data[1..-2].gsub("\\'","'")
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/shell/core_ext'
