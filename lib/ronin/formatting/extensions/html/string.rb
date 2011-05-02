#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/formatting/extensions/html/integer'
require 'ronin/formatting/extensions/text/string'

require 'cgi/util'

class String

  #
  # HTML escapes the String.
  #
  # @return [String]
  #   The HTML escaped String.
  #
  # @see http://rubydoc.info/stdlib/cgi/1.9.2/CGI.escapeHTML
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_escape
    CGI.escapeHTML(self)
  end

  #
  # Unescapes the HTML encoded String.
  #
  # @return [String]
  #   The unescaped String.
  #
  # @see http://rubydoc.info/stdlib/cgi/1.9.2/CGI.unescapeHTML
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_unescape
    CGI.unescapeHTML(self)
  end

  #
  # Formats the chars in the String for HTML.
  #
  # @return [String]
  #   The formatted HTML String.
  #
  # @see Integer#format_html
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_html
    format_chars { |c| c.ord.format_html }
  end

  #
  # Escapes a String for JavaScript.
  #
  # @return [String]
  #   The JavaScript escaped String.
  #
  # @example
  #   "hello".js_escape
  #   # => "%u0068%u0065%u006C%u006C%u006F"
  #
  # @see Integer#js_escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_escape
    format_chars { |c| c.ord.js_escape }
  end

  #
  # Unescapes a JavaScript escaped String.
  #
  # @return [String]
  #   The unescaped JavaScript String.
  #
  # @example
  #   "%u0068%u0065%u006C%u006C%u006F world".js_unescape
  #   # => "hello world"
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_unescape
    unescaped = ''

    scan(/(%u[0-9a-fA-F]{4}|%[0-9a-fA-F]{2}|.)/).each do |match|
      c = match[0]

      if (c.length > 1 && c[0,1] == '%')
        if c[1,1] == 'u'
          unescaped << c[2,4].to_i(16)
        else
          unescaped << c[1,2].to_i(16)
        end
      else
        unescaped << c
      end
    end

    return unescaped
  end

  #
  # Escapes a String for JavaScript.
  #
  # @return [String]
  #   The JavaScript escaped String.
  #
  # @example
  #   "hello".js_escape
  #   # => "%u0068%u0065%u006C%u006C%u006F"
  #
  # @see Integer#js_escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_js
    format_chars { |c| c.ord.format_js }
  end

end
