# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/binary/template'
require 'ronin/support/binary/ctypes'

class String

  alias unpack_original unpack

  #
  # Unpacks the String.
  #
  # @param [String, Array<Symbol, (Symbol, Integer)>] arguments
  #   The `String#unpack` format string or a list of
  #   {Ronin::Support::Binary::Template} types.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::Template#initialize}.
  #
  # @option kwargs [:little, :big, :net, nil] :endian
  #   The desired endianness of the packed data.
  #
  # @option kwargs [:x86, :x86_64, :ppc, :ppc64,
  #                 :arm, :arm_be, :arm64, :arm64_be,
  #                 :mips, :mips_le, :mips64, :mips64_le, nil] :arch
  #   The desired architecture that the data was packed for.
  #
  # @option kwargs [:linux, :macos, :windows,
  #                 :android, :apple_ios, :bsd,
  #                 :freebsd, :openbsd, :netbsd] :os
  #   The Operating System (OS) to use.
  #
  # @return [Array]
  #   The values unpacked from the String.
  #
  # @raise [ArgumentError]
  #   One of the arguments was not a known {Ronin::Support::Binary::Template}
  #   type.
  #
  # @example using {Ronin::Support::Binary::Template} types:
  #   "A\0\0\0hello\0".unpack(:uint32_le, :string)
  #   # => [10, "hello"]
  #
  # @example using a `String#unpack` format string:
  #   "A\0\0\0".unpack('V')
  #   # => 65
  #
  # @see https://rubydoc.info/stdlib/core/String:unpack
  # @see Ronin::Support::Binary::Template
  #
  # @since 0.5.0
  #
  # @api public
  #
  def unpack(*arguments,**kwargs)
    if (arguments.length == 1 && arguments.first.kind_of?(String))
      unpack_original(arguments.first)
    else
      template = Ronin::Support::Binary::Template.new(arguments,**kwargs)
      template.unpack(self)
    end
  end

  alias unpack1_original unpack1

  #
  # Unpacks a single value from the String.
  #
  # @param [String, Symbol] argument
  #   The `String#unpack` format String (ex: `L<`) or a
  #   {Ronin::Support::Binary::CTypes} type name (ex: `:uint32_le`).
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for
  #   {Ronin::Support::Binary::Template#initialize}.
  #
  # @option kwargs [:little, :big, :net, nil] :endian
  #   The desired endianness of the packed data.
  #
  # @option kwargs [:x86, :x86_64, :ppc, :ppc64,
  #                 :arm, :arm_be, :arm64, :arm64_be,
  #                 :mips, :mips_le, :mips64, :mips64_le, nil] :arch
  #   The desired architecture that the data was packed for.
  #
  # @return [Integer, Float, String]
  #   The unpacked value.
  #
  # @raise [ArgumentError]
  #   The given argument was not a String or a Symbol, or the given C type is
  #   unknown.
  #
  # @since 1.0.0
  #
  # @api public
  #
  def unpack1(argument,**kwargs)
    case argument
    when String
      unpack1_original(argument)
    when Symbol
      platform = Ronin::Support::Binary::CTypes.platform(**kwargs)
      type     = platform[argument]

      unpack1_original(type.pack_string)
    else
      raise(ArgumentError,"argument must be either a String or a Symbol: #{argument.inspect}")
    end
  end

end
