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

require 'cgi'

class Integer

  #
  # Formats the byte for HTTP.
  #
  # @return [String]
  #   The formatted byte.
  #
  # @example
  #   0x41.http_encode
  #   # => "%41"
  #
  # @api public
  #
  def http_encode
    "%%%X" % self
  end

  #
  # HTTP escapes the Integer.
  #
  # @return [String]
  #   The HTTP escaped form of the Integer.
  #
  # @example
  #   62.http_escape
  #   # => "%3E"
  #
  # @api public
  #
  # @since 0.6.0
  #
  def http_escape
    CGI.escape(chr)
  end

end
