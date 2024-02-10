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

require 'combinatorics/list_comprehension'

module Ronin
  module Support
    module Network
      class IPRange
        #
        # Represents an IP-glob range.
        #
        # ## Examples
        #
        #     ip_range = IPRange::Glob.new('10.0.1-3.*/24')
        #     ip_range.each { |ip| puts ip }
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
        class Glob

          include Enumerable

          ipv4_octet       = /(?:\d{1,2}|1\d{2}|2[1-4]\d|25[0-5])/
          ipv4_octet_range = /#{ipv4_octet}(?:-#{ipv4_octet})?/
          ipv4_octet_list  = /(?:#{ipv4_octet_range}(?:,#{ipv4_octet_range})*|\*)/
          ipv4_addr        = /#{ipv4_octet_list}(?:\.#{ipv4_octet_list}){3}/

          # Regular expression that matches IPv4-glob ranges.
          #
          # @api private
          #
          # @since 1.1.0
          IPV4_REGEX = /\A#{ipv4_addr}\z/

          ipv6_octet       = /[0-9a-fA-F]{1,4}/
          ipv6_octet_range = /#{ipv6_octet}(?:-#{ipv6_octet})?/
          ipv6_octet_list  = /(?:#{ipv6_octet_range}(?:,#{ipv6_octet_range})*|\*)/

          # Regular expression that matches IPv6-glob ranges.
          #
          # @api private
          #
          # @since 1.1.0
          IPV6_REGEX = /\A(?:
            (?:#{ipv6_octet_list}:){6}#{ipv4_addr}|
            (?:#{ipv6_octet_list}:){5}#{ipv6_octet_list}:#{ipv4_addr}|
            (?:#{ipv6_octet_list}:){5}:#{ipv6_octet_list}:#{ipv4_addr}|
            (?:#{ipv6_octet_list}:){1,1}(?::#{ipv6_octet_list}){1,4}:#{ipv4_addr}|
            (?:#{ipv6_octet_list}:){1,2}(?::#{ipv6_octet_list}){1,3}:#{ipv4_addr}|
            (?:#{ipv6_octet_list}:){1,3}(?::#{ipv6_octet_list}){1,2}:#{ipv4_addr}|
            (?:#{ipv6_octet_list}:){1,4}(?::#{ipv6_octet_list}){1,1}:#{ipv4_addr}|
            :(?::#{ipv6_octet_list}){1,5}:#{ipv4_addr}|
            (?:(?:#{ipv6_octet_list}:){1,5}|:):#{ipv4_addr}|
            (?:#{ipv6_octet_list}:){1,1}(?::#{ipv6_octet_list}){1,6}|
            (?:#{ipv6_octet_list}:){1,2}(?::#{ipv6_octet_list}){1,5}|
            (?:#{ipv6_octet_list}:){1,3}(?::#{ipv6_octet_list}){1,4}|
            (?:#{ipv6_octet_list}:){1,4}(?::#{ipv6_octet_list}){1,3}|
            (?:#{ipv6_octet_list}:){1,5}(?::#{ipv6_octet_list}){1,2}|
            (?:#{ipv6_octet_list}:){1,6}(?::#{ipv6_octet_list}){1,1}|
            #{ipv6_octet_list}(?::#{ipv6_octet_list}){7}|
            :(?::#{ipv6_octet_list}){1,7}|
            (?:(?:#{ipv6_octet_list}:){1,7}|:):
          )\z/x

          # Regular expression to match IP-glob ranges.
          #
          # @api private
          #
          # @since 1.1.0
          REGEX = /#{IPV4_REGEX}|#{IPV6_REGEX}/

          # The IP glob string.
          #
          # @return [String]
          attr_reader :string

          #
          # Initializes and parses the IP-glob range.
          #
          # @param [String] string
          #   The IP-glob string to parse.
          #
          # @raise [ArgumentError]
          #   The IP-glob string was neither a valid IPv4 or IPv6 glob address.
          #
          def initialize(string)
            @string = string

            case string
            when IPV6_REGEX
              @version   = 6
              @base      = 16
              @formatter = method(:format_ipv6_address)

              separator   = ':'
              octet_range = (0..0xffff)
            when IPV4_REGEX
              @version   = 4
              @base      = 10
              @formatter = method(:format_ipv4_address)

              separator   = '.'
              octet_range = (0..255)
            else
              raise(ArgumentError,"invalid IP-glob range: #{string.inspect}")
            end

            @ranges = string.split(separator).map do |segment|
              if    segment == '*'        then octet_range
              elsif segment.include?(',') then parse_list(segment)
              elsif segment.include?('-') then parse_range(segment)
              else                             [segment]
              end
            end
          end

          #
          # Alias for {#initialize new}.
          #
          # @param [String] string
          #   The IP-glob string to parse.
          #
          # @return [Glob]
          #   The parsed IP-glob range.
          #
          # @see #initialize
          #
          def self.parse(string)
            new(string)
          end

          #
          # Enumerates over the IP-glob range.
          #
          # @param [String] string
          #   The IP-glob string to parse and enumerate over.
          #
          # @yield [ip]
          #   The block which will be passed each IP address contained within
          #   the IP address range.
          #
          # @yieldparam [String] ip
          #   An IP address within the IP address range.
          #
          # @return [self]
          #
          # @example Enumerate through a IPv4 glob range:
          #   IPRange::Glob.each('10.0.1-3.*') { |ip| puts ip }
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
          # @example Enumerate through a globbed IPv6 range:
          #   IPRange::Glob.each('::ff::02-0a::c3') { |ip| puts ip }
          #
          def self.each(string,&block)
            new(string).each(&block)
          end

          #
          # Determines if the IP-glob range is IPv4.
          #
          # @return [Boolean]
          #
          def ipv4?
            @version == 4
          end

          #
          # Determines if the IP-glob range is IPv6.
          #
          # @return [Boolean]
          #
          def ipv6?
            @version == 6
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
            super(ip.to_s)
          end

          #
          # Determines if the given IP range is a sub-set of the IP CIDR range.
          #
          # @param [Glob, CIDR, Enumerable<String>] other
          #   The other IP range.
          #
          # @return [Boolean]
          #
          # @since 1.1.0
          #
          def ===(other)
            other.all? { |ip| include?(ip) }
          end

          #
          # Enumerates over the IP-glob range.
          #
          # @yield [ip]
          #   The block which will be passed each IP address contained within
          #   the IP address range.
          #
          # @yieldparam [String] ip
          #   An IP address within the IP address range.
          #
          # @return [self]
          #
          # @example Enumerate through a IPv4 glob range:
          #   ip_range = IPRange::Glob.new('10.0.1-3.*')
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
          # @example Enumerate through a globbed IPv6 range:
          #   ip_range = IPRange::Glob.new('::ff::02-0a::c3')
          #   ip_range.each { |ip| puts ip }
          #
          def each
            return enum_for(__method__) unless block_given?

            # cycle through the address ranges
            @ranges.comprehension do |address|
              yield @formatter.call(address)
            end

            return self
          end

          #
          # The first address in the IP glob range.
          #
          # @return [String]
          #   The first IP address in the IP glob range.
          #
          # @since 1.1.0
          #
          def first
            @formatter.call(@ranges.map(&:first))
          end

          #
          # The last address in the IP glob range.
          #
          # @return [String]
          #   The last IP address in the IP glob range.
          #
          # @since 1.1.0
          #
          def last
            @formatter.call(@ranges.map(&:last))
          end

          #
          # Converts the IP-glob range back into a String.
          #
          # @return [String]
          #
          def to_s
            @string
          end

          #
          # Inspects the IP-glob range.
          #
          # @return [String]
          #
          def inspect
            "#<#{self.class}: #{@string}>"
          end

          private

          #
          # Parses a comma separated list of numbers or ranges (ex: `i,j,k-l`).
          #
          # @param [String] list
          #   The string to parse.
          #
          # @return [Array<Integer, Range>]
          #   The parsed list.
          #
          def parse_list(list)
            list.split(',').flat_map do |octet|
              if octet.include?('-')
                # i-j range
                parse_range(octet)
              else
                octet.to_i(@base)
              end
            end
          end

          #
          # Parses a range of numbers. (ex: `i-j`).
          #
          # @param [String] range
          #   The string to parse.
          #
          # @return [Range<Integer,Integer>]
          #   The parsed range.
          #
          def parse_range(range)
            start, stop = range.split('-',2)

            start = start.to_i(@base)
            stop  = stop.to_i(@base)

            (start..stop).to_a
          end

          #
          # Formats an IPv4 address.
          #
          # @param [Array<String, Integer>] parts
          #   The address parts to format.
          #
          # @return [String]
          #   The formatted IPv4 address.
          #
          def format_ipv4_address(parts)
            parts.join('.')
          end

          #
          # Formats an IPv6 address.
          #
          # @param [Array<String, Integer>] parts
          #   The address parts to format.
          #
          # @return [String]
          #   The formatted IPv6 address.
          #
          def format_ipv6_address(parts)
            parts.map { |part|
              case part
              when Integer then part.to_s(16)
              else              part
              end
            }.join(':')
          end

        end
      end
    end
  end
end
