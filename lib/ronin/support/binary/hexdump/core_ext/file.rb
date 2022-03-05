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

class File

  #
  # Converts a hexdump file to it's original binary data.
  #
  # @param [Pathname, String] path
  #   The path of the hexdump file.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::Hexdump::Parser#initialize}.
  #
  # @option kwargs [:od, :hexdump] :format (:hexdump)
  #   The expected format of the hexdump. Must be either `:od` or
  #   `:hexdump`.
  #
  # @option kwargs [Symbol] :type (:byte)
  #   Denotes the encoding used for the bytes within the hexdump.
  #   Must be one of the following:
  #   * `:byte`
  #   * `:char`
  #   * `:uint8`
  #   * `:uint16`
  #   * `:uint32`
  #   * `:uint64`
  #   * `:int8`
  #   * `:int16`
  #   * `:int32`
  #   * `:int64`
  #   * `:uchar`
  #   * `:ushort`
  #   * `:uint`
  #   * `:ulong`
  #   * `:ulong_long`
  #   * `:short`
  #   * `:int`
  #   * `:long`
  #   * `:long_long`
  #   * `:float`
  #   * `:double`
  #   * `:float_le`
  #   * `:double_le`
  #   * `:float_be`
  #   * `:double_be`
  #   * `:uint16_le`
  #   * `:uint32_le`
  #   * `:uint64_le`
  #   * `:int16_le`
  #   * `:int32_le`
  #   * `:int64_le`
  #   * `:uint16_be`
  #   * `:uint32_be`
  #   * `:uint64_be`
  #   * `:int16_be`
  #   * `:int32_be`
  #   * `:int64_be`
  #   * `:ushort_le`
  #   * `:uint_le`
  #   * `:ulong_le`
  #   * `:ulong_long_le`
  #   * `:short_le`
  #   * `:int_le`
  #   * `:long_le`
  #   * `:long_long_le`
  #   * `:ushort_be`
  #   * `:uint_be`
  #   * `:ulong_be`
  #   * `:ulong_long_be`
  #   * `:short_be`
  #   * `:int_be`
  #   * `:long_be`
  #   * `:long_long_be`
  #
  # @option kwargs [2, 8, 10, 16, nil] :address_base
  #   The numerical base that the offset addresses are encoded in.
  #
  # @option kwargs [2, 8, 10, 16, nil] base
  #   The numerical base that the hexdumped numbers are encoded in.
  #
  # @option kwargs [Boolean] named_chars
  #   Indicates to parse `od`-style named characters (ex: `nul`,
  #   `del`, etc).
  #
  # @return [String]
  #   The raw-data from the hexdump.
  #
  # @raise [ArgumentError]
  #   Unsupported `type:` value, or the `format:` was not `:hexdump` or
  #   `:od`.
  #
  # @api public
  #
  def self.unhexdump(path,**kwargs)
    parser = Ronin::Support::Binary::Hexdump::Parser.new(**kwargs)
    parser.unhexdump(new(path))
  end

end
