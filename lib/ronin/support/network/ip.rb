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
require 'ronin/support/text/patterns'

require 'combinatorics/list_comprehension'
require 'ipaddr'

module Ronin
  module Support
    module Network
      class IP < IPAddr

        include Enumerable

        # Socket families and IP address masks
        MASKS = {
          Socket::AF_INET  => IN4MASK,
          Socket::AF_INET6 => IN6MASK
        }

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
        # @api public
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
        # Iterates over each IP address within the IP Address range. Supports
        # both IPv4 and IPv6 address ranges.
        #
        # @param [String] cidr_or_glob
        #   The IP address range to iterate over.
        #   May be in standard CIDR notation or globbed format.
        #
        # @yield [ip]
        #   The block which will be passed each IP address contained within the
        #   IP address range.
        #
        # @yieldparam [String] ip
        #   An IP address within the IP address range.
        #
        # @return [nil]
        #
        # @example Enumerate through a CIDR range
        #   IPAddr.each('10.1.1.1/24') do |ip|
        #     puts ip
        #   end
        #
        # @example Enumerate through a globbed IP range
        #   IPAddr.each('10.1.1-5,10-20.*') do |ip|
        #     puts ip
        #   end
        #
        # @example Enumerate through a globbed IPv6 range
        #   IPAddr.each('::ff::02-0a::c3') do |ip|
        #     puts ip
        #   end
        #
        # @api public
        #
        def self.each(cidr_or_glob,&block)
          unless (cidr_or_glob.include?('*') ||
                  cidr_or_glob.include?(',') ||
                  cidr_or_glob.include?('-'))
            return new(cidr_or_glob).each(&block)
          end

          return enum_for(__method__,cidr_or_glob) unless block

          if cidr_or_glob.include?(':') # IPv6
            separator = ':'
            base      = 16

            format = lambda { |address|
              address.map { |number|
                case number
                when Integer then number.to_s(16)
                else              number
                end
              }.join(':')
            }
          else # IPv4
            separator = '.'
            base      = 10
            format    = lambda { |address| address.join('.') }
          end

          # split the address
          segments = cidr_or_glob.split(separator)
          ranges   = []

          # map the components of the address to numeric ranges
          segments.each do |segment|
            ranges << case segment
                      when '*'
                        (1..254)
                      when /[,-]/
                        segment.split(',').flat_map do |octet|
                          if octet.include?('-')
                            start, stop = octet.split('-',2)
                            start = start.to_i(base)
                            stop  = stop.to_i(base)

                            (start..stop).to_a
                          else
                            octet.to_i(base)
                          end
                        end
                      else
                        [segment]
                      end
          end

          # cycle through the address ranges
          ranges.comprehension { |address| yield format[address] }
          return nil
        end

        #
        # Iterates over each IP address that is included in the addresses
        # netmask. Supports both IPv4 and IPv6 addresses.
        #
        # @yield [ip]
        #   The block which will be passed every IP address covered be the
        #   netmask of the IPAddr object.
        #
        # @yieldparam [String] ip
        #   An IP address.
        #
        # @example
        #   netblock = IPAddr.new('10.1.1.1/24')
        #
        #   netblock.each do |ip|
        #     puts ip
        #   end
        #
        # @api public
        #
        def each
          return enum_for(__method__) unless block_given?

          family_mask = MASKS[@family]

          (0..((~@mask_addr) & family_mask)).each do |i|
            yield _to_string(@addr | i)
          end

          return self
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
        # @api public
        #
        def get_name(**kwargs)
          DNS.get_name(self,**kwargs)
        end

        #
        # @see #get_name
        #
        def reverse_lookup(**kwargs)
          get_name(**kwargs)
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
        # @return [Array<String>]
        #   The hostnames of the address.
        #
        # @api public
        #
        def get_names(**kwargs)
          DNS.get_names(self,**kwargs)
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

      end
    end
  end
end
