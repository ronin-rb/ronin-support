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

require 'ronin/support/binary/types/int8_type'
require 'ronin/support/binary/types/int16_type'
require 'ronin/support/binary/types/int32_type'
require 'ronin/support/binary/types/int64_type'
require 'ronin/support/binary/types/uint8_type'
require 'ronin/support/binary/types/uint16_type'
require 'ronin/support/binary/types/uint32_type'
require 'ronin/support/binary/types/uint64_type'
require 'ronin/support/binary/types/float32_type'
require 'ronin/support/binary/types/float64_type'
require 'ronin/support/binary/types/char_types'

module Ronin
  module Support
    module Binary
      module Types
        module Native
          include CharTypes

          # The native endian-ness.
          ENDIAN = if [0x1].pack('S') == [0x1].pack('S>')
                     :big
                   else
                     :little
                   end

          # The size of a native pointer in bytes.
          #
          # @return [4, 8]
          ADDRESS_SIZE = if RbConfig::CONFIG['host_cpu'].include?('64')
                           8
                         else
                           4
                         end

          # The `int8_t` type.
          INT8 = Int8Type.new

          # The `int16_t` type (native-endianness).
          INT16 = Int16Type.new(endian: ENDIAN, pack_string: 's')

          # The `int32_t` type (native-endianness).
          INT32 = Int32Type.new(endian: ENDIAN, pack_string: 'l')

          # The `int64_t` type (native-endianness).
          INT64 = Int64Type.new(endian: ENDIAN, pack_string: 'q')

          # The `uint8_t` type.
          UINT8 = UInt8Type.new

          # The `byte` type.
          BYTE = UINT8

          # The `uint16_t` type (native-endianness).
          UINT16 = UInt16Type.new(endian: ENDIAN, pack_string: 'S')

          # The "word" type (16-bit unsigned integer).
          WORD = UINT16

          # The `uint32_t` type (native-endianness).
          UINT32 = UInt32Type.new(endian: ENDIAN, pack_string: 'L')

          # The "dword" type (32-bit unsigned integer).
          DWORD = UINT32

          # The `uint64_t` type (native-endianness).
          UINT64 = UInt64Type.new(endian: ENDIAN, pack_string: 'Q')

          # The "qword" type (64-bit unsigned integer).
          QWORD = UINT64

          # The "machine word" type.
          #
          # @return [UInt64, UInt32]
          #   {UInt64} on 64-bit systems and {UInt32} on 32-bit systems.
          MACHINE_WORD = if ADDRESS_SIZE == 8 then UINT64
                         else                      UINT32
                         end

          # The `float` type (native-endianness).
          FLOAT32 = Float32Type.new(endian: ENDIAN, pack_string: 'f')

          # The `float` type (native-endianness).
          FLOAT = FLOAT32

          # The `double` type (native-endianness).
          FLOAT64 = Float64Type.new(endian: ENDIAN,pack_string: 'd')

          # The `double` type (native-endianness).
          DOUBLE = FLOAT64

          # The native types.
          TYPES = {
            int8:  INT8,
            int16: INT16,
            int32: INT32,
            int64: INT64,

            short:     INT16,
            int:       INT32,
            long:      if ADDRESS_SIZE == 8 then INT64
                       else                      INT32
                       end,
            long_long: INT64,

            uint8:  UINT8,
            uint16: UINT16,
            uint32: UINT32,
            uint64: UINT64,

            byte:       UINT8,
            ushort:     UINT16,
            uint:       UINT32,
            ulong:      if ADDRESS_SIZE == 8 then UINT64
                        else                      UINT32
                        end,
            ulong_long: UINT64,

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
