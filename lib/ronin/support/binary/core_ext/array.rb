# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/template'

class Array

  alias pack_original pack

  #
  # Packs the Array into a String.
  #
  # @param [String, Array<Symbol, (Symbol, Integer)>] arguments
  #   The `Array#pack` format string or a list of
  #   {Ronin::Support::Binary::Template} types.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::Template#initialize}.
  #
  # @option kwargs [:little, :big, :net, nil] :endian
  #   The desired endianness to pack the data for.
  #
  # @option kwargs [:x86, :x86_64, :ppc, :ppc64,
  #                 :arm, :arm_be, :arm64, :arm64_be,
  #                 :mips, :mips_le, :mips64, :mips64_le, nil] :arch
  #   The desired architecture to pack the data for.
  #
  # @option kwargs [:linux, :macos, :windows,
  #                 :android, :apple_ios, :bsd,
  #                 :freebsd, :openbsd, :netbsd] :os
  #   The Operating System (OS) to use.
  #
  # @return [String]
  #   The packed Array.
  #
  # @raise [ArgumentError]
  #   One of the arguments was not a known {Ronin::Support::Binary::Template}
  #   type.
  #
  # @example using {Ronin::Support::Binary::Template} types:
  #   [0x1234, "hello"].pack(:uint16_le, :string)
  #   # => "\x34\x12hello\0"
  #
  # @example using a `String#unpack` format string:
  #   [0x1234, "hello"].pack('vZ*')
  #   # => "\x34\x12hello\0"
  #
  # @see https://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Support::Binary::Template
  #
  # @since 0.5.0
  #
  # @api public
  #
  def pack(*arguments,**kwargs)
    if (arguments.length == 1 && arguments.first.kind_of?(String))
      pack_original(arguments.first)
    else
      template = Ronin::Support::Binary::Template.new(arguments,**kwargs)
      template.pack(*self)
    end
  end

end
