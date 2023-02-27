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

require 'ronin/support/binary/memory'
require 'ronin/support/binary/byte_slice'
require 'ronin/support/binary/ctypes/mixin'

module Ronin
  module Support
    module Binary
      #
      # Represents a binary buffer of data.
      #
      # ## Examples
      #
      # Writing bytes into an empty buffer:
      #
      #     buffer = Buffer.new(10)
      #     # => #<Ronin::Support::Binary::Buffer: "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00">
      #     buffer[0] = 0x41
      #     buffer[1] = 0x42
      #     buffer[2] = 0x43
      #     buffer.to_s
      #     # => "ABC\x00\x00\x00\x00\x00\x00\x00"
      #
      # Writing different types of data to a buffer:
      #
      #     buffer = Buffer.new(16)
      #     # => #<Ronin::Support::Binary::Buffer: "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00">
      #     buffer.put_uint32(0,0x11223344)
      #     buffer.put_int32(4,-1)
      #     buffer.put_string(8,"ABC")
      #     buffer.put_float32(12,0.5)
      #     buffer.to_s
      #     # => "D3\"\x11\xFF\xFF\xFF\xFFABC\x00\x00\x00\x00?"
      #
      # Creating a buffer from an existing String:
      #
      #     buffer = Buffer.new("\x41\x00\x00\x00\x42\x00\x00\x00")
      #     # => #<Ronin::Support::Binary::Buffer: "A\u0000\u0000\u0000B\u0000\u0000\u0000">
      #     buffer.get_uint32(0)
      #     # => 65
      #     buffer.get_uint32(4)
      #     # => 66
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Buffer < Memory

        include CTypes::Mixin

        #
        # Initializes the buffer.
        #
        # @param [Integer, String, ByteSlice] length_or_string
        #   The size of the buffer or an existing String which will be used
        #   as the underlying buffer.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:little, :big, :net, nil] :endian
        #   The desired endianness of the values within the buffer.
        #
        # @option kwargs [:x86, :x86_64,
        #                 :ppc, :ppc64,
        #                 :mips, :mips_le, :mips_be,
        #                 :mips64, :mips64_le, :mips64_be,
        #                 :arm, :arm_le, :arm_be,
        #                 :arm64, :arm64_le, :arm64_be] :arch
        #   The desired architecture for the values within the buffer.
        #
        # @raise [ArgumentError]
        #   Either the `length_or_string` argument was not an Integer or a
        #   String.
        #
        def initialize(length_or_string, **kwargs)
          initialize_type_system(**kwargs)

          super(length_or_string)
        end

        #
        # Reads from the IO stream and returns a buffer.
        #
        # @param [IO] io
        #   The IO object to read from.
        #
        # @param [Integer] size
        #   The size of the buffer to read.
        #
        # @return [Buffer]
        #   The read buffer.
        #
        # @see #read_from
        #
        # @api public
        #
        def self.read_from(io,size)
          new(io.read(size))
        end

        alias length size

        #
        # Writes a value to the buffer at the given index.
        #
        # @param [Integer, Range<Integer,Integer>] index_or_range
        #   The index within the string to write to.
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
        # @example Writing a single byte:
        #   buffer[0] = 0x41
        #
        # @example Writing a single char:
        #   buffer[0] = 'A'
        #
        # @example Writing an Array of bytes to the given range of indexes:
        #   buffer[0..3] = [0x41, 0x42, 0x43]
        #
        # @example Writing an Array of chars to the given range of indexes:
        #   buffer[0..3] = ['A', 'B', 'C']
        #
        # @example Writing an Array of bytes to the given index and length:
        #   buffer[0,3] = [0x41, 0x42, 0x43]
        #
        # @example Writing an Array of bytes to the given index and length:
        #   buffer[0,3] = ['A', 'B', 'C']
        #
        def []=(index_or_range,length=nil,value)
          value = case value
                  when Integer
                    value.chr(Encoding::ASCII_8BIT)
                  when ::Array
                    value.map { |char_or_byte|
                      case char_or_byte
                      when Integer
                        char_or_byte.chr(Encoding::ASCII_8BIT)
                      else
                        char_or_byte
                      end
                    }.join
                  else
                    value
                  end

          super(index_or_range,length,value)
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

        #
        # @group Reader Methods
        #

        #
        # Reads a value of the given type at the given offset.
        #
        # @param [Symbol] type
        #   The type of the value to read.
        #
        # @param [Integer] offset
        #   The offset within the buffer to read.
        #
        # @return [Integer, Float, String]
        #   The decoded value.
        #
        def get(type,offset)
          type = @type_system[type]

          if (offset < 0) || ((offset + type.size) > size)
            raise(IndexError,"offset #{offset} is out of bounds: 0...#{size - type.size}")
          end

          data = @string[offset,type.size]
          return type.unpack(data)
        end

        #
        # Alias for `get(:byte,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `byte` within the buffer.
        #
        # @return [Integer]
        #   The read `byte`.
        #
        # @see #get
        #
        def get_byte(offset)
          get(:byte,offset)
        end

        #
        # Alias for `get(:char,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `char` within the buffer.
        #
        # @return [String]
        #   The read `char`.
        #
        # @see #get
        #
        def get_char(offset)
          get(:char,offset)
        end

        #
        # Alias for `get(:uchar,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `uchar` within the buffer.
        #
        # @return [String]
        #   The read `uchar`.
        #
        # @see #get
        #
        def get_uchar(offset)
          get(:uchar,offset)
        end

        #
        # Reads a null-byte terminated C string from the buffer, at the given
        # offset.
        #
        # @param [Integer] offset
        #   The offset of the `string` within the buffer.
        #
        # @param [Integer, nil] length
        #   The optional maximum desired length of the string.
        #
        # @return [String]
        #   The read C string, without the null-byte.
        #
        def get_string(offset,length=nil)
          if (offset < 0) || (offset >= size)
            raise(IndexError,"offset #{offset} is out of bounds: 0...#{size - 1}")
          elsif (length && (offset + length) > size)
            raise(IndexError,"offset #{offset} or length #{length} is out of bounds: 0...#{size - 1}")
          end

          if length
            substring = @string[offset,length]

            if (null_byte_index = substring.index("\0"))
              substring[0...null_byte_index]
            else
              substring
            end
          else
            if (null_byte_index = @string.index("\0",offset))
              @string[offset...null_byte_index]
            else
              @string[offset..]
            end
          end
        end

        #
        # Alias for `get(:int8,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `int8` within the buffer.
        #
        # @return [Integer]
        #   The read `int8`.
        #
        # @see #get
        #
        def get_int8(offset)
          get(:int8,offset)
        end

        #
        # Alias for `get(:int16,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `int16` within the buffer.
        #
        # @return [Integer]
        #   The read `int16`.
        #
        # @see #get
        #
        def get_int16(offset)
          get(:int16,offset)
        end

        #
        # Alias for `get(:int32,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `int32` within the buffer.
        #
        # @return [Integer]
        #   The read `int32`.
        #
        # @see #get
        #
        def get_int32(offset)
          get(:int32,offset)
        end

        #
        # Alias for `get(:int64,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `int64` within the buffer.
        #
        # @return [Integer]
        #   The read `int64`.
        #
        # @see #get
        #
        def get_int64(offset)
          get(:int64,offset)
        end

        #
        # Alias for `get(:uint8,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint8` within the buffer.
        #
        # @return [Integer]
        #   The read `uint8`.
        #
        # @see #get
        #
        def get_uint8(offset)
          get(:uint8,offset)
        end

        #
        # Alias for `get(:uint16,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint16` within the buffer.
        #
        # @return [Integer]
        #   The read `uint16`.
        #
        # @see #get
        #
        def get_uint16(offset)
          get(:uint16,offset)
        end

        #
        # Alias for `get(:uint32,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint32` within the buffer.
        #
        # @return [Integer]
        #   The read `uint32`.
        #
        # @see #get
        #
        def get_uint32(offset)
          get(:uint32,offset)
        end

        #
        # Alias for `get(:uint64,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint64` within the buffer.
        #
        # @return [Integer]
        #   The read `uint64`.
        #
        # @see #get
        #
        def get_uint64(offset)
          get(:uint64,offset)
        end

        #
        # Alias for `get(:short,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `short` within the buffer.
        #
        # @return [Integer]
        #   The read `short`.
        #
        # @see #get
        #
        def get_short(offset)
          get(:short,offset)
        end

        #
        # Alias for `get(:int,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `int` within the buffer.
        #
        # @return [Integer]
        #   The read `int`.
        #
        # @see #get
        #
        def get_int(offset)
          get(:int,offset)
        end

        #
        # Alias for `get(:long,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `long` within the buffer.
        #
        # @return [Integer]
        #   The read `long`.
        #
        # @see #get
        #
        def get_long(offset)
          get(:long,offset)
        end

        #
        # Alias for `get(:long_long,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `long_long` within the buffer.
        #
        # @return [Integer]
        #   The read `long_long`.
        #
        # @see #get
        #
        def get_long_long(offset)
          get(:long_long,offset)
        end

        #
        # Alias for `get(:ushort,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `ushort` within the buffer.
        #
        # @return [Integer]
        #   The read `ushort`.
        #
        # @see #get
        #
        def get_ushort(offset)
          get(:ushort,offset)
        end

        #
        # Alias for `get(:uint,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint` within the buffer.
        #
        # @return [Integer]
        #   The read `uint`.
        #
        # @see #get
        #
        def get_uint(offset)
          get(:uint,offset)
        end

        #
        # Alias for `get(:ulong,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `ulong` within the buffer.
        #
        # @return [Integer]
        #   The read `ulong`.
        #
        # @see #get
        #
        def get_ulong(offset)
          get(:ulong,offset)
        end

        #
        # Alias for `get(:ulong_long,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `ulong_long` within the buffer.
        #
        # @return [Integer]
        #   The read `ulong_long`.
        #
        # @see #get
        #
        def get_ulong_long(offset)
          get(:ulong_long,offset)
        end

        #
        # Alias for `get(:float32,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `float32` within the buffer.
        #
        # @return [Float]
        #   The read `float32`.
        #
        # @see #get
        #
        def get_float32(offset)
          get(:float32,offset)
        end

        #
        # Alias for `get(:float64,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `float64` within the buffer.
        #
        # @return [Float]
        #   The read `float64`.
        #
        # @see #get
        #
        def get_float64(offset)
          get(:float64,offset)
        end

        #
        # Alias for `get(:float,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `float` within the buffer.
        #
        # @return [Float]
        #   The read `float`.
        #
        # @see #get
        #
        def get_float(offset)
          get(:float,offset)
        end

        #
        # Alias for `get(:double,offset)`.
        #
        # @param [Integer] offset
        #   The offset of the `double` within the buffer.
        #
        # @return [Float]
        #   The read `double`.
        #
        # @see #get
        #
        def get_double(offset)
          get(:double,offset)
        end

        #
        # Returns the buffer starting at the given offset and with the given
        # size.
        #
        # @param [Integer] offset
        #   The offset within the buffer.
        #
        # @param [Integer] size
        #   The number of bytes for the buffer.
        #
        # @return [Buffer]
        #   The new buffer.
        #
        # @example
        #   subbuffer = buffer.buffer_at(10,40)
        #
        def buffer_at(offset,size)
          Buffer.new(byteslice(offset,size))
        end

        #
        # Returns the array starting at the given offset, with the given
        # length, containing the given type.
        #
        # @param [Integer] offset
        #   The offset within the buffer that the array starts at.
        #
        # @param [Symbol] type
        #   The type name.
        #
        # @param [Integer] length
        #   The number of elements in the array.
        #
        # @return [Array]
        #   The new array.
        #
        # @example
        #   array = buffer.array_at(0,:uint32,10)
        #
        def array_at(offset,type,length)
          type = @type_system[type]
          size = type.size * length

          return Array.new(type,byteslice(offset,size))
        end

        #
        # Returns a new {Struct} instance starting at the given offset.
        #
        # @param [Integer] offset
        #   The offset within the buffer that the struct starts at.
        #
        # @param [Class<Binary::Struct>] struct_class
        #   The struct class.
        #
        # @return [Binary::Struct]
        #   The new struct instance.
        #
        # @example
        #   struct = buffer.struct_at(10,MyStruct)
        #   # => #<MyStruct: ...>
        #
        def struct_at(offset,struct_class)
          unless struct_class < Struct
            raise(ArgumentError,"the given class must be a #{Struct} subclass: #{struct_class.inspect}")
          end

          return struct_class.new(byteslice(offset,struct_class.size))
        end

        #
        # Returns a new {Union} instance starting at the given offset.
        #
        # @param [Integer] offset
        #   The offset within the buffer that the union starts at.
        #
        # @param [Class<Union>] union_class
        #   The union class.
        #
        # @return [Union]
        #   The new union instance.
        #
        # @example
        #   union = buffer.union_at(10,MyUnion)
        #   # => #<MyUnion: ...>
        #
        def union_at(offset,union_class)
          unless union_class < Union
            raise(ArgumentError,"the given class must be a #{Union} subclass: #{union_class.inspect}")
          end

          return union_class.new(byteslice(offset,union_class.size))
        end

        #
        # Reads an array of the given type, starting at the given offset, with
        # the given length.
        #
        # @param [Symbol] type
        #   The type of the value to read.
        #
        # @param [Integer] offset
        #   The offset that the array starts at within the buffer.
        #
        # @param [Integer] count
        #   The number of desired elements within the array.
        #
        # @return [::Array<Object>]
        #   The read array of types.
        #
        def get_array_of(type,offset,count)
          type       = @type_system[type]
          array_type = type[count]

          if (offset < 0) || ((offset + array_type.size) > size)
            raise(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{size - type.size}")
          end

          slice = @string[offset,array_type.size]
          return array_type.unpack(slice)
        end

        #
        # Alias to `get_array_of(:byte,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of bytes to read.
        #
        # @return [::Array<Integer>]
        #   The read array of bytes.
        #
        # @see #get_array_of
        #
        def get_array_of_byte(offset,count)
          get_array_of(:byte,offset,count)
        end

        alias get_bytes get_array_of_byte

        #
        # Alias to `get_array_of(:char,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of chars to read.
        #
        # @return [::Array<Integer>]
        #   The read array of chars.
        #
        # @see #get_array_of
        #
        def get_array_of_char(offset,count)
          get_array_of(:char,offset,count)
        end

        alias get_chars get_array_of_char

        #
        # Alias to `get_array_of(:uchar,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of unsigned chars to read.
        #
        # @return [::Array<Integer>]
        #   The read array of unsigned chars.
        #
        # @see #get_array_of
        #
        def get_array_of_uchar(offset,count)
          get_array_of(:uchar,offset,count)
        end

        alias get_uchars get_array_of_uchar

        #
        # Alias to `get_array_of(:int8,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `int8` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `int8` values.
        #
        # @see #get_array_of
        #
        def get_array_of_int8(offset,count)
          get_array_of(:int8,offset,count)
        end

        #
        # Alias to `get_array_of(:int16,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `int16` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `int16` values.
        #
        # @see #get_array_of
        #
        def get_array_of_int16(offset,count)
          get_array_of(:int16,offset,count)
        end

        #
        # Alias to `get_array_of(:int32,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `int32` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `int32` values.
        #
        # @see #get_array_of
        #
        def get_array_of_int32(offset,count)
          get_array_of(:int32,offset,count)
        end

        #
        # Alias to `get_array_of(:int64,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `int64` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `int64` values.
        #
        # @see #get_array_of
        #
        def get_array_of_int64(offset,count)
          get_array_of(:int64,offset,count)
        end

        #
        # Alias to `get_array_of(:uint8,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `uint8` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `uint8` values.
        #
        # @see #get_array_of
        #
        def get_array_of_uint8(offset,count)
          get_array_of(:uint8,offset,count)
        end

        #
        # Alias to `get_array_of(:uint16,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `uint16` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `uint16` values.
        #
        # @see #get_array_of
        #
        def get_array_of_uint16(offset,count)
          get_array_of(:uint16,offset,count)
        end

        #
        # Alias to `get_array_of(:uint32,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `uint32` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `uint32` values.
        #
        # @see #get_array_of
        #
        def get_array_of_uint32(offset,count)
          get_array_of(:uint32,offset,count)
        end

        #
        # Alias to `get_array_of(:uint64,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `uint64` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `uint64` values.
        #
        # @see #get_array_of
        #
        def get_array_of_uint64(offset,count)
          get_array_of(:uint64,offset,count)
        end

        #
        # Alias to `get_array_of(:short,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `short` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `short` values.
        #
        # @see #get_array_of
        #
        def get_array_of_short(offset,count)
          get_array_of(:short,offset,count)
        end

        #
        # Alias to `get_array_of(:int,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `int` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `int` values.
        #
        # @see #get_array_of
        #
        def get_array_of_int(offset,count)
          get_array_of(:int,offset,count)
        end

        alias get_ints get_array_of_int

        #
        # Alias to `get_array_of(:long,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `long` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `long` values.
        #
        # @see #get_array_of
        #
        def get_array_of_long(offset,count)
          get_array_of(:long,offset,count)
        end

        #
        # Alias to `get_array_of(:long_long,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `long_long` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `long_long` values.
        #
        # @see #get_array_of
        #
        def get_array_of_long_long(offset,count)
          get_array_of(:long_long,offset,count)
        end

        #
        # Alias to `get_array_of(:ushort,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `ushort` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `ushort` values.
        #
        # @see #get_array_of
        #
        def get_array_of_ushort(offset,count)
          get_array_of(:ushort,offset,count)
        end

        #
        # Alias to `get_array_of(:uint,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `uint` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `uint` values.
        #
        # @see #get_array_of
        #
        def get_array_of_uint(offset,count)
          get_array_of(:uint,offset,count)
        end

        alias get_uints get_array_of_uint

        #
        # Alias to `get_array_of(:ulong,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `ulong` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `ulong` values.
        #
        # @see #get_array_of
        #
        def get_array_of_ulong(offset,count)
          get_array_of(:ulong,offset,count)
        end

        #
        # Alias to `get_array_of(:ulong_long,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `ulong_long` values to read.
        #
        # @return [::Array<Integer>]
        #   The read array of `ulong_long` values.
        #
        # @see #get_array_of
        #
        def get_array_of_ulong_long(offset,count)
          get_array_of(:ulong_long,offset,count)
        end

        #
        # Alias to `get_array_of(:float32,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `float32` values to read.
        #
        # @return [::Array<Float>]
        #   The read array of `float32` values.
        #
        # @see #get_array_of
        #
        def get_array_of_float32(offset,count)
          get_array_of(:float32,offset,count)
        end

        #
        # Alias to `get_array_of(:float64,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `float64` values to read.
        #
        # @return [::Array<Float>]
        #   The read array of `float64` values.
        #
        # @see #get_array_of
        #
        def get_array_of_float64(offset,count)
          get_array_of(:float64,offset,count)
        end

        #
        # Alias to `get_array_of(:float,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `float` values to read.
        #
        # @return [::Array<Float>]
        #   The read array of `float` values.
        #
        # @see #get_array_of
        #
        def get_array_of_float(offset,count)
          get_array_of(:float,offset,count)
        end

        alias get_floats get_array_of_float

        #
        # Alias to `get_array_of(:double,offset,count)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Integer] count
        #   The number of `double` values to read.
        #
        # @return [::Array<Float>]
        #   The read array of `double` values.
        #
        # @see #get_array_of
        #
        def get_array_of_double(offset,count)
          get_array_of(:double,offset,count)
        end

        alias get_doubles get_array_of_double

        #
        # @group Writer Methods
        #

        #
        # Writes a value of the given type to the given offset.
        #
        # @param [Symbol] type
        #   The type of the value to write.
        #
        # @param [Integer] offset
        #   The offset within the buffer to write.
        #
        # @param [Integer, Float, String] value
        #   The value to write.
        #
        def put(type,offset,value)
          type = @type_system[type]

          if (offset < 0) || ((offset + type.size) > size)
            raise(IndexError,"offset #{offset} is out of bounds: 0...#{size - type.size}")
          end

          data = type.pack(value)

          @string[offset,type.size] = data
          return self
        end

        #
        # Alias for `put(:byte,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `byte` within the buffer.
        #
        # @param [Integer] value
        #   The `char` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_byte(offset,value)
          put(:byte,offset,value)
        end

        #
        # Alias for `put(:char,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `char` within the buffer.
        #
        # @param [String] value
        #   The `char` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_char(offset,value)
          put(:char,offset,value)
        end

        #
        # Writes a null-terminated C string into the buffer at the given
        # offset.
        #
        # @param [Integer] offset
        #   The offset to start writing the string into the buffer.
        #
        # @param [String] string
        #   The String to write into the buffer.
        #
        # @return [self]
        #
        def put_string(offset,string)
          ascii_string = string.encode(Encoding::ASCII_8BIT)
          cstring      = "#{ascii_string}\0"

          if (offset < 0) || ((offset + cstring.bytesize) >= size)
            raise(IndexError,"offset #{offset} or C string size #{cstring.bytesize} is out of bounds: 0...#{size - 1}")
          end

          @string[offset,cstring.bytesize] = cstring
          return self
        end

        #
        # Alias for `put(:uchar,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `uchar` within the buffer.
        #
        # @param [String] value
        #   The `uchar` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_uchar(offset,value)
          put(:uchar,offset,value)
        end

        #
        # Alias for `put(:int8,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `int8` within the buffer.
        #
        # @param [Integer] value
        #   The `int8` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_int8(offset,value)
          put(:int8,offset,value)
        end

        #
        # Alias for `put(:int16,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `int16` within the buffer.
        #
        # @param [Integer] value
        #   The `int16` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_int16(offset,value)
          put(:int16,offset,value)
        end

        #
        # Alias for `put(:int32,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `int32` within the buffer.
        #
        # @param [Integer] value
        #   The `int32` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_int32(offset,value)
          put(:int32,offset,value)
        end

        #
        # Alias for `put(:int64,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `int64` within the buffer.
        #
        # @param [Integer] value
        #   The `int64` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_int64(offset,value)
          put(:int64,offset,value)
        end

        #
        # Alias for `put(:uint8,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint8` within the buffer.
        #
        # @param [Integer] value
        #   The `uint8` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_uint8(offset,value)
          put(:uint8,offset,value)
        end

        #
        # Alias for `put(:uint16,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint16` within the buffer.
        #
        # @param [Integer] value
        #   The `uint16` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_uint16(offset,value)
          put(:uint16,offset,value)
        end

        #
        # Alias for `put(:uint32,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint32` within the buffer.
        #
        # @param [Integer] value
        #   The `uint32` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_uint32(offset,value)
          put(:uint32,offset,value)
        end

        #
        # Alias for `put(:uint64,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint64` within the buffer.
        #
        # @param [Integer] value
        #   The `uint64` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_uint64(offset,value)
          put(:uint64,offset,value)
        end

        #
        # Alias for `put(:short,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `short` within the buffer.
        #
        # @param [Integer] value
        #   The `short` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_short(offset,value)
          put(:short,offset,value)
        end

        #
        # Alias for `put(:int,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `int` within the buffer.
        #
        # @param [Integer] value
        #   The `int` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_int(offset,value)
          put(:int,offset,value)
        end

        #
        # Alias for `put(:long,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `long` within the buffer.
        #
        # @param [Integer] value
        #   The `long` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_long(offset,value)
          put(:long,offset,value)
        end

        #
        # Alias for `put(:long_long,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `long_long` within the buffer.
        #
        # @param [Integer] value
        #   The `long_long` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_long_long(offset,value)
          put(:long_long,offset,value)
        end

        #
        # Alias for `put(:ushort,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `ushort` within the buffer.
        #
        # @param [Integer] value
        #   The `ushort` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_ushort(offset,value)
          put(:ushort,offset,value)
        end

        #
        # Alias for `put(:uint,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `uint` within the buffer.
        #
        # @param [Integer] value
        #   The `uint` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_uint(offset,value)
          put(:uint,offset,value)
        end

        #
        # Alias for `put(:ulong,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `ulong` within the buffer.
        #
        # @param [Integer] value
        #   The `ulong` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_ulong(offset,value)
          put(:ulong,offset,value)
        end

        #
        # Alias for `put(:ulong_long,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `ulong_long` within the buffer.
        #
        # @param [Integer] value
        #   The `ulong_long` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_ulong_long(offset,value)
          put(:ulong_long,offset,value)
        end

        #
        # Alias for `put(:float32,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `float32` within the buffer.
        #
        # @param [Float] value
        #   The `float32` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_float32(offset,value)
          put(:float32,offset,value)
        end

        #
        # Alias for `put(:float64,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `float64` within the buffer.
        #
        # @param [Float] value
        #   The `float64` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_float64(offset,value)
          put(:float64,offset,value)
        end

        #
        # Alias for `put(:float,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `float` within the buffer.
        #
        # @param [Float] value
        #   The `float` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_float(offset,value)
          put(:float,offset,value)
        end

        #
        # Alias for `put(:double,offset,value)`.
        #
        # @param [Integer] offset
        #   The offset of the `double` within the buffer.
        #
        # @param [Float] value
        #   The `double` value to write into the buffer.
        #
        # @return [self]
        #
        # @see #put
        #
        def put_double(offset,value)
          put(:double,offset,value)
        end

        #
        # Writes an array of the given type, to the given offset within the
        # buffer.
        #
        # @param [Symbol] type
        #   The type of the value to write.
        #
        # @param [Integer] offset
        #   The offset that the array should start at within the buffer.
        #
        # @param [::Array<Object>] array
        #   The array of values to write.
        #
        # @return [self]
        #
        def put_array_of(type,offset,array)
          type       = @type_system[type]
          array_type = type[array.length]

          if (offset < 0) || ((offset + array_type.size) > size)
            raise(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{size - type.size}")
          end

          data = array_type.pack(array)

          @string[offset,array_type.size] = data
          return self
        end

        #
        # Alias to `put_array_of(:byte,offset,bytes)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] bytes
        #   The array of bytes to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_byte(offset,bytes)
          put_array_of(:byte,offset,bytes)
        end

        alias put_bytes put_array_of_byte

        #
        # Alias to `put_array_of(:char,offset,bytes)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [String] chars
        #   The array of characters to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_char(offset,chars)
          put_array_of(:char,offset,chars)
        end

        alias put_chars put_array_of_char

        #
        # Alias to `put_array_of(:uchar,offset,bytes)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [String] chars
        #   The array of unsigned characters to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_uchar(offset,chars)
          put_array_of(:uchar,offset,chars)
        end

        alias put_uchars put_array_of_uchar

        #
        # Alias to `put_array_of(:int8,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `int8` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_int8(offset,ints)
          put_array_of(:int8,offset,ints)
        end

        #
        # Alias to `put_array_of(:int16,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `int16` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_int16(offset,ints)
          put_array_of(:int16,offset,ints)
        end

        #
        # Alias to `put_array_of(:int32,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `int32` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_int32(offset,ints)
          put_array_of(:int32,offset,ints)
        end

        #
        # Alias to `put_array_of(:int64,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `int64` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_int64(offset,ints)
          put_array_of(:int64,offset,ints)
        end

        #
        # Alias to `put_array_of(:uint8,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `uint8` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_uint8(offset,uints)
          put_array_of(:uint8,offset,uints)
        end

        #
        # Alias to `put_array_of(:uint16,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `uint16` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_uint16(offset,uints)
          put_array_of(:uint16,offset,uints)
        end

        #
        # Alias to `put_array_of(:uint32,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `uint32` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_uint32(offset,uints)
          put_array_of(:uint32,offset,uints)
        end

        #
        # Alias to `put_array_of(:uint64,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `uint64` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_uint64(offset,uints)
          put_array_of(:uint64,offset,uints)
        end

        #
        # Alias to `put_array_of(:short,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `short` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_short(offset,ints)
          put_array_of(:short,offset,ints)
        end

        #
        # Alias to `put_array_of(:int,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `int` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_int(offset,ints)
          put_array_of(:int,offset,ints)
        end

        alias put_ints put_array_of_int

        #
        # Alias to `put_array_of(:long,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `long` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_long(offset,ints)
          put_array_of(:long,offset,ints)
        end

        #
        # Alias to `put_array_of(:long_long,offset,ints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] ints
        #   The array of `long_long` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_long_long(offset,ints)
          put_array_of(:long_long,offset,ints)
        end

        #
        # Alias to `put_array_of(:ushort,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `ushort` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_ushort(offset,uints)
          put_array_of(:ushort,offset,uints)
        end

        #
        # Alias to `put_array_of(:uint,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `uint` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_uint(offset,uints)
          put_array_of(:uint,offset,uints)
        end

        alias put_uints put_array_of_uint

        #
        # Alias to `put_array_of(:ulong,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `ulong` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_ulong(offset,uints)
          put_array_of(:ulong,offset,uints)
        end

        #
        # Alias to `put_array_of(:ulong_long,offset,uints)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Integer>] uints
        #   The array of `ulong_long` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_ulong_long(offset,uints)
          put_array_of(:ulong_long,offset,uints)
        end

        #
        # Alias to `put_array_of(:float32,offset,floats)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Float>] floats
        #   The array of `float32` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_float32(offset,floats)
          put_array_of(:float32,offset,floats)
        end

        #
        # Alias to `put_array_of(:float64,offset,floats)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Float>] floats
        #   The array of `float64` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_float64(offset,floats)
          put_array_of(:float64,offset,floats)
        end

        #
        # Alias to `put_array_of(:float,offset,floats)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Float>] floats
        #   The array of `float` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_float(offset,floats)
          put_array_of(:float,offset,floats)
        end

        alias put_floats put_array_of_float

        #
        # Alias to `put_array_of(:double,offset,floats)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [::Array<Float>] floats
        #   The array of `double` values to write.
        #
        # @return [self]
        #
        # @see #put_array_of
        #
        def put_array_of_double(offset,floats)
          put_array_of(:double,offset,floats)
        end

        alias put_doubles put_array_of_double

      end
    end
  end
end
