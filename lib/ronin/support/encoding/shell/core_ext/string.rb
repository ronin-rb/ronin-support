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

require 'ronin/support/encoding/shell'

require 'strscan'

class String

  #
  # Shell escapes the characters in the String.
  #
  # @return [String]
  #   The shell escaped string.
  #
  # @example
  #   "hello\nworld".shell_escape
  #   # => "hello\\nworld"
  #
  # @see Ronin::Support::Encoding::Shell.escape
  #
  # @api public
  #
  # @since 1.0.0
  #
  def shell_escape
    Ronin::Support::Encoding::Shell.escape(self)
  end

  #
  # Shell unescapes the characters in the String.
  #
  # @return [String]
  #   The shell unescaped string.
  #
  # @example
  #   "hello\\nworld".shell_unescape
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::Shell.unescape
  #
  # @api public
  #
  # @since 1.0.0
  #
  def shell_unescape
    Ronin::Support::Encoding::Shell.unescape(self)
  end

  #
  # Shell encodes every character in the String.
  #
  # @return [String]
  #   The shell encoded String.
  #
  # @example
  #   "hello world".shell_encode
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f\\x0a\\x77\\x6f\\x72\\x6c\\x64"
  #
  # @see Ronin::Support::Encoding::Shell.encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def shell_encode
    Ronin::Support::Encoding::Shell.encode(self)
  end

  alias shell_decode shell_unescape

  #
  # Converts the String into a double-quoted shell escaped String.
  #
  # @return [String]
  #   The quoted and escaped shell string.
  #
  # @example
  #   "hello world".shell_string
  #   # => "\"hello world\""
  #   "hello\nworld".shell_string
  #   # => "$'hello\\nworld'"
  #
  # @see Ronin::Support::Encoding::Shell.quote
  #
  # @api public
  #
  # @since 1.0.0
  #
  def shell_string
    Ronin::Support::Encoding::Shell.quote(self)
  end

  #
  # Removes the quotes an unescapes a shell string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello \\\"world\\\"\"".shell_unquote
  #   # => "hello \"world\""
  #   "'hello\\'world'".shell_unquote
  #   # => "hello'world"
  #   "$'hello\\nworld'".shell_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::Shell.unquote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def shell_unquote
    Ronin::Support::Encoding::Shell.unquote(self)
  end

end
