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

require 'ronin/support/encoding/node_js'

class String

  #
  # Escapes a String for Node.js.
  #
  # @return [String]
  #   The Node.js escaped String.
  #
  # @example
  #   "hello\nworld\n".node_js_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::NodeJS.escape
  #
  # @since 1.2.0
  #
  # @api public
  #
  def node_js_escape
    Ronin::Support::Encoding::NodeJS.escape(self)
  end

  #
  # Unescapes a Node.js escaped String.
  #
  # @return [String]
  #   The unescaped Node.js String.
  #
  # @example
  #   "\\u0068\\u0065\\u006C\\u006C\\u006F world".node_js_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::NodeJS.unescape
  #
  # @since 1.2.0
  #
  # @api public
  #
  def node_js_unescape
    Ronin::Support::Encoding::NodeJS.unescape(self)
  end

  #
  # Node.js escapes every character of the String.
  #
  # @return [String]
  #   The Node.js escaped String.
  #
  # @example
  #   "hello".node_js_encode
  #   # => "\\u0068\\u0065\\u006C\\u006C\\u006F"
  #
  # @see Ronin::Support::Encoding::NodeJS.encode
  #
  # @api public
  #
  # @since 1.2.0
  #
  def node_js_encode
    Ronin::Support::Encoding::NodeJS.encode(self)
  end

  alias node_js_decode node_js_unescape

  #
  # Converts the String into a Node.js string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".node_js_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @see Ronin::Support::Encoding::NodeJS.quote
  #
  # @since 1.2.0
  #
  # @api public
  #
  def node_js_string
    Ronin::Support::Encoding::NodeJS.quote(self)
  end

  #
  # Removes the quotes an unescapes a Node.js string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".node_js_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::NodeJS.unquote
  #
  # @since 1.2.0
  #
  # @api public
  #
  def node_js_unquote
    Ronin::Support::Encoding::NodeJS.unquote(self)
  end

end
