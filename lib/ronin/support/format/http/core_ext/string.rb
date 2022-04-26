#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/format/http/core_ext/integer'
require 'ronin/support/format/text/core_ext/string'

require 'uri/common'
require 'cgi'

class String

  #
  # URI encodes the String.
  #
  # @param [Array<String>] unsafe
  #   The unsafe characters to encode.
  #
  # @return [String]
  #   The URI encoded form of the String.
  #
  # @example
  #   "art is graffiti".uri_encode
  #   # => "art%20is%20graffiti"
  #
  # @api public
  #
  def uri_encode(*unsafe)
    unless unsafe.empty? then URI::DEFAULT_PARSER.escape(self,unsafe.join)
    else                      URI::DEFAULT_PARSER.escape(self)
    end
  end

  #
  # URI decodes the String.
  #
  # @return [String]
  #   The decoded URI form of the String.
  #
  # @example
  #   "genre%3f".uri_decode
  #   # => "genre?"
  #
  # @api public
  #
  def uri_decode
    URI::DEFAULT_PARSER.unescape(self)
  end

  #
  # URI escapes the String.
  #
  # @return [String]
  #   The URI escaped form of the String.
  #
  # @example
  #   "x > y".uri_escape
  #   # => "x+%3E+y"
  #
  # @api public
  #
  def uri_escape
    CGI.escape(self)
  end

  #
  # URI unescapes the String.
  #
  # @return [String]
  #   The unescaped URI form of the String.
  #
  # @example
  #   "sweet+%26+sour".uri_unescape
  #   # => "sweet & sour"
  #
  # @api public
  #
  def uri_unescape
    CGI.unescape(self)
  end

  #
  # Formats the bytes of the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_bytes}.
  #
  # @return [String]
  #   The HTTP hexadecimal encoded form of the String.
  #
  # @example
  #   "hello".format_http
  #   # => "%68%65%6c%6c%6f"
  #
  # @see String#format_bytes
  #
  # @api public
  #
  def format_http(**kwargs)
    format_bytes(**kwargs) { |b| b.format_http }
  end

  #
  # HTTP escapes the String.
  #
  # @return [String]
  #   The HTTP escaped form of the String.
  #
  # @example
  #   "x > y".http_escape
  #   # => "x+%3E+y"
  #
  # @api public
  #
  # @since 0.6.0
  #
  def http_escape
    CGI.escape(self)
  end

  #
  # HTTP unescapes the String.
  #
  # @return [String]
  #   The raw String.
  #
  # @example
  #   "sweet+%26+sour".http_unescape
  #   # => "sweet & sour"
  #
  # @api public
  #
  # @since 0.6.0
  #
  def http_unescape
    CGI.unescape(self)
  end

end
