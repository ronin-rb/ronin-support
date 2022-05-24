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

class Integer

  #
  # URI encodes the byte.
  #
  # @return [String]
  #   The URI encoded byte.
  #
  # @example
  #   0x41.uri_encode
  #   # => "%41"
  #
  # @api public
  #
  def uri_encode
    "%%%2X" % self
  end

  #
  # URI escapes the byte.
  #
  # @param [Array<String>, nil] unsafe
  #   Optiona set of unsafe characters to escape.
  #
  # @return [String]
  #   The URI escaped byte.
  #
  # @example
  #   0x41.uri_escape
  #   # => "A"
  #   0x3d.uri_escape
  #   # => "%3D"
  #
  # @api public
  #
  def uri_escape(unsafe: nil)
    if unsafe then URI::DEFAULT_PARSER.escape(chr,unsafe.join)
    else           URI::DEFAULT_PARSER.escape(chr)
    end
  end

end
