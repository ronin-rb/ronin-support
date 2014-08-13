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

require 'resolv'

module Ronin
  module Network
    #
    # Provides helper methods for performing DNS queries.
    #
    # @since 0.4.0
    #
    module DNS
      #
      # The primary DNS nameserver to query.
      #
      # @return [Array<String>, String, nil]
      #   The address of the nameserver.
      #
      # @api public
      #
      def self.nameserver
        @nameserver
      end

      #
      # Sets the DNS nameserver to be queried.
      #
      # @param [IPAddr, String, nil] address
      #   The address of the nameserver.
      #
      # @return [String, nil]
      #   The address of the new nameserver.
      #
      # @api public
      #
      def self.nameserver=(address)
        @nameserver = address
      end

      #
      # Creates a DNS Resolver for the nameserver.
      #
      # @param [Array<String>, String] nameserver
      #   Optional DNS nameserver(s) to query.
      #
      # @return [Resolv::DNS]
      #   The DNS Resolver.
      #
      # @api public
      #
      # @since 0.6.0
      #
      def self.resolver(nameserver=self.nameserver)
        unless (nameserver.nil? || nameserver.empty?)
          Resolv::DNS.new(nameserver: nameserver)
        else
          Resolv::DNS.new
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
      def dns_resolver(nameserver=DNS.nameserver)
        DNS.resolver(nameserver)
      end

      #
      # Looks up the address of a hostname.
      #
      # @param [String] hostname
      #   The hostname to lookup.
      #
      # @param [Array<String>, String] nameserver
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
      def dns_lookup(hostname,nameserver=DNS.nameserver)
        hostname = hostname.to_s
        resolv   = dns_resolver(nameserver)
        address  = begin
                     resolv.getaddress(hostname).to_s
                   rescue Resolv::ResolvError
                   end

        yield(address) if (block_given? && address)
        return address
      end

      #
      # Looks up all addresses of a hostname.
      #
      # @param [String] hostname
      #   The hostname to lookup.
      #
      # @param [Array<String>, String] nameserver
      #   Optional DNS nameserver to query.
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
      def dns_lookup_all(hostname,nameserver=DNS.nameserver,&block)
        hostname  = hostname.to_s
        addresses = dns_resolver(nameserver).getaddresses(hostname).map(&:to_s)

        addresses.each(&block) if block
        return addresses
      end

      #
      # Looks up the hostname of the address.
      #
      # @param [String] address
      #   The address to lookup.
      #
      # @param [Array<String>, String] nameserver
      #   Optional DNS nameserver to query.
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
      def dns_reverse_lookup(address,nameserver=DNS.nameserver)
        address  = address.to_s
        resolv   = dns_resolver(nameserver)
        hostname = begin
                     resolv.getname(address).to_s
                   rescue Resolv::ResolvError
                   end

        yield(hostname) if (block_given? && hostname)
        return hostname
      end

      #
      # Looks up all hostnames associated with the address.
      #
      # @param [String] address
      #   The address to lookup.
      #
      # @param [Array<String>, String] nameserver
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
      def dns_reverse_lookup_all(address,nameserver=DNS.nameserver,&block)
        address   = address.to_s
        hostnames = dns_resolver(nameserver).getnames(address).map(&:to_s)

        hostnames.each(&block) if block
        return hostnames
      end
    end
  end
end
