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

  #
  # Converts the integer into hex format.
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

  alias to_hex hex_encode

  #
  # Converts the integer into an escaped hex character.
  #
  # @return [String]
  #   The hex escaped version of the Integer.
  #
  # @raise [RangeError]
  #   The integer value is negative.
  #
  # @example
  #   42.hex_char
  #   # => "\\x2a"
  #
  # @api public
  #
  def hex_escape
    if self >= 0x00 && self <= 0xff
      if    self == 0x22
        "\\\""
      elsif self == 0x5d
        "\\\\"
      elsif self >= 0x20 && self <= 0x7e
        chr
      else
        "\\x%.2x" % self
      end
    elsif self > 0xff
      "\\x%x" % self
    else
      raise(RangeError,"#{self} out of char range")
    end
  end

  alias hex_char hex_escape

  #
  # Encodes the number as a `0xXX` hex integer.
  #
  # @return [String]
  #   The hex encoded integer.
  #
  # @example
  #   42.hex_int
  #   # => "0x2e"
  #
  def hex_int
    "0x%.2x" % self
  end

end
