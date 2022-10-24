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
      # Contains methods for encoding/decoding escaping/unescaping HTTP data.
      #
      # @api public
      #
      module HTTP
        #
        # Encodes the byte as an escaped HTTP decimal character.
        #
        # @param [Integer] byte
        #   The byte toe HTTP encode.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The encoded HTTP byte.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
        #
        # @raise [RangeError]
        #   The byte value is negative or greater than 255.
        #
        # @example
        #   Encoding::HTTP.encode_byte(0x41)
        #   # => "%41"
        #
        # @example Lowercase encoding:
        #   Encoding::HTTP.encode_byte(0xff, case: :lower)
        #   # => "%ff"
        #
        def self.encode_byte(byte,**kwargs)
          if (byte >= 0) && (byte <= 0xff)
            case kwargs[:case]
            when :lower
              "%%%.2x" % byte
            when :upper, nil
              "%%%.2X" % byte
            else
              raise(ArgumentError,"case (#{kwargs[:case].inspect}) keyword argument must be either :lower, :upper, or nil")
            end
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # HTTP escapes the Integer.
        #
        # @param [Integer] byte
        #   The byte toe HTTP escape.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The HTTP escaped form of the Integer.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
        #
        # @raise [RangeError]
        #   The byte value is negative or greater than 255.
        #
        # @example
        #   Encoding::HTTP.escape_byte(0x41)
        #   # => "A"
        #   Encoding::HTTP.escape_byte(62)
        #   # => "%3E"
        #
        # @example Lowercase encoding:
        #   Encoding::HTTP.escape_byte(0xff, case: :lower)
        #   # => "%ff"
        #
        def self.escape_byte(byte,**kwargs)
          if (byte >= 0) && (byte <= 0xff)
            if (byte == 45) || (byte == 46) || ((byte >= 48) && (byte <= 57)) || ((byte >= 65) && (byte <= 90)) || (byte == 95) || ((byte >= 97) && (byte <= 122)) || (byte == 126)
              byte.chr
            elsif byte == 0x20
              '+'
            else
              encode_byte(byte,**kwargs)
            end
          else
            raise(RangeError,"#{byte.inspect} out of char range")
          end
        end

        #
        # HTTP escapes the special characters in the given data.
        #
        # @param [String] data
        #   The data to HTTP escape.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The HTTP escaped form of the String.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
        #
        # @example
        #   Encoding::HTTP.escape("x > y")
        #   # => "x+%3E+y"
        #
        # @example Lowercase encoding:
        #   Encoding::HTTP.escape("x > y", case: :lower)
        #   # => "x+%3e+y"
        #
        def self.escape(data,**kwargs)
          escaped = String.new

          data.each_byte do |byte|
            escaped << escape_byte(byte,**kwargs)
          end

          return escaped
        end

        #
        # HTTP unescapes the String.
        #
        # @param [String] data
        #   The data to unescape.
        #
        # @return [String]
        #   The raw String.
        #
        # @example
        #   Encoding::HTTP.unescape("sweet+%26+sour")
        #   # => "sweet & sour"
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
        # HTTP encodes each byte of the String.
        #
        # @param [String] data
        #   The data to HTTP encode.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The HTTP hexadecimal encoded form of the String.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
        #
        # @example
        #   Encoding::HTTP.encode("hello")
        #   # => "%68%65%6c%6c%6f"
        #
        # @example Lowercase encoding:
        #   Encoding::HTTP.encode("hello")
        #   # => "%68%65%6c%6c%6f"
        #
        def self.encode(data,**kwargs)
          encoded = String.new

          data.each_byte do |byte|
            encoded << encode_byte(byte,**kwargs)
          end

          return encoded
        end

        #
        # HTTP decodes the HTTP encoded String.
        #
        # @param [String] data
        #   The HTTP encoded data to decode.
        #
        # @return [String]
        #   The decoded String.
        #
        # @example
        #   Encoding::HTTP.decode("sweet+%26+sour")
        #   # => "sweet & sour"
        #
        def self.decode(data)
          unescape(data)
        end
      end
    end
  end
end

require 'ronin/support/encoding/http/core_ext'
