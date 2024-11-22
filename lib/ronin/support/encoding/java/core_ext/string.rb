# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/java'

class String

  #
  # Escapes a String for Java.
  #
  # @return [String]
  #   The Java escaped String.
  #
  # @example
  #   "hello\nworld\n".java_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::Java.escape
  #
  # @since 1.2.0
  #
  # @api public
  #
  def java_escape
    Ronin::Support::Encoding::Java.escape(self)
  end

  #
  # Unescapes a Java escaped String.
  #
  # @return [String]
  #   The unescaped Java String.
  #
  # @example
  #   "\\u0068\\u0065\\u006C\\u006C\\u006F world".java_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::Java.unescape
  #
  # @since 1.2.0
  #
  # @api public
  #
  def java_unescape
    Ronin::Support::Encoding::Java.unescape(self)
  end

  #
  # Java escapes every character of the String.
  #
  # @return [String]
  #   The Java escaped String.
  #
  # @example
  #   "hello".java_encode
  #   # => "\\u0068\\u0065\\u006C\\u006C\\u006F"
  #
  # @see Ronin::Support::Encoding::Java.encode
  #
  # @api public
  #
  # @since 1.2.0
  #
  def java_encode
    Ronin::Support::Encoding::Java.encode(self)
  end

  alias java_decode java_unescape

  #
  # Converts the String into a Java String.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".java_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @see Ronin::Support::Encoding::Java.quote
  #
  # @since 1.2.0
  #
  # @api public
  #
  def java_string
    Ronin::Support::Encoding::Java.quote(self)
  end

  #
  # Removes the quotes an unescapes a Java String.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".java_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::Java.unquote
  #
  # @since 1.2.0
  #
  # @api public
  #
  def java_unquote
    Ronin::Support::Encoding::Java.unquote(self)
  end

end
