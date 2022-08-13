#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
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

require 'uri/common'

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
        # @example
        #   Encoding::URI.encode_byte(0x41)
        #   # => "%41"
        #
        def self.encode_byte(byte)
          "%%%2X" % byte
        end

        #
        # URI escapes the byte.
        #
        # @param [Integer] byte
        #   The byte to URI escape.
        #
        # @param [Array<String>, nil] unsafe
        #   Optiona set of unsafe characters to escape.
        #
        # @return [String]
        #   The URI escaped byte.
        #
        # @example
        #   Encoding::URI.escape(0x41)
        #   # => "A"
        #   Encoding::URI.escape(0x3d)
        #   # => "%3D"
        #
        def self.escape_byte(byte, unsafe: nil)
          char = byte.chr

          if unsafe then ::URI::DEFAULT_PARSER.escape(char,unsafe.join)
          else           ::URI::DEFAULT_PARSER.escape(char)
          end
        end

        #
        # URI escapes the String.
        #
        # @param [String] data
        #   The data to URI escape.
        #
        # @param [Array<String>] unsafe
        #   The unsafe characters to encode.
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
        def self.escape(data, unsafe: nil)
          if unsafe then ::URI::DEFAULT_PARSER.escape(data,unsafe.join)
          else           ::URI::DEFAULT_PARSER.escape(data)
          end
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
          ::URI::DEFAULT_PARSER.unescape(data)
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

          data.each_char do |char|
            encoded << encode_byte(char.ord)
          end

          return encoded
        end

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
          def self.encode_byte(byte)
            if byte == 0x20 then '+'
            else                 URI.encode_byte(byte)
            end
          end

          #
          # URI Form escapes the Integer.
          #
          # @param [Integer] byte
          #   The byte to URI Form escape.
          #
          # @return [String]
          #   The URI Form escaped Integer.
          #
          # @example
          #   Encoding::URI::Form.escape(0x41)
          #   # => "A"
          #   Encoding::URI::Form.escape(0x20)
          #   # => "+"
          #
          def self.escape_byte(byte)
            ::URI.encode_www_form_component(byte.chr)
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
            ::URI.encode_www_form_component(data)
          end

          #
          # URI Form unescapes the String.
          #
          # @return [String]
          #   The URI Form unescaped String.
          #
          # @example
          #   "hello+world".uri_form_unescape
          #   # => "hello world"
          #   "hello%00world".uri_form_unescape
          #   # => "hello\u0000world"
          #
          def self.unescape(data)
            ::URI.decode_www_form_component(data)
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
          #   # => 
          #
          def self.encode(data)
            encoded = String.new

            data.each_char do |char|
              encoded << encode_byte(char.ord)
            end

            return encoded
          end

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
