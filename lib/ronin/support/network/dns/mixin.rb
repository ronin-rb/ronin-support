# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      module DNS
        #
        # Provides helper methods for performing DNS queries.
        #
        module Mixin
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

          #
          # Queries a single matching DNS record for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @param [:a, :aaaa, :any, :cname, :hinfo, :loc, :minfo, :mx, :ns, :ptr, :soa, :srv, :txt, :wks] record_type
          #   The record type.
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
          # @return [Resolv::DNS::Resource, nil]
          #   The matching DNS records or `nil` if no matching DNS records
          #   could be found.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource
          #
          def dns_get_record(name,record_type,**kwargs)
            dns_resolver(**kwargs).get_record(name.to_s,record_type)
          end

          #
          # Queries all matching DNS records for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @param [:a, :aaaa, :any, :cname, :hinfo, :loc, :minfo, :mx, :ns, :ptr, :soa, :srv, :txt, :wks] record_type
          #   The record type.
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
          # @return [Array<Resolv::DNS::Resource>]
          #   All matching DNS records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource
          #
          def dns_get_records(name,record_type,**kwargs)
            dns_resolver(**kwargs).get_records(name.to_s,record_type)
          end

          #
          # Queries all records of the host name using the `ANY` DNS query.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource>]
          #   All of the DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/ANY
          #
          def dns_get_any_records(name,**kwargs)
            dns_resolver(**kwargs).get_any_records(name.to_s)
          end

          #
          # Queries the `CNAME` record for the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::IN::CNAME, nil]
          #   The `CNAME` record or `nil` if the host name has no `CNAME`
          #   record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/CNAME
          #
          def dns_get_cname_record(name,**kwargs)
            dns_resolver(**kwargs).get_cname_record(name.to_s)
          end

          #
          # Queries the canonical name for the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   The canonical name for the host or `nil` if the host has no
          #   `CNAME` record.
          #
          def dns_get_cname(name,**kwargs)
            dns_resolver(**kwargs).get_cname(name.to_s)
          end

          #
          # Queries the `HINFO` record for the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::IN::HINFO, nil]
          #   The `HINFO` DNS record or `nil` if the host name has no `HINFO`
          #   record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/HINFO
          #
          def dns_get_hinfo_record(name,**kwargs)
            dns_resolver(**kwargs).get_hinfo_record(name.to_s)
          end

          #
          # Queries the first `A` record belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::IN::A, nil]
          #   The first `A` DNS record or `nil` if the host name has no `A`
          #   records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/A
          #
          def dns_get_a_record(name,**kwargs)
            dns_resolver(**kwargs).get_a_record(name.to_s)
          end

          #
          # Queries the first IPv4 address belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   The first IPv4 address belonging to the host name.
          #
          def dns_get_a_address(name,**kwargs)
            dns_resolver(**kwargs).get_a_address(name.to_s)
          end

          #
          # Queries all `A` records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource::IN::A>]
          #   All of the `A` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/A
          #
          def dns_get_a_records(name,**kwargs)
            dns_resolver(**kwargs).get_a_records(name.to_s)
          end

          #
          # Queries all IPv4 addresses belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   All of the IPv4 addresses belonging to the host name.
          #
          def dns_get_a_addresses(name,**kwargs)
            dns_resolver(**kwargs).get_a_addresses(name.to_s)
          end

          #
          # Queries the first `AAAA` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::IN::AAAA, nil]
          #   The first `AAAA` DNS record or `nil` if the host name has no
          #   `AAAA` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/AAAA
          #
          def dns_get_aaaa_record(name,**kwargs)
            dns_resolver(**kwargs).get_aaaa_record(name.to_s)
          end

          #
          # Queries the first IPv6 address belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   The first IPv6 address or `nil` if the host name has no IPv6
          #   addresses.
          #
          def dns_get_aaaa_address(name,**kwargs)
            dns_resolver(**kwargs).get_aaaa_address(name.to_s)
          end

          #
          # Queries all `AAAA` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource::IN::AAAA>]
          #   All of the `AAAA` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/AAAA
          #
          def dns_get_aaaa_records(name,**kwargs)
            dns_resolver(**kwargs).get_aaaa_records(name.to_s)
          end

          #
          # Queries all IPv6 addresses belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   All IPv6 addresses belonging to the host name.
          #
          def dns_get_aaaa_addresses(name,**kwargs)
            dns_resolver(**kwargs).get_aaaa_addresses(name.to_s)
          end

          #
          # Queries all `SRV` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource::IN::SRV>]
          #   All `SRV` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/SRV
          #
          def dns_get_srv_records(name,**kwargs)
            dns_resolver(**kwargs).get_srv_records(name.to_s)
          end

          #
          # Queries all `WKS` (Well-Known-Service) DNS records belonging to the
          # host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource::IN::WKS>]
          #   All `WKS` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/WKS
          #
          def dns_get_wks_records(name,**kwargs)
            dns_resolver(**kwargs).get_wks_records(name.to_s)
          end

          #
          # Queries the `LOC` (Location) DNS record of the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::LOC, nil]
          #   The `LOC` DNS record of the host name or `nil` if the host name
          #   has no `LOC` record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/LOC
          #
          def dns_get_loc_record(name,**kwargs)
            dns_resolver(**kwargs).get_loc_record(name.to_s)
          end

          #
          # Queries the `MINFO` (Machine-Info) DNS record of the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::MINFO, nil]
          #   The `MINFO` DNS record of the host name or `nil` if the host name
          #   has no `MINFO` record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/MINFO
          #
          def dns_get_minfo_record(name,**kwargs)
            dns_resolver(**kwargs).get_minfo_record(name.to_s)
          end

          #
          # Queries all `MX` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource::MX>]
          #   All `MX` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/MX
          #
          def dns_get_mx_records(name,**kwargs)
            dns_resolver(**kwargs).get_mx_records(name.to_s)
          end

          #
          # Queries the mailservers for the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   The host names of the mailservers serving the given host name.
          #
          def dns_get_mailservers(name,**kwargs)
            dns_resolver(**kwargs).get_mailservers(name.to_s)
          end

          #
          # Queries all `NS` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource::NS>]
          #   All `NS` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/NS
          #
          def dns_get_ns_records(name,**kwargs)
            dns_resolver(**kwargs).get_ns_records(name.to_s)
          end

          #
          # Queries the nameservers for the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   The host names of the nameservers serving the given host name.
          #
          def dns_get_nameservers(name,**kwargs)
            dns_resolver(**kwargs).get_nameservers(name.to_s)
          end

          #
          # Queries the first `PTR` DNS record for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
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
          # @return [Resolv::DNS::Resource::PTR, nil]
          #   The first `PTR` DNS record of the host name or `nil` if the host
          #   name has no `PTR` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/PTR
          #
          def dns_get_ptr_record(ip,**kwargs)
            dns_resolver(**kwargs).get_ptr_record(ip.to_s)
          end

          #
          # Queries the `PTR` host name for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
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
          #   The host name that points to the given IP.
          #
          def dns_get_ptr_name(ip,**kwargs)
            dns_resolver(**kwargs).get_ptr_name(ip.to_s)
          end

          #
          # Queries all `PTR` DNS records for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
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
          # @return [Array<Resolv::DNS::Resource::PTR>]
          #   All `PTR` DNS records for the given IP.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/PTR
          #
          def dns_get_ptr_records(ip,**kwargs)
            dns_resolver(**kwargs).get_ptr_records(ip.to_s)
          end

          #
          # Queries all `PTR` names for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
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
          #   The `PTR` names for the given IP.
          #
          def dns_get_ptr_names(ip,**kwargs)
            dns_resolver(**kwargs).get_ptr_names(ip.to_s)
          end

          #
          # Queries the first `SOA` DNS record belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::SOA, nil]
          #   The first `SOA` DNS record for the host name or `nil` if the host
          #   name has no `SOA` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/SOA
          #
          def dns_get_soa_record(name,**kwargs)
            dns_resolver(**kwargs).get_soa_record(name.to_s)
          end

          #
          # Queiries the first `TXT` DNS record belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Resolv::DNS::Resource::TXT, nil]
          #   The first `TXT` DNS record for the host name or `nil` if the host
          #   name has no `TXT` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/TXT
          #
          def dns_get_txt_record(name,**kwargs)
            dns_resolver(**kwargs).get_txt_record(name.to_s)
          end

          #
          # Queries the first `TXT` string belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   The first `TXT` string belonging to the host name or `nil` if the
          #   host name has no `TXT` records.
          #
          def dns_get_txt_string(name,**kwargs)
            dns_resolver(**kwargs).get_txt_string(name.to_s)
          end

          #
          # Queries all `TXT` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          # @return [Array<Resolv::DNS::Resource::TXT>]
          #   All of the `TXT` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/TXT
          #
          def dns_get_txt_records(name,**kwargs)
            dns_resolver(**kwargs).get_txt_records(name.to_s)
          end

          #
          # Queries all of the `TXT` string values of the host name.
          #
          # @param [String] name
          #   The host name to query.
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
          #   All `TXT` string values belonging of the host name.
          #
          def dns_get_txt_strings(name,**kwargs)
            dns_resolver(**kwargs).get_txt_strings(name.to_s)
          end
        end
      end
    end
  end
end
