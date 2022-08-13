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

require 'ronin/support/encoding/uri/core_ext/integer'
require 'ronin/support/encoding/text/core_ext/string'

require 'uri'

class String

  #
  # URI escapes the String.
  #
  # @param [Array<String>] unsafe
  #   The unsafe characters to encode.
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
  # URI encodes the String.
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
    encode_chars { |c| c.ord.uri_encode }
  end

  alias uri_decode uri_unescape

  #
  # URI Form escapes the String.
  #
  # @return [String]
  #   The URI Form escaped String.
  #
  # @example
  #   "hello world".uri_form_escape
  #   # => "hello+world"
  #   "hello\0world".uri_form_escape
  #   # => "hello%00world"
  #
  # @see https://www.w3.org/TR/2013/CR-html5-20130806/forms.html#url-encoded-form-data
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uri_form_escape
    URI.encode_www_form_component(self)
  end

  alias www_form_escape uri_form_escape

  #
  # URI Form unescapes the String.
  #
  # @return [String]
  #   The URI Form unescaped String.
  #
  # @example
  #   "hello+world".uri_form_unescape
  #   # => "hello world"
  #   "hello%00world".uri_form_unescape
  #   # => "hello\u0000world"
  #
  def uri_form_unescape
    URI.decode_www_form_component(self)
  end

  alias www_form_unescape uri_form_unescape

  #
  # URI Form encodes every character in the String.
  #
  # @return [String]
  #   The URI Form encoded String.
  #
  # @example
  #   "hello world".uri_form_encode
  #   # => 
  #
  # @see Integer#uri_form_encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uri_form_encode
    encode_bytes { |b| b.uri_form_encode }
  end

  alias www_form_encode uri_form_encode

  alias uri_form_decode uri_form_unescape
  alias www_form_decode uri_form_decode

end
