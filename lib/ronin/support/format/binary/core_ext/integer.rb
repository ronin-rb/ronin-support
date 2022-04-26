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

class Integer

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
  #   The `Array#pack` String or {Ronin::Support::Binary::Format} type.
  #
  # @param [:little, :big, :net, nil] endian
  #   The desired endianness of the packed integer.
  #
  # @param [:x86, :x86_64, :ppc, :ppc64,
  #         :arm, :arm_be, :arm64, :arm64_be,
  #         :mips, :mips_le, :mips64, :mips64_le, nil] arch
  #   The desired architecture to pack the integer for.
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
  # @example using {Ronin::Support::Binary::Format} types:
  #   0x41.pack(:uint32_le)
  #
  # @see http://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Support::Binary::Format
  #
  # @api public
  #
  def pack(argument, endian: nil, arch: nil)
    case argument
    when String
      [self].pack(argument)
    when Symbol
      types = if arch then Ronin::Support::Binary::Types.arch(arch)
              else         Ronin::Support::Binary::Types.endian(endian)
              end
      type = types[argument]
      type.pack(self)
    else
      raise(ArgumentError,"invalid pack argument: #{argument}")
    end
  end

  #
  # Hex-encodes the Integer.
  #
  # @return [String]
  #   The hex encoded version of the Integer.
  #
  # @example
  #   0x41.hex_encode
  #   # => "41"
  #
  # @since 0.6.0
  #
  def hex_encode
    "%.2x" % self
  end

  #
  # @return [String]
  #   The hex escaped version of the Integer.
  #
  # @example
  #   42.hex_escape
  #   # => "\\x2a"
  #
  # @api public
  #
  def hex_escape
    "\\x%.2x" % self
  end

  alias char chr

end
