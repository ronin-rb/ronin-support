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
      # Contains methods for encoding/decoding escaping/unescaping PowerShell
      # data.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#powershell_encode}
      # * {Integer#powershell_escape}
      # * {String#powershell_escape}
      # * {String#powershell_unescape}
      # * {String#powershell_encode}
      # * {String#powershell_decode}
      # * {String#powershell_string}
      # * {String#powershell_unquote}
      #
      # @api public
      #
      module PowerShell
        # Special PowerShell bytes and their escaped Strings.
        #
        # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
        ESCAPE_BYTES = {
          0x00 => "`0",
          0x07 => "`a",
          0x08 => "`b",
          0x09 => "`t",
          0x0a => "`n",
          0x0b => "`v",
          0x0c => "`f",
          0x0d => "`r",
          0x22 => '`"',
          0x23 => "`#",
          0x27 => "`'",
          0x5c => "\\\\", # \\
          0x60 => "``"
        }

        #
        # Encodes the byte as a PowerShell character.
        #
        # @param [Integer] byte
        #   The byte to escape.
        #
        # @return [String]
        #   The encoded PowerShell character.
        #
        # @raise [RangeError]
        #   The integer value is negative.
        #
        # @example
        #   Encoding::PowerShell.encode_byte(0x41)
        #   # => "[char]0x41"
        #   Encoding::PowerShell.encode_byte(0x0a)
        #   # => "`n"
        #
        # @example Encoding unicode characters:
        #   Encoding::PowerShell.encode_byte(1001)
        #   # => "`u{1001}"
        #
        # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
        #
        def self.encode_byte(byte)
          if byte >= 0x00 && byte <= 0xff
            "$([char]0x%.2x)" % byte
          elsif byte > 0xff
            "$([char]0x%x)" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # Escapes the byte as a PowerShell character.
        #
        # @param [Integer] byte
        #   The byte to escape.
        #
        # @return [String]
        #   The escaped PowerShell character.
        #
        # @raise [RangeError]
        #   The integer value is negative.
        #
        # @example
        #   Encoding::PowerShell.escape_byte(0x41)
        #   # => "A"
        #   Encoding::PowerShell.escape_byte(0x08)
        #   # => "`b"
        #   Encoding::PowerShell.escape_byte(0xff)
        #   # => "[char]0xff"
        #
        # @example Escaping unicode characters:
        #   Encoding::PowerShell.escape_byte(1001)
        #   # => "`u{1001}"
        #
        # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
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

        # PowerShell characters that must be grave-accent escaped.
        #
        # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
        BACKSLASHED_CHARS = {
          '0'  => "\0",
          'a'  => "\a",
          'b'  => "\b",
          't'  => "\t",
          'n'  => "\n",
          'v'  => "\v",
          'f'  => "\f",
          'r'  => "\r",
          '"'  => '"',
          '#'  => '#',
          "'"  => "'",
          "`"  => "`"
        }

        #
        # PowerShell escapes the special characters in the data.
        #
        # @param [String] data
        #   The data to PowerShell escape.
        #
        # @return [String]
        #   The PowerShell escaped string.
        #
        # @example
        #   Encoding::PowerShell.escape("hello\nworld")
        #   # => "hello`nworld"
        #
        # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
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
        # PowerShell unescapes the characters in the data.
        #
        # @param [String] data
        #   The PowerShell encoded data to unescape.
        #
        # @return [String]
        #   The unescaped string.
        #
        # @example
        #   Encoding::PowerShell.unescape("hello`nworld")
        #   # => "hello\nworld"
        #
        # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
        #
        def self.unescape(data)
          unescaped = String.new(encoding: Encoding::UTF_8)
          scanner   = StringScanner.new(data)

          until scanner.eos?
            unescaped << if (grave_escape      = scanner.scan(/`[0abetnvfr]/)) # `c
                           BACKSLASHED_CHARS.fetch(grave_escape[1,1])
                         elsif (hex_escape     = scanner.scan(/\$\(\[char\]0x[0-9a-fA-F]{1,2}\)/)) # [char]0xXX
                           hex_escape[10..-2].to_i(16).chr
                         elsif (hex_escape     = scanner.scan(/\$\(\[char\]0x[0-9a-fA-F]{3,}\)/)) # [char]0xXX
                           hex_escape[10..-2].to_i(16).chr(Encoding::UTF_8)
                         elsif (unicode_escape = scanner.scan(/`u\{[0-9a-fA-F]+\}/)) # `u{XXXX}'
                           unicode_escape[3..-2].to_i(16).chr(Encoding::UTF_8)
                         else
                           scanner.getch
                         end
          end

          return unescaped
        end

        #
        # PowerShell encodes every character in the data.
        #
        # @param [String] data
        #   The data to encode.
        #
        # @return [String]
        #   The PowerShell encoded String.
        #
        # @example
        #   Encoding::PowerShell.encode("hello world")
        #   # => "$([char]0x68)$([char]0x65)$([char]0x6c)$([char]0x6c)$([char]0x6f)$([char]0x20)$([char]0x77)$([char]0x6f)$([char]0x72)$([char]0x6c)$([char]0x64)"
        #
        # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
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
        #   The PowerShell encoded data to unescape.
        #
        # @return [String]
        #   The unescaped string.
        #
        # @see unescape
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Converts the data into a double-quoted PowerShell escaped String.
        #
        # @param [String] data
        #   the data to escape and quote.
        #
        # @return [String]
        #   The quoted and escaped PowerShell string.
        #
        # @example
        #   Encoding::PowerShell.quote("hello\nworld")
        #   # => "\"hello`nworld\""
        #
        def self.quote(data)
          "\"#{escape(data)}\""
        end

        #
        # Removes the quotes an unescapes a PowerShell string.
        #
        # @param [String] data
        #   The PowerShell string to unquote.
        #
        # @return [String]
        #   The un-quoted String if the String begins and ends with quotes, or
        #   the same String if it is not quoted.
        #
        # @example
        #   Encoding::PowerShell.unquote("\"hello`nworld\"")
        #   # => "hello\nworld"
        #   Encoding::PowerShell.unquote("'hello''world'")
        #   # => "hello'world"
        #
        def self.unquote(data)
          if (data.start_with?('"') && data.end_with?('"'))
            unescape(data[1..-2])
          elsif (data.start_with?("'") && data.end_with?("'"))
            data[1..-2].gsub("''","'")
          else
            data
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/powershell/core_ext'
