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

require 'socket'
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

      #
      # Determines the internal IP Address.
      #
      # @return [String]
      #   The non-loopback / non-multicast internal IP Address.
      #
      # @api public
      #
      def internal_ip
        addresses = Socket.ip_address_list

        addresses.find { |addr| addr.ipv4_private? || addr.ipv4_loopback? } ||
        addresses.find { |addr| addr.ipv6_linklocal? || addr.ipv6_loopback? }
      end

      #
      # Determines the accessible IP Address.
      #
      # @return [String]
      #   The accessible IP Address according to {#external_ip} or
      #   {#internal_ip}.
      #
      # @api public
      #
      def ip
        begin
          external_ip
        rescue
          internal_ip
        end
      end
    end
  end
end
