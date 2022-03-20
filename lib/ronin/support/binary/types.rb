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

require 'ronin/support/binary/types/native'
require 'ronin/support/binary/types/little_endian'
require 'ronin/support/binary/types/big_endian'
require 'ronin/support/binary/types/network'
require 'ronin/support/binary/types/arch'

module Ronin
  module Support
    module Binary
      module Types
        include Native

        # little-endian types
        INT16_LE = LittleEndian::INT16
        INT32_LE = LittleEndian::INT32
        INT64_LE = LittleEndian::INT64

        UINT16_LE = LittleEndian::UINT16
        UINT32_LE = LittleEndian::UINT32
        UINT64_LE = LittleEndian::UINT64

        WORD_LE  = LittleEndian::WORD
        DWORD_LE = LittleEndian::DWORD
        QWORD_LE = LittleEndian::QWORD

        MACHINE_WORD_LE = LittleEndian::MACHINE_WORD

        FLOAT32_LE = LittleEndian::FLOAT32
        FLOAT64_LE = LittleEndian::FLOAT64

        FLOAT_LE  = LittleEndian::FLOAT
        DOUBLE_LE = LittleEndian::DOUBLE

        # big-endian types
        INT16_BE = BigEndian::INT16
        INT32_BE = BigEndian::INT32
        INT64_BE = BigEndian::INT64

        UINT16_BE = BigEndian::UINT16
        UINT32_BE = BigEndian::UINT32
        UINT64_BE = BigEndian::UINT64

        WORD_BE  = BigEndian::WORD
        DWORD_BE = BigEndian::DWORD
        QWORD_BE = BigEndian::QWORD

        MACHINE_WORD_BE = BigEndian::MACHINE_WORD

        FLOAT32_BE = BigEndian::FLOAT32
        FLOAT64_BE = BigEndian::FLOAT64

        FLOAT_BE  = BigEndian::FLOAT
        DOUBLE_BE = BigEndian::DOUBLE

        # network byte-order types
        INT16_NE = Network::INT16
        INT32_NE = Network::INT32
        INT64_NE = Network::INT64

        UINT16_NE = Network::UINT16
        UINT32_NE = Network::UINT32
        UINT64_NE = Network::UINT64

        WORD_NE  = Network::WORD
        DWORD_NE = Network::DWORD
        QWORD_NE = Network::QWORD

        MACHINE_WORD_NE = Network::MACHINE_WORD

        FLOAT32_NE = Network::FLOAT32
        FLOAT64_NE = Network::FLOAT64

        FLOAT_NE  = Network::FLOAT
        DOUBLE_NE = Network::DOUBLE

        INT16_NET = Network::INT16
        INT32_NET = Network::INT32
        INT64_NET = Network::INT64

        UINT16_NET = Network::UINT16
        UINT32_NET = Network::UINT32
        UINT64_NET = Network::UINT64

        WORD_NET = Network::WORD
        DWORD_NET = Network::DWORD
        QWORD_NET = Network::QWORD

        MACHINE_WORD_NET = Network::MACHINE_WORD

        FLOAT32_NET = Network::FLOAT32
        FLOAT64_NET = Network::FLOAT64

        FLOAT_NET  = Network::FLOAT
        DOUBLE_NET = Network::DOUBLE

        # All types (native, little-endian, big-endian, and network byte-order).
        TYPES = Native::TYPES.merge(
          # little-endian types
          int16_le: LittleEndian::INT16,
          int32_le: LittleEndian::INT32,
          int64_le: LittleEndian::INT64,

          short_le:     LittleEndian::INT16,
          int_le:       LittleEndian::INT32,
          long_le:      if Native::ADDRESS_SIZE == 8 then LittleEndian::INT64
                        else                              LittleEndian::INT32
                        end,
          long_long_le: LittleEndian::INT64,

          uint16_le: LittleEndian::UINT16,
          uint32_le: LittleEndian::UINT32,
          uint64_le: LittleEndian::UINT64,

          ushort_le:     LittleEndian::UINT16,
          uint_le:       LittleEndian::UINT32,
          ulong_le:      if Native::ADDRESS_SIZE == 8 then LittleEndian::UINT64
                         else                              LittleEndian::UINT32
                         end,
          ulong_long_le: LittleEndian::UINT64,

          word_le:  WORD_LE,
          dword_le: DWORD_LE,
          qword_le: QWORD_LE,

          machine_word_le: LittleEndian::MACHINE_WORD,
          pointer_le:      LittleEndian::MACHINE_WORD,

          float32_le: LittleEndian::FLOAT32,
          float64_le: LittleEndian::FLOAT64,

          float_le:   LittleEndian::FLOAT,
          double_le:  LittleEndian::DOUBLE,

          # big-endian types
          int16_be: BigEndian::INT16,
          int32_be: BigEndian::INT32,
          int64_be: BigEndian::INT64,

          short_be:     BigEndian::INT16,
          int_be:       BigEndian::INT32,
          long_be:      if Native::ADDRESS_SIZE == 8 then BigEndian::INT64
                        else                              BigEndian::INT32
                        end,
          long_long_be: BigEndian::INT64,

          uint16_be: BigEndian::UINT16,
          uint32_be: BigEndian::UINT32,
          uint64_be: BigEndian::UINT64,

          ushort_be:     BigEndian::UINT16,
          uint_be:       BigEndian::UINT32,
          ulong_be:      if Native::ADDRESS_SIZE == 8 then BigEndian::UINT64
                         else                              BigEndian::UINT32
                         end,
          ulong_long_be: BigEndian::UINT64,

          word_be:  WORD_BE,
          dword_be: DWORD_BE,
          qword_be: QWORD_BE,

          machine_word_be: BigEndian::MACHINE_WORD,
          pointer_be:      BigEndian::MACHINE_WORD,

          float32_be: BigEndian::FLOAT32,
          float64_be: BigEndian::FLOAT64,

          float_be:   BigEndian::FLOAT,
          double_be:  BigEndian::DOUBLE,

          # network byte-order types
          int16_ne: Network::INT16,
          int32_ne: Network::INT32,
          int64_ne: Network::INT64,

          short_ne:     Network::INT16,
          int_ne:       Network::INT32,
          long_ne:      if Native::ADDRESS_SIZE == 8 then Network::INT64
                        else                              Network::INT32
                        end,
          long_long_ne: Network::INT64,

          uint16_ne: Network::UINT16,
          uint32_ne: Network::UINT32,
          uint64_ne: Network::UINT64,

          ushort_ne:     Network::UINT16,
          uint_ne:       Network::UINT32,
          ulong_ne:      if Native::ADDRESS_SIZE == 8 then Network::UINT64
                         else                              Network::UINT32
                         end,
          ulong_long_ne: Network::UINT64,

          word_ne:  WORD_NE,
          dword_ne: DWORD_NE,
          qword_ne: QWORD_NE,

          machine_word_ne: Network::MACHINE_WORD,
          pointer_ne:      Network::MACHINE_WORD,

          float32_ne: Network::FLOAT32,
          float64_ne: Network::FLOAT64,

          float_ne:   Network::FLOAT,
          double_ne:  Network::DOUBLE,

          # `_net` -> `_ne` aliases
          int16_net: Network::INT16,
          int32_net: Network::INT32,
          int64_net: Network::INT64,

          short_net:     Network::INT16,
          int_net:       Network::INT32,
          long_net:      if Native::ADDRESS_SIZE == 8 then Network::INT64
                         else                              Network::INT32
                         end,
          long_long_net: Network::INT64,

          uint16_net: Network::UINT16,
          uint32_net: Network::UINT32,
          uint64_net: Network::UINT64,

          ushort_net:     Network::UINT16,
          uint_net:       Network::UINT32,
          ulong_net:      if Native::ADDRESS_SIZE == 8 then Network::UINT64
                          else                              Network::UINT32
                          end,
          ulong_long_net: Network::UINT64,

          word_net:  WORD_NET,
          dword_net: DWORD_NET,
          qword_net: QWORD_NET,

          machine_word_net: Network::MACHINE_WORD,
          pointer_net:      Network::MACHINE_WORD,

          float32_net: Network::FLOAT32,
          float64_net: Network::FLOAT64,

          float_net:   Network::FLOAT,
          double_net:  Network::DOUBLE
        )

        # Represents the different endian type systems.
        ENDIAN = {
          little: LittleEndian,
          big:    BigEndian,
          net:    Network,

          nil => self
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

        #
        # Fetches the type system for the given endianness.
        #
        # @param [:little, :big, :net, nil] endian
        #   The endianness.
        #
        # @return [LittleEndian, BigEndian, Network, self]
        #   The type system for the given endianness.
        #
        # @raise [ArgumentError]
        #   The endian was unknown.
        #
        def self.endian(endian)
          ENDIAN.fetch(endian) do
            raise(ArgumentError,"unknown endian: #{endian.inspect}")
          end
        end

        #
        # @see Arch.[]
        #
        def self.arch(arch)
          Arch[arch]
        end
      end
    end
  end
end
