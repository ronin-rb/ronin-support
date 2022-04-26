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

class Float

  #
  # Packs the Float into a String.
  #
  # @param [String, Symbol] argument
  #   The `Array#pack` format string or {Ronin::Support::Binary::Format} type.
  #
  # @param [:little, :big, :net, nil] endian
  #   The desired endianness of the packed float.
  #
  # @param [:x86, :x86_64, :ppc, :ppc64,
  #         :arm, :arm_be, :arm64, :arm64_be,
  #         :mips, :mips_le, :mips64, :mips64_le, nil] arch
  #   The desired architecture to pack the float for.
  #
  # @return [String]
  #   The packed float.
  #
  # @raise [ArgumentError]
  #   The given argument was not a `String`, `Symbol`, or valid type name.
  #
  # @example using `Array#pack` format string:
  #   0.42.pack('F')
  #   # => =\n\xD7>"
  #
  # @example using {Ronin::Support::Binary::Format} types:
  #   0x42.pack(:float_be)
  #   # => ">\xD7\n="
  #
  # @see https://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Support::Binary::Format
  #
  # @since 0.5.0
  #
  # @api public
  #
  def pack(argument, endian: nil, arch: nil)
    case argument
    when String
      [self].pack(argument)
    else
      types = if arch then Ronin::Support::Binary::Types.arch(arch)
              else         Ronin::Support::Binary::Types.endian(endian)
              end
      type = types[argument]
      type.pack(self)
    end
  end

end
