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

require 'ronin/support/binary/ctypes'
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

        # The underlying String buffer.
        #
        # @return [String, ByteSlice]
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
          when Integer
            size    = size_or_string
            @string = String.new("\0" * size, encoding: Encoding::ASCII_8BIT)
          else
            raise(ArgumentError,"first argument must be either a size (Integer) or a buffer (String): #{size_or_string.inspect}")
          end
        end

        #
        # The size of the underlying buffer.
        #
        # @return [Integer]
        #
        def size
          @string.bytesize
        end

        #
        # Reads a character or a substring from the underlying buffer at the
        # given index.
        #
        # @param [Integer, (Integer, Integer), Range(Integer)] index_or_range
        #   The index or range within the buffer to read from.
        #
        # @param [Integer, Float::INFINITY, nil] length
        #   The optional length in bytes to read.
        #
        # @return [String, nil]
        #   The character or substring at the given index or range.
        #
        # @example Reading a single char at the given index:
        #   memory[0]
        #   # => "\x00"
        #
        # @example Reading multiple chars at the range of indexes:
        #   memory[0..2]
        #   # => "\x00\x00"
        #
        # @example Reading multiple chars at the given index and length:
        #   memory[0,2]
        #   # => "\x00\x00"
        #
        def [](index_or_range,length=nil)
          case index_or_range
          when Range
            range = index_or_range

            @string[range]
          when Integer
            index  = index_or_range

            case length
            when Integer         then @string[index,length]
            when nil             then @string[index]
            when Float::INFINITY then @string[index,@string.length - index]
            else
              raise(ArgumentError,"invalid length (#{length.inspect}) must be an Integer, nil, or Float::INFINITY")
            end
          else
            raise(ArgumentError,"invalid index (#{index_or_range.inspect}) must be an Integer or a Range")
          end
        end

        #
        # Writes a value to the underlying buffer at the given index.
        #
        # @param [Integer, Range(Integer)] index_or_range
        #   The index within the string to write to.
        #
        # @param [Integer, Float::INFINITY, nil] length
        #   Optional additional length argument.
        #
        # @param [String] value
        #   The integer, float, or character value to write to the buffer.
        #
        # @return [String]
        #   The string written into the buffer.
        #
        # @example Writing a single char:
        #   buffer[0] = 'A'
        #
        # @example Writing multiple characters to the given range of indexes:
        #   buffer[0..3] = "AAA"
        #
        def []=(index_or_range,length=nil,value)
          case index_or_range
          when Range
            range = index_or_range

            @string[range] = value
          when Integer
            index  = index_or_range

            case length
            when Integer then @string[index,length] = value
            when nil     then @string[index] = value
            when Float::INFINITY
              @string[index,@string.length - index] = value
            else
              raise(ArgumentError,"invalid length (#{length.inspect}) must be an Integer, nil, or Float::INFINITY")
            end
          else
            raise(ArgumentError,"invalid index (#{index_or_range.inspect}) must be an Integer or a Range")
          end
        end

        #
        # Returns a byte slice of the memory at the given offset and for the 
        # remainder of the memory.
        #
        # @param [Integer] offset
        #   The offset for the byte slice within the memory.
        #
        # @return [ByteSlice]
        #   The new byte slice.
        #
        # @example
        #   memory+10
        #
        # @example Create a buffer starting at offset 10:
        #   buffer = Buffer.new(memory+10)
        #
        # @example Create an Array starting at offset 10:
        #   array = Binary::Array.new(:int32_le, memory+10)
        #
        def +(offset)
          ByteSlice.new(@string, offset: offset, length: size - offset)
        end

        #
        # Creates a new byte slice within the memory.
        #
        # @param [Integer] offset
        #   The offset of the new byte slice.
        #
        # @param [Integer] length
        #   The length of the new byte slice.
        #
        # @return [ByteSlice]
        #   The new byte slice.
        #
        def byteslice(offset,length=1)
          ByteSlice.new(@string, offset: offset, length: length)
        end

        #
        # Clears the memory by setting each byte to 0.
        #
        # @return [self]
        #
        def clear
          (0...@string.bytesize).each do |index|
            @string.setbyte(index,0)
          end

          return self
        end

        #
        # Copies data from this memory object into another memory object.
        #
        # @param [Memory] dest
        #   The destination memory object to copy the data to.
        #
        # @param [Integer] count
        #   The number of bytes to copy.
        #
        def copy_to(dest,count=size)
          dest[0,count] = @string
        end

        #
        # Copies data from the other memory object into this memory object.
        #
        # @param [Memory] src
        #   The source memory object to copy the data from.
        #
        # @param [Integer] count
        #   The number of bytes to copy.
        #
        def copy_from(src,count=size)
          @string[0,count] = src[0,count]
        end

        #
        # Reads {#size} bytes from the given IO stream.
        #
        # @param [IO] io
        #   The IO stream to read from.
        #
        # @return [self]
        #
        def read_from(io)
          data = io.read(size)

          @string[0,data.bytesize] = data
          return self
        end

        #
        # Converts the buffer to a String.
        #
        # @return [String]
        #   The raw binary buffer.
        #
        def pack
          @string.to_s
        end

        alias to_s pack
        alias to_str pack

      end
    end
  end
end
