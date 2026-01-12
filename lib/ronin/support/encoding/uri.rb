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

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping URI data.
      #
      # ## Features
      #
      # * Supports uppercase (ex: `%FF`) and lowercase (ex: `%ff`) URI encoding.
      # * Supports {URI::Form URI form} encoding.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#uri_encode}
      # * {Integer#uri_escape}
      # * {Integer#uri_form_encode}
      # * {Integer#uri_form_escape}
      # * {String#uri_escape}
      # * {String#uri_unescape}
      # * {String#uri_encode}
      # * {String#uri_decode}
      # * {String#uri_form_escape}
      # * {String#uri_form_unescape}
      # * {String#uri_form_encode}
      # * {String#uri_form_decode}
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The URI encoded byte.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
        #
        # @raise [RangeError]
        #   The byte value is negative or greater than 255.
        #
        # @example
        #   Encoding::URI.encode_byte(0x41)
        #   # => "%41"
        #
        # @example Lowercase encoding:
        #   Encoding::URI.encode_byte(0xff, case: :lower)
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
        # URI escapes the byte.
        #
        # @param [Integer] byte
        #   The byte to URI escape.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The URI escaped byte.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
        #
        # @raise [RangeError]
        #   The byte value is negative or greater than 255.
        #
        # @example
        #   Encoding::URI.escape_byte(0x41)
        #   # => "A"
        #   Encoding::URI.escape_byte(0x3d)
        #   # => "%3D"
        #
        # @example Lowercase encoding:
        #   Encoding::URI.escape_byte(0xff, case: :lower)
        #   # => "%ff"
        #
        def self.escape_byte(byte,**kwargs)
          if (byte >= 0) && (byte <= 0xff)
            if (byte == 33) || (byte == 36) || (byte == 38) || ((byte >= 39) && (byte <= 59)) || (byte == 61) || ((byte >= 63) && (byte <= 91)) || (byte == 93) || (byte == 95) || ((byte >= 97) && (byte <= 122)) || (byte == 126)
              byte.chr
            else
              encode_byte(byte,**kwargs)
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The URI escaped form of the String.
        #
        # @raise [ArgumentError]
        #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
        #
        # @example
        #   Encoding::URI.escape("x > y")
        #   # => "x%20%3E%20y"
        #
        # @example Lowercase encoding:
        #   Encoding::URI.escape("x > y", case: :lower)
        #   # => "x%20%3e%20y"
        #
        # @api public
        #
        def self.escape(data,**kwargs)
          escaped = String.new

          data.each_byte do |byte|
            escaped << escape_byte(byte,**kwargs)
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:lower, :upper, nil] :case
        #   Controls whether to output lowercase or uppercase hexadecimal.
        #   Defaults to uppercase hexadecimal.
        #
        # @return [String]
        #   The URI encoded form of the String.
        #
        # @example
        #   Encoding::URI.encode("plain text")
        #   # => "%70%6C%61%69%6E%20%74%65%78%74"
        #
        # @example Lowercase encoding:
        #   Encoding::URI.escape("plain text", case: :lower)
        #   # => "%70%6c%61%69%6e%20%74%65%78%74"
        #
        def self.encode(data,**kwargs)
          encoded = String.new

          data.each_byte do |byte|
            encoded << encode_byte(byte,**kwargs)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option kwargs [:lower, :upper, nil] :case
          #   Controls whether to output lowercase or uppercase hexadecimal.
          #   Defaults to uppercase hexadecimal.
          #
          # @return [String]
          #   The URI Form encoded byte.
          #
          # @raise [RangeError]
          #   The byte value is negative or greater than 255.
          #
          # @example
          #   Encoding::URI::Form.encode_byte(0x41)
          #   # => "%41"
          #   Encoding::URI::Form.encode_byte(0x20)
          #   # => "+"
          #
          # @example Lowercase encoding:
          #   Encoding::URI::Form.encode_byte(0xff, case: :lower)
          #   # => "%ff"
          #
          def self.encode_byte(byte,**kwargs)
            if byte == 0x20 then '+'
            else                 URI.encode_byte(byte,**kwargs)
            end
          end

          #
          # URI Form escapes the given byte.
          #
          # @param [Integer] byte
          #   The byte to URI Form escape.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option kwargs [:lower, :upper, nil] :case
          #   Controls whether to output lowercase or uppercase hexadecimal.
          #   Defaults to uppercase hexadecimal.
          #
          # @return [String]
          #   The URI Form escaped byte.
          #
          # @raise [RangeError]
          #   The byte value is negative or greater than 255.
          #
          # @example
          #   Encoding::URI::Form.escape_byte(0x41)
          #   # => "A"
          #   Encoding::URI::Form.escape_byte(0x20)
          #   # => "+"
          #
          # @example Lowercase encoding:
          #   Encoding::URI::Form.escape_byte(0xff, case: :lower)
          #   # => "%ff"
          #
          def self.escape_byte(byte,**kwargs)
            if (byte == 42) || (byte == 45) || (byte == 46) || ((byte >= 48) && (byte <= 57)) || ((byte >= 65) && (byte <= 90)) || (byte == 95) || ((byte >= 97) && (byte <= 122))
              byte.chr
            else
              encode_byte(byte,**kwargs)
            end
          end

          #
          # URI Form escapes the String.
          #
          # @param [String] data
          #   The data to URI Form escape.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option kwargs [:lower, :upper, nil] :case
          #   Controls whether to output lowercase or uppercase hexadecimal.
          #   Defaults to uppercase hexadecimal.
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
          # @example Lowercase encoding:
          #   Encoding::URI::Form.escape("hello\xffworld", case: :lower)
          #   # => "hello%ffworld"
          #
          # @see https://www.w3.org/TR/2013/CR-html5-20130806/forms.html#url-encoded-form-data
          def self.escape(data,**kwargs)
            escaped = String.new

            data.each_byte do |byte|
              escaped << escape_byte(byte,**kwargs)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option kwargs [:lower, :upper, nil] :case
          #   Controls whether to output lowercase or uppercase hexadecimal.
          #   Defaults to uppercase hexadecimal.
          #
          # @return [String]
          #   The URI Form encoded String.
          #
          # @example
          #   Encoding::URI::Form.encode("hello world")
          #   # => "%68%65%6C%6C%6F+%77%6F%72%6C%64"
          #
          # @example Lowercase encoding:
          #   Encoding::URI::Form.encode("hello world", case: :lower)
          #   # => "%68%65%6c%6c%6f+%77%6f%72%6c%64"
          #
          def self.encode(data,**kwargs)
            encoded = String.new

            data.each_byte do |byte|
              encoded << encode_byte(byte,**kwargs)
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
