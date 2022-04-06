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

require 'ronin/support/binary/types'
require 'ronin/support/binary/byte_slice'

module Ronin
  module Support
    module Binary
      #
      # Base class for all memory objects.
      #
      # @api private
      #
      # @since 1.0.0
      #
      class Memory

        # The size of the memory in bytes.
        #
        # @return [Integer]
        attr_reader :size

        # The underlying String buffer.
        #
        # @return [String]
        attr_reader :string

        #
        # Initializes the memory.
        #
        # @param [Integer, String, ByteSlice] size_or_string
        #   The size of the buffer or an existing String which will be used
        #   as the underlying buffer.
        #
        # @raise [ArgumentError]
        #   The argument was not an Integer, String, or {ByteSlice}.
        #
        def initialize(size_or_string)
          case size_or_string
          when String, ByteSlice
            @string = size_or_string
            @size   = @string.bytesize
          when Integer
            @size   = size_or_string
            @string = String.new("\0" * @size, encoding: Encoding::ASCII_8BIT)
          else
            raise(ArgumentError,"first argument must be either a size (Integer) or a buffer (String): #{size_or_string.inspect}")
          end
        end

        #
        # Clears the memory by setting each byte to 0.
        #
        # @return [self]
        #
        def clear
          (0...@size).each do |index|
            @string.setbyte(index,0)
          end

          return self
        end

        #
        # Converts the buffer to a String.
        #
        # @return [String]
        #   The raw binary buffer.
        #
        def to_s
          @string.to_s
        end

        alias to_str to_s

      end
    end
  end
end
