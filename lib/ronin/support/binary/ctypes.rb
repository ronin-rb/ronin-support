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

require 'ronin/support/binary/ctypes/native'
require 'ronin/support/binary/ctypes/little_endian'
require 'ronin/support/binary/ctypes/big_endian'
require 'ronin/support/binary/ctypes/network'
require 'ronin/support/binary/ctypes/arch'
require 'ronin/support/binary/ctypes/os'

require 'ronin/support/binary/ctypes/array_type'
require 'ronin/support/binary/ctypes/flexible_array_type'
require 'ronin/support/binary/ctypes/struct_type'

require 'ronin/support/binary/ctypes/array_object_type'
require 'ronin/support/binary/ctypes/struct_object_type'
require 'ronin/support/binary/ctypes/union_object_type'

module Ronin
  module Support
    module Binary
      #
      # Provides a complete virtual C type system, implemented purely in Ruby.
      # The type objects are then used by {Binary::Template}, {Binary::Buffer},
      # {Binary::Stream}, {Binary::Array}, {Binary::Struct}, and {Binary::Union}
      # to encode and decoded any C binary data.
      #
      # ## Supported Types
      #
      # * Scalar Types:
      #   * Character Types:
      #     * {CharType char} (ex: `'c'`)
      #     * {StringType string} (ex: `"abc"`)
      #   * Signed Integer Types:
      #     * {CTypes::Int8Type int8} (`-127` - `127`)
      #     * {CTypes::Int16Type int16} (`-32768` to `32767`)
      #     * {CTypes::Int32Type int32} (`-2147483648` - `2147483648`)
      #     * {CTypes::Int64Type int64} (`-9223372036854775808` -
      #       `9223372036854775808`)
      #   * Unsigned Integer Types:
      #     * {CTypes::UInt8Type uint8} (`0x00` - `0xff`)
      #     * {CTypes::UInt16Type uint16} (`0x0000` - `0xffff`)
      #     * {CTypes::UInt32Type uint32} (`0x00000000` - `0xffffffff`)
      #     * {CTypes::UInt64Type uint64} (`0x0000000000000000` -
      #       `0xffffffffffffffff`)
      #   * Floating Point Types:
      #     * {CTypes::Float32Type float} (`-3.40282347E+38F` -
      #       `3.40282347E+38F`)
      #     * {CTypes::Float64Type double} (`-1.79769313486231570E+308` -
      #       `1.79769313486231570E+308`)
      # * Aggregate Types:
      #   * {CTypes::ArrayType Array} (ex: `{1,2,3}`)
      #   * {CTypes::FlexibleArrayType unbounded Array} (ex: `char c[] = {...}`)
      #   * {CTypes::StructType struct} (ex: `struct s = {1, 'c', ...}`)
      #   * {CTypes::UnionType union} (ex: `union u = {1234}`)
      # * Object Types:
      #   * {CTypes::ArrayObjectType array} objects (see: {Binary::Array}).
      #   * {CTypes::StructObjectType struct} objects (see: {Binary::Struct}).
      #   * {CTypes::UnionObjectType union} objects (see: {Binary::Union}).
      #
      # ## Supported Endian-ness
      #
      # * {CTypes::LittleEndian little-endian} byte-order
      # * {CTypes::BigEndian big-endian} byte-order
      # * {CTypes::Network network} byte-order
      #
      # ## Supported Architectures
      #
      # * {CTypes::Arch::ARM arm}
      # * {CTypes::Arch::ARM::BigEndian armbe (big-endian)}
      # * {CTypes::Arch::ARM64 arm64}
      # * {CTypes::Arch::ARM64::BigEndian arm64be (big-endian)}
      # * {CTypes::Arch::MIPS mips}
      # * {CTypes::Arch::MIPS::LittleEndian mipsle (little-endian)}
      # * {CTypes::Arch::MIPS64 mips64}
      # * {CTypes::Arch::MIPS64::LittleEndian mips64le (little-endian)}
      # * {CTypes::Arch::PPC ppc}
      # * {CTypes::Arch::PPC64 ppc64}
      # * {CTypes::Arch::X86 x86}
      # * {CTypes::Arch::X86_64 x86-64}
      #
      # ## Supported Operating Systems (OS)
      #
      # * {CTypes::OS::UNIX UNIX}
      # * {CTypes::OS::BSD BSD}
      #   * {CTypes::OS::FreeBSD FreeBSD}
      #   * {CTypes::OS::OpenBSD OpenBSD}
      #   * {CTypes::OS::NetBSD NetBSD}
      # * {CTypes::OS::Linux Linux}
      # * {CTypes::OS::MacOS macOS}
      # * {CTypes::OS::Windows Windows}
      # * {CTypes::OS::Android Android}
      # * {CTypes::OS::AppleIOS Apple iOS}
      #
      module CTypes
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
        POINTER_LE      = LittleEndian::POINTER

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
        POINTER_BE      = BigEndian::POINTER

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
        POINTER_NE      = Network::POINTER

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

        WORD_NET  = Network::WORD
        DWORD_NET = Network::DWORD
        QWORD_NET = Network::QWORD

        MACHINE_WORD_NET = Network::MACHINE_WORD
        POINTER_NET      = Network::POINTER

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
          long_le:      LittleEndian::LONG,
          long_long_le: LittleEndian::INT64,

          uint16_le: LittleEndian::UINT16,
          uint32_le: LittleEndian::UINT32,
          uint64_le: LittleEndian::UINT64,

          ushort_le:     LittleEndian::UINT16,
          uint_le:       LittleEndian::UINT32,
          ulong_le:      LittleEndian::ULONG,
          ulong_long_le: LittleEndian::UINT64,

          word_le:  WORD_LE,
          dword_le: DWORD_LE,
          qword_le: QWORD_LE,

          machine_word_le: LittleEndian::MACHINE_WORD,
          pointer_le:      LittleEndian::POINTER,

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
          long_be:      BigEndian::LONG,
          long_long_be: BigEndian::INT64,

          uint16_be: BigEndian::UINT16,
          uint32_be: BigEndian::UINT32,
          uint64_be: BigEndian::UINT64,

          ushort_be:     BigEndian::UINT16,
          uint_be:       BigEndian::UINT32,
          ulong_be:      BigEndian::ULONG,
          ulong_long_be: BigEndian::UINT64,

          word_be:  WORD_BE,
          dword_be: DWORD_BE,
          qword_be: QWORD_BE,

          machine_word_be: BigEndian::MACHINE_WORD,
          pointer_be:      BigEndian::POINTER,

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
          long_ne:      Network::LONG,
          long_long_ne: Network::INT64,

          uint16_ne: Network::UINT16,
          uint32_ne: Network::UINT32,
          uint64_ne: Network::UINT64,

          ushort_ne:     Network::UINT16,
          uint_ne:       Network::UINT32,
          ulong_ne:      Network::ULONG,
          ulong_long_ne: Network::UINT64,

          word_ne:  WORD_NE,
          dword_ne: DWORD_NE,
          qword_ne: QWORD_NE,

          machine_word_ne: Network::MACHINE_WORD,
          pointer_ne:      Network::POINTER,

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
          long_net:      Network::LONG,
          long_long_net: Network::INT64,

          uint16_net: Network::UINT16,
          uint32_net: Network::UINT32,
          uint64_net: Network::UINT64,

          ushort_net:     Network::UINT16,
          uint_net:       Network::UINT32,
          ulong_net:      Network::ULONG,
          ulong_long_net: Network::UINT64,

          word_net:  WORD_NET,
          dword_net: DWORD_NET,
          qword_net: QWORD_NET,

          machine_word_net: Network::MACHINE_WORD,
          pointer_net:      Network::POINTER,

          float32_net: Network::FLOAT32,
          float64_net: Network::FLOAT64,

          float_net:   Network::FLOAT,
          double_net:  Network::DOUBLE
        )

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

        # Represents the different endian type systems.
        ENDIAN = {
          little: LittleEndian,
          big:    BigEndian,
          net:    Network,

          nil => self
        }

        # The supported architectures.
        ARCHES = {
          x86: Arch::X86,

          x86_64: Arch::X86_64,
          ia64:   Arch::X86_64,
          amd64:  Arch::X86_64,

          ppc:   Arch::PPC,
          ppc64: Arch::PPC64,

          mips:    Arch::MIPS,
          mips_le: Arch::MIPS::LittleEndian,
          mips_be: Arch::MIPS, # MIPS is big-endian by default

          mips64:    Arch::MIPS64,
          mips64_le: Arch::MIPS64::LittleEndian,
          mips64_be: Arch::MIPS64, # MIPS is big-endian by default

          arm:      Arch::ARM,
          arm_le:   Arch::ARM,
          arm_be:   Arch::ARM::BigEndian,

          arm64:    Arch::ARM64,
          arm64_le: Arch::ARM64, # ARM is little-endian by default
          arm64_be: Arch::ARM64::BigEndian
        }

        # The supported Operating Systems.
        OSES = {
          unix:      OS::UNIX,

          bsd:       OS::BSD,
          freebsd:   OS::FreeBSD,
          openbsd:   OS::OpenBSD,
          netbsd:    OS::NetBSD,

          linux:     OS::Linux,
          macos:     OS::MacOS,
          windows:   OS::Windows,

          android:   OS::Android,
          apple_ios: OS::AppleIOS
        }

        #
        # Returns the types module/object for the given endianness,
        # architecture, and/or Operating System (OS).
        #
        # @param [:little, :big, :net, nil] endian
        #   The endianness.
        #
        # @param [:x86, :x86_64,
        #         :ppc, :ppc64,
        #         :mips, :mips_le, :mips_be,
        #         :mips64, :mips64_le, :mips64_be,
        #         :arm, :arm_le, :arm_be,
        #         :arm64, :arm64_le, :arm64_be] arch
        #   The architecture name to lookup.
        #
        # @param [:linux, :macos, :windows,
        #         :android, :apple_ios, :bsd,
        #         :freebsd, :openbsd, :netbsd] os
        #   The Operating System name to lookup.
        #
        # @return [CTypes,
        #          CTypes::LittleEndian,
        #          CTypes::BigEndian,
        #          CTypes::Network,
        #          CTypes::Arch::ARM,
        #          CTypes::Arch::ARM::BigEndian,
        #          CTypes::Arch::ARM64,
        #          CTypes::Arch::ARM64::BigEndian,
        #          CTypes::Arch::MIPS,
        #          CTypes::Arch::MIPS::LittleEndian,
        #          CTypes::Arch::MIPS64,
        #          CTypes::Arch::MIPS64::LittleEndian,
        #          CTypes::Arch::PPC,
        #          CTypes::Arch::PPC64,
        #          CTypes::Arch::X86,
        #          CTypes::Arch::X86_64,
        #          CTypes::OS]
        #   The types module.
        #
        # @raise [ArgumentError]
        #   The endian was unknown, the architecture name was unknown,
        #   or the os name was unknown.
        #
        def self.platform(arch: nil, endian: nil, os: nil)
          types = if arch
                    ARCHES.fetch(arch) do
                      raise(ArgumentError,"unknown architecture: #{arch.inspect}")
                    end
                  else
                    ENDIAN.fetch(endian) do
                      raise(ArgumentError,"unknown endian: #{endian.inspect}")
                    end
                  end

          if os
            types = OSES.fetch(os) {
              raise(ArgumentError,"unknown OS: #{os.inspect}")
            }.new(types)
          end

          return types
        end
      end
    end
  end
end
