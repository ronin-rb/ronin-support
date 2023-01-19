# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'base64'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # [Base64] encoding/decoding.
      #
      # [Base64]: https://en.wikipedia.org/wiki/Base64
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
          when :strict   then ::Base64.strict_encode64(data)
          when :url_safe then ::Base64.urlsafe_encode64(data)
          when nil       then ::Base64.encode64(data)
          else
            raise(ArgumentError,"Base64 mode must be either :string, :url, or nil: #{mode.inspect}")
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
          when :strict   then ::Base64.strict_decode64(data)
          when :url_safe then ::Base64.urlsafe_decode64(data)
          when nil       then ::Base64.decode64(data)
          else
            raise(ArgumentError,"Base64 mode must be either :string, :url, or nil: #{mode.inspect}")
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/base64/core_ext'
