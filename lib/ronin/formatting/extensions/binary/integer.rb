#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/binary/template'

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
  # @param [String, Symbol, arch] arguments
  #   The `Array#pack` code, {Ronin::Binary::Template} type or Architecture
  #   object with `#endian` and `#address_length` methods.
  #
  # @return [String]
  #   The packed Integer.
  #
  # @raise [ArgumentError]
  #   The given Symbol could not be found in
  #   {Ronin::Binary::Template::INT_TYPES}.
  #
  # @example using a `Array#pack` template:
  #   0x41.pack('V')
  #   # => "A\0\0\0"
  #
  # @example using {Ronin::Binary::Template} types:
  #   0x41.pack(:uint32_le)
  #
  # @example using archs other than `Ronin::Arch` (**deprecated**):
  #   arch = OpenStruct.new(:endian => :little, :address_length => 4)
  #
  #   0x41.pack(arch)
  #   # => "A\0\0\0"
  #
  # @example using a `Ronin::Arch` arch (**deprecated**):
  #   0x41.pack(Arch.i686)
  #   # => "A\0\0\0"
  #
  # @example specifying a custom address-length (**deprecated**):
  #   0x41.pack(Arch.ppc,2)
  #   # => "\0A"
  #
  # @see http://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Binary::Template
  #
  # @api public
  #
  def pack(*arguments)
    if (arguments.length == 1 && arguments.first.kind_of?(String))
      [self].pack(arguments.first)
    elsif (arguments.length == 1 && arguments.first.kind_of?(Symbol))
      type = arguments.first

      unless Ronin::Binary::Template::INT_TYPES.include?(type)
        raise(ArgumentError,"unsupported integer type: #{type}")
      end

      [self].pack(Ronin::Binary::Template::TYPES[type])
    elsif (arguments.length == 1 || arguments.length == 2)
      # TODO: deprecate this calling convention
      arch, address_length = arguments

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
    else
      raise(ArgumentError,"wrong number of arguments (#{arguments.length} for 1..2)")
    end
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
