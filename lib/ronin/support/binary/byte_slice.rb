# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    module Binary
      #
      # Represents a slice of bytes from a larger buffer.
      #
      # @api semipublic
      #
      class ByteSlice

        # The underlying string of the byte slice.
        #
        # @return [String]
        attr_reader :string

        # The offset that the byte slice starts at within {#string}.
        #
        # @return [Integer]
        attr_reader :offset

        # The length of the byte slice within {#string}.
        #
        # @return [Integer]
        attr_reader :length

        alias bytesize length
        alias size length

        #
        # Initializes the byte slice.
        #
        # @param [String, ByteSlice] string
        #   The string that the byte slice will point within.
        #
        # @param [Integer] offset
        #   The offset of the byte slice within the string.
        #
        # @param [Integer, Float::INFINITY] length
        #   The length of the byte slice, in bytes.
        #
        # @raise [ArgumentError]
        #   The given string was not a Stirng or a {ByteSlice}.
        #
        # @raise [IndexError]
        #   The offset or length is out of bounds of the strings length.
        #
        def initialize(string, offset: , length: )
          if length == Float::INFINITY
            length = string.bytesize - offset
          end

          case string
          when ByteSlice
            if (offset < 0) || ((offset + length) > string.bytesize)
              raise(IndexError,"offset #{offset} or length #{length} is out of bounds: 0...#{string.bytesize}")
            end

            @string = string.string
            @offset = string.offset + offset
            @length = length
          when String
            if (offset < 0) || ((offset + length) > string.bytesize)
              raise(IndexError,"offset #{offset} or length #{length} is out of bounds: 0...#{string.bytesize}")
            end

            @string = string
            @offset = offset
            @length = length
          else
            raise(ArgumentError,"string was not a String or a #{ByteSlice}: #{string.inspect}")
          end
        end

        #
        # Reads a character or a substring from the buffer at the given index.
        #
        # @param [Integer, (Integer, Integer), Range(Integer)] index_or_range
        #   The index or range within the buffer to read from.
        #
        # @param [Integer, nil] length
        #   Optional additional length argument.
        #
        # @return [String, nil]
        #   The character or substring at the given index or range.
        #
        # @raise [ArgumentError]
        #   An invalid index or length value was given.
        #
        def [](index_or_range,length=nil)
          case index_or_range
          when Range
            range = index_or_range

            @string[@offset + range.begin,range.end - range.begin]
          when Integer
            index = index_or_range

            case length
            when Integer
              @string[@offset + index,length]
            when nil
              @string[@offset + index]
            when Float::INFINITY
              @string[@offset + index,@length - index]
            else
              raise(ArgumentError,"invalid length (#{length.inspect}) must be an Integer, nil, or Float::INFINITY")
            end
          else
            raise(ArgumentError,"invalid index (#{index_or_range.inspect}) must be an Integer or a Range")
          end
        end

        #
        # Writes a value to the buffer at the given index.
        #
        # @param [Integer, Range(Integer)] index_or_range
        #   The index or range within the string to write to.
        #
        # @param [Integer, nil] length
        #   Optional additional length argument.
        #
        # @param [String] value
        #   The integer, float, or character value to write to the buffer.
        #
        # @return [String]
        #   The string written into the buffer.
        #
        # @raise [ArgumentError]
        #   An invalid index or length value was given.
        #
        def []=(index_or_range,length=nil,value)
          case index_or_range
          when Range
            range = index_or_range

            @string[@offset + range.begin,range.end - range.begin] = value
          when Integer
            index = index_or_range

            case length
            when Integer
              @string[@offset + index,length] = value
            when nil
              @string[@offset + index] = value
            when Float::INFINITY
              @string[@offset + index,@length - index] = value
            else
              raise(ArgumentError,"invalid length (#{length.inspect}) must be an Integer, nil, or Float::INFINITY")
            end
          else
            raise(ArgumentError,"invalid index (#{index_or_range.inspect}) must be an Integer or a Range")
          end
        end

        #
        # Creates a new byte slice within the byte slice.
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
          ByteSlice.new(self, offset: offset, length: length)
        end

        #
        # Finds the substring within the byte slice.
        #
        # @param [String] substring
        #   The substring to search for.
        #
        # @param [Integer] offset
        #   The optional offset to start searching at.
        #
        # @return [Integer, nil]
        #   The index of the substring or `nil` if the substring could not be
        #   found.
        #
        def index(substring,offset=0)
          if (index = @string.index(substring,@offset + offset))
            if index < (@offset + @length)
              index - @offset
            end
          end
        end

        #
        # Gets the byte at the given index within the byte slice.
        #
        # @param [Integer] index
        #
        # @return [Integer, nil]
        #   The byte at the given index, or nil if the index is out of bounds.
        #
        def getbyte(index)
          if index < @length
            @string.getbyte(@offset + index)
          end
        end

        #
        # Sets the byte at the given index within the byte slice.
        #
        # @param [Integer] index
        #   The index to set.
        #
        # @param [Integer] byte
        #   The new byte value to set.
        #
        # @raise [IndexError]
        #   The index was out of bounds.
        #
        def setbyte(index,byte)
          if index < @length
            @string.setbyte(@offset + index,byte)
          else
            raise(IndexError,"index #{index.inspect} is out of bounds")
          end
        end

        #
        # Enumerates over each byte in the byte slice.
        #
        # @yield [byte]
        #   If a block is given, it will be passed each byte within the byte
        #   slice.
        #
        # @yieldparam [Integer] byte
        #   A byte value from the byte slice.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        def each_byte
          return enum_for(__method__) unless block_given?

          (@offset...(@offset + @length)).each do |index|
            yield @string.getbyte(index)
          end
        end

        #
        # The bytes within the byte slice.
        #
        # @return [Array<Integer>]
        #   The Array of bytes within the byte slice.
        #
        def bytes
          each_byte.to_a
        end

        #
        # Enumerates over each character within the byte slice.
        #
        # @yield [char]
        #   If a block is given, it will be passed each character within the
        #   byte slice.
        #
        # @yieldparam [String] char
        #   A character value from the byte slice.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        def each_char
          return enum_for(__method__) unless block_given?

          (@offset...(@offset + @length)).each do |index|
            yield @string[index]
          end
        end

        #
        # The characters within the byte slice.
        #
        # @return [Array<String>]
        #   The Array of characters within the byte slice.
        #
        def chars
          each_char.to_a
        end

        #
        # Converts the byte slice to a String.
        #
        # @return [String]
        #
        def to_s
          if (@offset > 0 || @length < @string.bytesize)
            @string[@offset,@length]
          else
            @string
          end
        end

        alias to_str to_s

      end
    end
  end
end
