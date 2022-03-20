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
          Int8 = Int8Type.new

          # The `int16_t` type (native-endianness).
          Int16 = Int16Type.new(endian: ENDIAN, pack_string: 's')

          # The `int32_t` type (native-endianness).
          Int32 = Int32Type.new(endian: ENDIAN, pack_string: 'l')

          # The `int64_t` type (native-endianness).
          Int64 = Int64Type.new(endian: ENDIAN, pack_string: 'q')

          # The `uint8_t` type.
          UInt8 = UInt8Type.new

          # The `byte` type.
          Byte = UInt8

          # The `uint16_t` type (native-endianness).
          UInt16 = UInt16Type.new(endian: ENDIAN, pack_string: 'S')

          # The "word" type (16-bit unsigned integer).
          WORD = UInt16

          # The `uint32_t` type (native-endianness).
          UInt32 = UInt32Type.new(endian: ENDIAN, pack_string: 'L')

          # The "dword" type (32-bit unsigned integer).
          DWORD = UInt32

          # The `uint64_t` type (native-endianness).
          UInt64 = UInt64Type.new(endian: ENDIAN, pack_string: 'Q')

          # The "qword" type (64-bit unsigned integer).
          QWORD = UInt64

          # The "machine word" type.
          #
          # @return [UInt64, UInt32]
          #   {UInt64} on 64-bit systems and {UInt32} on 32-bit systems.
          MACHINE_WORD = if ADDRESS_SIZE == 8 then UInt64
                         else                      UInt32
                         end

          # The `float` type (native-endianness).
          Float32 = Float32Type.new(endian: ENDIAN, pack_string: 'f')

          # The `double` type (native-endianness).
          Float64 = Float64Type.new(endian: ENDIAN,pack_string: 'd')

          # The native types.
          TYPES = {
            int8:  Int8,
            int16: Int16,
            int32: Int32,
            int64: Int64,

            short:     Int16,
            int:       Int32,
            long:      if ADDRESS_SIZE == 8 then Int64
                       else                      Int32
                       end,
            long_long: Int64,

            uint8:  UInt8,
            uint16: UInt16,
            uint32: UInt32,
            uint64: UInt64,

            byte:       UInt8,
            ushort:     UInt16,
            uint:       UInt32,
            ulong:      if ADDRESS_SIZE == 8 then UInt64
                        else                      UInt32
                        end,
            ulong_long: UInt64,

            word:  WORD,
            dword: DWORD,
            qword: QWORD,

            machine_word: MACHINE_WORD,
            pointer:      MACHINE_WORD,

            float32: Float32,
            float64: Float64,

            float:   Float32,
            double:  Float64,

            char:  Char,
            uchar: UChar,

            cstring: CString,
            string:  CString
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
