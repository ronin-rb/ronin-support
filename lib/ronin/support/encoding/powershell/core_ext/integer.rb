# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/powershell'

class Integer

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
  # @see Ronin::Support::Encoding::PowerShell.encode_byte
  #
  # @since 1.0.0
  #
  # @api public
  #
  def powershell_encode
    Ronin::Support::Encoding::PowerShell.encode_byte(self)
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
  # @see Ronin::Support::Encoding::PowerShell.escape_byte
  #
  # @since 1.0.0
  #
  # @api public
  #
  def powershell_escape
    Ronin::Support::Encoding::PowerShell.escape_byte(self)
  end

  alias psh_escape powershell_escape

end
