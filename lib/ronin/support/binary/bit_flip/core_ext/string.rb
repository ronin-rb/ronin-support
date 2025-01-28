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

class String

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
  def each_bit_flip(&block)
    Ronin::Support::Binary::BitFlip::String.each_bit_flip(self,&block)
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
    Ronin::Support::Binary::BitFlip::String.bit_flips(self)
  end

  alias flip_bits bit_flips

end
