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
require 'ronin/support/network/dns/idn'

require 'resolv'

module Ronin
  module Support
    module Network
      module DNS
        #
        # Wraps around [Resolv::DNS].
        #
        # [Resolv::DNS]: https://rubydoc.info/stdlib/resolv/Resolv/DNS
        #
        # @api semipublic
        #
        # @since 1.0.0
        #
        class Resolver

          # The nameserver(s) to query.
          #
          # @return [Array<String>]
          attr_reader :nameservers

          #
          # Initializes the resolver.
          #
          # @param [Array<String>] nameservers
          #   The nameserver(s) to query.
          #
          # @param [String, nil] nameserver
          #   The optional singular nameserver to query.
          #
          # @example Creating a DNS resolver with a single nameserver:
          #   resolver = Resolver.new(nameserver: '1.1.1.1')
          #
          # @example Creating a DNS resolver with multiple nameservers:
          #   resolver = Resolver.new(nameservers: ['1.1.1.1', '8.8.8.8'])
          #
          def initialize(nameservers: self.class.default_nameservers,
                         nameserver:  nil)
            @nameservers = if nameserver then [nameserver]
                           else               nameservers
                           end

            @resolver = Resolv::DNS.new(nameserver: @nameservers)
          end

          #
          # The system's nameserver(s) to use by default.
          #
          # @return [Array<String>]
          #   The nameserver(s) IP addresses.
          #
          def self.default_nameservers
            @default_nameservers ||= Resolv::DNS::Config.default_config_hash[:nameserver]
          end

          #
          # Queries the first IP address for the given host name.
          #
          # @param [String] host
          #   The host name to query.
          #
          # @return [String, nil]
          #   The first IP address for the host name or `nil` if the host name
          #   has no IP addresses.
          #
          def get_address(host)
            host = IDN.to_ascii(host)

            begin
              @resolver.getaddress(host).to_s
            rescue Resolv::ResolvError
            end
          end

          #
          # Queries all IP addresses for the given host name.
          #
          # @param [String] host
          #   The host name to query.
          #
          # @return [Array<String>]
          #   The IP addresses for the host name.
          #
          def get_addresses(host)
            host = IDN.to_ascii(host)

            addresses = @resolver.getaddresses(host)
            addresses.map!(&:to_s)
            return addresses
          end

          #
          # Reverse-queries the first host name for the given IP address.
          #
          # @param [String] ip
          #   The IP address to reverse lookup.
          #
          # @return [String, nil]
          #   The first host name associated with the given IP address or `nil`
          #   if no host names could be found for the IP address.
          #
          def get_name(ip)
            @resolver.getname(ip).to_s
          rescue Resolv::ResolvError
          end

          #
          # Reverse-queries all host names for the given IP address.
          #
          # @param [String] ip
          #   The IP address to reverse lookup.
          #
          # @return [Array<String>]
          #   The host names associated with the given IP address.
          #
          def get_names(ip)
            names = @resolver.getnames(ip)
            names.map!(&:to_s)
            names
          end

          # Mapping of record type names to the `Resolv::DNS::Resource::IN`
          # classes.
          #
          # @api private
          RECORD_TYPES = {
            a:     Resolv::DNS::Resource::IN::A,
            aaaa:  Resolv::DNS::Resource::IN::AAAA,
            any:   Resolv::DNS::Resource::IN::ANY,
            cname: Resolv::DNS::Resource::IN::CNAME,
            hinfo: Resolv::DNS::Resource::IN::HINFO,
            loc:   Resolv::DNS::Resource::IN::LOC,
            minfo: Resolv::DNS::Resource::IN::MINFO,
            mx:    Resolv::DNS::Resource::IN::MX,
            ns:    Resolv::DNS::Resource::IN::NS,
            ptr:   Resolv::DNS::Resource::IN::PTR,
            soa:   Resolv::DNS::Resource::IN::SOA,
            srv:   Resolv::DNS::Resource::IN::SRV,
            txt:   Resolv::DNS::Resource::IN::TXT,
            wks:   Resolv::DNS::Resource::IN::WKS
          }

          #
          # Queries a single matching DNS record for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @param [:a, :aaaa, :any, :cname, :hinfo, :loc, :minfo, :mx, :ns, :ptr, :soa, :srv, :txt, :wks] record_type
          #   The record type.
          #
          # @return [Resolv::DNS::Resource, nil]
          #   The matching DNS records or `nil` if no matching DNS records
          #   could be found.
          #
          # @raise [ArgumentError]
          #   An unlnown record type was given.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource
          #
          def get_record(name,record_type)
            name = IDN.to_ascii(name)

            record_class = RECORD_TYPES.fetch(record_type) do
              raise(ArgumentError,"record type (#{record_type.inspect}) must be #{RECORD_TYPES.keys.map(&:inspect).join(', ')}")
            end

            begin
              @resolver.getresource(name,record_class)
            rescue Resolv::ResolvError
            end
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
          # @return [Array<Resolv::DNS::Resource>]
          #   All matching DNS records.
          #
          # @raise [ArgumentError]
          #   An unlnown record type was given.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource
          #
          def get_records(name,record_type)
            name = IDN.to_ascii(name)

            record_class = RECORD_TYPES.fetch(record_type) do
              raise(ArgumentError,"record type (#{record_type.inspect}) must be #{RECORD_TYPES.keys.map(&:inspect).join(', ')}")
            end

            @resolver.getresources(name,record_class)
          end

          #
          # Queries all records of the host name using the `ANY` DNS query.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource>]
          #   All of the DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/ANY
          #
          def get_any_records(name)
            get_records(name,:any)
          end

          #
          # Queries the `CNAME` record for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::IN::CNAME, nil]
          #   The `CNAME` record or `nil` if the host name has no `CNAME`
          #   record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/CNAME
          #
          def get_cname_record(name)
            get_record(name,:cname)
          end

          #
          # Queries the canonical name for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [String, nil]
          #   The canonical name for the host or `nil` if the host has no
          #   `CNAME` record.
          #
          def get_cname(name)
            if (cname = get_cname_record(name))
              cname.name.to_s
            end
          end

          #
          # Queries the `HINFO` record for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::IN::HINFO, nil]
          #   The `HINFO` DNS record or `nil` if the host name has no `HINFO`
          #   record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/HINFO
          #
          def get_hinfo_record(name)
            get_record(name,:hinfo)
          end

          #
          # Queries the first `A` record belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::IN::A, nil]
          #   The first `A` DNS record or `nil` if the host name has no `A`
          #   records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/A
          #
          def get_a_record(name)
            get_record(name,:a)
          end

          #
          # Queries the first IPv4 address belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [String, nil]
          #   The first IPv4 address belonging to the host name.
          #
          def get_a_address(name)
            if (a = get_a_record(name))
              a.address.to_s
            end
          end

          #
          # Queries all `A` records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource::IN::A>]
          #   All of the `A` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/A
          #
          def get_a_records(name)
            get_records(name,:a)
          end

          #
          # Queries all IPv4 addresses belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<String>]
          #   All of the IPv4 addresses belonging to the host name.
          #
          def get_a_addresses(name)
            records = get_a_records(name)
            records.map! { |a| a.address.to_s }
            records
          end

          #
          # Queries the first `AAAA` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::IN::AAAA, nil]
          #   The first `AAAA` DNS record or `nil` if the host name has no
          #   `AAAA` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/AAAA
          #
          def get_aaaa_record(name)
            get_record(name,:aaaa)
          end

          #
          # Queries the first IPv6 address belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [String, nil]
          #   The first IPv6 address or `nil` if the host name has no IPv6
          #   addresses.
          #
          def get_aaaa_address(name)
            if (aaaa = get_aaaa_record(name))
              aaaa.address.to_s
            end
          end

          #
          # Queries all `AAAA` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource::IN::AAAA>]
          #   All of the `AAAA` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/AAAA
          #
          def get_aaaa_records(name)
            get_records(name,:aaaa)
          end

          #
          # Queries all IPv6 addresses belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<String>]
          #   All IPv6 addresses belonging to the host name.
          #
          def get_aaaa_addresses(name)
            records = get_aaaa_records(name)
            records.map! { |aaaa| aaaa.address.to_s }
            records
          end

          #
          # Queries all `SRV` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource::IN::SRV>]
          #   All `SRV` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/SRV
          #
          def get_srv_records(name)
            get_records(name,:srv)
          end

          #
          # Queries all `WKS` (Well-Known-Service) DNS records belonging to the
          # host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource::IN::WKS>]
          #   All `WKS` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/IN/WKS
          #
          def get_wks_records(name)
            get_records(name,:wks)
          end

          #
          # Queries the `LOC` (Location) DNS record of the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::LOC, nil]
          #   The `LOC` DNS record of the host name or `nil` if the host name
          #   has no `LOC` record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/LOC
          #
          def get_loc_record(name)
            get_record(name,:loc)
          end

          #
          # Queries the `MINFO` (Machine-Info) DNS record of the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::MINFO, nil]
          #   The `MINFO` DNS record of the host name or `nil` if the host name
          #   has no `MINFO` record.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/MINFO
          #
          def get_minfo_record(name)
            get_record(name,:minfo)
          end

          #
          # Queries all `MX` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource::MX>]
          #   All `MX` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/MX
          #
          def get_mx_records(name)
            get_records(name,:mx)
          end

          #
          # Queries the mailservers for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<String>]
          #   The host names of the mailservers serving the given host name.
          #
          def get_mailservers(name)
            records = get_mx_records(name)
            records.map! { |mx| mx.exchange.to_s }
            records
          end

          #
          # Queries all `NS` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource::NS>]
          #   All `NS` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/NS
          #
          def get_ns_records(name)
            get_records(name,:ns)
          end

          #
          # Queries the nameservers for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<String>]
          #   The host names of the nameservers serving the given host name.
          #
          def get_nameservers(name)
            records = get_ns_records(name)
            records.map! { |ns| ns.name.to_s }
            records
          end

          #
          # Queries the first `PTR` DNS record for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
          #
          # @return [Resolv::DNS::Resource::PTR, nil]
          #   The first `PTR` DNS record of the host name or `nil` if the host
          #   name has no `PTR` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/PTR
          #
          def get_ptr_record(ip)
            get_record(ip,:ptr)
          end

          #
          # Queries the `PTR` host name for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
          #
          # @return [String, nil]
          #   The host name that points to the given IP.
          #
          def get_ptr_name(ip)
            if (ptr = get_ptr_record(ip))
              ptr.name.to_s
            end
          end

          #
          # Queries all `PTR` DNS records for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
          #
          # @return [Array<Resolv::DNS::Resource::PTR>]
          #   All `PTR` DNS records for the given IP.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/PTR
          #
          def get_ptr_records(ip)
            get_records(ip,:ptr)
          end

          #
          # Queries all `PTR` names for the IP address.
          #
          # @param [String] ip
          #   The IP address to query.
          #
          # @return [Array<String>]
          #   The `PTR` names for the given IP.
          #
          def get_ptr_names(ip)
            records = get_ptr_records(ip)
            records.map! { |ptr| ptr.name.to_s }
            records
          end

          #
          # Queries the first `SOA` DNS record belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::SOA, nil]
          #   The first `SOA` DNS record for the host name or `nil` if the host
          #   name has no `SOA` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/SOA
          #
          def get_soa_record(name)
            get_record(name,:soa)
          end

          #
          # Queiries the first `TXT` DNS record belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Resolv::DNS::Resource::TXT, nil]
          #   The first `TXT` DNS record for the host name or `nil` if the host
          #   name has no `TXT` records.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/TXT
          #
          def get_txt_record(name)
            get_record(name,:txt)
          end

          #
          # Queries the first `TXT` string belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [String, nil]
          #   The first `TXT` string belonging to the host name or `nil` if the
          #   host name has no `TXT` records.
          #
          def get_txt_string(name)
            if (txt = get_txt_record(name))
              txt.strings.join
            end
          end

          #
          # Queries all `TXT` DNS records belonging to the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<Resolv::DNS::Resource::TXT>]
          #   All of the `TXT` DNS records belonging to the host name.
          #
          # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/TXT
          #
          def get_txt_records(name)
            get_records(name,:txt)
          end

          #
          # Queries all of the `TXT` string values of the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @return [Array<String>]
          #   All `TXT` string values belonging of the host name.
          #
          def get_txt_strings(name)
            get_txt_records(name).map(&:strings).flatten
          end

        end
      end
    end
  end
end
