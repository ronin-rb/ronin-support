# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/ip'

module Ronin
  module Support
    module Network
      class IP < IPAddr
        #
        # Provides helper methods for looking up the public and local IP
        # address.
        #
        module Mixin
          #
          # Determines the current public IP address.
          #
          # @return [String, nil]
          #   The public IP address according to {https://ipinfo.io/ip}.
          #
          # @see Network::IP.public_address
          #
          # @since 1.0.0
          #
          def public_address
            Network::IP.public_address
          end

          #
          # Determines the current public IP.
          #
          # @return [String, nil]
          #   The public IP according to {https://ipinfo.io/ip}.
          #
          # @see Network::IP.public_ip
          #
          # @since 0.6.0
          #
          def public_ip
            Network::IP.public_ip
          end

          #
          # Determines the local IP addresses.
          #
          # @return [Array<String>]
          #
          # @see Network::IP.local_addresses
          #
          # @since 1.0.0
          #
          def local_addresses
            Network::IP.local_addresses
          end

          #
          # Determines the local IP address.
          #
          # @return [String]
          #
          # @see Network::IP.local_ip_address
          #
          # @since 1.0.0
          #
          def local_address
            Network::IP.local_address
          end

          #
          # Determines the local IPs.
          #
          # @return [Array<Network::IP>]
          #
          # @see Network::IP.local_ips
          #
          # @since 1.0.0
          #
          def local_ips
            Network::IP.local_ips
          end

          #
          # Determines the local IP.
          #
          # @return [Network::IP]
          #   The private, link-local, or loopback IP.
          #
          # @see Network::IP.local_ip
          #
          # @since 0.6.0
          #
          def local_ip
            Network::IP.local_ip
          end
        end
      end
    end
  end
end
