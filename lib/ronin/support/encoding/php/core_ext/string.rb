# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/php'

class String

  #
  # Escapes a String for PHP.
  #
  # @return [String]
  #   The PHP escaped String.
  #
  # @example
  #   "hello\nworld\n".php_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::PHP.escape
  # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
  #
  # @since 1.2.0
  #
  # @api public
  #
  def php_escape
    Ronin::Support::Encoding::PHP.escape(self)
  end

  #
  # Unescapes a PHP escaped String.
  #
  # @return [String]
  #   The unescaped PHP String.
  #
  # @example
  #   "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64".php_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::PHP.unescape
  # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double).
  #
  # @since 1.2.0
  #
  # @api public
  #
  def php_unescape
    Ronin::Support::Encoding::PHP.unescape(self)
  end

  #
  # PHP escapes every character of the String.
  #
  # @return [String]
  #   The PHP escaped String.
  #
  # @example
  #   "hello".php_encode
  #   # => "\\u{0068}\\u{0065}\\u{006C}\\u{006C}\\u{006F}"
  #
  # @see Ronin::Support::Encoding::PHP.encode
  # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
  #
  # @api public
  #
  # @since 1.2.0
  #
  def php_encode
    Ronin::Support::Encoding::PHP.encode(self)
  end

  alias php_decode php_unescape

  #
  # Converts the String into a PHP string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".php_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @see Ronin::Support::Encoding::PHP.quote
  # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
  #
  # @since 1.2.0
  #
  # @api public
  #
  def php_string
    Ronin::Support::Encoding::PHP.quote(self)
  end

  #
  # Removes the quotes an unescapes a PHP string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".php_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::PHP.unquote
  # @see https://www.php.net/manual/en/language.types.string.php#language.types.string.syntax.double
  #
  # @since 1.2.0
  #
  # @api public
  #
  def php_unquote
    Ronin::Support::Encoding::PHP.unquote(self)
  end

end
