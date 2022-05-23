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

require 'ronin/support/binary/ctypes'

class Integer

  #
  # Packs the Integer into a String.
  #
  # @param [String, Symbol] argument
  #   The `Array#pack` String or {Ronin::Support::Binary::Format} type.
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
  #   The packed Integer.
  #
  # @raise [ArgumentError]
  #   The given argument was not a `String`, `Symbol`, or valid type name.
  #
  # @example using a `Array#pack` format string:
  #   0x41.pack('V')
  #   # => "A\0\0\0"
  #
  # @example using {Ronin::Support::Binary::Format} types:
  #   0x41.pack(:uint32_le)
  #
  # @see http://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Support::Binary::Format
  #
  # @api public
  #
  def pack(argument, **kwargs)
    case argument
    when String
      [self].pack(argument)
    when Symbol
      types = Ronin::Support::Binary::CTypes.platform(**kwargs)
      type  = types[argument]
      type.pack(self)
    else
      raise(ArgumentError,"invalid pack argument: #{argument}")
    end
  end

  #
  # Hex-encodes the Integer.
  #
  # @return [String]
  #   The hex encoded version of the Integer.
  #
  # @example
  #   0x41.hex_encode
  #   # => "41"
  #
  # @since 0.6.0
  #
  def hex_encode
    "%.2x" % self
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
