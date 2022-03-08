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
          # Sets the DNS nameservers to query.
          #
          # @param [Array<String>] new_nameservers
          #   The new DNS nameserver addresses to query.
          #
          # @return [Array<String>]
          #   The new DNS nameserver addresses to query.
          #
          def dns_nameservers=(new_nameservers)
            @dns_nameservers = new_nameservers.map(&:to_s)
            @dns_resolver    = Network::DNS.resolver(
              nameservers: @dns_nameservers
            )
            return new_nameservers
          end

          #
          # The default DNS nameserver(s) to query.
          #
          # @return [Array<String>]
          #   The addresses of the DNS nameserver(s) to query.
          #
          def dns_nameservers
            @dns_nameservers ||= Network::DNS.nameservers
          end

          #
          # Sets the primary DNS nameserver to query.
          #
          # @param [String] new_nameserver
          #   The address of the new primary DNS nameserver to query.
          #
          # @return [String]
          #   The address of the new primary DNS nameserver to query.
          #
          def dns_nameserver=(new_nameserver)
            self.dns_nameservers = [new_nameserver]
            return new_nameserver
          end

          #
          # Creates a DNS Resolver for the nameserver.
          #
          # @param [Array<String>, String, nil] nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @param [String, nil] nameserver
          #   Optional DNS nameserver to query.
          #
          # @return [Resolv, Resolv::DNS]
          #   The DNS Resolver.
          #
          # @api public
          #
          def dns_resolver(nameservers: nil, nameserver: nil)
            if nameserver
              Network::DNS.resolver(nameserver: nameserver)
            elsif nameservers
              Network::DNS.resolver(nameservers: nameservers)
            else
              @dns_resolver ||= Network::DNS.resolver(
                nameservers: dns_nameservers
              )
            end
          end

          #
          # Looks up the address of a hostname.
          #
          # @param [String] host
          #   The hostname to lookup.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option [Array<String>, String, nil] :nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @option [String, nil] :nameserver
          #   Optional DNS nameserver to query.
          #
          # @return [String, nil]
          #   The address of the hostname.
          #
          # @api public
          #
          def dns_get_address(host,**kwargs)
            dns_resolver(**kwargs).get_address(host.to_s)
          end

          alias dns_lookup dns_get_address

          #
          # Looks up all addresses of a hostname.
          #
          # @param [String] host
          #   The hostname to lookup.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option [Array<String>, String, nil] :nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @option [String, nil] :nameserver
          #   Optional DNS nameserver to query.
          #
          # @return [Array<String>]
          #   The addresses of the hostname.
          #
          # @api public
          #
          def dns_get_addresses(host,**kwargs)
            dns_resolver(**kwargs).get_addresses(host.to_s)
          end

          #
          # Looks up the hostname of the address.
          #
          # @param [String] ip
          #   The IP address to lookup.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option [Array<String>, String, nil] :nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @option [String, nil] :nameserver
          #   Optional DNS nameserver to query.
          #
          # @return [String, nil]
          #   The hostname of the address.
          #
          # @api public
          #
          def dns_get_name(ip,**kwargs)
            dns_resolver(**kwargs).get_name(ip.to_s)
          end

          alias dns_reverse_lookup dns_get_name

          #
          # Looks up all hostnames associated with the address.
          #
          # @param [String] ip
          #   The IP address to lookup.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option [Array<String>, String, nil] :nameservers
          #   Optional DNS nameserver(s) to query.
          #
          # @option [String, nil] :nameserver
          #   Optional DNS nameserver to query.
          #
          # @return [Array<String>]
          #   The hostnames of the address.
          #
          # @api public
          #
          def dns_get_names(ip,**kwargs)
            dns_resolver(**kwargs).get_names(ip.to_s)
          end
        end
      end
    end
  end
end
