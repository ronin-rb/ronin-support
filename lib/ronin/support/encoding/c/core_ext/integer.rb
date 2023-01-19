# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/c'

class Integer

  #
  # Escapes the Integer as a C character.
  #
  # @return [String]
  #   The escaped C character.
  #
  # @raise [RangeError]
  #   The integer value is negative.
  #
  # @example 
  #   0x41.c_escape
  #   # => "A"
  #   0x22.c_escape
  #   # => "\\\""
  #   0x7f.c_escape
  #   # => "\\x7F"
  #
  # @example Escaping unicode characters:
  #   0xffff.c_escape
  #   # => "\\uFFFF"
  #   0x10000.c_escape
  #   # => "\\U000100000"
  #
  # @see Ronin::Support::Encoding::C.escape_byte
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_escape
    Ronin::Support::Encoding::C.escape_byte(self)
  end

  alias c_char c_escape

  #
  # Formats the Integer as a C escaped String.
  #
  # @return [String]
  #   The escaped C character.
  #
  # @example
  #   0x41.c_encode
  #   # => "\\x41"
  #   0x100.c_encode
  #   # => "\\u1000"
  #   0x10000.c_encode
  #   # => "\\U000100000"
  #
  # @see Ronin::Support::Encoding::C.encode_byte
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_encode
    Ronin::Support::Encoding::C.encode_byte(self)
  end

end
