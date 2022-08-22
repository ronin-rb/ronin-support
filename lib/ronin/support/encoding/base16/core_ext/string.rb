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

require 'ronin/support/encoding/base16'

class String

  #
  # [Base16] encodes the String.
  #
  # [Base16]: https://en.wikipedia.org/wiki/Base16
  #
  # @return [String]
  #   The Base16 encoded String.
  #
  # @example
  #   "The quick brown fox jumps over the lazy dog".base16_encode
  #   # => "54686520717569636b2062726f776e20666f78206a756d7073206f76657220746865206c617a7920646f67"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def base16_encode
    Ronin::Support::Encoding::Base16.encode(self)
  end

  #
  # [Base16] decodes the String.
  #
  # [Base16]: https://en.wikipedia.org/wiki/Base16
  #
  # @return [String]
  #   The Base16 decodes String.
  #
  # @example
  #   "54686520717569636b2062726f776e20666f78206a756d7073206f76657220746865206c617a7920646f67".base16_decode
  #   # => "The quick brown fox jumps over the lazy dog"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def base16_decode
    Ronin::Support::Encoding::Base16.decode(self)
  end

end
