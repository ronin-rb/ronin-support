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
      # Base62 encoding.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#base62_encode}
      # * {String#base62_decode}
      #
      # @see https://en.wikipedia.org/wiki/Base62
      #
      # @api public
      #
      # @since 1.1.0
      #
      module Base62
        # Base62 table
        TABLE = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

        #
        # Base62 encodes an integer.
        #
        # @param [Integer] int
        #   The integer to Base62 encode.
        #
        # @return [String]
        #   The Base62 encoded string.
        #
        def self.encode_int(int)
          if int == 0
            String.new('0')
          elsif int < 0
            raise(ArgumentError,"cannot Base62 encode negative numbers: #{int.inspect}")
          else
            encoded    = String.new
            table_size = TABLE.length

            while int > 0
              encoded.prepend(TABLE[int % table_size])
              int /= table_size
            end

            return encoded
          end
        end

        #
        # Base62 decodes a String back into an Integer.
        #
        # @param [String] string
        #   The string to Base62 decode.
        #
        # @return [Integer]
        #   The Base62 decoded integer.
        #
        def self.decode(string)
          decoded    = 0
          multiplier = 1
          table_size = TABLE.length

          string.each_char.reverse_each.with_index do |char,index|
            decoded    += TABLE.index(char) * multiplier
            multiplier *= table_size
          end

          return decoded
        end
      end
    end
  end
end

require 'ronin/support/encoding/base62/core_ext'
