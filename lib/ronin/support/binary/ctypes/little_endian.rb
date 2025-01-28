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

require 'ronin/support/binary/ctypes/int8_type'
require 'ronin/support/binary/ctypes/int16_type'
require 'ronin/support/binary/ctypes/int32_type'
require 'ronin/support/binary/ctypes/int64_type'
require 'ronin/support/binary/ctypes/uint8_type'
require 'ronin/support/binary/ctypes/uint16_type'
require 'ronin/support/binary/ctypes/uint32_type'
require 'ronin/support/binary/ctypes/uint64_type'
require 'ronin/support/binary/ctypes/float32_type'
require 'ronin/support/binary/ctypes/float64_type'
require 'ronin/support/binary/ctypes/char_types'
require 'ronin/support/binary/ctypes/native'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Represents the C types, but in little-endian byte-order.
        #
        module LittleEndian
          include CharTypes

          # The size of a native pointer in bytes.
          #
          # @return [4, 8]
          ADDRESS_SIZE = Native::ADDRESS_SIZE

          # The `int8_t` type.
          INT8 = Int8Type.new

          # The `int16_t` type (little-endianness).
          INT16 = Int16Type.new(endian: :little, pack_string: 's<')

          # The `int32_t` type (little-endianness).
          INT32 = Int32Type.new(endian: :little, pack_string: 'l<')

          # The `int64_t` type (little-endianness).
          INT64 = Int64Type.new(endian: :little, pack_string: 'q<')

          # The `short` type.
          SHORT = INT16

          # The `int` type.
          INT = INT32

          # The `long` type.
          LONG = if ADDRESS_SIZE == 8 then INT64
                 else                      INT32
                 end

          # The `long long` type.
          LONG_LONG = INT64

          # The `uint8_t` type.
          UINT8 = UInt8Type.new

          # The `byte` type.
          BYTE = UINT8

          # The `uint16_t` type (little-endianness).
          UINT16 = UInt16Type.new(endian: :little, pack_string: 'S<')

          # The `uint32_t` type (little-endianness).
          UINT32 = UInt32Type.new(endian: :little, pack_string: 'L<')

          # The `uint64_t` type (little-endianness).
          UINT64 = UInt64Type.new(endian: :little, pack_string: 'Q<')

          # The `unsigned short` type.
          USHORT = UINT16

          # The `unsigned int` type.
          UINT = UINT32

          # The `unsigned long` type.
          ULONG = if ADDRESS_SIZE == 8 then UINT64
                  else                      UINT32
                  end

          # The `unsigned long long` type.
          ULONG_LONG = UINT64

          # The "word" type (16-bit little-endian unsigned integer).
          WORD = UINT16

          # The "dword" type (32-bit little-endian unsigned integer).
          DWORD = UINT32

          # The "qword" type (64-bit little-endian unsigned integer).
          QWORD = UINT64

          # The "machine word" type.
          #
          # @return [UINT64, UINT32]
          #   {UINT64} on 64-bit systems and {UINT32} on 32-bit systems.
          MACHINE_WORD = if ADDRESS_SIZE == 8 then UINT64
                         else                      UINT32
                         end

          # The `void *` type.
          POINTER = MACHINE_WORD

          # The `float` type (little-endianness).
          FLOAT32 = Float32Type.new(endian: :little, pack_string: 'e')

          # The `float` type (little-endianness).
          FLOAT = FLOAT32

          # The `double` type (little-endianness).
          FLOAT64 = Float64Type.new(endian: :little, pack_string: 'E')

          # The `double` type (little-endianness).
          DOUBLE = FLOAT64

          # The little-endian types.
          TYPES = {
            int8:  INT8,
            int16: INT16,
            int32: INT32,
            int64: INT64,

            short:     SHORT,
            int:       INT,
            long:      LONG,
            long_long: LONG_LONG,

            uint8:  UINT8,
            uint16: UINT16,
            uint32: UINT32,
            uint64: UINT64,

            byte:       BYTE,
            ushort:     USHORT,
            uint:       UINT,
            ulong:      ULONG,
            ulong_long: ULONG_LONG,

            word:  WORD,
            dword: DWORD,
            qword: QWORD,

            machine_word: MACHINE_WORD,
            pointer:      MACHINE_WORD,

            float32: FLOAT32,
            float64: FLOAT64,

            float:   FLOAT,
            double:  DOUBLE,

            char:  CHAR,
            uchar: UCHAR,

            cstring: STRING,
            string:  STRING
          }

          #
          # Fetches the type from {TYPES}.
          #
          # @param [Symbol] name
          #   The type name to lookup.
          #
          # @return [Type]
          #   The type object from {TYPES}.
          #
          # @raise [ArgumentError]
          #   The type name was unknown.
          #
          def self.[](name)
            TYPES.fetch(name) do
              raise(ArgumentError,"unknown type: #{name.inspect}")
            end
          end
        end
      end
    end
  end
end
