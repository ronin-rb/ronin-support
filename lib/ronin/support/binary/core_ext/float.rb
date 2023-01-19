# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes'

class Float

  #
  # Packs the Float into a String.
  #
  # @param [String, Symbol] argument
  #   The `Array#pack` format string or {Ronin::Support::Binary::Template} type.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::CTypes.platform}.
  #
  # @option kwargs [:little, :big, :net, nil] :endian
  #   The desired endianness of the binary format.
  #
  # @option kwargs [:x86, :x86_64,
  #                 :ppc, :ppc64,
  #                 :mips, :mips_le, :mips_be,
  #                 :mips64, :mips64_le, :mips64_be,
  #                 :arm, :arm_le, :arm_be,
  #                 :arm64, :arm64_le, :arm64_be] :arch
  #   The desired architecture of the binary format.
  #
  # @option kwargs [:linux, :macos, :windows,
  #                 :bsd, :freebsd, :openbsd, :netbsd] :os
  #   The Operating System name to lookup.
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
  # @example using {Ronin::Support::Binary::Template} types:
  #   0x42.pack(:float_be)
  #   # => ">\xD7\n="
  #
  # @see https://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Support::Binary::Template
  #
  # @since 0.5.0
  #
  # @api public
  #
  def pack(argument, **kwargs)
    case argument
    when String
      [self].pack(argument)
    else
      types = Ronin::Support::Binary::CTypes.platform(**kwargs)
      type  = types[argument]
      type.pack(self)
    end
  end

end
