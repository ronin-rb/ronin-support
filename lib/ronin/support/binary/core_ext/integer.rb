#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  # Enumerates over every bit flip in the integer.
  #
  # @param [Integer, Range(Integer)] bits
  #   The number of bits to flip or a range of bit indexes to flip.
  #
  # @yield [int]
  #   If a block is given, it will be passed each bit-flipped integer.
  #
  # @yieldparam [Integer] int
  #   The integer but with one of it's bits flipped.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator object will be returned.
  #
  # @raise [ArgumentError]
  #   The given bits must be either a Range or an Integer.
  #
  # @example bit-flip all eight bits:
  #   0x41.each_bit_flip(8) { |int| puts "%.8b" % int }
  #
  # @example bit-flip bits 8-16:
  #   0xffff.each_bit_flip(8...16) { |int| puts "%.16b" % int }
  #
  # @api public
  #
  def each_bit_flip(bits)
    return enum_for(__method__,bits) unless block_given?

    bits = case bits
           when Range   then bits
           when Integer then (0...bits)
           else
             raise(ArgumentError,"bits must be an Integer or a Range: #{bits.inspect}")
           end

    bits.each do |bit_index|
      mask = 1 << bit_index

      yield self ^ mask
    end
  end

  #
  # Returns every bit flip in the integer.
  #
  # @param [Integer, Range(Integer)] bits
  #   The number of bits to flip or a range of bit indexes to flip.
  #
  # @return [Array<Integer>]
  #   The bit-flipped integers.
  #
  # @raise [ArgumentError]
  #   The given bits must be either a Range or an Integer.
  #
  # @example bit-flip all eight bits:
  #   0x41.bit_flips(8)
  #
  # @example bit-flip bits 8-16:
  #   0xffff.bit_flips(8...16)
  #
  # @api public
  #
  def bit_flips(bits)
    each_bit_flip(bits).to_a
  end

  alias flip_bits bit_flips

  #
  # Extracts a sequence of bytes which represent the Integer.
  #
  # @param [Integer] length
  #   The number of bytes to decode from the Integer.
  #
  # @param [Symbol, String] endian
  #   The endianness to use while decoding the bytes of the Integer.
  #   May be one of:
  #
  #   * `big`
  #   * `little`
  #   * `net`
  #
  # @return [Array]
  #   The bytes decoded from the Integer.
  #
  # @raise [ArgumentError]
  #   The given `endian` was not one of:
  #
  #   * `little`
  #   * `net`
  #   * `big`
  #
  # @example
  #   0xff41.bytes(2)
  #   # => [65, 255]
  #
  # @example
  #   0xff41.bytes(4, :big)
  #   # => [0, 0, 255, 65]
  #
  # @api public
  #
  def bytes(length,endian=:little)
    endian = endian.to_sym
    buffer = []

    case endian
    when :little
      mask  = 0xff
      shift = 0

      length.times do |i|
        buffer << ((self & mask) >> shift)

        mask <<= 8
        shift += 8
      end
    when :big, :net
      shift = ((length - 1) * 8)
      mask  = (0xff << shift)

      length.times do |i|
        buffer << ((self & mask) >> shift)

        mask >>= 8
        shift -= 8
      end
    else
      raise(ArgumentError,"invalid endian #{endian}")
    end

    return buffer
  end

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
  #                 :bsd, :freebsd, :openbsd, :netbsd] :os
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
