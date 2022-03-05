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

require 'ronin/support/binary/hexdump/parser'

class String

  #
  # Converts a multitude of hexdump formats back into raw-data.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::Hexdump::Parser#initialize}.
  #
  # @option kwargs [Symbol] :format
  #   The expected format of the hexdump. Must be either `:od` or
  #   `:hexdump`.
  #
  # @option kwargs [Symbol] :encoding
  #   Denotes the encoding used for the bytes within the hexdump.
  #   Must be one of the following:
  #
  #   * `:binary`
  #   * `:octal`
  #   * `:octal_bytes`
  #   * `:octal_shorts`
  #   * `:octal_ints`
  #   * `:octal_quads` (Ruby 1.9 only)
  #   * `:decimal`
  #   * `:decimal_bytes`
  #   * `:decimal_shorts`
  #   * `:decimal_ints`
  #   * `:decimal_quads` (Ruby 1.9 only)
  #   * `:hex`
  #   * `:hex_chars`
  #   * `:hex_bytes`
  #   * `:hex_shorts`
  #   * `:hex_ints`
  #   * `:hex_quads`
  #   * `:named_chars` (Ruby 1.9 only)
  #   * `:floats`
  #   * `:doubles`
  #
  # @option kwargs [:little, :big, :network] :endian (:little)
  #   The endianness of the words.
  #
  # @option kwargs [Integer] :segment (16)
  #   The length in bytes of each segment in the hexdump.
  #
  # @return [String]
  #   The raw-data from the hexdump.
  #
  # @api public
  #
  def unhexdump(**kwargs)
    parser = Ronin::Support::Binary::Hexdump::Parser.new(**kwargs)
    parser.unhexdump(self)
  end

end
