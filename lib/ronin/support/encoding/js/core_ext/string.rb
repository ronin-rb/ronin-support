#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
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

require 'ronin/support/encoding/js/core_ext/integer'
require 'ronin/support/encoding/text/core_ext/string'

class String

  # JavaScript characters that must be back-slashed.
  JS_BACKSLASHED_CHARS = {
    "\\b"  => "\b",
    "\\t"  => "\t",
    "\\n"  => "\n",
    "\\f"  => "\f",
    "\\r"  => "\r",
    "\\\"" => "\"",
    "\\\'" => "'",
    "\\\\" => "\\"
  }

  #
  # Escapes a String for JavaScript.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#encode_chars}.
  #
  # @return [String]
  #   The JavaScript escaped String.
  #
  # @example
  #   "hello\nworld\n".js_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Integer#js_escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_escape(**kwargs)
    encode_chars(**kwargs) { |c| c.ord.js_escape }
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
  # @since 0.2.0
  #
  # @api public
  #
  def js_unescape
    unescaped = String.new

    scan(/[\\%]u[0-9a-fA-F]{1,4}|[\\%][0-9a-fA-F]{1,2}|\\[btnfr\'\"\\]|./) do |c|
      unescaped << JS_BACKSLASHED_CHARS.fetch(c) do
        if (c.start_with?("\\u") || c.start_with?("%u"))
          c[2..-1].to_i(16)
        elsif (c.start_with?("\\") || c.start_with?("%"))
          c[1..-1].to_i(16)
        else
          c
        end
      end
    end

    return unescaped
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
  # @see #js_encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def js_encode(**kwargs)
    encode_chars(**kwargs) { |c| c.ord.js_encode }
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
  # @since 1.0.0
  #
  # @api public
  #
  def js_string
    "\"#{js_escape}\""
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
  # @since 1.0.0
  #
  # @api public
  #
  def js_unquote
    if ((self[0] == '"' && self[-1] == '"') ||
        (self[0] == "'" && self[-1] == "'"))
      self[1..-2].js_unescape
    else
      self
    end
  end

end
