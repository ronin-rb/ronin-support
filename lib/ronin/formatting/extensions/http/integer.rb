#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as publishe by
# the Free Software Foundation, either version 3 of the License, or
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

require 'uri'
require 'cgi'

class Integer

  #
  # URI encodes the byte.
  #
  # @return [String]
  #   The URI encoded byte.
  #
  def uri_encode
    URI.encode(self.chr)
  end

  #
  # URI escapes the byte.
  #
  # @return [String]
  #   The URI escaped byte.
  #
  def uri_escape
    CGI.escape(self.chr)
  end

  #
  # Formats the byte for HTTP.
  #
  # @return [String]
  #   The formatted byte.
  #
  def format_http
    "%%%x" % self
  end

end
