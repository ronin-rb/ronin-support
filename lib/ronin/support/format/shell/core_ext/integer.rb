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

class Integer

  # Special shell bytes and their escaped Strings.
  SHELL_ESCAPE_BYTES = {
    0x00 => "\\0",  # $'\0'
    0x07 => "\\a",  # $'\a'
    0x08 => "\\b",  # $'\b'
    0x09 => "\\t",  # $'\t'
    0x0a => "\\n",  # $'\n'
    0x0b => "\\v",  # $'\v'
    0x0c => "\\f",  # $'\f'
    0x0d => "\\r",  # $'\r'
    0x1B => "\\e",  # $'\e'
    0x22 => "\\\"", # \"
    0x23 => "\\#",  # \#
    0x5c => "\\\\"  # \\
  }

  #
  # Encodes the Integer as a shell character.
  #
  # @return [String]
  #   The encoded shell character.
  #
  # @raise [RangeError]
  #   The integer value is negative.
  #
  # @example 
  #   0x41.shell_encode
  #   # => "\\x41"
  #   0x0a.shell_encode
  #   # => "\\n"
  #
  # @example Encoding unicode characters:
  #   1001.shell_encode
  #   # => "\\u1001"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def shell_encode
    if self >= 0x00 && self <= 0xff
      "\\x%.2x" % self
    elsif self > 0xff
      "\\u%x" % self
    else
      raise(RangeError,"#{self} out of char range")
    end
  end

  alias sh_encode shell_encode
  alias bash_encode shell_encode

  #
  # Escapes the Integer as a shell character.
  #
  # @return [String]
  #   The escaped shell character.
  #
  # @raise [RangeError]
  #   The integer value is negative.
  #
  # @example 
  #   0x41.shell_escape
  #   # => "A"
  #   0x08.shell_escape
  #   # => "\b"
  #   0xff.shell_escape
  #   # => "\xff"
  #
  # @example Escaping unicode characters:
  #   1001.shell_escape
  #   # => "\\u1001"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def shell_escape
    if self >= 0x00 && self <= 0xff
      SHELL_ESCAPE_BYTES.fetch(self) do
        if self >= 0x20 && self <= 0x7e
          chr
        else
          shell_encode
        end
      end
    else
      shell_encode
    end
  end

  alias sh_escape shell_escape
  alias bash_escape shell_escape

end
