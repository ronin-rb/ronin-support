#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/html'

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
  # @see Ronin::Support::Encoding::HTML.escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_escape
    Ronin::Support::Encoding::HTML.escape(self)
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
  # @see Ronin::Support::Encoding::HTML.unescape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_unescape
    Ronin::Support::Encoding::HTML.unescape(self)
  end

  #
  # Encodes the chars in the String for HTML.
  #
  # @return [String]
  #   The encoded HTML String.
  #
  # @example
  #   "abc".html_encode
  #   # => "&#97;&#98;&#99;"
  #
  # @see Ronin::Support::Encoding::HTML.encode
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_encode
    Ronin::Support::Encoding::HTML.encode(self)
  end

  alias html_decode html_unescape

end
