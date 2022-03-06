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

require 'ronin/support/network/dns'

module Ronin
  module Support
    module Network
      module Mixins
        #
        # Provides helper methods for performing DNS queries.
        #
        # @api public
        #
        # @since 1.0.0
        #
        module DNS
          #
          # Creates a DNS Resolver for the nameserver.
          #
          # @param [Array<String>, String] nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @return [Resolv, Resolv::DNS]
          #   The DNS Resolver.
          #
          # @api public
          #
          def dns_resolver(nameservers=Network::DNS.nameserver)
            Network::DNS.resolver(nameservers)
          end

          #
          # Looks up the address of a hostname.
          #
          # @param [String] host
          #   The hostname to lookup.
          #
          # @param [Array<String>] nameservers
          #   Optional DNS nameserver to query.
          #
          # @yield [address]
          #   If a block is given and the hostname was resolved, the address
          #   will be passed to the block.
          #
          # @yieldparam [String] address
          #   The address of the hostname.
          #
          # @return [String, nil]
          #   The address of the hostname.
          #
          # @api public
          #
          def dns_get_address(host, nameservers: Network::DNS.nameservers)
            host     = host.to_s
            resolver = dns_resolver(nameservers)
            address  = resolver.get_address(host)

            yield(address) if (block_given? && address)
            return address
          end

          alias dns_lookup dns_get_address

          #
          # Looks up all addresses of a hostname.
          #
          # @param [String] host
          #   The hostname to lookup.
          #
          # @param [Array<String>, String] nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @yield [address]
          #   If a block is given, each resolved address will be passed to the
          #   block.
          #
          # @yieldparam [String] address
          #   A address of the hostname.
          #
          # @return [Array<String>]
          #   The addresses of the hostname.
          #
          # @api public
          #
          def dns_get_addresses(host, nameservers: Network::DNS.nameservers,
                                      &block)
            host      = host.to_s
            resolver  = dns_resolver(nameservers)
            addresses = resolver.get_addresses(host)

            addresses.each(&block) if block
            return addresses
          end

          #
          # Looks up the hostname of the address.
          #
          # @param [String] ip
          #   The IP address to lookup.
          #
          # @param [Array<String>, String] nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @yield [hostname]
          #   If a block is given and a hostname was found for the address,
          #   the resolved hostname will be passed to the block.
          #
          # @yieldparam [String] hostname
          #   The hostname of the address.
          #
          # @return [String, nil]
          #   The hostname of the address.
          #
          # @api public
          #
          def dns_get_name(ip, nameservers: Network::DNS.nameservers)
            ip       = ip.to_s
            resolver = dns_resolver(nameservers)
            host     = resolver.get_name(ip)

            yield(host) if (block_given? && host)
            return host
          end

          alias dns_reverse_lookup dns_get_name

          #
          # Looks up all hostnames associated with the address.
          #
          # @param [String] ip
          #   The IP address to lookup.
          #
          # @param [Array<String>, String] nameservers
          #   Optional DNS nameserver to query.
          #
          # @yield [hostname]
          #   If a block is given and hostnames were found for the address,
          #   each hostname will be passed to the block.
          #
          # @yieldparam [String] hostname
          #   A hostname of the address.
          #
          # @return [Array<String>]
          #   The hostnames of the address.
          #
          # @api public
          #
          def dns_get_names(ip, nameservers: Network::DNS.nameservers, &block)
            ip       = ip.to_s
            resolver = dns_resolver(nameservers)
            hosts    = resolver.get_names(ip)

            hosts.each(&block) if block
            return hosts
          end
        end
      end
    end
  end
end
