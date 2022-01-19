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

require 'ronin/support/formatting/core_ext/xml/integer'
require 'ronin/support/formatting/core_ext/text/string'

require 'cgi'

class String

  #
  # XML escapes the String.
  #
  # @return [String]
  #   The XML escaped String.
  #
  # @example
  #   "one & two".xml_escape
  #   # => "one &amp; two"
  #
  # @see http://rubydoc.info/stdlib/cgi/1.9.2/CGI.escapeHTML
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_escape
    CGI.escapeHTML(self)
  end

  #
  # Unescapes the XML encoded String.
  #
  # @return [String]
  #   The unescaped String.
  #
  # @example
  #   "&lt;p&gt;one &lt;span&gt;two&lt;/span&gt;&lt;/p&gt;".xml_unescape
  #   # => "<p>one <span>two</span></p>"
  #
  # @see http://rubydoc.info/stdlib/cgi/1.9.2/CGI.unescapeHash
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_unescape
    CGI.unescapeHTML(self)
  end

  #
  # Formats the chars in the String for XML.
  #
  # @param [Hash] options
  #   Additional options for {#format_chars}.
  #
  # @return [String]
  #   The formatted XML String.
  #
  # @example
  #   "abc".format_xml
  #   # => "&#97;&#98;&#99;"
  #
  # @see Integer#format_xml
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_xml(options={})
    format_chars(options) { |c| c.ord.format_xml }
  end

end
