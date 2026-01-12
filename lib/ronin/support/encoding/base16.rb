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
      # Base16 encoding.
      #
      # ## Core-Ext Methods
      #
      # * {String#base16_encode}
      # * {String#base16_decode}
      #
      # @see https://www.rfc-editor.org/rfc/rfc4648#page-10
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Base16
        #
        # Base16 encodes the given data.
        #
        # @param [String] data
        #   The given data to Base16 encode.
        #
        # @return [String]
        #   The Base16 encoded version of the String.
        #
        # @example
        #   Encoding::Base16.encode("hello")
        #   # => "68656C6C6F"
        #
        def self.encode(data)
          encoded = String.new

          data.each_byte do |byte|
            encoded << ("%.2x" % byte)
          end

          return encoded
        end

        #
        # Base16 decodes the String.
        #
        # @param [String] data
        #   The given data to Base16 decode.
        #
        # @return [String]
        #   The Base16 decoded version of the String.
        #
        # @example
        #   Encoding::Base16.decode("68656C6C6F")
        #   # => "hello"
        #
        def self.decode(data)
          decoded = String.new(encoding: Encoding::ASCII_8BIT)

          data.scan(/../).each do |hex_char|
            decoded << hex_char.to_i(16).chr
          end

          return decoded
        end
      end
    end
  end
end

require 'ronin/support/encoding/base16/core_ext'
