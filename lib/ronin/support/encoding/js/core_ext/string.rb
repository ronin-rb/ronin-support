# frozen_string_literal: true
#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/js'

class String

  #
  # Escapes a String for JavaScript.
  #
  # @return [String]
  #   The JavaScript escaped String.
  #
  # @example
  #   "hello\nworld\n".js_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::JS.escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_escape
    Ronin::Support::Encoding::JS.escape(self)
  end

  #
  # Unescapes a JavaScript escaped String.
  #
  # @return [String]
  #   The unescaped JavaScript String.
  #
  # @example
  #   "\\u0068\\u0065\\u006C\\u006C\\u006F world".js_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::JS.unescape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_unescape
    Ronin::Support::Encoding::JS.unescape(self)
  end

  #
  # JavaScript escapes every character of the String.
  #
  # @return [String]
  #   The JavaScript escaped String.
  #
  # @example
  #   "hello".js_encode
  #   # => "\\u0068\\u0065\\u006C\\u006C\\u006F"
  #
  # @see Ronin::Support::Encoding::JS.encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def js_encode
    Ronin::Support::Encoding::JS.encode(self)
  end

  alias js_decode js_unescape

  #
  # Converts the String into a JavaScript string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".js_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @see Ronin::Support::Encoding::JS.quote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def js_string
    Ronin::Support::Encoding::JS.quote(self)
  end

  #
  # Removes the quotes an unescapes a JavaScript string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".js_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::JS.unquote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def js_unquote
    Ronin::Support::Encoding::JS.unquote(self)
  end

end
