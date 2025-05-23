# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/punycode'

class String

  #
  # Encodes a unicode String into Punycode.
  #
  # @return [String]
  #   The punycode String.
  #
  # @example
  #   "詹姆斯".punycode_encode
  #   # => "xn--8ws00zhy3a"
  #
  # @see https://en.wikipedia.org/wiki/Punycode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def punycode_encode
    Ronin::Support::Encoding::Punycode.encode(self)
  end

  #
  # Decodes a Punycode String back into unicode.
  #
  # @return [String]
  #   The decoded unicode String.
  #
  # @example
  #   "xn--8ws00zhy3a".punycode_decode
  #   # => "詹姆斯"
  #
  # @see https://en.wikipedia.org/wiki/Punycode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def punycode_decode
    Ronin::Support::Encoding::Punycode.decode(self)
  end

end
