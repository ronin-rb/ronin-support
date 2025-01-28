# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/hex'

class String

  #
  # Hex-encodes characters in the String.
  #
  # @return [String]
  #   The hex encoded version of the String.
  #
  # @example
  #   "hello".hex_encode
  #   # => "68656C6C6F"
  #
  # @see Ronin::Support::Encoding::Hex.encodde
  #
  # @since 0.6.0
  #
  def hex_encode
    Ronin::Support::Encoding::Hex.encode(self)
  end

  #
  # Hex-decodes the String.
  #
  # @return [String]
  #   The hex decoded version of the String.
  #
  # @example
  #   "68656C6C6F".hex_decode
  #   # => "hello"
  #
  # @see Ronin::Support::Encoding::Hex.decodde
  #
  def hex_decode
    Ronin::Support::Encoding::Hex.decode(self)
  end

  #
  # Hex-escapes the characters within the String.
  #
  # @return [String]
  #   The hex escaped version of the String.
  #
  # @example
  #   "hello\nworld".hex_escape
  #   # => "hello\\nworld"
  #
  # @see Ronin::Support::Encoding::Hex.escape
  #
  # @api public
  #
  def hex_escape
    Ronin::Support::Encoding::Hex.escape(self)
  end

  #
  # Unescapes the characters within the String.
  #
  # @return [String]
  #   The hex unescaped version of the String.
  #
  # @example
  #   "hello\\nworld".hex_unescape
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::Hex.unescape
  #
  # @api public
  #
  def hex_unescape
    Ronin::Support::Encoding::Hex.unescape(self)
  end

  #
  # Converts the String into a double-quoted hex string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld".hex_string
  #   # => "\"hello\\nworld\""
  #
  # @see Ronin::Support::Encoding::Hex.quote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def hex_string
    Ronin::Support::Encoding::Hex.quote(self)
  end

  #
  # Removes the quotes and unescapes a hex string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".hex_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::Hex.unquote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def hex_unquote
    Ronin::Support::Encoding::Hex.unquote(self)
  end

end
