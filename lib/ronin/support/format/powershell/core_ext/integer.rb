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

  # Special PowerShell bytes and their escaped Strings.
  POWERSHELL_ESCAPE_BYTES = {
    0x00 => "`0",
    0x07 => "`a",
    0x08 => "`b",
    0x09 => "`t",
    0x0a => "`n",
    0x0b => "`v",
    0x0c => "`f",
    0x0d => "`r",
    0x22 => '`"',
    0x23 => "`#",
    0x27 => "`'",
    0x5c => "\\\\", # \\
    0x60 => "``"
  }

  #
  # Encodes the Integer as a PowerShell character.
  #
  # @return [String]
  #   The encoded PowerShell character.
  #
  # @raise [RangeError]
  #   The integer value is negative.
  #
  # @example 
  #   0x41.powershell_encode
  #   # => "[char]0x41"
  #   0x0a.powershell_encode
  #   # => "`n"
  #
  # @example Encoding unicode characters:
  #   1001.powershell_escape
  #   # => "`u{1001}"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def powershell_encode
    if self >= 0x00 && self <= 0xff
      "$([char]0x%.2x)" % self
    elsif self > 0xff
      "$([char]0x%x)" % self
    else
      raise(RangeError,"#{self} out of char range")
    end
  end

  alias psh_encode powershell_encode

  #
  # Escapes the Integer as a PowerShell character.
  #
  # @return [String]
  #   The escaped PowerShell character.
  #
  # @raise [RangeError]
  #   The integer value is negative.
  #
  # @example 
  #   0x41.powershell_escape
  #   # => "A"
  #   0x08.powershell_escape
  #   # => "`b"
  #   0xff.powershell_escape
  #   # => "[char]0xff"
  #
  # @example Escaping unicode characters:
  #   1001.powershell_escape
  #   # => "`u{1001}"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def powershell_escape
    if self >= 0x00 && self <= 0xff
      POWERSHELL_ESCAPE_BYTES.fetch(self) do
        if self >= 0x20 && self <= 0x7e
          chr
        else
          powershell_encode
        end
      end
    else
      powershell_encode
    end
  end

  alias psh_escape powershell_escape

end
