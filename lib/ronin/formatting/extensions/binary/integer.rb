#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

class Integer

  #
  # Extracts a sequence of bytes which represent the Integer.
  #
  # @param [Integer] address_length
  #   The number of bytes to decode from the Integer.
  #
  # @param [String, Symbol] endian
  #   The endianness to use while decoding the bytes of the Integer.
  #   May be either `:big`, `:little` or `:net`.
  #
  # @return [Array]
  #   The bytes decoded from the Integer.
  #
  # @raise [RuntimeError]
  #   The given `endian` is not `:little`, `"little"`, `:net`, `"net"`,
  #   `:big` or `"big"`.
  #
  # @example
  #   0xff41.bytes(2)
  #   # => [65, 255]
  #
  # @example
  #   0xff41.bytes(4, :big)
  #   # => [0, 0, 255, 65]
  #
  def bytes(address_length,endian=:little)
    endian = endian.to_s
    buffer = []

    case endian
    when :little, 'little', :net, 'net'
      mask = 0xff

      address_length.times do |i|
        buffer << ((self & mask) >> (i*8))
        mask <<= 8
      end
    when :big, 'big'
      mask = (0xff << ((address_length-1)*8))

      address_length.times do |i|
        buffer << ((self & mask) >> ((address_length-i-1)*8))
        mask >>= 8
      end
    else
      raise(RuntimeError,"invalid endian #{endian.inspect}",caller)
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
  # @raise [RuntimeError]
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
  def pack(arch,address_length=nil)
    if arch.kind_of?(String)
      return [self].pack(arch)
    end

    unless arch.respond_to?(:address_length)
      raise(RuntimeError,"first argument to Ineger#pack must respond to address_length",caller)
    end

    unless arch.respond_to?(:endian)
      raise(RuntimeError,"first argument to Ineger#pack must respond to endian",caller)
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
  def hex_escape
    "\\x%.2x" % self
  end

  alias char chr

end
