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

require 'ronin/support/encoding/python'

class String

  #
  # Escapes a String for Python.
  #
  # @return [String]
  #   The Python escaped String.
  #
  # @example
  #   "hello\nworld\n".python_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::Python.escape
  # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
  #
  # @since 1.2.0
  #
  # @api public
  #
  def python_escape
    Ronin::Support::Encoding::Python.escape(self)
  end

  #
  # Unescapes a Python escaped String.
  #
  # @return [String]
  #   The unescaped Python String.
  #
  # @example
  #   "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64".python_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::Python.unescape
  # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
  #
  # @since 1.2.0
  #
  # @api public
  #
  def python_unescape
    Ronin::Support::Encoding::Python.unescape(self)
  end

  #
  # Python escapes every character of the String.
  #
  # @return [String]
  #   The Python escaped String.
  #
  # @example
  #   "hello".python_encode
  #   # => "\\u0068\\u0065\\u006c\\u006c\\u006f"
  #
  # @see Ronin::Support::Encoding::Python.encode
  # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
  #
  # @api public
  #
  # @since 1.2.0
  #
  def python_encode
    Ronin::Support::Encoding::Python.encode(self)
  end

  alias python_decode python_unescape

  #
  # Converts the String into a Python string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".python_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @see Ronin::Support::Encoding::Python.quote
  # @see https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals
  #
  # @since 1.2.0
  #
  # @api public
  #
  def python_string
    Ronin::Support::Encoding::Python.quote(self)
  end

  #
  # Removes the quotes an unescapes a Python string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".python_unquote
  #   # => "hello\nworld"
  #   "\"hello\\nworld\"".python_unquote
  #   # => "hello\nworld"
  #   "'hello\\nworld'".python_unquote
  #   # => "hello\nworld"
  #   "'''hello\\nworld'''".python_unquote
  #   # => "hello\nworld"
  #   "u'hello\\nworld'".python_unquote
  #   # => "hello\nworld"
  #   "r'hello\\nworld'".python_unquote
  #   # => "hello\\nworld"
  #
  # @see Ronin::Support::Encoding::Python.unquote
  # @see https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals
  #
  # @since 1.2.0
  #
  # @api public
  #
  def python_unquote
    Ronin::Support::Encoding::Python.unquote(self)
  end

end
