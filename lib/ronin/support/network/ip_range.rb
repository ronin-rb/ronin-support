# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      #     IPRange.each('10.0.1-3.*') { |ip| puts ip }
      #     # 10.0.1.0
      #     # 10.0.1.1
      #     # ...
      #     # 10.0.1.254
      #     # 10.0.1.255
      #     # ...
      #     # 10.0.2.0
      #     # 10.0.2.1
      #     # ...
      #     # 10.0.2.254
      #     # 10.0.2.255
      #     # ...
      #     # 10.0.3.0
      #     # 10.0.3.1
      #     # ...
      #     # 10.0.3.254
      #     # 10.0.3.255
      #
      # @api public
      #
      # @since 1.0.0
      #
      class IPRange

        # Regular expression to match CIDR ranges or IP-glob ranges.
        #
        # @api private
        #
        # @since 1.1.0
        REGEX = /#{CIDR::REGEX}|#{Glob::REGEX}/

        # The parsed IP range.
        #
        # @return [CIDR, Glob]
        #
        # @api private
        #
        # @since 1.1.0
        attr_reader :range

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
        #   ip_range = IPRange.new('10.0.1-3.*')
        #
        # @raise [ArgumentError]
        #   The IP range was neither a CIDR range or a IP-glob range.
        #
        def initialize(string)
          @range = case string
                   when CIDR::REGEX then CIDR.new(string)
                   when Glob::REGEX then Glob.new(string)
                   else
                     raise(ArgumentError,"invalid IP range: #{string.inspect}")
                   end
        end

        #
        # Alias for {#initialize new}.
        #
        # @param [String] string
        #   The IP range to parse.
        #
        # @return [IPRange]
        #   The parsed IP range.
        #
        # @see #initialize
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
        #   IPRange.each('10.0.1-3.*') { |ip| puts ip }
        #   # 10.0.1.0
        #   # 10.0.1.1
        #   # ...
        #   # 10.0.1.254
        #   # 10.0.1.255
        #   # ...
        #   # 10.0.2.0
        #   # 10.0.2.1
        #   # ...
        #   # 10.0.2.254
        #   # 10.0.2.255
        #   # ...
        #   # 10.0.3.0
        #   # 10.0.3.1
        #   # ...
        #   # 10.0.3.254
        #   # 10.0.3.255
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
          string =~ CIDR::REGEX
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
          string =~ Glob::REGEX
        end

        #
        # The IP range string.
        #
        # @return [String]
        #
        # @see CIDR#string
        # @see Glob#string
        #
        def string
          @range.string
        end

        #
        # Determines if the IP range is IPv4.
        #
        # @return [Boolean]
        #
        # @see CIDR#ipv4?
        # @see Glob#ipv4?
        #
        def ipv4?
          @range.ipv4?
        end

        #
        # Determines if the IP range is IPv6.
        #
        # @return [Boolean]
        #
        # @see CIDR#ipv6?
        # @see Glob#ipv6?
        #
        def ipv6?
          @range.ipv6?
        end

        #
        # Determines whether the IP address exists within the IP range.
        #
        # @param [IP, IPAddr, String] ip
        #   The IP address to check.
        #
        # @return [Boolean]
        #   Indicates whether the IP address exists within the IP range.
        #
        # @since 1.1.0
        #
        def include?(ip)
          @range.include?(ip)
        end

        #
        # Compares the IP range to another IP range.
        #
        # @param [Object] other
        #   The other IP range.
        #
        # @return [Boolean]
        #
        # @since 1.1.0
        #
        def ==(other)
          other.kind_of?(self.class) && @range == other.range
        end

        #
        # Determines if the given IP range is a sub-set of the IP range.
        #
        # @param [IPRange, Enumerable<String>] other
        #   The other IP range.
        #
        # @return [Boolean]
        #
        # @see CIDR#===
        # @see Glob#===
        #
        # @since 1.1.0
        #
        def ===(other)
          case other
          when IPRange
            @range === other.range
          else
            @range === other
          end
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
        #   ip_range = IPRange.new('10.0.1-3.*')
        #   ip_range.each { |ip| puts ip }
        #   # 10.0.1.0
        #   # 10.0.1.1
        #   # ...
        #   # 10.0.1.254
        #   # 10.0.1.255
        #   # ...
        #   # 10.0.2.0
        #   # 10.0.2.1
        #   # ...
        #   # 10.0.2.254
        #   # 10.0.2.255
        #   # ...
        #   # 10.0.3.0
        #   # 10.0.3.1
        #   # ...
        #   # 10.0.3.254
        #   # 10.0.3.255
        #
        # @see CIDR#each
        # @see Glob#each
        #
        def each(&block)
          @range.each(&block)
        end

        #
        # The first IP address in the IP range.
        #
        # @return [String]
        #
        # @see CIDR#first
        # @see Glob#last
        #
        # @since 1.1.0
        #
        def first
          @range.first
        end

        #
        # The last IP address in the IP range.
        #
        # @return [String]
        #
        # @see CIDR#first
        # @see Glob#last
        #
        # @since 1.1.0
        #
        def last
          @range.last
        end

        #
        # Calculates the size of the IP range.
        #
        # @return [Integer]
        #
        # @see CIDR#size
        # @see Glob#size
        #
        # @since 1.1.0
        #
        def size
          @range.size
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
