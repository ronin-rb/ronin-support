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

require 'ronin/support/encoding/shell'

class Integer

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
  # @see Ronin::Support::Encoding::Shell.encode_byte
  #
  # @since 1.0.0
  #
  # @api public
  #
  def shell_encode
    Ronin::Support::Encoding::Shell.encode_byte(self)
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
  # @see Ronin::Support::Encoding::Shell.escape_byte
  #
  # @since 1.0.0
  #
  # @api public
  #
  def shell_escape
    Ronin::Support::Encoding::Shell.escape_byte(self)
  end

  alias sh_escape shell_escape
  alias bash_escape shell_escape

end
