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

require 'ronin/support/format/text/core_ext/string'
require 'ronin/support/format/hex/core_ext/integer'

class String

  #
  # Hex-encodes characters in the String.
  #
  # @return [String]
  #   The hex encoded version of the String.
  #
  # @example
  #   "hello".hex_encode
  #   # => "68656C6C6F"
  #
  # @since 0.6.0
  #
  def hex_encode
    format_bytes { |b| b.hex_encode }
  end

  #
  # Hex-decodes the String.
  #
  # @return [String]
  #   The hex decoded version of the String.
  #
  # @example
  #   "68656C6C6F".hex_decode
  #   # => "hello"
  #
  def hex_decode
    scan(/../).map { |hex| hex.to_i(16).chr }.join
  end

  #
  # Hex-escapes characters in the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_bytes}.
  #
  # @return [String]
  #   The hex escaped version of the String.
  #
  # @example
  #   "hello".hex_escape
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  # @see String#format_bytes
  #
  # @api public
  #
  def hex_escape(**kwargs)
    format_bytes(**kwargs) { |b| b.hex_escape }
  end

  alias hex_string hex_escape

  alias hex_unescape unescape

end