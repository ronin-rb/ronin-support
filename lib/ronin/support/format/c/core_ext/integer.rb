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

class Integer

  # Special C bytes and their escaped Strings.
  C_ESCAPE_BYTES = {
    0x00 => '\0',
    0x07 => '\a',
    0x08 => '\b',
    0x09 => '\t',
    0x0a => '\n',
    0x0b => '\v',
    0x0c => '\f',
    0x0d => '\r',
    0x22 => '\"',
    0x1B => '\e',
    0x5c => '\\\\'
  }

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
  #   # => "\x7F"
  #
  # @example Escaping unicode characters:
  #   0xffff.c_escape
  #   # => "\\uFFFF"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_escape
    if self >= 0x00 && self <= 0xff
      C_ESCAPE_BYTES.fetch(self) do
        if self >= 0x20 && self <= 0x7e
          chr
        else
          "\\x%.2x" % self
        end
      end
    elsif self >= 0x100 && self <= 0xffff
      "\\u%.4x" % self
    elsif self >= 0x10000
      "\\u%.8x" % self
    else
      raise(RangeError,"#{self} out of char range")
    end
  end

  alias c_char c_escape

  #
  # Formats the Integer as a C escaped String.
  #
  # @return [String]
  #   The escaped C character.
  #
  # @example
  #   0x41.format_c
  #   # => "\x41"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def format_c
    "\\x%.2x" % self
  end

  alias c_encode format_c

end
