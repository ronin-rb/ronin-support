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

require 'ronin/support/network/dns/resolver'

require 'resolv'

module Ronin
  module Support
    module Network
      #
      # Provides helper methods for performing DNS queries.
      #
      # @since 0.4.0
      #
      module DNS
        #
        # The primary DNS nameserver(s) to query.
        #
        # @return [Array<String>]
        #   The addresses of the nameservers.
        #
        # @api public
        #
        def self.nameservers
          @nameservers ||= Resolver.default_nameservers
        end

        #
        # Sets the DNS nameserver to be queried.
        #
        # @param [Array<String>, String] new_nameservers
        #   The addresses of the new nameservers.
        #
        # @return [Array<String>]
        #   The addresses of the new nameservers.
        #
        # @api public
        #
        def self.nameservers=(new_nameservers)
          @nameservers = Array(new_nameservers).map(&:to_s)
          @resolver    = Resolver.new(@nameservers)
          return new_nameservers
        end

        #
        # Creates a DNS Resolver for the given nameserver(s).
        #
        # @param [Array<String>, nil] nameservers
        #   Optional DNS nameserver(s) to query.
        #
        # @return [Resolver]
        #   The DNS Resolver.
        #
        # @api public
        #
        # @since 0.6.0
        #
        def self.resolver(nameservers=nil)
          if nameservers
            Resolver.new(Array(nameservers).map(&:to_s))
          else
            @resolver ||= Resolver.new(self.nameservers)
          end
        end

        #
        # Creates a DNS Resolver for the nameserver.
        #
        # @param [Array<String>, String] nameserver
        #   Optional DNS nameserver(s) to query.
        #
        # @return [Resolv, Resolv::DNS]
        #   The DNS Resolver.
        #
        # @api public
        #
        def dns_resolver(nameservers=DNS.nameserver)
          DNS.resolver(nameservers)
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
        #   If a block is given and the hostname was resolved, the address will
        #   be passed to the block.
        #
        # @yieldparam [String] address
        #   The address of the hostname.
        #
        # @return [String, nil]
        #   The address of the hostname.
        #
        # @api public
        #
        def dns_lookup(host, nameservers: DNS.nameservers)
          host     = host.to_s
          resolver = dns_resolver(nameservers)
          address  = resolver.get_address(host)

          yield(address) if (block_given? && address)
          return address
        end

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
        def dns_lookup_all(host, nameservers: DNS.nameservers, &block)
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
        def dns_reverse_lookup(ip, nameservers: DNS.nameservers)
          ip       = ip.to_s
          resolver = dns_resolver(nameservers)
          host     = resolver.get_name(ip)

          yield(host) if (block_given? && host)
          return host
        end

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
        def dns_reverse_lookup_all(ip, nameservers: DNS.nameservers, &block)
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
