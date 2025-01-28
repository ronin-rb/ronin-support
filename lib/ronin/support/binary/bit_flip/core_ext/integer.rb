# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/bit_flip'

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
  def each_bit_flip(bits,&block)
    Ronin::Support::Binary::BitFlip::Integer.each_bit_flip(self,bits,&block)
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
    Ronin::Support::Binary::BitFlip::Integer.bit_flips(self,bits)
  end

  alias flip_bits bit_flips

end
