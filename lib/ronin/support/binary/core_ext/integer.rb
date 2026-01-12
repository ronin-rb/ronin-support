# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes'

class Integer

  #
  # Packs the Integer into a String.
  #
  # @param [String, Symbol] argument
  #   The `Array#pack` String or {Ronin::Support::Binary::Template} type.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::CTypes.platform}.
  #
  # @option kwargs [:little, :big, :net, nil] :endian
  #   The desired endianness of the binary format.
  #
  # @option kwargs [:x86, :x86_64,
  #                 :ppc, :ppc64,
  #                 :mips, :mips_le, :mips_be,
  #                 :mips64, :mips64_le, :mips64_be,
  #                 :arm, :arm_le, :arm_be,
  #                 :arm64, :arm64_le, :arm64_be] :arch
  #   The desired architecture of the binary format.
  #
  # @option kwargs [:linux, :macos, :windows,
  #                 :android, :apple_ios, :bsd,
  #                 :freebsd, :openbsd, :netbsd] :os
  #   The Operating System name to lookup.
  #
  # @return [String]
  #   The packed Integer.
  #
  # @raise [ArgumentError]
  #   The given argument was not a `String`, `Symbol`, or valid type name.
  #
  # @example using a `Array#pack` format string:
  #   0x41.pack('V')
  #   # => "A\0\0\0"
  #
  # @example using {Ronin::Support::Binary::CTypes} types:
  #   0x41.pack(:uint32_le)
  #   # => "A\x00\x00\x00"
  #
  # @example specifying the endian-ness:
  #   0x41.pack(:uint32, endian: :big)
  #   # => "\x00\x00\x00A"
  #
  # @example specifying the architecture:
  #   0x41.pack(:ulong, arch: :arm64)
  #   # => "A\x00\x00\x00\x00\x00\x00\x00"
  #
  # @example specifying the architecture and Operating System (OS):
  #   0x41.pack(:size_t, arch: :arm64, os: :linux)
  #   # => "A\x00\x00\x00\x00\x00\x00\x00"
  #
  # @see http://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Support::Binary::Template
  #
  # @api public
  #
  def pack(argument, **kwargs)
    case argument
    when String
      [self].pack(argument)
    when Symbol
      types = Ronin::Support::Binary::CTypes.platform(**kwargs)
      type  = types[argument]
      type.pack(self)
    else
      raise(ArgumentError,"invalid pack argument: #{argument}")
    end
  end

  #
  # Converts the integer into an 8-bit unsigned integer.
  #
  # @return [Integer]
  #   The integer truncated to 8-bits.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_uint8
    self & 0xff
  end

  alias to_u8 to_uint8

  #
  # Converts the integer into an 16-bit unsigned integer.
  #
  # @return [Integer]
  #   The integer truncated to 16-bits.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_uint16
    self & 0xffff
  end

  alias to_u16 to_uint16

  #
  # Converts the integer into an 32-bit unsigned integer.
  #
  # @return [Integer]
  #   The integer truncated to 32-bits.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_uint32
    self & 0xffffffff
  end

  alias to_u32 to_uint32

  #
  # Converts the integer into an 64-bit unsigned integer.
  #
  # @return [Integer]
  #   The integer truncated to 64-bits.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_uint64
    self & 0xffffffffffffffff
  end

  alias to_u64 to_uint64

  #
  # Converts the integer into an 8-bit signed integer.
  #
  # @return [Integer]
  #   The integer truncated to 8-bits with signed preserved.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_int8
    int = self & 0xff

    if int[7] == 1
      # interpret the new signed bit
      int -= 0x100
    end

    return int
  end

  alias to_i8 to_int8

  #
  # Converts the integer into an 16-bit signed integer.
  #
  # @return [Integer]
  #   The integer truncated to 16-bits with signed preserved.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_int16
    int = self & 0xffff

    if int[15] == 1
      # interpret the new signed bit
      int -= 0x10000
    end

    return int
  end

  alias to_i16 to_int16

  #
  # Converts the integer into an 32-bit signed integer.
  #
  # @return [Integer]
  #   The integer truncated to 32-bits with signed preserved.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_int32
    int = self & 0xffffffff

    if int[31] == 1
      # interpret the new signed bit
      int -= 0x100000000
    end

    return int
  end

  alias to_i32 to_int32

  #
  # Converts the integer into an 64-bit signed integer.
  #
  # @return [Integer]
  #   The integer truncated to 64-bits with signed preserved.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_int64
    int = self & 0xffffffffffffffff

    if int[63] == 1
      # interpret the new signed bit
      int -= 0x10000000000000000
    end

    return int
  end

  alias to_i64 to_int64

end
