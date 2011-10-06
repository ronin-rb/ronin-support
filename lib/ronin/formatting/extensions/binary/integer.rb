#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

class Integer

  #
  # Extracts a sequence of bytes which represent the Integer.
  #
  # @param [Integer] address_length
  #   The number of bytes to decode from the Integer.
  #
  # @param [Symbol, String] endian
  #   The endianness to use while decoding the bytes of the Integer.
  #   May be one of:
  #
  #   * `:big` / `"big"`
  #   * `:little` / `"little"`
  #   * `:net` / `"net"`
  #
  # @return [Array]
  #   The bytes decoded from the Integer.
  #
  # @raise [ArgumentError]
  #   The given `endian` was not one of:
  #
  #   * `:little` / `"little"`
  #   * `:net` / `"net"`
  #   * `:big` / `"big"`
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
  def bytes(address_length,endian=:little)
    endian = endian.to_sym
    buffer = []

    case endian
    when :little, :net
      mask  = 0xff
      shift = 0

      address_length.times do |i|
        buffer << ((self & mask) >> shift)

        mask <<= 8
        shift += 8
      end
    when :big
      shift = ((address_length - 1) * 8)
      mask  = (0xff << shift)

      address_length.times do |i|
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
  # Packs the Integer into a String, for a specific architecture and
  # address-length.
  #
  # @param [Ronin::Arch, #endian, #address_length, String] arch
  #   The architecture to pack the Integer for.
  #
  # @param [Integer] address_length
  #   The number of bytes to pack.
  #
  # @return [String]
  #   The packed Integer.
  #
  # @raise [ArgumentError]
  #   The given `arch` does not respond to the `endian` or
  #   `address_length` methods.
  #
  # @example using archs other than `Ronin::Arch`.
  #   arch = OpenStruct.new(:endian => :little, :address_length => 4)
  #   
  #   0x41.pack(arch)
  #   # => "A\0\0\0"
  #
  # @example using a `Ronin::Arch` arch.
  #   0x41.pack(Arch.i686)
  #   # => "A\0\0\0"
  #
  # @example specifying a custom address-length.
  #   0x41.pack(Arch.ppc,2)
  #   # => "\0A"
  #
  # @example using a `Array#pack` template String for the arch.
  #   0x41.pack('L')
  #   # => "A\0\0\0"
  #
  # @see http://ruby-doc.org/core/classes/Array.html#M002222
  #
  # @api public
  #
  def pack(arch,address_length=nil)
    if arch.kind_of?(String)
      return [self].pack(arch)
    end

    unless arch.respond_to?(:address_length)
      raise(ArgumentError,"first argument to Ineger#pack must respond to address_length")
    end

    unless arch.respond_to?(:endian)
      raise(ArgumentError,"first argument to Ineger#pack must respond to endian")
    end

    address_length ||= arch.address_length

    integer_bytes = bytes(address_length,arch.endian)
    integer_bytes.map! { |b| b.chr }

    return integer_bytes.join
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
