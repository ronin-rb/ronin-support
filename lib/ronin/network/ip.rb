#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/extensions/ip_addr'

require 'net/http'

module Ronin
  module Network
    #
    # @since 0.6.0
    #
    module IP
      #
      # Determines the current external IP Address.
      #
      # @return [String]
      #   The external IP Address according to {http://checkip.dyndns.org}.
      #
      # @api public
      #
      def external_ip
        IPAddr.extract(Net::HTTP.get('checkip.dyndns.org','/')).first
      end

      alias ip external_ip
    end
  end
end
