# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
        # @param [Array<String>] new_nameservers
        #   The addresses of the new nameservers.
        #
        # @return [Array<String>]
        #   The addresses of the new nameservers.
        #
        # @api public
        #
        def self.nameservers=(new_nameservers)
          @nameservers = new_nameservers.map(&:to_s)
          @resolver    = Resolver.new(nameservers: @nameservers)
          return new_nameservers
        end

        #
        # Sets the primary DNS nameserver to be queried.
        #
        # @param [String] new_nameserver
        #   The new primary nameserver address.
        #
        # @return [String]
        #   The address of the primary nameserver.
        #
        def self.nameserver=(new_nameserver)
          self.nameservers = [new_nameserver]
          return new_nameserver
        end

        #
        # Creates a DNS Resolver for the given nameserver(s).
        #
        # @param [Array<String>, String, nil] nameservers
        #   Optional DNS nameserver(s) to query.
        #
        # @param [String, nil] nameserver
        #   Optional DNS nameserver to query.
        #
        # @return [Resolver]
        #   The DNS Resolver.
        #
        # @api public
        #
        # @since 0.6.0
        #
        def self.resolver(nameservers: nil, nameserver: nil)
          if nameserver
            Resolver.new(nameserver: nameserver.to_s)
          elsif nameservers
            Resolver.new(nameservers: nameservers.map(&:to_s))
          else
            @resolver ||= Resolver.new(nameservers: self.nameservers)
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
        def self.get_address(host,**kwargs)
          resolver(**kwargs).get_address(host.to_s)
        end

        #
        # Alias for {get_address}.
        #
        # @param [String] host
        #   The hostname to lookup.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {get_address}.
        #
        # @return [String, nil]
        #   The address of the hostname.
        #
        # @see get_address
        #
        def self.lookup(host,**kwargs)
          get_address(host,**kwargs)
        end

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
        def self.get_addresses(host,**kwargs)
          resolver(**kwargs).get_addresses(host.to_s)
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
        def self.get_name(ip,**kwargs)
          resolver(**kwargs).get_name(ip.to_s)
        end

        #
        # Alias for {get_name}.
        #
        # @param [String] ip
        #   The IP address to lookup.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {get_name}.
        #
        # @return [String, nil]
        #   The hostname of the address.
        #
        # @see get_name
        #
        def self.reverse_lookup(ip,**kwargs)
          get_name(ip,**kwargs)
        end

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
        def self.get_names(ip,**kwargs)
          resolver(**kwargs).get_names(ip.to_s)
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
        def self.get_record(name,record_type,**kwargs)
          resolver(**kwargs).get_record(name.to_s,record_type)
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
        def self.get_records(name,record_type,**kwargs)
          resolver(**kwargs).get_records(name.to_s,record_type)
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
        def self.get_any_records(name,**kwargs)
          resolver(**kwargs).get_any_records(name.to_s)
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
        def self.get_cname_record(name,**kwargs)
          resolver(**kwargs).get_cname_record(name.to_s)
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
        def self.get_cname(name,**kwargs)
          resolver(**kwargs).get_cname(name.to_s)
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
        def self.get_hinfo_record(name,**kwargs)
          resolver(**kwargs).get_hinfo_record(name.to_s)
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
        def self.get_a_record(name,**kwargs)
          resolver(**kwargs).get_a_record(name.to_s)
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
        def self.get_a_address(name,**kwargs)
          resolver(**kwargs).get_a_address(name.to_s)
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
        def self.get_ipv4_address(name,**kwargs)
          resolver(**kwargs).get_ipv4_address(name.to_s)
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
        def self.get_a_records(name,**kwargs)
          resolver(**kwargs).get_a_records(name.to_s)
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
        def self.get_a_addresses(name,**kwargs)
          resolver(**kwargs).get_a_addresses(name.to_s)
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
        def self.get_ipv4_addresses(name,**kwargs)
          resolver(**kwargs).get_ipv4_addresses(name.to_s)
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
        def self.get_aaaa_record(name,**kwargs)
          resolver(**kwargs).get_aaaa_record(name.to_s)
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
        def self.get_aaaa_address(name,**kwargs)
          resolver(**kwargs).get_aaaa_address(name.to_s)
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
        def self.get_ipv6_address(name,**kwargs)
          resolver(**kwargs).get_ipv6_address(name.to_s)
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
        def self.get_aaaa_records(name,**kwargs)
          resolver(**kwargs).get_aaaa_records(name.to_s)
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
        def self.get_aaaa_addresses(name,**kwargs)
          resolver(**kwargs).get_aaaa_addresses(name.to_s)
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
        def self.get_ipv6_addresses(name,**kwargs)
          resolver(**kwargs).get_ipv6_addresses(name.to_s)
        end

        #
        # Queries the first IPv4 or IPv6 address belonging to the host name.
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
        #   The first IPv4 or IPv6 address or `nil` if the host name has no
        #   IPv4 or IPv6 addresses.
        #
        def self.get_ip_address(name,**kwargs)
          resolver(**kwargs).get_ip_address(name.to_s)
        end

        #
        # Queries all IP addresses belonging to the host name.
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
        #   All IPv4 or IPv6 addresses belonging to the host name.
        #
        def self.get_ip_addresses(name,**kwargs)
          resolver(**kwargs).get_ip_addresses(name.to_s)
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
        def self.get_srv_records(name,**kwargs)
          resolver(**kwargs).get_srv_records(name.to_s)
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
        def self.get_wks_records(name,**kwargs)
          resolver(**kwargs).get_wks_records(name.to_s)
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
        def self.get_loc_record(name,**kwargs)
          resolver(**kwargs).get_loc_record(name.to_s)
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
        def self.get_minfo_record(name,**kwargs)
          resolver(**kwargs).get_minfo_record(name.to_s)
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
        def self.get_mx_records(name,**kwargs)
          resolver(**kwargs).get_mx_records(name.to_s)
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
        def self.get_mailservers(name,**kwargs)
          resolver(**kwargs).get_mailservers(name.to_s)
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
        def self.get_ns_records(name,**kwargs)
          resolver(**kwargs).get_ns_records(name.to_s)
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
        def self.get_nameservers(name,**kwargs)
          resolver(**kwargs).get_nameservers(name.to_s)
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
        def self.get_ptr_record(ip,**kwargs)
          resolver(**kwargs).get_ptr_record(ip.to_s)
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
        def self.get_ptr_name(ip,**kwargs)
          resolver(**kwargs).get_ptr_name(ip.to_s)
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
        def self.get_ptr_records(ip,**kwargs)
          resolver(**kwargs).get_ptr_records(ip.to_s)
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
        def self.get_ptr_names(ip,**kwargs)
          resolver(**kwargs).get_ptr_names(ip.to_s)
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
        def self.get_soa_record(name,**kwargs)
          resolver(**kwargs).get_soa_record(name.to_s)
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
        def self.get_txt_record(name,**kwargs)
          resolver(**kwargs).get_txt_record(name.to_s)
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
        def self.get_txt_string(name,**kwargs)
          resolver(**kwargs).get_txt_string(name.to_s)
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
        def self.get_txt_records(name,**kwargs)
          resolver(**kwargs).get_txt_records(name.to_s)
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
        def self.get_txt_strings(name,**kwargs)
          resolver(**kwargs).get_txt_strings(name.to_s)
        end
      end
    end
  end
end
