# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase XML special
  #   characters. Defaults to lowercase hexadecimal.
  #
  # @return [String]
  #   The HTML escaped String.
  #
  # @raise [ArgumentError]
  #   The `case:` keyword argument is invalid.
  #
  # @example
  #   "one & two".html_escape
  #   # => "one &amp; two"
  #
  # @example Uppercase escaped characters:
  #   "one & two".html_escape(case: :upper)
  #   # => "one &AMP; two"
  #
  # @see https://rubydoc.info/stdlib/cgi/1.9.2/CGI.escapeHTML
  # @see Ronin::Support::Encoding::HTML.escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_escape(**kwargs)
    Ronin::Support::Encoding::HTML.escape(self,**kwargs)
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
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:decimal, :hex] :format (:decimal)
  #   The numeric format for the escaped characters.
  #
  # @option kwargs [Boolean] :zero_pad
  #   Controls whether the escaped characters will be left-padded with
  #   up to seven `0` characters.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase XML special
  #   characters. Defaults to lowercase hexadecimal.
  #
  # @return [String]
  #   The encoded HTML String.
  #
  # @raise [ArgumentError]
  #   The `format:` or `case:` keyword argument is invalid.
  #
  # @example
  #   "abc".html_encode
  #   # => "&#97;&#98;&#99;"
  #
  # @example Zero-padding:
  #   "abc".html_encode(zero_pad: true)
  #   # => "&#0000097;&#0000098;&#0000099;"
  #
  # @example Hexadecimal encoded characters:
  #   "abc".html_encode(format: :hex)
  #   # => "&#x61;&#x62;&#x63;"
  #
  # @example Uppercase hexadecimal encoded characters:
  #   "abc\xff".html_encode(format: :hex, case: :upper)
  #   # => "&#X61;&#X62;&#X63;&#XFF;"
  #
  # @see Ronin::Support::Encoding::HTML.encode
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_encode(**kwargs)
    Ronin::Support::Encoding::HTML.encode(self,**kwargs)
  end

  alias html_decode html_unescape

end
