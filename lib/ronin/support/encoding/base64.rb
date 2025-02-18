# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      # Base64 encoding/decoding.
      #
      # ## Core-Ext Methods
      #
      # * {String#base64_encode}
      # * {String#base64_decode}
      #
      # @see https://en.wikipedia.org/wiki/Base64
      #
      # @api public
      #
      module Base64
        #
        # Base64 encodes the given data.
        #
        # @param [String] data
        #   The data to Base64 encode.
        #
        # @param [:strict, :url_safe, nil] mode
        #   The Base64 encoding mode.
        #
        # @return [String]
        #   The Base64 encoded data.
        #
        def self.encode(data, mode: nil)
          case mode
          when :strict   then strict_encode(data)
          when :url_safe then encode_urlsafe(data)
          when nil       then [data].pack("m")
          else
            raise(ArgumentError,"Base64 mode must be either :string, :url_safe, or nil: #{mode.inspect}")
          end
        end

        #
        # Base64 decodes the given data.
        #
        # @param [String] data
        #   The Base64 data to decode.
        #
        # @param [:strict, :url_safe, nil] mode
        #   The Base64 encoding mode.
        #
        # @return [String]
        #   The decoded data.
        #
        def self.decode(data, mode: nil)
          case mode
          when :strict   then strict_decode(data)
          when :url_safe then decode_urlsafe(data)
          when nil       then data.unpack1("m")
          else
            raise(ArgumentError,"Base64 mode must be either :string, :url_safe, or nil: #{mode.inspect}")
          end
        end

        #
        # Base64 strict encodes the given data.
        #
        # @param [String] data
        #   The data to Base64 encode.
        #
        # @return [String]
        #   The Base64 strict encoded data.
        #
        def self.strict_encode(data)
          [data].pack("m0")
        end

        #
        # Base64 strict decodes the given data.
        #
        # @param [String] data
        #   The Base64 data to decode.
        #
        # @return [String]
        #   The strict decoded data.
        #
        def self.strict_decode(data)
          data.unpack1("m0")
        end

        #
        # Base64 url-safe encodes the given data.
        #
        # @param [String] data
        #   The data to Base64 encode.
        #
        # @return [String]
        #   The Base64 url-safe encoded data.
        #
        def self.encode_urlsafe(data, padding: true)
          str = strict_encode(data)
          str.chomp!("==") or str.chomp!("=") unless padding
          str.tr!("+/", "-_")
          str
        end

        #
        # Base64 url-safe decodes the given data.
        #
        # @param [String] data
        #   The Base64 data to decode.
        #
        # @return [String]
        #   The url-safe decoded data.
        #
        def self.decode_urlsafe(data)
          if !data.end_with?("=") && data.length % 4 != 0
            data = data.ljust((str.length + 3) & ~3, "=")
            data.tr!("-_", "+/")
          else
            data = data.tr("-_", "+/")
          end
          strict_decode(data)
        end
      end
    end
  end
end

require 'ronin/support/encoding/base64/core_ext'
