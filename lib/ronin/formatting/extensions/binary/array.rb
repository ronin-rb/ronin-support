#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/binary/template'

class Array

  alias pack_original pack

  #
  # Packs the Array into a String.
  #
  # @param [String, Array<Symbol, (Symbol, Integer)>] arguments
  #   The `Array#pack` template or a list of {Ronin::Binary::Template} types.
  #
  # @return [String]
  #   The packed Array.
  #
  # @raise [ArgumentError]
  #   One of the arguments was not a known {Ronin::Binary::Template} type.
  #
  # @example using {Ronin::Binary::Template} types:
  #   [0x1234, "hello"].pack(:uint16_le, :string)
  #   # => "\x34\x12hello\0"
  #
  # @example using a `String#unpack` template:
  #   [0x1234, "hello"].pack('vZ*')
  #   # => "\x34\x12hello\0"
  #
  # @see http://rubydoc.info/stdlib/core/Array:pack
  # @see Ronin::Binary::Template
  #
  # @since 0.5.0
  #
  # @api public
  #
  def pack(*arguments)
    if (arguments.length == 1 && arguments.first.kind_of?(String))
      pack_original(arguments.first)
    else
      pack_original(Ronin::Binary::Template.compile(arguments))
    end
  end

end
