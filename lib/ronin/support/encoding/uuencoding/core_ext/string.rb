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

class String

  #
  # [uuencodes][uuencoding] the String.
  #
  # [uuencoding]: https://en.wikipedia.org/wiki/Uuencoding
  #
  # @return [String]
  #   The UU encoded String.
  #
  # @example
  #   "hello world".uu_encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uu_encode
    [self].pack('u')
  end

  alias uuencode uu_encode
  alias uu_escape uu_encode

  #
  # Decodes the [uuencoded][uuencoding] String.
  #
  # [uuencoding]: https://en.wikipedia.org/wiki/Uuencoding
  #
  # @return [String]
  #   The decoded String.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uu_decode
    unpack1('u')
  end

  alias uudecode uu_decode
  alias uu_unescape uu_decode

end
