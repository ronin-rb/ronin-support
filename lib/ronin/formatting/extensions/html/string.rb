#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
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

require 'ronin/formatting/extensions/xml/string'
require 'ronin/formatting/extensions/js/string'

class String

  #
  # HTML escapes the String.
  #
  # @return [String]
  #   The HTML escaped String.
  #
  # @example
  #   "one & two".html_escape
  #   # => "one &amp; two"
  #
  # @see https://rubydoc.info/stdlib/cgi/1.9.2/CGI.escapeHTML
  #
  # @since 0.2.0
  #
  # @see #xml_escape
  #
  # @api public
  #
  def html_escape
    xml_escape
  end

  #
  # Unescapes the HTML encoded String.
  #
  # @return [String]
  #   The unescaped String.
  #
  # @example
  #   "&lt;p&gt;one &lt;span&gt;two&lt;/span&gt;&lt;/p&gt;".html_unescape
  #   # => "<p>one <span>two</span></p>"
  #
  # @see https://rubydoc.info/stdlib/cgi/1.9.2/CGI.unescapeHTML
  #
  # @since 0.2.0
  #
  # @see #xml_unescape
  #
  # @api public
  #
  def html_unescape
    xml_unescape
  end

  #
  # Formats the chars in the String for HTML.
  #
  # @param [Hash] options
  #   Additional options for {#format_chars}.
  #
  # @return [String]
  #   The formatted HTML String.
  #
  # @example
  #   "abc".format_html
  #   # => "&#97;&#98;&#99;"
  #
  # @see Integer#format_html
  #
  # @since 0.2.0
  #
  # @see #format_xml
  #
  # @api public
  #
  def format_html(options={})
    format_xml(options)
  end

end
