#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

require 'ipaddr'
require 'resolv'
require 'strscan'

class IPAddr

  include Enumerable

  # A regular expression for matching IPv4 Addresses.
  IPV4_REGEXP = /[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}/

  # A regular expression for matching IPv6 Addresses.
  IPV6_REGEXP = /:(:[0-9a-f]{1,4}){1,7}|([0-9a-f]{1,4}::?){1,7}[0-9a-f]{1,4}(:#{IPV4_REGEXP})?/

  # A regular expression for matching IP Addresses.
  REGEXP = /#{IPV4_REGEXP}|#{IPV6_REGEXP}/

  #
  # Extracts IP Addresses from text.
  #
  # @param [String] text
  #   The text to scan for IP Addresses.
  #
  # @param [Symbol] version
  #   The version of IP Address to scan for (`:ipv4` or `:ipv6`).
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
  def IPAddr.extract(text,version=nil,&block)
    regexp = case version
             when :ipv4
               IPV4_REGEXP
             when :ipv6
               IPV6_REGEXP
             else
               REGEXP
             end

    parser = StringScanner.new(text)

    if block_given?
      yield parser.matched while parser.skip_until(regexp)
      return nil
    else
      ips = []

      ips << parser.matched while parser.skip_until(regexp)
      return ips
    end
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
  #   IPAddr.each('10.1.1-5.*') do |ip|
  #     puts ip
  #   end
  #
  # @example Enumerate through a globbed IPv6 range
  #   IPAddr.each('::ff::02-0a::c3') do |ip|
  #     puts ip
  #   end
  #
  def IPAddr.each(cidr_or_glob,&block)
    unless (cidr_or_glob.include?('*') || cidr_or_glob.include?('-'))
      return IPAddr.new(cidr_or_glob).each(&block)
    end

    return enum_for(:each,cidr_or_glob) unless block

    if cidr_or_glob.include?('::')
      prefix = if cidr_or_glob[0,2] == '::'
                 '::'
               else
                 ''
               end

      separator = '::'
      base = 16

      format = lambda { |address|
        prefix + address.map { |i| '%.2x' % i }.join('::')
      }
    else
      separator = '.'
      base = 10

      format = lambda { |address| address.join('.') }
    end

    # split the address
    ranges = cidr_or_glob.split(separator)
    
    # map the components of the address to numeric ranges
    ranges.map! do |segment|
      if segment == '*'
        (1..254)
      elsif segment.include?('-')
        start, stop = segment.split('-',2).map { |i| i.to_i(base) }

        (start..stop)
      elsif !(segment.empty?)
        segment.to_i(base)
      end
    end
    ranges.compact!

    expand_range = lambda { |address,remaining|
      if remaining.empty?
        block.call(format.call(address))
      else
        n = remaining.first
        remaining = remaining[1..-1]

        if n.kind_of?(Range)
          n.each { |i| expand_range.call(address + [i], remaining) }
        else
          expand_range.call(address + [n], remaining)
        end
      end
    }

    expand_range.call([], ranges)
    return nil
  end

  #
  # Resolves the host-name for the IP address.
  #
  # @return [String, nil]
  #   The host-name for the IP address. If the IP address could not be
  #   resolved, `nil` will be returned.
  #
  def resolv_name
    begin
      Resolv.getname(self.to_s)
    rescue Resolv::ResolvError
    end
  end

  #
  # Resolves the host-names for the IP address.
  #
  # @return [Array<String>]
  #   The host-names for the IP address.
  #
  def resolv_names
    begin
      Resolv.getnames(self.to_s)
    rescue Resolv::ResolvError
      []
    end
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
  def each
    return enum_for(:each) unless block_given?

    case @family
    when Socket::AF_INET
      family_mask = IN4MASK
    when Socket::AF_INET6
      family_mask = IN6MASK
    end

    (0..((~@mask_addr) & family_mask)).each do |i|
      yield _to_string(@addr | i)
    end

    return self
  end

end
