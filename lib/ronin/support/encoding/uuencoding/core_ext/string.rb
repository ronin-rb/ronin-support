# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/uuencoding'

class String

  #
  # UUEncodes the String.
  #
  # @return [String]
  #   The UU encoded String.
  #
  # @example
  #   "hello world".uu_encode
  #   # => "+:&5L;&\\@=V]R;&0`\n"
  #
  # @see Ronin::Support::Encoding::UUEncoding.encode
  # @see https://en.wikipedia.org/wiki/Uuencoding
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uu_encode
    Ronin::Support::Encoding::UUEncoding.encode(self)
  end

  alias uuencode uu_encode
  alias uu_escape uu_encode

  #
  # Decodes the UUEncoded String.
  #
  # @return [String]
  #   The decoded String.
  #
  # @example
  #   "+:&5L;&\\@=V]R;&0`\n".uu_decode
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::UUEncoding.decode
  # @see https://en.wikipedia.org/wiki/Uuencoding
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uu_decode
    Ronin::Support::Encoding::UUEncoding.decode(self)
  end

  alias uudecode uu_decode
  alias uu_unescape uu_decode

end
