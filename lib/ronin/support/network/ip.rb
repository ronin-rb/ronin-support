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
require 'ronin/support/network/host'
require 'ronin/support/text/patterns'

require 'combinatorics/list_comprehension'
require 'ipaddr'

module Ronin
  module Support
    module Network
      #
      # Represents a single IP address.
      #
      # @api public
      #
      # @since 1.0.0
      #
      class IP < IPAddr

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
                   when :ipv4, :v4, 4 then Text::Patterns::IPv4
                   when :ipv6, :v6, 6 then Text::Patterns::IPv6
                   else                    Text::Patterns::IP
                   end

          text.scan(regexp) do |match|
            yield match
          end

          return nil
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
        def get_name(**kwargs)
          DNS.get_name(self,**kwargs)
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
        def get_names(**kwargs)
          DNS.get_names(self,**kwargs)
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
        # @return [Host, nil]
        #   The hostname of the address.
        #
        def get_host(**kwargs)
          if (name = get_name(**kwargs))
            Host.new(name)
          end
        end

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
        # @return [Array<Host>]
        #   The hostnames of the address.
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
        def hosts
          @hosts ||= get_hosts
        end

        #
        # The primary host name of the address.
        #
        # @return [Host, nil]
        #   The host name or `nil` if the IP address has no host names.
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
          DNS.get_ptr_record(self,**kwargs)
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
          DNS.get_ptr_name(self,**kwargs)
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
          DNS.get_ptr_records(self,**kwargs)
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
          DNS.get_ptr_names(self,**kwargs)
        end

        alias to_str to_s

      end
    end
  end
end
