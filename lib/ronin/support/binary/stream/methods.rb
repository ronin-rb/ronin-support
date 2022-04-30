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

module Ronin
  module Support
    module Binary
      class Stream
        #
        # Adds `read_*`/`write_*` methods for reading and writing binary data
        # types.
        #
        # @api private
        #
        # @since 1.0.0
        #
        module Methods
          #
          # @group Reader Methods
          #

          #
          # Reads a value of the given type from the IO stream.
          #
          # @param [Symbol] type
          #   The desired type of data to read.
          #
          # @return [Integer, Float, String, nil]
          #   The read value.
          #
          # @api public
          #
          def read_value(type)
            type  = @type_system[type]

            if (slice = read(type.size))
              type.unpack(slice)
            end
          end

          #
          # Alias for `read_value(:byte)`.
          #
          # @return [Integer]
          #   The read `byte`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_byte
            read_value(:byte)
          end

          #
          # Alias for `read_value(:char)`.
          #
          # @return [String]
          #   The read `char`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_char
            read_value(:char)
          end

          #
          # Alias for `read_value(:uchar)`.
          #
          # @return [String]
          #   The read `uchar`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_uchar
            read_value(:uchar)
          end

          #
          # Reads a null-byte terminated C string from the buffer.
          #
          # @param [Integer, nil] length
          #   The optional maximum desired length of the string.
          #
          # @return [String]
          #   The read C string, without the null-byte.
          #
          # @api public
          #
          def read_string(length=nil)
            new_string = String.new('', encoding: external_encoding)

            if length
              length.times do
                if eof? || ((c = read(1)) == "\0")
                  break
                end

                new_string << c
              end
            else
              until eof?
                if ((c = read(1)) == "\0")
                  break
                end

                new_string << c
              end
            end

            return new_string
          end

          #
          # Alias for `read_value(:int8)`.
          #
          # @return [Integer, nil]
          #   The read `int8`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_int8
            read_value(:int8)
          end

          #
          # Alias for `read_value(:int16)`.
          #
          # @return [Integer, nil]
          #   The read `int16`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_int16
            read_value(:int16)
          end

          #
          # Alias for `read_value(:int32)`.
          #
          # @return [Integer, nil]
          #   The read `int32`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_int32
            read_value(:int32)
          end

          #
          # Alias for `read_value(:int64)`.
          #
          # @return [Integer, nil]
          #   The read `int64`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_int64
            read_value(:int64)
          end

          #
          # Alias for `read_value(:uint8)`.
          #
          # @return [Integer, nil]
          #   The read `uint8`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_uint8
            read_value(:uint8)
          end

          #
          # Alias for `read_value(:uint16)`.
          #
          # @return [Integer, nil]
          #   The read `uint16`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_uint16
            read_value(:uint16)
          end

          #
          # Alias for `read_value(:uint32)`.
          #
          # @return [Integer, nil]
          #   The read `uint32`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_uint32
            read_value(:uint32)
          end

          #
          # Alias for `read_value(:uint64)`.
          #
          # @return [Integer, nil]
          #   The read `uint64`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_uint64
            read_value(:uint64)
          end

          #
          # Alias for `read_value(:short)`.
          #
          # @return [Integer, nil]
          #   The read `short`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_short
            read_value(:short)
          end

          #
          # Alias for `read_value(:int)`.
          #
          # @return [Integer, nil]
          #   The read `int`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_int
            read_value(:int)
          end

          #
          # Alias for `read_value(:long)`.
          #
          # @return [Integer, nil]
          #   The read `long`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_long
            read_value(:long)
          end

          #
          # Alias for `read_value(:long_long)`.
          #
          # @return [Integer, nil]
          #   The read `long_long`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_long_long
            read_value(:long_long)
          end

          #
          # Alias for `read_value(:ushort)`.
          #
          # @return [Integer, nil]
          #   The read `ushort`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_ushort
            read_value(:ushort)
          end

          #
          # Alias for `read_value(:uint)`.
          #
          # @return [Integer, nil]
          #   The read `uint`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_uint
            read_value(:uint)
          end

          #
          # Alias for `read_value(:ulong)`.
          #
          # @return [Integer, nil]
          #   The read `ulong`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_ulong
            read_value(:ulong)
          end

          #
          # Alias for `read_value(:ulong_long)`.
          #
          # @return [Integer, nil]
          #   The read `ulong_long`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_ulong_long
            read_value(:ulong_long)
          end

          #
          # Alias for `read_value(:float32)`.
          #
          # @return [Float, nil]
          #   The read `float32`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_float32
            read_value(:float32)
          end

          #
          # Alias for `read_value(:float64)`.
          #
          # @return [Float, nil]
          #   The read `float64`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_float64
            read_value(:float64)
          end

          #
          # Alias for `read_value(:float)`.
          #
          # @return [Float, nil]
          #   The read `float`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_float
            read_value(:float)
          end

          #
          # Alias for `read_value(:double)`.
          #
          # @return [Float, nil]
          #   The read `double`.
          #
          # @see #read_value
          #
          # @api public
          #
          def read_double
            read_value(:double)
          end

          #
          # Reads an array of the given type, starting at the given  with
          # the given length.
          #
          # @param [Symbol] type
          #   The type of the value to read.
          #
          # @param [Integer] count
          #   The number of desired elements within the array.
          #
          # @return [Array<Object>]
          #   The read array of types.
          #
          # @api public
          #
          def read_array_of(type,count)
            type       = @type_system[type]
            array_type = type[count]
            data       = read(array_type.size)

            return array_type.unpack(data)
          end

          #
          # Alias to `read_array_of(:byte,count)`.
          #
          # @param [Integer] count
          #   The number of bytes to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of bytes.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_byte(count)
            read_array_of(:byte,count)
          end

          alias read_bytes read_array_of_byte

          #
          # Alias to `read_array_of(:char,count)`.
          #
          # @param [Integer] count
          #   The number of chars to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of chars.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_char(count)
            read_array_of(:char,count)
          end

          alias read_chars read_array_of_char

          #
          # Alias to `read_array_of(:uchar,count)`.
          #
          # @param [Integer] count
          #   The number of unsigned chars to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of unsigned chars.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_uchar(count)
            read_array_of(:uchar,count)
          end

          alias read_uchars read_array_of_uchar

          #
          # Alias to `read_array_of(:int8,count)`.
          #
          # @param [Integer] count
          #   The number of `int8` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `int8` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_int8(count)
            read_array_of(:int8,count)
          end

          #
          # Alias to `read_array_of(:int16,count)`.
          #
          # @param [Integer] count
          #   The number of `int16` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `int16` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_int16(count)
            read_array_of(:int16,count)
          end

          #
          # Alias to `read_array_of(:int32,count)`.
          #
          # @param [Integer] count
          #   The number of `int32` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `int32` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_int32(count)
            read_array_of(:int32,count)
          end

          #
          # Alias to `read_array_of(:int64,count)`.
          #
          # @param [Integer] count
          #   The number of `int64` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `int64` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_int64(count)
            read_array_of(:int64,count)
          end

          #
          # Alias to `read_array_of(:uint8,count)`.
          #
          # @param [Integer] count
          #   The number of `uint8` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `uint8` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_uint8(count)
            read_array_of(:uint8,count)
          end

          #
          # Alias to `read_array_of(:uint16,count)`.
          #
          # @param [Integer] count
          #   The number of `uint16` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `uint16` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_uint16(count)
            read_array_of(:uint16,count)
          end

          #
          # Alias to `read_array_of(:uint32,count)`.
          #
          # @param [Integer] count
          #   The number of `uint32` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `uint32` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_uint32(count)
            read_array_of(:uint32,count)
          end

          #
          # Alias to `read_array_of(:uint64,count)`.
          #
          # @param [Integer] count
          #   The number of `uint64` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `uint64` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_uint64(count)
            read_array_of(:uint64,count)
          end

          #
          # Alias to `read_array_of(:short,count)`.
          #
          # @param [Integer] count
          #   The number of `short` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `short` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_short(count)
            read_array_of(:short,count)
          end

          #
          # Alias to `read_array_of(:int,count)`.
          #
          # @param [Integer] count
          #   The number of `int` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `int` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_int(count)
            read_array_of(:int,count)
          end

          alias read_ints read_array_of_int

          #
          # Alias to `read_array_of(:long,count)`.
          #
          # @param [Integer] count
          #   The number of `long` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `long` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_long(count)
            read_array_of(:long,count)
          end

          #
          # Alias to `read_array_of(:long_long,count)`.
          #
          # @param [Integer] count
          #   The number of `long_long` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `long_long` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_long_long(count)
            read_array_of(:long_long,count)
          end

          #
          # Alias to `read_array_of(:ushort,count)`.
          #
          # @param [Integer] count
          #   The number of `ushort` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `ushort` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_ushort(count)
            read_array_of(:ushort,count)
          end

          #
          # Alias to `read_array_of(:uint,count)`.
          #
          # @param [Integer] count
          #   The number of `uint` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `uint` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_uint(count)
            read_array_of(:uint,count)
          end

          alias read_uints read_array_of_uint

          #
          # Alias to `read_array_of(:ulong,count)`.
          #
          # @param [Integer] count
          #   The number of `ulong` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `ulong` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_ulong(count)
            read_array_of(:ulong,count)
          end

          #
          # Alias to `read_array_of(:ulong_long,count)`.
          #
          # @param [Integer] count
          #   The number of `ulong_long` values to read.
          #
          # @return [Array<Integer, nil>]
          #   The read array of `ulong_long` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_ulong_long(count)
            read_array_of(:ulong_long,count)
          end

          #
          # Alias to `read_array_of(:float32,count)`.
          #
          # @param [Integer] count
          #   The number of `float32` values to read.
          #
          # @return [Array<Float, nil>]
          #   The read array of `float32` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_float32(count)
            read_array_of(:float32,count)
          end

          #
          # Alias to `read_array_of(:float64,count)`.
          #
          # @param [Integer] count
          #   The number of `float64` values to read.
          #
          # @return [Array<Float, nil>]
          #   The read array of `float64` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_float64(count)
            read_array_of(:float64,count)
          end

          #
          # Alias to `read_array_of(:float,count)`.
          #
          # @param [Integer] count
          #   The number of `float` values to read.
          #
          # @return [Array<Float, nil>]
          #   The read array of `float` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_float(count)
            read_array_of(:float,count)
          end

          alias read_floats read_array_of_float

          #
          # Alias to `read_array_of(:double,count)`.
          #
          # @param [Integer] count
          #   The number of `double` values to read.
          #
          # @return [Array<Float, nil>]
          #   The read array of `double` values.
          #
          # @see #read_array_of
          #
          # @api public
          #
          def read_array_of_double(count)
            read_array_of(:double,count)
          end

          alias read_doubles read_array_of_double

          #
          # @group Writer Methods
          #

          #
          # Writes the value to the IO stream.
          #
          # @param [Symbol] type
          #   The type of value to write.
          #
          # @param [Integer, Float, String] value
          #   The value to write.
          #
          # @return [self]
          #
          # @api public
          #
          def write_value(type,value)
            type = @type_system[type]
            data = type.pack(value)

            write(data)
            return self
          end

          #
          # Alias for `write_value(:byte,value)`.
          #
          # @param [Integer] value
          #   The `char` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_byte(value)
            write_value(:byte,value)
          end

          #
          # Alias for `write_value(:char,value)`.
          #
          # @param [String] value
          #   The `char` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_char(value)
            write_value(:char,value)
          end

          #
          # Writes a null-terminated C string to the buffer.
          #
          # @param [String] string
          #   The String to write into the buffer.
          #
          # @return [self]
          #
          # @api public
          #
          def write_string(string)
            ascii_string = string.encode(Encoding::ASCII_8BIT)
            cstring      = if ascii_string.end_with?("\0")
                             ascii_string
                           else
                             "#{ascii_string}\0"
                           end

            write(cstring)
            return self
          end

          #
          # Alias for `write_value(:uchar,value)`.
          #
          # @param [String] value
          #   The `uchar` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_uchar(value)
            write_value(:uchar,value)
          end

          #
          # Alias for `write_value(:int8,value)`.
          #
          # @param [Integer] value
          #   The `int8` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_int8(value)
            write_value(:int8,value)
          end

          #
          # Alias for `write_value(:int16,value)`.
          #
          # @param [Integer] value
          #   The `int16` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_int16(value)
            write_value(:int16,value)
          end

          #
          # Alias for `write_value(:int32,value)`.
          #
          # @param [Integer] value
          #   The `int32` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_int32(value)
            write_value(:int32,value)
          end

          #
          # Alias for `write_value(:int64,value)`.
          #
          # @param [Integer] value
          #   The `int64` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_int64(value)
            write_value(:int64,value)
          end

          #
          # Alias for `write_value(:uint8,value)`.
          #
          # @param [Integer] value
          #   The `uint8` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_uint8(value)
            write_value(:uint8,value)
          end

          #
          # Alias for `write_value(:uint16,value)`.
          #
          # @param [Integer] value
          #   The `uint16` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_uint16(value)
            write_value(:uint16,value)
          end

          #
          # Alias for `write_value(:uint32,value)`.
          #
          # @param [Integer] value
          #   The `uint32` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_uint32(value)
            write_value(:uint32,value)
          end

          #
          # Alias for `write_value(:uint64,value)`.
          #
          # @param [Integer] value
          #   The `uint64` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_uint64(value)
            write_value(:uint64,value)
          end

          #
          # Alias for `write_value(:short,value)`.
          #
          # @param [Integer] value
          #   The `short` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_short(value)
            write_value(:short,value)
          end

          #
          # Alias for `write_value(:int,value)`.
          #
          # @param [Integer] value
          #   The `int` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_int(value)
            write_value(:int,value)
          end

          #
          # Alias for `write_value(:long,value)`.
          #
          # @param [Integer] value
          #   The `long` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_long(value)
            write_value(:long,value)
          end

          #
          # Alias for `write_value(:long_long,value)`.
          #
          # @param [Integer] value
          #   The `long_long` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_long_long(value)
            write_value(:long_long,value)
          end

          #
          # Alias for `write_value(:ushort,value)`.
          #
          # @param [Integer] value
          #   The `ushort` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_ushort(value)
            write_value(:ushort,value)
          end

          #
          # Alias for `write_value(:uint,value)`.
          #
          # @param [Integer] value
          #   The `uint` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_uint(value)
            write_value(:uint,value)
          end

          #
          # Alias for `write_value(:ulong,value)`.
          #
          # @param [Integer] value
          #   The `ulong` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_ulong(value)
            write_value(:ulong,value)
          end

          #
          # Alias for `write_value(:ulong_long,value)`.
          #
          # @param [Integer] value
          #   The `ulong_long` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_ulong_long(value)
            write_value(:ulong_long,value)
          end

          #
          # Alias for `write_value(:float32,value)`.
          #
          # @param [Float] value
          #   The `float32` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_float32(value)
            write_value(:float32,value)
          end

          #
          # Alias for `write_value(:float64,value)`.
          #
          # @param [Float] value
          #   The `float64` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_float64(value)
            write_value(:float64,value)
          end

          #
          # Alias for `write_value(:float,value)`.
          #
          # @param [Float] value
          #   The `float` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_float(value)
            write_value(:float,value)
          end

          #
          # Alias for `write_value(:double,value)`.
          #
          # @param [Float] value
          #   The `double` value to write into the buffer.
          #
          # @return [self]
          #
          # @see #write_value
          #
          # @api public
          #
          def write_double(value)
            write_value(:double,value)
          end

          #
          # Writes an array of the given type.
          #
          # @param [Symbol] type
          #   The type of the value to write.
          #
          # @param [Array<Object>] array
          #   The array of values to write.
          #
          # @return [self]
          #
          # @api public
          #
          def write_array_of(type,array)
            type       = @type_system[type]
            array_type = type[array.length]
            data       = array_type.pack(array)

            write(data)
            return self
          end

          #
          # Alias to `write_array_of(:byte,bytes)`.
          #
          # @param [Array<Integer>] bytes
          #   The array of bytes to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_byte(bytes)
            write_array_of(:byte,bytes)
          end

          alias write_bytes write_array_of_byte

          #
          # Alias to `write_array_of(:char,bytes)`.
          #
          # @param [String] chars
          #   The array of characters to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_char(chars)
            write_array_of(:char,chars)
          end

          alias write_chars write_array_of_char

          #
          # Alias to `write_array_of(:uchar,bytes)`.
          #
          # @param [String] chars
          #   The array of unsigned characters to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_uchar(chars)
            write_array_of(:uchar,chars)
          end

          alias write_uchars write_array_of_uchar

          #
          # Alias to `write_array_of(:int8,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `int8` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_int8(ints)
            write_array_of(:int8,ints)
          end

          #
          # Alias to `write_array_of(:int16,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `int16` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_int16(ints)
            write_array_of(:int16,ints)
          end

          #
          # Alias to `write_array_of(:int32,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `int32` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_int32(ints)
            write_array_of(:int32,ints)
          end

          #
          # Alias to `write_array_of(:int64,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `int64` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_int64(ints)
            write_array_of(:int64,ints)
          end

          #
          # Alias to `write_array_of(:uint8,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `uint8` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_uint8(uints)
            write_array_of(:uint8,uints)
          end

          #
          # Alias to `write_array_of(:uint16,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `uint16` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_uint16(uints)
            write_array_of(:uint16,uints)
          end

          #
          # Alias to `write_array_of(:uint32,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `uint32` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_uint32(uints)
            write_array_of(:uint32,uints)
          end

          #
          # Alias to `write_array_of(:uint64,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `uint64` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_uint64(uints)
            write_array_of(:uint64,uints)
          end

          #
          # Alias to `write_array_of(:short,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `short` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_short(ints)
            write_array_of(:short,ints)
          end

          #
          # Alias to `write_array_of(:int,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `int` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_int(ints)
            write_array_of(:int,ints)
          end

          alias write_ints write_array_of_int

          #
          # Alias to `write_array_of(:long,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `long` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_long(ints)
            write_array_of(:long,ints)
          end

          #
          # Alias to `write_array_of(:long_long,ints)`.
          #
          # @param [Array<Integer>] ints
          #   The array of `long_long` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_long_long(ints)
            write_array_of(:long_long,ints)
          end

          #
          # Alias to `write_array_of(:ushort,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `ushort` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_ushort(uints)
            write_array_of(:ushort,uints)
          end

          #
          # Alias to `write_array_of(:uint,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `uint` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_uint(uints)
            write_array_of(:uint,uints)
          end

          alias write_uints write_array_of_uint

          #
          # Alias to `write_array_of(:ulong,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `ulong` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_ulong(uints)
            write_array_of(:ulong,uints)
          end

          #
          # Alias to `write_array_of(:ulong_long,uints)`.
          #
          # @param [Array<Integer>] uints
          #   The array of `ulong_long` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_ulong_long(uints)
            write_array_of(:ulong_long,uints)
          end

          #
          # Alias to `write_array_of(:float32,floats)`.
          #
          # @param [Array<Float>] floats
          #   The array of `float32` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_float32(floats)
            write_array_of(:float32,floats)
          end

          #
          # Alias to `write_array_of(:float64,floats)`.
          #
          # @param [Array<Float>] floats
          #   The array of `float64` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_float64(floats)
            write_array_of(:float64,floats)
          end

          #
          # Alias to `write_array_of(:float,floats)`.
          #
          # @param [Array<Float>] floats
          #   The array of `float` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_float(floats)
            write_array_of(:float,floats)
          end

          alias write_floats write_array_of_float

          #
          # Alias to `write_array_of(:double,floats)`.
          #
          # @param [Array<Float>] floats
          #   The array of `double` values to write.
          #
          # @return [self]
          #
          # @see #write_array_of
          #
          # @api public
          #
          def write_array_of_double(floats)
            write_array_of(:double,floats)
          end

          alias write_doubles write_array_of_double
        end
      end
    end
  end
end
