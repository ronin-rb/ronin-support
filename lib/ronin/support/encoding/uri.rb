# frozen_string_literal: true
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

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping URI data.
      #
      # @api public
      #
      module URI
        #
        # URI encodes the byte.
        #
        # @param [Integer] byte
        #   The byte to URI encode.
        #
        # @return [String]
        #   The URI encoded byte.
        #
        # @raise [RangeError]
        #   The byte value is negative.
        #
        # @example
        #   Encoding::URI.encode_byte(0x41)
        #   # => "%41"
        #
        def self.encode_byte(byte)
          if (byte >= 0) && (byte <= 0xff)
            "%%%2X" % byte
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # URI escapes the byte.
        #
        # @param [Integer] byte
        #   The byte to URI escape.
        #
        # @return [String]
        #   The URI escaped byte.
        #
        # @raise [RangeError]
        #   The byte value is negative.
        #
        # @example
        #   Encoding::URI.escape_byte(0x41)
        #   # => "A"
        #   Encoding::URI.escape_byte(0x3d)
        #   # => "%3D"
        #
        def self.escape_byte(byte)
          if (byte >= 0) && (byte <= 0xff)
            if ((byte >= 0) && (byte <= 32)) || (byte == 34) || (byte == 35) || (byte == 37) || (byte == 60) || (byte == 62) || (byte == 92) || (byte == 94) || (byte == 96) || ((byte >= 123) && (byte <= 125)) || (byte >= 127)
              "%%%2X" % byte
            else
              byte.chr
            end
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # URI escapes the String.
        #
        # @param [String] data
        #   The data to URI escape.
        #
        # @return [String]
        #   The URI escaped form of the String.
        #
        # @example
        #   Encoding::URI.escape("x > y")
        #   # => "x%20%3E%20y"
        #
        # @api public
        #
        def self.escape(data)
          escaped = String.new

          data.each_byte do |byte|
            escaped << escape_byte(byte)
          end

          return escaped
        end

        #
        # URI unescapes the String.
        #
        # @param [String] data
        #   The URI escaped data to unescape.
        #
        # @return [String]
        #   The unescaped URI form of the String.
        #
        # @example
        #   Encoding::URI.unescape("sweet%20%26%20sour")
        #   # => "sweet & sour"
        #
        def self.unescape(data)
          data.gsub(/%[A-Fa-f0-9]{2}/) do |escaped_char|
            escaped_char[1..].to_i(16).chr
          end
        end

        #
        # URI encodes the String.
        #
        # @param [String] data
        #   The data to URI encode.
        #
        # @return [String]
        #   The URI encoded form of the String.
        #
        # @example
        #   Encoding::URI.encode("plain text")
        #   # => "%70%6C%61%69%6E%20%74%65%78%74"
        #
        def self.encode(data)
          encoded = String.new

          data.each_byte do |byte|
            encoded << encode_byte(byte)
          end

          return encoded
        end

        #
        # Alias for {unescape}.
        #
        # @param [String] data
        #   The URI escaped data to decode.
        #
        # @return [String]
        #   The decoded URI form of the String.
        #
        # @see unescape
        #
        def self.decode(data)
          unescape(data)
        end

        #
        # Contains methods for encoding/decoding escaping/unescaping URI form
        # data.
        #
        # @api public
        #
        module Form
          #
          # URI Form encodes the given byte.
          #
          # @param [Integer] byte
          #   The byte to URI Form encode.
          #
          # @return [String]
          #   The URI Form encoded byte.
          #
          # @raise [RangeError]
          #   The byte value is negative.
          #
          def self.encode_byte(byte)
            if byte == 0x20 then '+'
            else                 URI.encode_byte(byte)
            end
          end

          #
          # URI Form escapes the given byte.
          #
          # @param [Integer] byte
          #   The byte to URI Form escape.
          #
          # @return [String]
          #   The URI Form escaped byte.
          #
          # @raise [RangeError]
          #   The byte value is negative.
          #
          # @example
          #   Encoding::URI::Form.escape_byte(0x41)
          #   # => "A"
          #   Encoding::URI::Form.escape_byte(0x20)
          #   # => "+"
          #
          def self.escape_byte(byte)
            if byte == 0x20 then '+'
            else            URI.escape_byte(byte)
            end
          end

          #
          # URI Form escapes the String.
          #
          # @param [String] data
          #   The data to URI Form escape.
          #
          # @return [String]
          #   The URI Form escaped String.
          #
          # @example
          #   Encoding::URI::Form.escape("hello world")
          #   # => "hello+world"
          #   Encoding::URI::Form.escape("hello\0world")
          #   # => "hello%00world"
          #
          # @see https://www.w3.org/TR/2013/CR-html5-20130806/forms.html#url-encoded-form-data
          def self.escape(data)
            escaped = String.new

            data.each_byte do |byte|
              escaped << escape_byte(byte)
            end

            return escaped
          end

          #
          # URI Form unescapes the String.
          #
          # @param [String] data
          #   The URI Form escaped data to unescape.
          #
          # @return [String]
          #   The URI Form unescaped String.
          #
          # @example
          #   Encoding::URI::Form.unescape("hello+world")
          #   # => "hello world"
          #   Encoding::URI::Form.unescape("hello%00world")
          #   # => "hello\u0000world"
          #
          def self.unescape(data)
            data.gsub(/(?:\+|%[A-Fa-f0-9]{2})/) do |escaped_char|
              if escaped_char == '+'
                ' '
              else
                escaped_char[1..].to_i(16).chr
              end
            end
          end

          #
          # URI Form encodes every character in the given data.
          #
          # @param [String] data
          #   The given data to URI Form encode.
          #
          # @return [String]
          #   The URI Form encoded String.
          #
          # @example
          #   Encoding::URI::Form.encode("hello world")
          #   # => "%68%65%6C%6C%6F+%77%6F%72%6C%64"
          #
          def self.encode(data)
            encoded = String.new

            data.each_byte do |byte|
              encoded << encode_byte(byte)
            end

            return encoded
          end

          #
          # Alias for {unescape}.
          #
          # @param [String] data
          #   The URI Form escaped data to decode.
          #
          # @return [String]
          #   The URI Form decoded String.
          #
          # @see unescape
          #
          def self.decode(data)
            unescape(data)
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/uri/core_ext'
