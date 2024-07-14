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

require 'ronin/support/encoding/base62'

class Integer

  #
  # [Base62] encodes the Integer.
  #
  # [Base62]: https://en.wikipedia.org/wiki/Base62
  #
  # @return [String]
  #   The Base62 encoded String.
  #
  # @example
  #   1337.base62_encode
  #   # => "LZ"
  #
  # @api public
  #
  # @since 1.1.0
  #
  def base62_encode
    Ronin::Support::Encoding::Base62.encode_int(self)
  end

end
