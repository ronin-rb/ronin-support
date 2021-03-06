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

require 'uri/common'
require 'cgi'

class Integer

  #
  # URI encodes the byte.
  #
  # @return [String]
  #   The URI encoded byte.
  #
  # @api public
  #
  def uri_encode
    URI::DEFAULT_PARSER.escape(chr)
  end

  #
  # URI escapes the byte.
  #
  # @return [String]
  #   The URI escaped byte.
  #
  # @example
  #   0x3d.uri_escape
  #   # => "%3D"
  #
  # @api public
  #
  def uri_escape
    CGI.escape(chr)
  end

  #
  # Formats the byte for HTTP.
  #
  # @return [String]
  #   The formatted byte.
  #
  # @example
  #   0x41.format_http
  #   # => "%41"
  #
  # @api public
  #
  def format_http
    "%%%X" % self
  end

end
