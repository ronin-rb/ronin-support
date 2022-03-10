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
require 'ronin/support/network/ip'

module Ronin
  module Support
    module Network
      #
      # Represents a host or host name.
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Host

        # The host name.
        #
        # @return [String]
        attr_reader :name

        #
        # Initializes the host.
        #
        # @param [String] name
        #
        def initialize(name)
          @name = name
        end

        #
        # Looks up the address of a hostname.
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
        def get_address(**kwargs)
          DNS.resolver(**kwargs).get_address(@name)
        end

        alias lookup get_address

        #
        # Looks up all addresses of a hostname.
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
        def get_addresses(**kwargs)
          DNS.resolver(**kwargs).get_addresses(@name)
        end

        #
        # Looks up the IPs of the host.
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
        #   The IP for the host.
        #
        # @api public
        #
        def get_ip(**kwargs)
          if (address = get_address(**kwargs))
            IP.new(address)
          end
        end

        #
        # Looks up all IPs for the host.
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
        # @return [Array<IP>]
        #   The IPs for the host.
        #
        # @api public
        #
        def get_ips(**kwargs)
          get_addresses(**kwargs).map { |address| IP.new(address) }
        end

        #
        # The IPs for the host.
        #
        # @return [Array<IP>]
        #   The IPs of the host or an empty Array if the host has no IP
        #   addresses.
        #
        # @note This method returns memoized data.
        #
        def ips
          @ips ||= get_ips
        end

        #
        # The IP for the host.
        #
        # @return [IP, nil]
        #   The IP for the host or `nil` if the host has no IP addresses.
        #
        def ip
          ips.first
        end

        #
        # Queries a single matching DNS record for the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
        #
        # @param [Class<Resolv::DNS::Resource>] type_class
        #   The record type class.
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
        def get_record(name=nil,type_class,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_record(name,type_class)
        end

        #
        # Queries all matching DNS records for the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
        #
        # @param [Class<Resolv::DNS::Resource>] type_class
        #   The record type class.
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
        def get_records(name=nil,type_class,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_records(name,type_class)
        end

        #
        # Queries all records of the host name using the `ANY` DNS query.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_any_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_any_records(name)
        end

        #
        # Queries the `CNAME` record for the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_cname_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_cname_record(name)
        end

        #
        # Queries the canonical name for the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_cname(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_cname(name)
        end

        #
        # The `CNAME` record for the host.
        #
        # @return [String, nil]
        #   The `CNAME` host name.
        #
        # @note This method returns memoized data.
        #
        def cname
          @cname ||= get_cname
        end

        #
        # Queries the `HINFO` record for the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_hinfo_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_hinfo_record(name)
        end

        #
        # The `HINFO` record for the host.
        #
        # @return [Resolv::DNS::Resource::IN::HINFO, nil]
        #   The `HINFO` DNS record or `nil` if the host name has no `HINFO`
        #   record.
        #
        # @note This method returns memoized data.
        #
        def hinfo_record
          @hinfo_record ||= get_hinfo_record
        end

        #
        # Queries the first `A` record belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_a_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_a_record(name)
        end

        #
        # Queries the first IPv4 address belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_a_address(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_a_address(name)
        end

        #
        # Queries all `A` records belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_a_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_a_records(name)
        end

        #
        # Queries all IPv4 addresses belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_a_addresses(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_a_addresses(name)
        end

        #
        # Queries the first `AAAA` DNS records belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_aaaa_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_aaaa_record(name)
        end

        #
        # Queries the first IPv6 address belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_aaaa_address(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_aaaa_address(name)
        end

        #
        # Queries all `AAAA` DNS records belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_aaaa_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_aaaa_records(name)
        end

        #
        # Queries all IPv6 addresses belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_aaaa_addresses(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_aaaa_addresses(name)
        end

        #
        # Queries all `SRV` DNS records belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_srv_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_srv_records(name)
        end

        #
        # Queries all `WKS` (Well-Known-Service) DNS records belonging to the
        # host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_wks_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_wks_records(name)
        end

        #
        # Queries the `LOC` (Location) DNS record of the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_loc_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_loc_record(name)
        end

        #
        # Queries the `MINFO` (Machine-Info) DNS record of the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_minfo_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_minfo_record(name)
        end

        #
        # Queries all `MX` DNS records belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_mx_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_mx_records(name)
        end

        #
        # Queries the mailservers for the host name.
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
        def get_mailservers(**kwargs)
          DNS.resolver(**kwargs).get_mailservers(@name)
        end

        #
        # The mailservers for the host.
        #
        # @return [Array<String>]
        #   The mailserver host names for the host.
        #
        # @note This method returns memoized data.
        #
        def mailservers
          @mailservers ||= get_mailservers
        end

        #
        # Queries all `NS` DNS records belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_ns_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_ns_records(name)
        end

        #
        # Queries the nameservers for the host name.
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
        def get_nameservers(**kwargs)
          DNS.resolver(**kwargs).get_nameservers(@name)
        end

        #
        # The nameservers for the host.
        #
        # @return [Array<String>]
        #   The nameserver IP addresses for the host.
        #
        # @note This method returns memoized data.
        #
        def nameservers
          @nameservers ||= get_nameservers
        end

        #
        # Queries the first `SOA` DNS record belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_soa_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_soa_record(name)
        end

        #
        # The `SOA` record for the host.
        #
        # @return [Resolv::DNS::Resource::SOA, nil]
        #   The first `SOA` DNS record for the host name or `nil` if the host
        #   name has no `SOA` records.
        #
        # @note This method returns memoized data.
        #
        # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/SOA
        #
        def soa_record
          @soa_record ||= get_soa_record
        end

        #
        # Queiries the first `TXT` DNS record belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_txt_record(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_txt_record(name)
        end

        #
        # Queries the first `TXT` string belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_txt_string(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_txt_string(name)
        end

        #
        # Queries all `TXT` DNS records belonging to the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_txt_records(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_txt_records(name)
        end

        #
        # Queries all of the `TXT` string values of the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
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
        def get_txt_strings(name=nil,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_txt_strings(name)
        end

        #
        # The `TXT` strings for the host.
        #
        # @return [Array<String>]
        #   All `TXT` string values belonging of the host name.
        #
        # @note This method returns memoized data.
        #
        def txt_strings
          @txt_strings ||= get_txt_strings
        end

        #
        # Converts the host to a String.
        #
        # @return [String]
        #
        def to_s
          @name.to_s
        end

        #
        # Converts the host to a String.
        #
        # @return [String]
        #
        def to_str
          @name.to_str
        end

      end
    end
  end
end
