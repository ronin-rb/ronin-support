# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/xml'

class String

  #
  # XML escapes the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase XML special
  #   characters. Defaults to lowercase hexadecimal.
  #
  # @return [String]
  #   The XML escaped String.
  #
  # @example
  #   "one & two".xml_escape
  #   # => "one &amp; two"
  #
  # @example Uppercase escaped characters:
  #   "one & two".xml_escape(case: :upper)
  #   # => "one &AMP; two"
  #
  # @see http://rubydoc.info/stdlib/cgi/CGI.escapeHTML
  # @see Ronin::Support::Encoding::XML.escape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_escape(**kwargs)
    Ronin::Support::Encoding::XML.escape(self,**kwargs)
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
  # @see http://rubydoc.info/stdlib/cgi/CGI.unescapeHash
  # @see Ronin::Support::Encoding::XML.unescape
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_unescape
    Ronin::Support::Encoding::XML.unescape(self)
  end

  #
  # Encodes each character in the String as an XML character.
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
  #   The XML encoded String.
  #
  # @example
  #   "abc".xml_encode
  #   # => "&#97;&#98;&#99;"
  #
  # @example Zero-padding:
  #   "abc".xml_encode(zero_pad: true)
  #   # => "&#0000097;&#0000098;&#0000099;"
  #
  # @example Hexadecimal encoded characters:
  #   "abc".xml_encode(format: :hex)
  #   # => "&#x61;&#x62;&#x63;"
  #
  # @example Uppercase hexadecimal encoded characters:
  #   "abc\xff".xml_encode(format: :hex, case: :upper)
  #   # => "&#X61;&#X62;&#X63;&#XFF;"
  #
  # @see Ronin::Support::Encoding::XML.encode
  #
  # @since 1.0.0
  #
  # @api public
  #
  def xml_encode(**kwargs)
    Ronin::Support::Encoding::XML.encode(self,**kwargs)
  end

  alias xml_decode xml_unescape

end
