# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/exceptions'
require 'ronin/support/network/asn'
require 'ronin/support/network/dns'
require 'ronin/support/network/host'
require 'ronin/support/text/patterns'

require 'ipaddr'
require 'socket'
require 'net/https'

module Ronin
  module Support
    module Network
      #
      # Represents a single IP address.
      #
      # ## Examples
      #
      #     ip = IP.new('192.30.255.113')
      #
      # Reverse DNS lookup:
      #
      #     ip.get_name
      #     # => "lb-192-30-255-113-sea.github.com"
      #     ip.get_names
      #     # => ["lb-192-30-255-113-sea.github.com"]
      #     ip.get_host
      #     # => #<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>
      #     ip.get_hosts
      #     # => [#<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>]
      #     ip.host
      #     # => #<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>
      #     ip.hosts
      #     # => [#<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>]
      #
      # Get ASN information:
      #
      #     ip.asn
      #     # => #<Ronin::Support::Network::ASN::DNSRecord:0x00007f34142de598
      #     #     @country_code="US",
      #     #     @name=nil,
      #     #     @number=15133,
      #     #     @range=#<Ronin::Support::Network::IPRange::CIDR: 93.184.216.0/24>>
      #
      # @api public
      #
      # @since 1.0.0
      #
      class IP < IPAddr

        #
        # Initializes the IP address.
        #
        # @param [String] address
        #   The address of the IP.
        #
        # @param [Integer] family
        #   The address family for the CIDR range. This is mainly for
        #   backwards compatibility with `IPAddr#initialize`.
        #
        # @raise [InvalidIP]
        #   The given address is not a valid IP address.
        #
        # @example
        #   ip = IP.new('192.30.255.113')
        #
        # @note
        #   If the IP address has an `%iface` suffix, it will be removed from
        #   the IP address.
        #
        def initialize(address,family=Socket::AF_UNSPEC)
          case address
          when String
            # XXX: remove the %iface suffix for ruby < 3.1.0
            if address =~ /%.+$/
              address = address.sub(/%.+$/,'')
            end

            # pre-cache the given IP address String
            @address = address
          end

          begin
            super(address,family)
          rescue IPAddr::InvalidAddressError
            raise(InvalidIP,"invalid IP address: #{address.inspect}")
          end
        end

        protected

        #
        # Sets the IP address using the numeric IP address value.
        #
        # @param [Integer] addr
        #   The new numeric IP address value.
        #
        # @param [Integer] family
        #   Optional IP address family.
        #
        # @api private
        #
        def set(addr,*family)
          super(addr,*family)

          # unset the cached IP address since the numeric address has changed
          @address = nil
          return self
        end

        public

        # The URI for https://ipinfo.io/ip
        IPINFO_URI = URI::HTTPS.build(host: 'ipinfo.io', path: '/ip')

        #
        # Determines the current public IP address.
        #
        # @return [String, nil]
        #   The public IP address according to {https://ipinfo.io/ip}.
        #
        def self.public_address
          response = begin
                       Net::HTTP.get_response(IPINFO_URI)
                     rescue
                       # ignore any network failures
                     end

          if response && response.code == '200'
            return response.body
          end
        end

        #
        # Determines the current public IP.
        #
        # @return [IP, nil]
        #   The public IP according to {https://ipinfo.io/ip}.
        #
        def self.public_ip
          if (address = public_address)
            new(address)
          end
        end

        #
        # Determines all local IP addresses.
        #
        # @return [Array<String>]
        #
        # @example
        #   IP.local_addresses
        #   # => ["127.0.0.1", "192.168.1.42", "::1", "fe80::4ba:612f:9e2:37e2"]
        #
        def self.local_addresses
          Socket.ip_address_list.map do |addrinfo|
            address = addrinfo.ip_address

            if address =~ /%.+$/
              address = address.sub(/%.+$/,'')
            end

            address
          end
        end

        #
        # Determines all local IPs.
        #
        # @return [Array<IP>]
        #
        # @example
        #   IP.local_ips
        #   # => [#<Ronin::Support::Network::IP: 127.0.0.1>,
        #         #<Ronin::Support::Network::IP: 192.168.1.42>,
        #         #<Ronin::Support::Network::IP: ::1>,
        #         #<Ronin::Support::Network::IP: fe80::04ba:612f:09e2:37e2>]
        #
        def self.local_ips
          local_addresses.map(&method(:new))
        end

        #
        # Determines the local IP address.
        #
        # @return [String]
        #
        # @example
        #   IP.local_address
        #   # => "127.0.0.1"
        #
        def self.local_address
          Socket.ip_address_list.first.ip_address
        end

        #
        # Determines the local IP.
        #
        # @return [IP]
        #
        # @example
        #   IP.local_ip
        #   # => #<Ronin::Support::Network::IP: 127.0.0.1>
        #
        def self.local_ip
          new(local_address)
        end

        #
        # Extracts IP Addresses from text.
        #
        # @param [String] text
        #   The text to scan for IP Addresses.
        #
        # @param [4, :v4, :ipv4, 6, :v6, :ipv6] version
        #   The version of IP Address to extract.
        #
        # @yield [ip]
        #   The given block will be passed each extracted IP Address.
        #
        # @yieldparam [String] ip
        #   An IP Address from the text.
        #
        # @return [Array<String>]
        #   The IP Addresses found in the text.
        #
        # @example
        #   IPAddr.extract("Host: 127.0.0.1\n\rHost: 10.1.1.1\n\r")
        #   # => ["127.0.0.1", "10.1.1.1"]
        #
        # @example Extract only IPv4 addresses from a large amount of text:
        #   IPAddr.extract(text,:v4) do |ip|
        #     puts ip
        #   end
        #
        def self.extract(text,version=nil,&block)
          return enum_for(__method__,text,version).to_a unless block_given?

          regexp = case version
                   when :ipv4, :v4, 4 then Text::Patterns::IPV4_ADDR
                   when :ipv6, :v6, 6 then Text::Patterns::IPV6_ADDR
                   else                    Text::Patterns::IP_ADDR
                   end

          text.scan(regexp,&block)
          return nil
        end

        #
        # Determines if the address is a IPv4 broadcast addresses.
        #
        # @return [Boolean]
        #
        # @example
        #   ip = IPAddr.new('255.255.255.255')
        #   ip.broadcast?
        #   # => true
        #   ip = IPAddr.new('192.168.1.255')
        #   ip.broadcast?
        #   # => true
        #   ip = IPAddr.new('1.1.1.1')
        #   ip.broadcast?
        #   # => false
        #
        def broadcast?
          # NOTE: IPv6 does not have broadcast addresses
          ipv4? && (@addr & 0xff) == 0xff
        end

        #
        # Determines if the address is a "logical" IPv4 address.
        #
        # @return [Boolean]
        #
        # @example
        #   ip = IPAddr.new('0.0.0.0')
        #   ip.logical?
        #   # => true
        #   ip = IPAddr.new('192.168.1.0')
        #   ip.logical?
        #   # => true
        #   ip = IPAddr.new('1.1.1.1')
        #   ip.logical?
        #   # => false
        #
        def logical?
          ipv4? && (@addr & 0xff) == 0x00
        end

        #
        # The IP address.
        #
        # @return [String]
        #   The String version of the IP address.
        #
        def address
          @address ||= to_s
        end

        #
        # The Autonomous System Number (ASN) information for the IP address.
        #
        # @return [ASN::Record]
        #
        # @example
        #   ip = IP.new('93.184.216.34')
        #   ip.asn
        #   # => #<Ronin::Support::Network::ASN::DNSRecord:0x00007f34142de598
        #         @country_code="US",
        #         @name=nil,
        #         @number=15133,
        #         @range=#<Ronin::Support::Network::IPRange::CIDR: 93.184.216.0/24>>
        #
        def asn
          @asn ||= ASN.query(self)
        end

        #
        # Looks up the hostname of the address.
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
        # @example
        #   ip = IP.new('192.30.255.113')
        #   ip.get_name
        #   # => "lb-192-30-255-113-sea.github.com"
        #
        def get_name(**kwargs)
          DNS.get_name(@address,**kwargs)
        end

        alias reverse_lookup get_name

        #
        # Looks up all hostnames associated with the IP.
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
        # @example
        #   ip = IP.new('192.30.255.113')
        #   ip.get_names
        #   # => ["lb-192-30-255-113-sea.github.com"]
        #
        def get_names(**kwargs)
          DNS.get_names(@address,**kwargs)
        end

        #
        # Looks up the host for the IP.
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
        # @return [Host, nil]
        #   The host for the IP.
        #
        # @example
        #   ip = IP.new('192.30.255.113')
        #   ip.get_host
        #   # => #<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>
        #
        def get_host(**kwargs)
          if (name = get_name(**kwargs))
            Host.new(name)
          end
        end

        #
        # Looks up all hosts associated with the IP.
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
        # @return [Array<Host>]
        #   The hosts for the IP.
        #
        # @example
        #   ip = IP.new('192.30.255.113')
        #   ip.get_hosts
        #   # => [#<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>]
        #
        def get_hosts(**kwargs)
          get_names(**kwargs).map { |name| Host.new(name) }
        end

        #
        # The host names of the address.
        #
        # @return [Array<Host>]
        #   The host names of the address or an empty Array if the IP address
        #   has no host names.
        #
        # @example
        #   ip = IP.new('192.30.255.113')
        #   ip.hosts
        #   # => [#<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>]
        #
        # @note This method returns memoized data.
        #
        def hosts
          @hosts ||= get_hosts
        end

        #
        # The primary host name of the address.
        #
        # @return [Host, nil]
        #   The host name or `nil` if the IP address has no host names.
        #
        # @example
        #   ip = IP.new('192.30.255.113')
        #   ip.host
        #   # => #<Ronin::Support::Network::Host: lb-192-30-255-113-sea.github.com>
        #
        def host
          hosts.first
        end

        #
        # Queries the first `PTR` DNS record for the IP address.
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
        def get_ptr_record(**kwargs)
          DNS.get_ptr_record(@address,**kwargs)
        end

        #
        # Queries the `PTR` host name for the IP address.
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
        def get_ptr_name(**kwargs)
          DNS.get_ptr_name(@address,**kwargs)
        end

        #
        # Queries all `PTR` DNS records for the IP address.
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
        def get_ptr_records(**kwargs)
          DNS.get_ptr_records(@address,**kwargs)
        end

        #
        # Queries all `PTR` names for the IP address.
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
        def get_ptr_names(**kwargs)
          DNS.get_ptr_names(@address,**kwargs)
        end

        alias canonical to_string
        alias to_str to_s
        alias to_uint to_i

        #
        # Inspects the IP.
        #
        # @return [String]
        #   The inspected IP object.
        #
        def inspect
          "#<#{self.class}: #{@address}>"
        end

      end
    end
  end
end
