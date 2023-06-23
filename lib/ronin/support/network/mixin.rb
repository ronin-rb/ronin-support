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

require 'ronin/support/network/ip/mixin'
require 'ronin/support/network/dns/mixin'
require 'ronin/support/network/tcp/mixin'
require 'ronin/support/network/udp/mixin'
require 'ronin/support/network/ssl/mixin'
require 'ronin/support/network/unix/mixin'
require 'ronin/support/network/http/mixin'

module Ronin
  module Support
    module Network
      #
      # Provides helper methods for networking functions.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Mixin
        include IP::Mixin
        include DNS::Mixin
        include TCP::Mixin
        include UDP::Mixin
        include SSL::Mixin
        include UNIX::Mixin
        include HTTP::Mixin
      end
    end
  end
end
