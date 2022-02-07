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

require 'ronin/support/binary/template'

class Float

  #
  # Packs the Float into a String.
  #
  # @param [String, Symbol] argument
  #   The `Array#pack` String code or {Ronin::Support::Binary::Template} type.
  #
  # @return [String]
  #   The packed float.
  #
  # @raise [ArgumentError]
  #   The given Symbol could not be found in
  #   {Ronin::Support::Binary::Template::FLOAT_TYPES}.
  #
  # @example using `Array#pack` template:
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
  def pack(argument)
    case argument
    when String
      [self].pack(argument)
    else
      unless Ronin::Support::Binary::Template::FLOAT_TYPES.include?(argument)
        raise(ArgumentError,"unsupported integer type: #{argument}")
      end

      [self].pack(Ronin::Support::Binary::Template::TYPES[argument])
    end
  end

end
