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

require 'uri/common'

class String

  #
  # URI escapes the String.
  #
  # @return [String]
  #   The URI escaped form of the String.
  #
  # @example
  #   "x > y".uri_escape
  #   # => "x%20%3E%20y"
  #
  # @api public
  #
  def uri_escape(unsafe: nil)
    if unsafe then URI::DEFAULT_PARSER.escape(self,unsafe.join)
    else           URI::DEFAULT_PARSER.escape(self)
    end
  end

  #
  # URI unescapes the String.
  #
  # @return [String]
  #   The unescaped URI form of the String.
  #
  # @example
  #   "sweet%20%26%20sour".uri_unescape
  #   # => "sweet & sour"
  #
  # @api public
  #
  def uri_unescape
    URI::DEFAULT_PARSER.unescape(self)
  end

  #
  # URI formats the characters in the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_chars}.
  #
  # @return [String]
  #   The URI formatted String.
  #
  # @example
  #   "hello".format_uri
  #   # => "%68%65%6C%6C%6F"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def format_uri(**kwargs)
    format_chars(**kwargs) { |c| c.ord.uri_encode }
  end

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
  #   "plain text".uri_encode
  #   # => "%70%6C%61%69%6E%20%74%65%78%74"
  #
  # @see #format_uri
  #
  # @api public
  #
  def uri_encode
    format_uri
  end

  alias uri_decode uri_unescape

end
