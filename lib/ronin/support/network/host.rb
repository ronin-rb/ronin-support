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
require 'ronin/support/network/ip'
require 'ronin/support/network/tld'
require 'ronin/support/network/public_suffix'

module Ronin
  module Support
    module Network
      #
      # Represents a host or host name.
      #
      # ## Examples
      # 
      #     host = Host.new('www.example.com')
      #
      # Resolve parent domain:
      #
      #     host.domain
      #     # => #<Ronin::Support::Network::Domain: example.co.uk>
      #
      # Resolve IP addresses:
      #
      #     host.get_address
      #     # => "172.67.128.149"
      #     host.get_addresses
      #     # => ["104.21.2.18", "172.67.128.149"]
      #     host.get_ip
      #     # => #<Ronin::Support::Network::IP: 172.67.128.149>
      #     host.get_ips
      #     # => [#<Ronin::Support::Network::IP: 104.21.2.18>, #<Ronin::Support::Network::IP: 172.67.128.149>]
      #     host.ip
      #     # => #<Ronin::Support::Network::IP: 172.67.128.149>
      #     host.ips
      #     # => [#<Ronin::Support::Network::IP: 104.21.2.18>, #<Ronin::Support::Network::IP: 172.67.128.149>]
      #
      # Other DNS queries:
      #
      #     host = Host.new('www.github.com')
      #     host.get_record(:txt)
      #     # => #<Resolv::DNS::Resource::IN::TXT:0x00007f7e500777d8 @strings=["MS=ms58704441"], @ttl=3575>
      #     host.get_records(:txt)
      #     # => [#<Resolv::DNS::Resource::IN::TXT:0x00007f7e500777d8 @strings=["MS=ms58704441"], @ttl=3575>, ...]
      #     host.get_cname_record
      #     # => #<Resolv::DNS::Resource::IN::CNAME:0x00007f7e50063da0 @name=#<Resolv::DNS::Name: github.com.>, @ttl=3500>
      #     host.get_cname
      #     # => "github.com"
      #     host.cname
      #     # => "github.com"
      #     host.get_mx_records
      #     # => [#<Resolv::DNS::Resource::IN::MX:0x00007f7e50035658 @exchange=#<Resolv::DNS::Name: aspmx.l.google.com.>, @preference=1, @ttl=3600>, ...]
      #     host.get_mailservers
      #     # => ["alt1.aspmx.l.google.com",
      #           "alt4.aspmx.l.google.com",
      #           "alt3.aspmx.l.google.com",
      #           "alt2.aspmx.l.google.com",
      #           "aspmx.l.google.com"]
      #     host.mailservers
      #     # => ["alt1.aspmx.l.google.com",
      #           "alt4.aspmx.l.google.com",
      #           "alt3.aspmx.l.google.com",
      #           "alt2.aspmx.l.google.com",
      #           "aspmx.l.google.com"]
      #     host.get_ns_records
      #     # => [#<Resolv::DNS::Resource::IN::NS:0x00007f7e4f972258 @name=#<Resolv::DNS::Name: dns1.p08.nsone.net.>, @ttl=900>, ...]
      #     host.get_nameservers
      #     # => ["dns3.p08.nsone.net",
      #           "ns-1707.awsdns-21.co.uk",
      #           "dns2.p08.nsone.net",
      #           "ns-1283.awsdns-32.org",
      #           "dns4.p08.nsone.net",
      #           "ns-421.awsdns-52.com",
      #           "dns1.p08.nsone.net",
      #           "ns-520.awsdns-01.net"]
      #     host.nameservers
      #     # => ["dns3.p08.nsone.net",
      #           "ns-1707.awsdns-21.co.uk",
      #           "dns2.p08.nsone.net",
      #           "ns-1283.awsdns-32.org",
      #           "dns4.p08.nsone.net",
      #           "ns-421.awsdns-52.com",
      #           "dns1.p08.nsone.net",
      #           "ns-520.awsdns-01.net"]
      #     host.get_soa_record
      #     # => #<Resolv::DNS::Resource::IN::SOA:0x00007f7e4f63d0b0 @mname=#<Resolv::DNS::Name: ns-1707.awsdns-21.co.uk.>, @rname=#<Resolv::DNS::Name: awsdns-hostmaster.amazon.com.>, @serial=1, @refresh=7200, @retry=900, @expire=1209600, @minimum=86400, @ttl=880>
      #     host.soa_record
      #     # => #<Resolv::DNS::Resource::IN::SOA:0x00007f7e4f63d0b0 @mname=#<Resolv::DNS::Name: ns-1707.awsdns-21.co.uk.>, @rname=#<Resolv::DNS::Name: awsdns-hostmaster.amazon.com.>, @serial=1, @refresh=7200, @retry=900, @expire=1209600, @minimum=86400, @ttl=880>
      #     host.get_txt_record
      #     # => #<Resolv::DNS::Resource::IN::TXT:0x00007f7e4f8cbbb0 @strings=[\"adobe-idp-site-verification=b92c9e999aef825edc36e0a3d847d2dbad5b2fc0e05c79ddd7a16139b48ecf4b\"], @ttl=2887>
      #     host.get_txt_string
      #     # => "stripe-verification=f88ef17321660a01bab1660454192e014defa29ba7b8de9633c69d6b4912217f"
      #     host.get_txt_records
      #     # => [#<Resolv::DNS::Resource::IN::TXT:0x00007f7e4f67c648 @strings=[\"apple-domain-verification=RyQhdzTl6Z6x8ZP4\"], @ttl=2852>, ...]
      #     host.get_txt_strings
      #     # => ["apple-domain-verification=RyQhdzTl6Z6x8ZP4",
      #           "MS=ms58704441",
      #           "atlassian-domain-verification=jjgw98AKv2aeoYFxiL/VFaoyPkn3undEssTRuMg6C/3Fp/iqhkV4HVV7WjYlVeF8",
      #           "MS=6BF03E6AF5CB689E315FB6199603BABF2C88D805",
      #           "v=spf1 ip4:192.30.252.0/22 include:_netblocks.google.com include:_netblocks2.google.com include:_netblocks3.google.com include:spf.protection.outlook.com include:mail.zendesk.com include:_spf.salesforce.com include:servers.mcsv.net ip4:166.78.69.169 ip4:1",
      #           "66.78.69.170 ip4:166.78.71.131 ip4:167.89.101.2 ip4:167.89.101.192/28 ip4:192.254.112.60 ip4:192.254.112.98/31 ip4:192.254.113.10 ip4:192.254.113.101 ip4:192.254.114.176 ip4:62.253.227.114 ~all",
      #           "docusign=087098e3-3d46-47b7-9b4e-8a23028154cd",
      #           "google-site-verification=UTM-3akMgubp6tQtgEuAkYNYLyYAvpTnnSrDMWoDR3o",
      #           "stripe-verification=f88ef17321660a01bab1660454192e014defa29ba7b8de9633c69d6b4912217f",
      #           "adobe-idp-site-verification=b92c9e999aef825edc36e0a3d847d2dbad5b2fc0e05c79ddd7a16139b48ecf4b",
      #           "MS=ms44452932"]
      #     host.txt_strings
      #     # => ["apple-domain-verification=RyQhdzTl6Z6x8ZP4",
      #           "MS=ms58704441",
      #           "atlassian-domain-verification=jjgw98AKv2aeoYFxiL/VFaoyPkn3undEssTRuMg6C/3Fp/iqhkV4HVV7WjYlVeF8",
      #           "MS=6BF03E6AF5CB689E315FB6199603BABF2C88D805",
      #           "v=spf1 ip4:192.30.252.0/22 include:_netblocks.google.com include:_netblocks2.google.com include:_netblocks3.google.com include:spf.protection.outlook.com include:mail.zendesk.com include:_spf.salesforce.com include:servers.mcsv.net ip4:166.78.69.169 ip4:1",
      #           "66.78.69.170 ip4:166.78.71.131 ip4:167.89.101.2 ip4:167.89.101.192/28 ip4:192.254.112.60 ip4:192.254.112.98/31 ip4:192.254.113.10 ip4:192.254.113.101 ip4:192.254.114.176 ip4:62.253.227.114 ~all",
      #           "docusign=087098e3-3d46-47b7-9b4e-8a23028154cd",
      #           "google-site-verification=UTM-3akMgubp6tQtgEuAkYNYLyYAvpTnnSrDMWoDR3o",
      #           "stripe-verification=f88ef17321660a01bab1660454192e014defa29ba7b8de9633c69d6b4912217f",
      #           "adobe-idp-site-verification=b92c9e999aef825edc36e0a3d847d2dbad5b2fc0e05c79ddd7a16139b48ecf4b",
      #           "MS=ms44452932"]
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
        #   The host's hostname.
        #
        # @example
        #   host = Host.new('www.example.com')
        #
        def initialize(name)
          @name = name
        end

        #
        # Determines if the hostname is an [IDN] hostname.
        #
        # [IDN]: https://en.wikipedia.org/wiki/Internationalized_domain_name
        #
        # @return [Boolean]
        #
        def idn?
          @name !~ /\A[A-Za-z0-9._-]+\z/
        end

        #
        # Determines if the hostname is a [punycode] hostnmae.
        #
        # [punycode]: https://en.wikipedia.org/wiki/Punycode
        #
        # @return [Boolean]
        #
        def punycode?
          @name.include?('xn--')
        end

        #
        # The Top-Level Domain of the hostnmae.
        #
        # @return [String]
        #   The last component of the hostname.
        #
        # @raise [InvalidHostname]
        #   The hostname does not end with a valid TLD.
        #
        # @example
        #   host = Host.new('foo.bar.example.co.uk')
        #   host.tld
        #   # => "uk"
        #
        def tld
          @tld ||= TLD.list.split(@name).last
        end

        #
        # The public suffix of the hostname.
        #
        # @return [String]
        #   The suffix of the hostname (ex: `.co.uk`).
        #
        # @raise [InvalidHostname]
        #   The hostname does not end with a valid suffix.
        #
        # @example
        #   host = Host.new('foo.bar.example.co.uk')
        #   host.suffix
        #   # => "co.uk"
        #
        def suffix
          @suffix ||= PublicSuffix.list.split(@name).last
        end

        #
        # Returns the associated domain for the hostname.
        #
        # @return [Domain]
        #   The domain object derived from the hostname, without any sub-domain
        #   components (ex: `www`).
        #
        # @raise [InvalidHostname]
        #   The hostname does not end with a valid suffix.
        #
        # @example
        #   host = Host.new('foo.bar.example.co.uk')
        #   host.domain
        #   # => #<Ronin::Support::Network::Domain: example.co.uk>
        #
        # @note This method returns memoized data.
        #
        def domain
          @domain ||= begin
            domain, suffix = PublicSuffix.list.split(@name)

            if (last_dot = domain.rindex('.'))
              domain = domain[(last_dot+1)..]
            end

            Domain.new("#{domain}.#{suffix}")
          end
        end

        #
        # Creates a sub-domain under the hostname.
        #
        # @param [String] subname
        #   The sub-name to add under the hostname.
        #
        # @return [Host]
        #   The new sub-domain.
        #
        def subdomain(subname)
          Host.new("#{subname}.#{@name}")
        end

        #
        # Changes the suffix of the hostname.
        #
        # @param [String] new_suffix
        #   The new suffix for the hostname.
        #
        # @return [Host]
        #   The new host object with the new suffix.
        #
        # @raise [PublicSuffix::InvalidHostname]
        #   The hostname does not end with a valid suffix.
        #
        # @example
        #   host = Host.new('www.example.co.uk')
        #   host.change_suffix('.com')
        #   # => #<Ronin::Support::Network::Host: www.example.com>
        #
        def change_suffix(new_suffix)
          name, suffix = PublicSuffix.list.split(@name)
          new_suffix   = new_suffix.to_s

          if new_suffix.start_with?('.')
            return self.class.new("#{name}#{new_suffix}")
          else
            return self.class.new("#{name}.#{new_suffix}")
          end
        end

        alias change_tld change_suffix

        #
        # Enumerates over every hostname with a different TLD.
        #
        # @yield [host]
        #   The given block will be passed each hostname with a different TLD.
        #
        # @yieldparam [Host] host
        #   The new host object with a different TLD.
        #
        # @return [Enumerator]
        #   If no block is given, an enumerator will be returned.
        #
        def each_tld
          return enum_for(__method__) unless block_given?

          TLD.list.each do |tld|
            yield change_suffix(tld)
          end

          return nil
        end

        #
        # Enumerates over every hostname with a different public suffix.
        #
        # @param [:icann, :private, nil] type
        #   The optional specific type of suffixes to enumerate.
        #
        # @yield [host]
        #   The given block will be passed each hostname with a different
        #   public suffix.
        #
        # @yieldparam [Host] host
        #   The new host object with a different public suffix.
        #
        # @return [Enumerator]
        #   If no block is given, an enumerator will be returned.
        #
        def each_suffix(type: nil)
          return enum_for(__method__, type: type) unless block_given?

          PublicSuffix.list.each do |suffix|
            unless suffix.wildcard?
              if (type == nil) || (suffix.type == type)
                yield change_suffix(suffix)
              end
            end
          end

          return nil
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
        # @example
        #   host = Host.new('www.example.com')
        #   host.get_address
        #   # => "172.67.128.149"
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
        # @example
        #   host = Host.new('www.example.com')
        #   host.get_addresses
        #   # => ["104.21.2.18", "172.67.128.149"]
        #
        def get_addresses(**kwargs)
          DNS.resolver(**kwargs).get_addresses(@name)
        end

        #
        # The addreses of the hostname.
        #
        # @return [Array<String>]
        #   The addresses associated with the hostname.
        #
        # @example
        #   host = Host.new('www.example.com')
        #   host.addresses
        #   # => ["104.21.2.18", "172.67.128.149"]
        #
        # @note This method returns memoized data.
        #
        def addresses
          @addresses ||= get_addresses
        end

        #
        # Determines if the hostname has any addresses.
        #
        # @return [Boolean]
        #
        # @example
        #   host = Host.new('www.example.com')
        #   host.has_addresses?
        #   # => trun
        #   host = Host.new('www.does-not-exist.com')
        #   host.has_addresses?
        #   # => false
        #
        def has_addresses?
          !addresses.empty?
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
        # @example
        #   host = Host.new('www.example.com')
        #   host.get_ip
        #   # => #<Ronin::Support::Network::IP: 172.67.128.149>
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
        # @example
        #   host = Host.new('www.example.com')
        #   host.get_ips
        #   # => [#<Ronin::Support::Network::IP: 104.21.2.18>, #<Ronin::Support::Network::IP: 172.67.128.149>]
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
        # @example
        #   host = Host.new('www.example.com')
        #   host.ips
        #   # => [#<Ronin::Support::Network::IP: 104.21.2.18>, #<Ronin::Support::Network::IP: 172.67.128.149>]
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
        # @example
        #   host = Host.new('www.example.com')
        #   host.ip
        #   # => #<Ronin::Support::Network::IP: 104.21.2.18>
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
        # @param [:a, :aaaa, :any, :cname, :hinfo, :loc, :minfo, :mx, :ns, :ptr, :soa, :srv, :txt, :wks] record_type
        #   The record type to query for.
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
        # @example
        #   host = Host.new('www.example.com')
        #
        # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource
        # @see DNS::Resolver#get_record
        #
        def get_record(name=nil,record_type,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_record(name,record_type)
        end

        #
        # Queries all matching DNS records for the host name.
        #
        # @param [String, nil] name
        #   The optional record name to query.
        #
        # @param [:a, :aaaa, :any, :cname, :hinfo, :loc, :minfo, :mx, :ns, :ptr, :soa, :srv, :txt, :wks] record_type
        #   The record type to query for.
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
        # @see DNS::Resolver#get_records
        #
        def get_records(name=nil,record_type,**kwargs)
          name = if name then "#{name}.#{@name}"
                 else         @name
                 end

          DNS.resolver(**kwargs).get_records(name,record_type)
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
        # @see DNS::Resolver#get_any_records
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
        # @see DNS::Resolver#get_cname_record
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
        # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/CNAME
        # @see DNS::Resolver#get_cname
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
        # @see #get_cname
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
        # @see DNS::Resolver#get_hinfo_record
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
        # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/HINFO
        # @see #get_hinfo_record
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
        # @see DNS::Resolver#get_a_record
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
        # @see DNS::Resolver#get_a_address
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
        # @see DNS::Resolver#get_a_records
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
        # @see DNS::Resolver#get_a_addresses
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
        # @see DNS::Resolver#get_aaaa_record
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
        # @see DNS::Resolver#get_aaaa_address
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
        # @see DNS::Resolver#get_aaaa_records
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
        # @see DNS::Resolver#get_aaaa_addresses
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
        # @see DNS::Resolver#get_srv_records
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
        # @see DNS::Resolver#get_wks_records
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
        # @see DNS::Resolver#get_loc_record
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
        # @see DNS::Resolver#get_minfo_record
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
        # @see DNS::Resolver#get_mx_records
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
        # @see DNS::Resolver#get_mailservers
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
        # @see #get_mailservers
        #
        def mailservers
          @mailservers ||= get_mailservers
        end

        #
        # Determines if the hostname has any associated mailservers?
        #
        # @return [Boolean]
        #
        def has_mailservers?
          !mailservers.empty?
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
        # @see DNS::Resolver#get_ns_records
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
        # @see DNS::Resolver#get_nameservers
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
        # @see #get_nameservers
        #
        def nameservers
          @nameservers ||= get_nameservers
        end

        #
        # Determines if the hostname has any associated nameservers?
        #
        # @return [Boolean]
        #
        def has_nameservers?
          !nameservers.empty?
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
        # @see DNS::Resolver#get_soa_record
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
        # @see https://rubydoc.info/stdlib/resolv/Resolv/DNS/Resource/SOA
        # @see #get_soa_record
        #
        # @note This method returns memoized data.
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
        # @see DNS::Resolver#get_txt_record
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
        # @see DNS::Resolver#get_txt_string
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
        # @see DNS::Resolver#get_txt_records
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
        # @see DNS::Resolver#get_txt_strings
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
        # @see #get_txt_strings
        #
        def txt_strings
          @txt_strings ||= get_txt_strings
        end

        #
        # Converts the host to a String.
        #
        # @return [String]
        #   The host's hostname.
        #
        # @example
        #   host = Host.new('www.example.com')
        #   host.to_s
        #   # => "www.example.com"
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

        #
        # Inspects the host.
        #
        # @return [String]
        #   The inspected host object.
        #
        def inspect
          "#<#{self.class}: #{@name}>"
        end

      end
    end
  end
end

require 'ronin/support/network/domain'
