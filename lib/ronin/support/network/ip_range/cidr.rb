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

require 'ipaddr'

module Ronin
  module Support
    module Network
      class IPRange
        #
        # Represents CIDR notation IP ranges.
        #
        # ## Examples
        #
        #     cidr = Network::IP::CIDR.new('10.0.0.1/24')
        #     cidr.each { |ip puts }
        #     # 10.0.0.0
        #     # 10.0.0.1
        #     # ...
        #     # 10.0.0.254
        #     # 10.0.0.255
        #
        # @api public
        #
        # @since 1.0.0
        #
        class CIDR < IPAddr

          include Enumerable

          # The CIDR IP range string.
          #
          # @return [String]
          attr_reader :string

          #
          # Initializes and parses the CIDR range.
          #
          # @param [String] string
          #   The CIDR range string to parse.
          #
          # @param [Integer] family
          #   The address family for the CIDR range. This is mainly for
          #   backwards compatibility with `IPAddr#initialize`.
          #
          def initialize(string,family=Socket::AF_UNSPEC)
            super(string,family)

            @string = string
          end

          #
          # Alias for {#initialize new}.
          #
          # @param [String] string
          #   The CIDR range string to parse.
          #
          # @return [CIDR]
          #   The parsed CIDR range.
          #
          # @see #initialize
          #
          def self.parse(string)
            new(string)
          end

          # Socket families and IP address sizes
          SIZES = {
            Socket::AF_INET  => 32,
            Socket::AF_INET6 => 128
          }

          # Socket families and IP address masks
          MASKS = {
            Socket::AF_INET  => IN4MASK,
            Socket::AF_INET6 => IN6MASK
          }

          #
          # Calcualtes the CIDR range between two IP addresses.
          #
          # @param [String, IPAddr] first
          #   The first IP address in the CIDR range.
          #
          # @param [String, IPAddr] last
          #   The last IP Address in the CIDR range.
          #
          # @return [CIDR]
          #   The CIDR range between the two IP addresses.
          #
          # @example
          #   IPRange::CIDR.range("1.1.1.1","1.1.1.255")
          #   # => #<Ronin::Support::Network::IPRange::CIDR: 1.1.1.1/24>
          #
          def self.range(first,last)
            first_ip = case first
                       when IPAddr then first
                       else             IPAddr.new(first)
                       end

            last_ip = case last
                      when IPAddr then last
                      else             IPAddr.new(last)
                      end

            unless (first_ip.family == last_ip.family)
              raise(ArgumentError,"must specify two IPv4 or IPv6 addresses: #{first.inspect} #{last.inspect}")
            end

            num_bits  = SIZES.fetch(first_ip.family)
            diff_bits = first_ip.to_i ^ last_ip.to_i

            if diff_bits > 0
              prefix_length = num_bits - Math.log2(diff_bits).ceil

              return new("#{first_ip}/#{prefix_length}")
            else
              return new(first_ip.to_s)
            end
          end

          #
          # Enumerates over each IP address that is included in the addresses
          # netmask. Supports both IPv4 and IPv6 addresses.
          #
          # @param [String] string
          #   The CIDR range string to parse and enumerate over.
          #
          # @yield [ip]
          #   The block which will be passed every IP address covered be the
          #   netmask of the IPAddr object.
          #
          # @yieldparam [String] ip
          #   An IP address.
          #
          # @example
          #   IPRange::CIDR.each('10.0.0.1/24') { |ip| puts ip }
          #   # 10.0.0.0
          #   # 10.0.0.1
          #   # ...
          #   # 10.0.0.254
          #   # 10.0.0.255
          #
          def self.each(string,&block)
            new(string).each(&block)
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
          # @return [self]
          #
          # @example
          #   cidr = IPAddr.new('10.1.1.1/24')
          #   cidr.each { |ip| puts ip }
          #   # 10.0.0.0
          #   # 10.0.0.1
          #   # ...
          #   # 10.0.0.254
          #   # 10.0.0.255
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
          # The first IP address of the CIDR Range.
          #
          # @return [String]
          #
          def first
            _to_string(@addr)
          end

          #
          # The last IP address of the CIDR range.
          #
          # @return [String]
          #
          def last
            _to_string(@addr | ~@mask_addr)
          end

          #
          # Converts the CIDR range back into a String.
          #
          # @return [String]
          #
          def to_s
            @string
          end

          #
          # Inspects the CIDR range.
          #
          # @return [String]
          #
          def inspect
            "#<#{self.class}: #{@string}>"
          end

        end
      end
    end
  end
end
