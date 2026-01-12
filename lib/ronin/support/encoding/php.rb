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
      # Contains methods for encoding/decoding escaping/unescaping PHP strings.
      #
      # ## Core-Ext Methods
      #
      # * {String#php_escape}
      # * {String#php_unescape}
      # * {String#php_encode}
      # * {String#php_decode}
      # * {String#php_string}
      # * {String#php_unquote}
      #
      # @api public
      #
      # @since 1.2.0
      #
      # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
      #
      module PHP
        # Special PHP bytes and their escaped Strings.
        ESCAPE_BYTES = {
          0x00 => '\0',
          0x09 => '\t',
          0x0a => '\n',
          0x0c => '\f',
          0x0d => '\r',
          0x1b => '\e',
          0x22 => '\"',
          0x24 => '\$',
          0x5c => '\\\\'
        }

        #
        # Encodes a byte as a PHP escaped character.
        #
        # @param [Integer] byte
        #   The byte value to encode.
        #
        # @return [String]
        #   The escaped PHP character.
        #
        # @example
        #   Encoding::PHP.encode_byte(0x41)
        #   # => "\\x41"
        #   Encoding::PHP.encode_byte(0x100)
        #   # => "\\u{100}"
        #   Encoding::PHP.encode_byte(0x10000)
        #   # => "\\u{10000}"
        #
        # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            "\\x%.2x" % byte
          elsif byte >= 0x100 && byte <= 0x10ffff
            "\\u{%.x}" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # Escapes a byte as a PHP character.
        #
        # @param [Integer] byte
        #   The byte value to escape.
        #
        # @return [String]
        #   The escaped PHP character.
        #
        # @raise [RangeError]
        #   The byte value isn't a valid ASCII or UTF byte.
        #
        # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
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
        # Encodes each byte of the given data as a PHP escaped character.
        #
        # @param [String] data
        #   The given data to encode.
        #
        # @return [String]
        #   The encoded PHP String.
        #
        # @example
        #   Encoding::PHP.encode("hello")
        #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
        #
        # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
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
        # Decodes the PHP encoded data.
        #
        # @param [String] data
        #   The given PHP data to decode.
        #
        # @return [String]
        #   The decoded data.
        #
        # @see unescape
        # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double).
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Escapes the PHP string.
        #
        # @param [String] data
        #   The data to escape.
        #
        # @return [String]
        #   The PHP escaped String.
        #
        # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
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

        # PHP characters that must be backslash escaped.
        #
        # @see https://www.php.net/manual/en/language.types.string.php
        BACKSLASH_CHARS = {
          '\0'   => "\0",
          '\t'   => "\t",
          '\n'   => "\n",
          '\v'   => "\v",
          '\f'   => "\f",
          '\r'   => "\r",
          '\"'   => '"',
          '\$'   => "$",
          '\\\\' => "\\"
        }

        #
        # Unescapes the PHP escaped String.
        #
        # @param [String] data
        #   The given PHP escaped data.
        #
        # @return [String]
        #   The unescaped version of the hex escaped String.
        #
        # @example
        #   Encoding::PHP.unescape("\\x68\\x65\\x6c\\x6c\\x6f")
        #   # => "hello"
        #
        # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
        #
        def self.unescape(data)
          unescaped = String.new(encoding: Encoding::UTF_8)
          scanner   = StringScanner.new(data)

          until scanner.eos?
            # see https://www.php.net/manual/en/language.types.string.php
            unescaped << if (hex_escape     = scanner.scan(/\\x[0-9a-fA-F]{1,2}/))
                           hex_escape[2..].to_i(16).chr
                         elsif (unicode_escape = scanner.scan(/\\u\{[0-9a-fA-F]+\}/))
                           unicode_escape[3..-2].to_i(16).chr(Encoding::UTF_8)
                         elsif (octal_escape   = scanner.scan(/\\[0-7]{1,3}/))
                           octal_escape[1..].to_i(8).chr

                         elsif (backslash_char    = scanner.scan(/\\./))
                           BACKSLASH_CHARS.fetch(backslash_char,backslash_char)
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # Escapes and quotes the given data as a PHP string.
        #
        # @param [String] data
        #   The given data to escape and quote.
        #
        # @return [String]
        #   The quoted PHP string.
        #
        # @example
        #   Encoding::PHP.quote("hello\nworld\n")
        #   # => "\"hello\\nworld\\n\""
        #
        # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Removes the quotes and unescapes the PHP quoted string.
        #
        # @param [String] data
        #   The given PHP string.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::PHP.unquote("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #   Encoding::PHP.unquote("'hello\\'world'")
        #   # => "hello'world"
        #
        # @see https://www.php.net/manual/en/language.types.string.php
        #
        def self.unquote(data)
          if (data.start_with?('"') && data.end_with?('"'))
            unescape(data[1..-2])
          elsif (data.start_with?("'") && data.end_with?("'"))
            data[1..-2].gsub(/\\(['\\])/,'\1')
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/php/core_ext'
