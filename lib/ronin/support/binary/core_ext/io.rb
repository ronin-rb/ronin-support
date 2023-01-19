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

require 'ronin/support/binary/stream/methods'
require 'ronin/support/binary/ctypes'

class IO

  include Ronin::Support::Binary::Stream::Methods

  #
  # The type system which `read_*`/`write_*`
  # {Ronin::Support::Binary::Stream::Methods methods} will use.
  #
  # @api private
  #
  # @see Ronin::Support::Binary::Stream::Methods
  #
  def type_system
    Ronin::Support::Binary::CTypes
  end

end
