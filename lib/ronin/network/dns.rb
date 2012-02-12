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
      # The nameserver to query.
      #
      # @return [String, nil]
      #   The address of the nameserver.
      #
      # @api public
      #
      def self.nameserver
        @nameserver
      end

      #
      # Sets the nameserver to be queried.
      #
      # @param [IPAddr, String, nil]
      #   The address of the nameserver.
      #
      # @return [String, nil]
      #   The address of the new nameserver.
      #
      # @api public
      #
      def self.nameserver=(address)
        @resolver   = nil
        @nameserver = unless address.nil?
                        address.to_s
                      end
      end

      #
      # The DNS Resolver to be used.
      #
      # @return [Resolv, Resolv::DNS]
      #   The DNS Resolver.
      #
      # @api private
      #
      def self.resolver
        @resolver ||= if nameserver
                        Resolv::DNS.new(:nameserver => nameserver)
                      else
                        Resolv
                      end
      end

      #
      # Looks up the address of a hostname.
      #
      # @param [String] hostname
      #   The hostname to lookup.
      #
      # @return [String, nil]
      #   The address of the hostname.
      #
      # @api public
      #
      def dns_lookup(hostname)
        begin
          DNS.resolver.getaddress(hostname.to_s)
        rescue Resolv::ResolvError
        end
      end

      #
      # Looks up all addresses of a hostname.
      #
      # @param [String] hostname
      #   The hostname to lookup.
      #
      # @return [Array<String>]
      #   The addresses of the hostname.
      #
      # @api public
      #
      def dns_lookup_all(hostname)
        DNS.resolver.getaddresses(hostname.to_s)
      end

      #
      # Looks up the hostname of the address.
      #
      # @param [String] address
      #   The address to lookup.
      #
      # @return [String, nil]
      #   The hostname of the address.
      #
      # @api public
      #
      def dns_reverse_lookup(address)
        begin
          DNS.resolver.getname(address.to_s)
        rescue Resolv::ResolvError
        end
      end

      #
      # Looks up all hostnames associated with the address.
      #
      # @param [String] address
      #   The address to lookup.
      #
      # @return [Array<String>]
      #   The hostnames of the address.
      #
      # @api public
      #
      def dns_reverse_lookup_all(address)
        DNS.resolver.getnames(address.to_s)
      end
    end
  end
end
