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

require 'ronin/support/network/ip_range/cidr'
require 'ronin/support/network/ip_range/glob'
require 'ronin/support/network/ip_range/range'

module Ronin
  module Support
    module Network
      #
      # Represents an IP range.
      #
      # ## Examples
      #
      # Enumerating over a CIDR range:
      #
      #     IPRange.each('10.0.0.1/24') { |ip| puts ip }
      #     # 10.0.0.0
      #     # 10.0.0.1
      #     # 10.0.0.2
      #     # ...
      #     # 10.0.0.254
      #     # 10.0.0.255
      #
      # Enumerating over a IP-glob range:
      #
      #     IPRange.each('10.0.1-3.*/24') { |ip| puts ip }
      #     # 10.0.1.1
      #     # 10.0.1.2
      #     # ...
      #     # 10.0.1.253
      #     # 10.0.1.254
      #     # ...
      #     # 10.0.2.1
      #     # 10.0.2.2
      #     # ...
      #     # 10.0.2.253
      #     # 10.0.2.254
      #     # ...
      #     # 10.0.3.1
      #     # 10.0.3.2
      #     # ...
      #     # 10.0.3.253
      #     # 10.0.3.254
      #
      # @api public
      #
      # @since 1.0.0
      #
      class IPRange

        #
        # Initializes the IP range.
        #
        # @param [String] string
        #   The IP range string.
        #
        # @example Initializing a CIDR IP range:
        #   ip_range = IPRange.new('10.0.0.1/24')
        #
        # @example Initializing an IP-glob range:
        #   ip_range = IPRange.new('10.0.1-3.*/24')
        #
        def initialize(string)
          @range = if self.class.glob?(string) then Glob.new(string)
                   else                             CIDR.new(string)
                   end
        end

        #
        # @see new
        #
        def self.parse(string)
          new(string)
        end

        #
        # Enumerates over each IP address that is included in the addresses
        # netmask. Supports both IPv4 and IPv6 addresses.
        #
        # @param [String] string
        #   The IP range string to parse and enumerate over.
        #
        # @yield [ip]
        #   The block which will be passed every IP address covered be the
        #   netmask of the IPAddr object.
        #
        # @yieldparam [String] ip
        #   An IP address.
        #
        # @return [Enumerator]
        #   If no block is given an Enumerator will be returned.
        #
        # @example Enumerating over a CIDR range:
        #   IPRange.each('10.0.0.1/24') { |ip| puts ip }
        #   # 10.0.0.0
        #   # 10.0.0.1
        #   # 10.0.0.2
        #   # ...
        #   # 10.0.0.254
        #   # 10.0.0.255
        #
        # @example Enumerating over a IP-glob range:
        #   IPRange.each('10.0.1-3.*/24') { |ip| puts ip }
        #   # 10.0.1.1
        #   # 10.0.1.2
        #   # ...
        #   # 10.0.1.253
        #   # 10.0.1.254
        #   # ...
        #   # 10.0.2.1
        #   # 10.0.2.2
        #   # ...
        #   # 10.0.2.253
        #   # 10.0.2.254
        #   # ...
        #   # 10.0.3.1
        #   # 10.0.3.2
        #   # ...
        #   # 10.0.3.253
        #   # 10.0.3.254
        #
        # @see #each
        #
        def self.each(string,&block)
          new(string).each(&block)
        end

        #
        # Determines if the IP range is a CIDR range.
        #
        # @param [String] string
        #   The IP range string to inspect.
        #
        # @return [Boolean]
        #   Indicates that the IP range is a CIDR range.
        #
        def self.cidr?(string)
          !glob?(string)
        end

        #
        # Determines if the IP range is a IP-glob range.
        #
        # @param [String] string
        #   The IP range string to inspect.
        #
        # @return [Boolean]
        #   Indicates that the IP range is a IP-glob range.
        #
        def self.glob?(string)
          string.include?('*') ||
          string.include?(',') ||
          string.include?('-')
        end

        #
        # The IP range string.
        #
        # @return [String]
        #
        def string
          @range.string
        end

        #
        # Determines if the IP range is IPv4.
        #
        # @return [Boolean]
        #
        def ipv4?
          @range.ipv4?
        end

        #
        # Determines if the IP range is IPv6.
        #
        # @return [Boolean]
        #
        def ipv6?
          @range.ipv6?
        end

        #
        # Enumerates over each IP address that is included in the addresses
        # netmask. Supports both IPv4 and IPv6 addresses.
        #
        # @yield [ip]
        #   The block which will be passed every IP address covered be the
        #   netmask of the IPAddr object.
        #
        # @yieldparam [String] ip
        #   An IP address.
        #
        # @return [Enumerator]
        #   If no block is given an Enumerator will be returned.
        #
        # @example Enumerating over a CIDR range:
        #   ip_range = IPRange.new('10.0.0.1/24')
        #   ip_range.each { |ip| puts ip }
        #   # 10.0.0.0
        #   # 10.0.0.1
        #   # 10.0.0.2
        #   # ...
        #   # 10.0.0.254
        #   # 10.0.0.255
        #
        # @example Enumerating over a IP-glob range:
        #   ip_range = IPRange.new('10.0.1-3.*/24')
        #   ip_range.each { |ip| puts ip }
        #   # 10.0.1.1
        #   # 10.0.1.2
        #   # ...
        #   # 10.0.1.253
        #   # 10.0.1.254
        #   # ...
        #   # 10.0.2.1
        #   # 10.0.2.2
        #   # ...
        #   # 10.0.2.253
        #   # 10.0.2.254
        #   # ...
        #   # 10.0.3.1
        #   # 10.0.3.2
        #   # ...
        #   # 10.0.3.253
        #   # 10.0.3.254
        #
        # @see CIDR#each
        # @see Glob#each
        #
        def each(&block)
          @range.each(&block)
        end

        #
        # Converts the IP range back to a String.
        #
        # @return [String]
        #
        # @see CIDR#to_s
        # @see Glob#to_s
        #
        def to_s
          @range.to_s
        end

        #
        # Inspects the IP range.
        #
        # @return [String]
        #
        def inspect
          "#<#{self.class}: #{@range.string}>"
        end

      end
    end
  end
end
