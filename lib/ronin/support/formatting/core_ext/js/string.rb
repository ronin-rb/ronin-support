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

require 'ronin/support/formatting/core_ext/js/integer'
require 'ronin/support/formatting/core_ext/text/string'

class String

  # JavaScript characters that must be back-slashed.
  JS_BACKSLASHED_CHARS = {
    "\\b"  => "\b",
    "\\t"  => "\t",
    "\\n"  => "\n",
    "\\f"  => "\f",
    "\\r"  => "\r",
    "\\\"" => "\"",
    "\\\\" => "\\"
  }

  #
  # Escapes a String for JavaScript.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_chars}.
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
    format_chars(**kwargs) { |c| c.ord.js_escape }
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
    unescaped = ''

    scan(/[\\%]u[0-9a-fA-F]{1,4}|[\\%][0-9a-fA-F]{1,2}|\\[btnfr"\\]|./) do |c|
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
  # Escapes a String for JavaScript.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_chars}.
  #
  # @return [String]
  #   The JavaScript escaped String.
  #
  # @example
  #   "hello".js_escape
  #   # => "\\u0068\\u0065\\u006C\\u006C\\u006F"
  #
  # @see Integer#js_escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_js(**kwargs)
    format_chars(**kwargs) { |c| c.ord.format_js }
  end

end
