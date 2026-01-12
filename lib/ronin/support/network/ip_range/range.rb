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

require 'ronin/support/network/ip'

require 'ipaddr'

module Ronin
  module Support
    module Network
      class IPRange
        #
        # Represents an arbitrary range of IP addresses.
        #
        # ## Examples
        #
        #     range = Network::IPRange::Range.new('128.2.3.4','200.10.1.255')
        #     range.each { |ip| puts ip }
        #     # 128.2.3.4
        #     # 128.2.3.5
        #     # ...
        #     # 200.10.1.254
        #     # 200.10.1.255
        #
        # @since 1.0.0
        #
        # @api public
        #
        class Range

          include Enumerable

          # The first IP address of the ASN IP range.
          #
          # @return [IP]
          attr_reader :begin
          alias first begin

          # The last IP address of the ASN IP range.
          #
          # @return [IP]
          attr_reader :end
          alias last end

          # The common prefix shared by the first and last IP addresses in the
          # ASN IP range.
          #
          # @return [String]
          attr_reader :prefix

          # The address family of the ASN IP range.
          #
          # @return [Socket::AF_INET, Socket::AF_INET6]
          attr_reader :family

          #
          # Initializes the ASN IP range.
          #
          # @param [String] first
          #   The first IP address in the ASN IP range.
          #
          # @param [String] last
          #   The last IP address in the ASN IP range.
          #
          # @raise [ArgumentError]
          #   Both IP addresses must be either IPv4 addresses or IPv6 addresses.
          #
          # @api private
          #
          def initialize(first,last)
            @begin  = IP.new(first)
            @end    = IP.new(last)

            if (@begin.ipv4? && !@end.ipv4?) ||
               (@begin.ipv6? && !@end.ipv6?)
              raise(ArgumentError,"must specify two IPv4 or IPv6 addresses: #{first.inspect} #{last.inspect}")
            end

            @prefix = self.class.prefix(first,last)
            @family = @begin.family

            @begin_uint = @begin.to_i
            @end_uint   = @end.to_i
          end

          #
          # Finds the common prefix of two IP addresses.
          #
          # @param [String] first
          #   The first IP address of the ASN IP range.
          #
          # @param [String] last
          #   The last IP address of the ASN IP range.
          #
          # @return [String]
          #   The common prefix shared by both IPs.
          #
          # @api private
          #
          def self.prefix(first,last)
            min_length = [first.length, last.length].min

            min_length.times do |index|
              if first[index] != last[index]
                return first[0,index]
              end
            end

            return first
          end

          #
          # Determines whether the IP range is an IPv4 range.
          #
          # @return [Boolean]
          #
          def ipv4?
            @begin.ipv4?
          end

          #
          # Determines whether the IP range is an IPv6 range.
          #
          # @return [Boolean]
          #
          def ipv6?
            @end.ipv6?
          end

          #
          # Determines if the given IP belongs to the ASN IP range.
          #
          # @param [IP, IPAddr, String] ip
          #   The IP to test.
          #
          # @return [Boolean]
          #   Specifies whether the IP is or is not within the ASN IP range.
          #
          def include?(ip)
            ip      = IPAddr.new(ip) unless ip.kind_of?(IPAddr)
            ip_uint = ip.to_i

            return (ip_uint >= @begin_uint) && (ip_uint <= @end_uint)
          end

          #
          # Enumerates over every IP address in the ASN IP range.
          #
          # @yield [ip]
          #   If a block is given, it will be passed every IP within the ASN
          #   IP range.
          #
          # @yieldparam [IP] ip
          #   An IP within the ASN IP range.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator will be returned.
          #
          # @example
          #   range = IPRange::Range.new('1.1.1.1','1.1.3.42')
          #   range.each { |ip| puts ip }
          #   # 1.1.1.1
          #   # 1.1.1.2
          #   # ...
          #   # 1.1.3.41
          #   # 1.1.3.42
          #
          def each
            return enum_for(__method__) unless block_given?

            ipaddr = @begin.clone

            (@begin_uint..@end_uint).each do |ip_uint|
              ipaddr.send(:set,ip_uint)
              yield ipaddr.to_s
            end

            return self
          end

          #
          # Compares the IP range to another object.
          #
          # @param [Object] other
          #   The other object to compare to.
          #
          # @return [Boolean]
          #
          def ==(other)
            self.class == other.class &&
              self.begin == other.begin &&
              self.end   == other.end
          end

          #
          # Determines if the given IP range is a sub-set of the IP range.
          #
          # @param [IPRange::Range, CIDR, Glob, Enumerable<String>] other
          #   The other IP range.
          #
          # @return [Boolean]
          #
          # @since 1.1.0
          #
          def ===(other)
            case other
            when IPRange::Range
              self.begin <= other.begin && self.end >= other.end
            when Enumerable
              other.all? { |ip| include?(ip) }
            else
              false
            end
          end

          #
          # Calculates the size of the IP range.
          #
          # @return [Integer]
          #
          # @since 1.1.0
          #
          def size
            (@end_uint - @begin_uint) + 1
          end

          #
          # Converts the IP range to a String.
          #
          # @return [String]
          #
          def to_s
            "#{@begin} - #{@end}"
          end

          #
          # Inspects the IP range.
          #
          # @return [String]
          #
          def inspect
            "#<#{self.class}: #{self}>"
          end

        end
      end
    end
  end
end
