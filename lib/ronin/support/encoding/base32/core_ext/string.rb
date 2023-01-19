# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/base32'

class String

  #
  # [Base32] encodes the String.
  #
  # [Base32]: https://en.wikipedia.org/wiki/Base32
  #
  # @return [String]
  #   The Base32 encoded String.
  #
  # @example
  #   "The quick brown fox jumps over the lazy dog".base32_encode
  #   # => "KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO==="
  #
  # @api public
  #
  # @since 1.0.0
  #
  def base32_encode
    Ronin::Support::Encoding::Base32.encode(self)
  end

  #
  # [Base32] decodes the String.
  #
  # [Base32]: https://en.wikipedia.org/wiki/Base32
  #
  # @return [String]
  #   The Base32 decodes String.
  #
  # @example
  #   "KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO===".base32_decode
  #   # => "The quick brown fox jumps over the lazy dog"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def base32_decode
    Ronin::Support::Encoding::Base32.decode(self)
  end

end
