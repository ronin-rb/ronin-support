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
        Int8  = Native::Int8
        Int16 = Native::Int16
        Int32 = Native::Int32
        Int64 = Native::Int64

        UInt8  = Native::UInt8
        UInt16 = Native::UInt16
        UInt32 = Native::UInt32
        UInt64 = Native::UInt64

        Byte  = Native::UInt8
        Char  = Native::Char
        UChar = Native::UChar

        CString = Native::CString

        Float32 = Native::Float32
        Float64 = Native::Float64

        # little-endian types
        Int16_LE = LittleEndian::Int16
        Int32_LE = LittleEndian::Int32
        Int64_LE = LittleEndian::Int64

        UInt16_LE = LittleEndian::UInt16
        UInt32_LE = LittleEndian::UInt32
        UInt64_LE = LittleEndian::UInt64

        Float32_LE = LittleEndian::Float32
        Float64_LE = LittleEndian::Float64

        # big-endian types
        Int16_BE = BigEndian::Int16
        Int32_BE = BigEndian::Int32
        Int64_BE = BigEndian::Int64

        UInt16_BE = BigEndian::UInt16
        UInt32_BE = BigEndian::UInt32
        UInt64_BE = BigEndian::UInt64

        Float32_BE = BigEndian::Float32
        Float64_BE = BigEndian::Float64

        # network byte-order types
        Int16_NE = Network::Int16
        Int32_NE = Network::Int32
        Int64_NE = Network::Int64

        UInt16_NE = Network::UInt16
        UInt32_NE = Network::UInt32
        UInt64_NE = Network::UInt64

        Float32_NE = Network::Float32
        Float64_NE = Network::Float64

        Int16_Net = Network::Int16
        Int32_Net = Network::Int32
        Int64_Net = Network::Int64

        UInt16_Net = Network::UInt16
        UInt32_Net = Network::UInt32
        UInt64_Net = Network::UInt64

        Float32_Net = Network::Float32
        Float64_Net = Network::Float64

        # All types (native, little-endian, big-endian, and network byte-order).
        TYPES = Native::TYPES.merge(
          # little-endian types
          int16_le: LittleEndian::Int16,
          int32_le: LittleEndian::Int32,
          int64_le: LittleEndian::Int64,

          short_le:     LittleEndian::Int16,
          int_le:       LittleEndian::Int32,
          long_le:      LittleEndian::Int64,
          long_long_le: LittleEndian::Int64,

          uint16_le: LittleEndian::UInt16,
          uint32_le: LittleEndian::UInt32,
          uint64_le: LittleEndian::UInt64,

          ushort_le:     LittleEndian::UInt16,
          uint_le:       LittleEndian::UInt32,
          ulong_le:      LittleEndian::UInt64,
          ulong_long_le: LittleEndian::UInt64,

          float32_le: LittleEndian::Float32,
          float64_le: LittleEndian::Float64,

          float_le:   LittleEndian::Float32,
          double_le:  LittleEndian::Float64,

          # big-endian types
          int16_be: BigEndian::Int16,
          int32_be: BigEndian::Int32,
          int64_be: BigEndian::Int64,

          short_be:     BigEndian::Int16,
          int_be:       BigEndian::Int32,
          long_be:      BigEndian::Int64,
          long_long_be: BigEndian::Int64,

          uint16_be: BigEndian::UInt16,
          uint32_be: BigEndian::UInt32,
          uint64_be: BigEndian::UInt64,

          ushort_be:     BigEndian::UInt16,
          uint_be:       BigEndian::UInt32,
          ulong_be:      BigEndian::UInt64,
          ulong_long_be: BigEndian::UInt64,

          float32_be: BigEndian::Float32,
          float64_be: BigEndian::Float64,

          float_be:   BigEndian::Float32,
          double_be:  BigEndian::Float64,

          # network byte-order types
          int16_ne: Network::Int16,
          int32_ne: Network::Int32,
          int64_ne: Network::Int64,

          short_ne:     Network::Int16,
          int_ne:       Network::Int32,
          long_ne:      Network::Int64,
          long_long_ne: Network::Int64,

          uint16_ne: Network::UInt16,
          uint32_ne: Network::UInt32,
          uint64_ne: Network::UInt64,

          ushort_ne:     Network::UInt16,
          uint_ne:       Network::UInt32,
          ulong_ne:      Network::UInt64,
          ulong_long_ne: Network::UInt64,

          float32_ne: Network::Float32,
          float64_ne: Network::Float64,

          float_ne:   Network::Float32,
          double_ne:  Network::Float64,

          # `_net` -> `_ne` aliases
          int16_net: Network::Int16,
          int32_net: Network::Int32,
          int64_net: Network::Int64,

          short_net:     Network::Int16,
          int_net:       Network::Int32,
          long_net:      Network::Int64,
          long_long_net: Network::Int64,

          uint16_net: Network::UInt16,
          uint32_net: Network::UInt32,
          uint64_net: Network::UInt64,

          ushort_net:     Network::UInt16,
          uint_net:       Network::UInt32,
          ulong_net:      Network::UInt64,
          ulong_long_net: Network::UInt64,

          float32_net: Network::Float32,
          float64_net: Network::Float64,

          float_net:   Network::Float32,
          double_net:  Network::Float64
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
