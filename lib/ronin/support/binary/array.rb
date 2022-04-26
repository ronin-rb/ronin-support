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

require 'ronin/support/binary/memory'
require 'ronin/support/binary/byte_slice'
require 'ronin/support/binary/types/mixin'

module Ronin
  module Support
    module Binary
      #
      # Represents an Array of binary types that can be read from and written
      # to.
      #
      # @note This class provides lazy memory mapped access to an underlying
      # buffer. This means values are decoded/encoded each time they are read
      # or written to.
      #
      # ## Examples
      #
      # Creating a buffer of `int32`s:
      #
      #     buffer = Buffer.new(:int32, 4)
      #     # => #<Ronin::Support::Binary::Binary::Array: "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00">
      #     buffer[0] = 0x11111111
      #     buffer[1] = 0x22222222
      #     buffer[2] = 0x33333333
      #     buffer[3] = -1
      #     buffer.to_s
      #     # => "\x11\x11\x11\x11\"\"\"\"3333\xFF\xFF\xFF\xFF"
      #
      # Creating a buffer from an existing String:
      #
      #     buffer = Buffer.new(:uint32_le, "\x41\x00\x00\x00\x42\x00\x00\x00")
      #     # => #<Ronin::Support::Binary::Binary::Array: "A\u0000\u0000\u0000B\u0000\u0000\u0000">
      #     buffer[0]
      #     # => 65
      #     buffer[1]
      #     # => 66
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Array < Memory

        include Types::Mixin
        include Enumerable

        # The underlying type of the data within the array buffer.
        #
        # @return [Types::Type]
        attr_reader :type

        # The number of elements in the array buffer.
        #
        # @return [Integer]
        attr_reader :length

        #
        # Initializes the array buffer.
        #
        # @param [Symbol] type
        #   The type of each element in the array buffer.
        #
        # @param [Integer, String, ByteSlice] length_or_string
        #   The length of the buffer or an existing String which will be used
        #   as the underlying buffer.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:little, :big, :net, nil] :endian
        #   The desired endianness of the values within the array buffer.
        #
        # @option kwargs [:x86, :x86_64,
        #                 :ppc, :ppc64,
        #                 :mips, :mips_le, :mips_be,
        #                 :mips64, :mips64_le, :mips64_be,
        #                 :arm, :arm_le, :arm_be,
        #                 :arm64, :arm64_le, :arm64_be] :arch
        #   The desired architecture for the values within the array buffer.
        #
        # @raise [ArgumentError]
        #   Either the `length_or_string` argument was not an Integer or a
        #   String.
        #
        # @example Creating a new array buffer:
        #   array = Binary::Array.new(:uint32_le, 10)
        #   # => #<Ronin::Support::Binary::Binary::Array: "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00">
        #
        # @example Creating a new array buffer from a String:
        #   array = Binary::Array.new(:uint32_le, "\x41\x00\x00\x00\x42\x00\x00\x00")
        #   # => #<Ronin::Support::Binary::Binary::Array: "A\u0000\u0000\u0000B\u0000\u0000\u0000">
        #
        def initialize(type, length_or_string, **kwargs)
          initialize_type_system(**kwargs)

          @type = @type_resolver.resolve(type)

          case length_or_string
          when String, ByteSlice
            super(length_or_string)

            @length = @size / @type.size
          when Integer
            @length = length_or_string

            super(@type.size * @length)
          else
            raise(ArgumentError,"first argument must be either a length (Integer) or a buffer (String): #{length_or_string.inspect}")
          end
        end

        #
        # Reads a value from the array at the given index.
        #
        # @param [Integer] index
        #   The index to read from.
        #
        # @return [Integer, Float, String, Binary::Array, Binary::Struct]
        #   The integer, float, or character read from the given index.
        #
        def [](index)
          offset = index * @type.size

          if (index < 0 || offset+@type.size > @size)
            raise(IndexError,"index #{index} is out of bounds: 0...#{@length}")
          end

          slice = super(offset,@type.size)
          return @type.unpack(slice)
        end

        #
        # Writes a value to the array at the given index.
        #
        # @param [Integer] index
        #   The array index to write the value to.
        #
        # @param [Integer, Float, String, Binary::Array, Binary::Struct] value
        #   The integer, float, or character value to write to the array.
        #
        # @return [Integer, Float, String, Binary::Array, Binary::Struct]
        #   The integer, float, or character value that was written.
        #   
        def []=(index,value)
          offset = index * @type.size

          if (index < 0 || offset+@type.size > @size)
            raise(IndexError,"index #{index} is out of bounds: 0...#{@length}")
          end

          data = @type.pack(value)
          return super(offset,@type.size,data)
        end

        #
        # Enumerates over every value within the array buffer.
        #
        # @yield [value]
        #   The given block will be passed each value at each index within the
        #   array buffer.
        #
        # @yieldparam [Integer, Float, String] value
        #   The integer, float, or character read from the array buffer.
        #
        # @return [Enumerator]
        #   If no block was given, an Enumerator will be returned.
        #
        def each
          return enum_for(__method__) unless block_given?

          (0...@length).each do |index|
            yield self[index]
          end
        end

        #
        # Converts the array buffer to a String.
        #
        # @return [String]
        #   The raw binary buffer.
        #
        def to_s
          @string
        end

        alias to_str to_s

        #
        # Inspects the array buffer.
        #
        # @return [String]
        #
        def inspect
          "#<#{self.class}: #{@string.inspect}>"
        end

      end
    end
  end
end
