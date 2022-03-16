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

module Ronin
  module Support
    module Binary
      #
      # Represents a binary buffer of data.
      #
      # ## Examples
      #
      # Creating a buffer of bytes:
      #
      #     buffer = Buffer.new(10)
      #     buffer[0] = 0x41
      #     buffer[1] = 0x42
      #     buffer[2] = 0x43
      #     buffer.to_s
      #     # => "ABC\x00\x00\x00\x00\x00\x00\x00"
      #
      # Creating a buffer of `int32`s:
      #
      #     buffer = Buffer.new(:int32, 4)
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
      #     buffer[0]
      #     # => 65
      #     buffer[1]
      #     # => 66
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Buffer

        # The endianness of data within the buffer.
        #
        # @return [:little, :big, :net, nil]
        attr_reader :endian

        # The desired architecture for the buffer.
        #
        # @return [Symbol, nil]
        attr_reader :arch

        # The type system that the buffer is using.
        #
        # @return [Types, Types::LittleEndian, Types::BigEndian, Types::Network]
        attr_reader :type_system

        # The underlying type of the data within the buffer.
        #
        # @return [Types::Type]
        attr_reader :type

        # The length of the buffer.
        #
        # @return [Integer]
        attr_reader :length

        # The size of the buffer in bytes.
        #
        # @return [Integer]
        attr_reader :size

        # The underlying String buffer.
        #
        # @return [String]
        attr_accessor :string

        #
        # Initializes the buffer.
        #
        # @param [Symbol] type
        #
        # @param [Integer, String] length_or_string
        #   The length of the buffer or an existing String which will be used
        #   as the underlying buffer.
        #
        # @param [:little, :big, :net, nil] endian
        #   The desired endianness of the values within the buffer.
        #
        # @param [:x86, :x86_64,
        #         :ppc, :ppc64,
        #         :mips, :mips_le, :mips_be,
        #         :mips64, :mips64_le, :mips64_be,
        #         :arm, :arm_le, :arm_be,
        #         :arm64, :arm64_le, :arm64_be] arch
        #   The desired architecture for the values within the buffer.
        #
        # @raise [ArgumentError]
        #   Either the `length` or `string:` keyword argument must be given.
        #
        # @example Creating a new blank buffer:
        #   buffer = Buffer.new(1024)
        #
        # @example Creating a new buffer with the given type:
        #   buffer = Buffer.new(:uint32_le, 10)
        #
        # @example Creating a new buffer from a String:
        #   buffer = Buffer.new(:uint32_le, "\x41\x00\x00\x00\x42\x00\x00\x00")
        #
        def initialize(type=:byte,length_or_string, endian: nil, arch: nil)
          @endian = endian
          @arch   = arch

          @type_system = if arch then Types.arch(arch)
                         else         Types.endian(endian)
                         end
          @type = @type_system[type]

          case length_or_string
          when String
            @string = length_or_string
            @size   = @string.bytesize
            @length = @size / @type.size
          when Integer
            @length = length_or_string
            @size   = @type.size * @length

            @string = String.new("\0" * @size, encoding: Encoding::ASCII_8BIT)
          else
            raise(ArgumentError,"argument must be either a length (Integer) or a buffer (String): #{length_or_string.inspect}")
          end
        end

        def self.from(string, type: :byte, **kwargs)
          buffer = new(**kwargs)
        end

        #
        # Reads a value from the buffer at the given index.
        #
        # @param [Integer] index
        #   The index to read from.
        #
        # @return [Integer, Float, String]
        #   The integer, float, or character read from the given index.
        #
        def [](index)
          offset = index * @type.size
          slice  = @string[offset,@type.size]

          return @type.unpack(slice)
        end

        #
        # Writes a value to the buffer at the given index.
        #
        # @param [Integer] index
        #
        # @param [Integer, Float, String] value
        #   The integer, float, or character value to write to the buffer.
        #
        # @return [Integer, Float, String]
        #   The integer, float, or character value that was written.
        #   
        def []=(index,value)
          offset = index * @type.size
          data   = @type.pack(value)

          @string[offset,@type.size] = data
          return value
        end

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

          slice = @string[offset,type.size]
          return type.unpack(slice)
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
          range = if length then (offset...(offset+length))
                  else           (offset...@string.length)
                  end

          substring = @string.byteslice(range)

          if (null_byte = substring.index("\0"))
            substring = substring.byteslice(0,null_byte)
          end

          return substring
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
        # Reads an array of the given type, starting at the given offset, with
        # the given length.
        #
        # @param [Symbol] type_name
        #   The type of the value to read.
        #
        # @param [Integer] offset
        #   The offset that the array starts at within the buffer.
        #
        # @param [Integer] count
        #   The number of desired elements within the array.
        #
        # @return [Array<Object>]
        #   The read array of types.
        #
        def get_array_of(type,offset,count)
          type       = @type_system[type]
          array_type = type[count]

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
        # @return [Array<Integer>]
        #   The read array of bytes.
        #
        # @see #get_array_of
        #
        def get_bytes(offset,count)
          get_array_of(:byte,offset,count)
        end

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
          data = type.pack(value)

          @string[offset,type.size] = data
          return value
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
        # @return [Integer]
        #   The written `byte`.
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
        # @return [Integer]
        #   The written `char`.
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
        def put_string(offset,string)
          ascii_string = string.encode(@string.encoding)
          cstring      = "#{ascii_string}\0"

          @string[offset,cstring.bytesize] = cstring
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
        # @return [Integer]
        #   The written `uchar`.
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
        # @return [Integer]
        #   The written `int8`.
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
        # @return [Integer]
        #   The written `int16`.
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
        # @return [Integer]
        #   The written `int32`.
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
        # @return [Integer]
        #   The written `int64`.
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
        # @return [Integer]
        #   The written `uint8`.
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
        # @return [Integer]
        #   The written `uint16`.
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
        # @return [Integer]
        #   The written `uint32`.
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
        # @return [Integer]
        #   The written `uint64`.
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
        # @return [Integer]
        #   The written `short`.
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
        # @return [Integer]
        #   The written `int`.
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
        # @return [Integer]
        #   The written `long`.
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
        # @return [Integer]
        #   The written `long_long`.
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
        # @return [Integer]
        #   The written `ushort`.
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
        # @return [Integer]
        #   The written `uint`.
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
        # @return [Integer]
        #   The written `ulong`.
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
        # @return [Integer]
        #   The written `ulong_long`.
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
        # @return [Float]
        #   The written `float32` value.
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
        # @return [Float]
        #   The written `float64` value.
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
        # @return [Float]
        #   The written `float` value.
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
        # @return [Float]
        #   The written `double` value.
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
        # @param [Symbol] type_name
        #   The type of the value to write.
        #
        # @param [Integer] offset
        #   The offset that the array should start at within the buffer.
        #
        # @param [Array<Object>] array
        #   The array of values to write.
        #
        # @return [Array<Object>]
        #   The written array of values.
        #
        def put_array_of(type,offset,array)
          type       = @type_system[type]
          array_type = type[array.length]
          data       = array_type.pack(*array)

          @string[offset,array_type.size] = data
          return array
        end

        #
        # Alias to `put_array_of(:byte,offset,bytes)`.
        #
        # @param [Integer] offset
        #   The offset within the buffer to start reading at.
        #
        # @param [Array<Integer>] bytes
        #   The array of bytes to write.
        #
        # @return [Array<Integer>]
        #   The wrriten array of bytes.
        #
        # @see #put_array_of
        #
        def put_bytes(offset,bytes)
          put_array_of(:byte,offset,bytes)
        end

        #
        # Converts the buffer to a String.
        #
        # @return [String]
        #   The raw binary buffer.
        #
        def to_s
          @string
        end

        alias to_str to_s

      end
    end
  end
end
