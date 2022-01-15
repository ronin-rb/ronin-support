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

require 'ronin/extensions/resolv'
require 'ronin/extensions/regexp'

require 'ipaddr'
require 'combinatorics/list_comprehension'

class IPAddr

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
  # @param [Integer, Symbol] version
  #   The version of IP Address to scan for (`4`, `6`, `:v4` or `:v6`).
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
  def IPAddr.extract(text,version=nil,&block)
    return enum_for(__method__,text,version).to_a unless block_given?

    regexp = case version
             when :ipv4, :v4, 4 then Regexp::IPv4
             when :ipv6, :v6, 6 then Regexp::IPv6
             else                    Regexp::IP
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
  def IPAddr.each(cidr_or_glob,&block)
    unless (cidr_or_glob.include?('*') ||
            cidr_or_glob.include?(',') ||
            cidr_or_glob.include?('-'))
      return IPAddr.new(cidr_or_glob).each(&block)
    end

    return enum_for(__method__,cidr_or_glob) unless block

    if cidr_or_glob.include?('::')
      separator = '::'
      base      = 16

      prefix = if cidr_or_glob.start_with?('::') then '::'
               else                                   ''
               end

      format = lambda { |address|
        prefix + address.map { |i| '%.2x' % i }.join('::')
      }
    else
      separator = '.'
      base      = 10
      format    = lambda { |address| address.join('.') }
    end

    # split the address
    segments = cidr_or_glob.split(separator)
    ranges   = []
    
    # map the components of the address to numeric ranges
    segments.each do |segment|
      next if segment.empty?

      ranges << if segment == '*'
                  (1..254)
                else
                  segment.split(',').map { |octet|
                    if octet.include?('-')
                      start, stop = octet.split('-',2)

                      (start.to_i(base)..stop.to_i(base)).to_a
                    else
                      octet.to_i(base)
                    end
                  }.flatten
                end
    end

    # cycle through the address ranges
    ranges.comprehension { |address| yield format[address] }
    return nil
  end

  #
  # Resolves the host-names for the IP address.
  #
  # @param [String] nameserver
  #   The optional nameserver to query.
  #
  # @return [Array<String>]
  #   The host-names for the IP address.
  #
  # @api public
  #
  def lookup(nameserver=nil)
    Resolv.resolver(nameserver).getnames(self.to_s)
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

end
