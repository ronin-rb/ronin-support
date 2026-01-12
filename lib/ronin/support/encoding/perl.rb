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
      # Contains methods for encoding/decoding escaping/unescaping Perl strings.
      #
      # ## Core-Ext Methods
      #
      # * {String#perl_escape}
      # * {String#perl_unescape}
      # * {String#perl_encode}
      # * {String#perl_decode}
      # * {String#perl_string}
      # * {String#perl_unquote}
      #
      # @api public
      #
      # @since 1.2.0
      #
      module Perl
        #
        # Encodes a byte as a Perl escaped character.
        #
        # @param [Integer] byte
        #   The byte value to encode.
        #
        # @return [String]
        #   The escaped Perl character.
        #
        # @example
        #   Encoding::Perl.encode_byte(0x41)
        #   # => "\\x41"
        #   Encoding::Perl.encode_byte(0x100)
        #   # => "\\x{100}"
        #   Encoding::Perl.encode_byte(0x10000)
        #   # => "\\x{10000}"
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            "\\x%2X" % byte
          elsif byte >= 0x100 && byte <= 0x10ffff
            "\\x{%.X}" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        # Special Perl bytes and their escaped Strings.
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        ESCAPE_BYTES = {
          0x07 => '\a',
          0x08 => '\b',
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
        # Escapes a byte as a Perl character.
        #
        # @param [Integer] byte
        #   The byte value to escape.
        #
        # @return [String]
        #   The escaped Perl character.
        #
        # @raise [RangeError]
        #   The byte value isn't a valid ASCII or UTF byte.
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
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
        # Encodes each byte of the given data as a Perl escaped character.
        #
        # @param [String] data
        #   The given data to encode.
        #
        # @return [String]
        #   The encoded Perl String.
        #
        # @example
        #   Encoding::Perl.encode("hello")
        #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
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
        # Decodes the Perl encoded data.
        #
        # @param [String] data
        #   The given Perl data to decode.
        #
        # @return [String]
        #   The decoded data.
        #
        # @see unescape
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Escapes the Perl string.
        #
        # @param [String] data
        #   The data to escape.
        #
        # @return [String]
        #   The Perl escaped String.
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
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

        # Common escaped characters.
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        BACKSLASH_CHARS = {
          '\a'   => "\a",
          '\b'   => "\b",
          '\t'   => "\t",
          '\n'   => "\n",
          '\f'   => "\f",
          '\r'   => "\r",
          '\e'   => "\e",
          '\"'   => '"',
          '\$'   => '$',
          '\\\\' => '\\'
        }

        # `\c` control characters.
        #
        # @see https://perldoc.perl.org/perlop#%5B5%5D
        CONTROL_CHARS = {
          '\c@' => "\x00",
          '\cA' => "\x01",
          '\cB' => "\x02",
          '\cC' => "\x03",
          '\cD' => "\x04",
          '\cE' => "\x05",
          '\cF' => "\x06",
          '\cG' => "\x07",
          '\cH' => "\x08",
          '\cI' => "\x09",
          '\cJ' => "\x0a",
          '\cK' => "\x0b",
          '\cL' => "\x0c",
          '\cM' => "\x0d",
          '\cN' => "\x0e",
          '\cO' => "\x0f",
          '\cP' => "\x10",
          '\cQ' => "\x11",
          '\cR' => "\x12",
          '\cS' => "\x13",
          '\cT' => "\x14",
          '\cU' => "\x15",
          '\cV' => "\x16",
          '\cW' => "\x17",
          '\cX' => "\x18",
          '\cY' => "\x19",
          '\cZ' => "\x1a",
          '\ca' => "\x01",
          '\cb' => "\x02",
          '\cc' => "\x03",
          '\cd' => "\x04",
          '\ce' => "\x05",
          '\cf' => "\x06",
          '\cg' => "\x07",
          '\ch' => "\x08",
          '\ci' => "\x09",
          '\cj' => "\x0a",
          '\ck' => "\x0b",
          '\cl' => "\x0c",
          '\cm' => "\x0d",
          '\cn' => "\x0e",
          '\co' => "\x0f",
          '\cp' => "\x10",
          '\cq' => "\x11",
          '\cr' => "\x12",
          '\cs' => "\x13",
          '\ct' => "\x14",
          '\cu' => "\x15",
          '\cv' => "\x16",
          '\cw' => "\x17",
          '\cx' => "\x18",
          '\cy' => "\x19",
          '\cz' => "\x1a",
          '\c[' => "\x1b",
          '\c]' => "\x1d",
          '\c^' => "\x1e",
          '\c_' => "\x1f",
          '\c?' => "\x7f"
        }

        #
        # Unescapes the escaped [Perl String][1].
        #
        # @param [String] data
        #   The given Perl escaped data.
        #
        # @return [String]
        #   The unescaped version of the hex escaped String.
        #
        # @raise [NotImplementedError]
        #   Decoding [Perl Unicode Named Characters][2] is currently not
        #   supported (ex: `\N{GREEK CAPITAL LETTER SIGMA}`).
        #
        #   [2]: https://www.perl.com/pub/2012/04/perlunicook-unicode-named-characters.html/
        #
        # @example
        #   Encoding::Perl.unescape("\\x68\\x65\\x6c\\x6c\\x6f")
        #   # => "hello"
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        #
        def self.unescape(data)
          unescaped = String.new(encoding: Encoding::UTF_8)
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (unicode_escape      = scanner.scan(/\\x\{\s*[0-9a-fA-F]{1,8}\s*\}/)) # \x{X...}
                           unicode_escape[3..-2].strip.to_i(16).chr(Encoding::UTF_8)
                         elsif (unicode_escape   = scanner.scan(/\\N\{\s*U\+[0-9a-fA-F]{1,8}\s*\}/)) # \N{U+X...}
                           unicode_escape[3..-2].strip[2..].to_i(16).chr(Encoding::UTF_8)
                         elsif (unicode_escape   = scanner.scan(/\\N\{[^\}]+\}/)) # \N{NAMED UNICODE CHAR}
                           raise(NotImplementedError,"decoding Perl Unicode Named Characters (#{unicode_escape.inspect}) is currently not supported: #{data.inspect}")
                         elsif (hex_escape       = scanner.scan(/\\x[0-9a-fA-F]{0,2}/)) # \xXX, \xX, or \x
                           hex = hex_escape[2..]

                           unless hex.empty? then hex.to_i(16).chr
                           else                   '' # no-op
                           end
                         elsif (octal_escape     = scanner.scan(/\\o\{\s*[0-7]{1,3}\s*\}/)) # \o{NNN}, \o{NN}, \o{N}
                           octal_escape[3..-2].strip.to_i(8).chr
                         elsif (octal_escape     = scanner.scan(/\\[0-7]{1,3}/)) # \NNN, \NN, \N
                           octal_escape[1..].to_i(8).chr
                         elsif (control_char     = scanner.scan(/\\c[@a-zA-Z\[\]\^_\?]/)) # \c control char
                           CONTROL_CHARS.fetch(control_char)
                         elsif (backslash_escape = scanner.scan(/\\./)) # \C
                           BACKSLASH_CHARS.fetch(backslash_escape) do
                             backslash_escape[1]
                           end
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # Escapes and quotes the given data as a Perl string.
        #
        # @param [String] data
        #   The given data to escape and quote.
        #
        # @return [String]
        #   The quoted Perl string.
        #
        # @example
        #   Encoding::Perl.quote("hello\nworld\n")
        #   # => "\"hello\\nworld\\n\""
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Removes the quotes an unescapes a [quoted Perl string][1].
        #
        # [1]: https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        #
        # @param [String] data
        #   The given Perl string.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::Perl.unquote("\"hello\\nworld\"")
        #   # => "hello\nworld"
        #   Encoding::Perl.unquote("qq{hello\\'world}")
        #   # => "hello'world"
        #   Encoding::Perl.unquote("'hello\\'world'")
        #   # => "hello'world"
        #   Encoding::Perl.unquote("q{hello\\'world}")
        #   # => "hello\\'world"
        #
        # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
        #
        def self.unquote(data)
          if (data.start_with?('"') && data.end_with?('"'))
            unescape(data[1..-2])
          elsif (data.start_with?('qq{') && data.end_with?('}'))
            unescape(data[3..-2])
          elsif (data.start_with?("'") && data.end_with?("'"))
            data[1..-2].gsub(/\\(['\\])/,'\1')
          elsif (data.start_with?('q{') && data.end_with?('}'))
            data[2..-2]
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/perl/core_ext'
