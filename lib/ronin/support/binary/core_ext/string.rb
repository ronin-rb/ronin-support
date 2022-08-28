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

require 'ronin/support/binary/core_ext/integer'
require 'ronin/support/binary/format'

class String

  alias unpack_original unpack

  #
  # Unpacks the String.
  #
  # @param [String, Array<Symbol, (Symbol, Integer)>] arguments
  #   The `String#unpack` format string or a list of
  #   {Ronin::Support::Binary::Format} types.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::Format#initialize}.
  #
  # @option kwargs [:little, :big, :net, nil] :endian
  #   The desired endianness of the packed data.
  #
  # @option kwargs [:x86, :x86_64, :ppc, :ppc64,
  #                 :arm, :arm_be, :arm64, :arm64_be,
  #                 :mips, :mips_le, :mips64, :mips64_le, nil] :arch
  #   The desired architecture that the data was packed for.
  #
  # @return [Array]
  #   The values unpacked from the String.
  #
  # @raise [ArgumentError]
  #   One of the arguments was not a known {Ronin::Support::Binary::Format}
  #   type.
  #
  # @example using {Ronin::Support::Binary::Format} types:
  #   "A\0\0\0hello\0".unpack(:uint32_le, :string)
  #   # => [10, "hello"]
  #
  # @example using a `String#unpack` format string:
  #   "A\0\0\0".unpack('V')
  #   # => 65
  #
  # @see https://rubydoc.info/stdlib/core/String:unpack
  # @see Ronin::Support::Binary::Format
  #
  # @since 0.5.0
  #
  # @api public
  #
  def unpack(*arguments,**kwargs)
    if (arguments.length == 1 && arguments.first.kind_of?(String))
      unpack_original(arguments.first)
    else
      format = Ronin::Support::Binary::Format.new(arguments,**kwargs)
      unpack_original(format.pack_string)
    end
  end

  #
  # Enumerates over every bit flip of every byte in the string.
  #
  # @yield [string]
  #   If a block is given, it will be passed each bit-flipped string.
  #
  # @yieldparam [String] string
  #   The String, but with one of it's bits flipped.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator object will be returned.
  #
  # @example bit-flip all bytes in the String:
  #   "foo".each_bit_flip { |string| puts string }
  #
  # @api public
  #
  def each_bit_flip
    return enum_for(__method__) unless block_given?

    bits = (0...8)

    each_byte.each_with_index do |byte,index|
      byte.each_bit_flip(bits) do |flipped_byte|
        new_string = dup
        new_string.setbyte(index,flipped_byte)
        yield new_string
      end
    end
  end

  #
  # Returns every bit flip of every byte in the string.
  #
  # @return [Array<String>]
  #   The bit-flipped strings.
  #
  # @example bit-flip all bytes in the String:
  #   "foo".bit_flips
  #
  # @api public
  #
  def bit_flips
    each_bit_flip.to_a
  end

  alias flip_bits bit_flips

end
