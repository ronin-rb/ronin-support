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

require 'ronin/support/network/dns'
require 'ronin/support/network/ip_range/cidr'
require 'ronin/support/network/asn/dns_record'
require 'ronin/support/network/asn/list'

module Ronin
  module Support
    module Network
      #
      # Handles Autonomous System Numbers (ASN).
      #
      # ## Example
      #
      # Query the ASN record for a given IP address:
      #
      #     Network::ASN.query('4.2.2.1')
      #     # =>
      #     # #<Ronin::Support::Network::ASN::DNSRecord:0x00007f34424f4ac0
      #     #  @country_code="US",
      #     #  @name=nil,
      #     #  @number=3356,
      #     #  @range=#<Ronin::Support::Network::IPRange::CIDR: 4.0.0.0/9>>
      #
      # Query all ASN records for the given ISP name:
      #
      #     Network::ASN.list.name('LEVEL3').to_a
      #     # => [#<Ronin::Support::Network::ASN::Record:0x00007f344164ed18
      #     #      @country_code="US",
      #     #      @name="LEVEL3",
      #     #      @number=3356,
      #     #      @range=#<Ronin::Support::Network::IPRange::Range: 4.0.0.0 - 4.23.87.255>>,
      #     #     #<Ronin::Support::Network::ASN::Record:0x00007f344164d828
      #     #      @country_code="US",
      #     #      @name="LEVEL3",
      #     #      @number=3356,
      #     #      @range=#<Ronin::Support::Network::IPRange::Range: 4.23.90.0 - 4.23.91.255>>,
      #     #     ...]
      #
      # Query all IPv6 ASN records for a given company:
      #
      #     Network::ASN.list.name('GOOGLE').ipv6
      #     # =>
      #     # [#<Ronin::Support::Network::ASN::Record:0x00007fc45b411500
      #     #   @country_code="US",
      #     #   @name="GOOGLE",
      #     #   @number=15169,
      #     #   @range=
      #     #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:: - 2001:4860:1024:ffff:ffff:ffff:ffff:ffff>>,
      #     #  #<Ronin::Support::Network::ASN::Record:0x00007fc45b428d68
      #     #   @country_code="US",
      #     #   @name="GOOGLE",
      #     #   @number=15169,
      #     #   @range=
      #     #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:1026:: - 2001:4860:4804:ffff:ffff:ffff:ffff:ffff>>,
      #     #  #<Ronin::Support::Network::ASN::Record:0x00007fc45b44be08
      #     #   @country_code="US",
      #     #   @name="GOOGLE",
      #     #   @number=15169,
      #     #   @range=
      #     #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:4806:: - 2001:4860:4864:ffff:ffff:ffff:ffff:ffff>>,
      #     #  #<Ronin::Support::Network::ASN::Record:0x00007fc45b4562e0
      #     #   @country_code="US",
      #     #   @name="GOOGLE",
      #     #   @number=15169,
      #     #   @range=
      #     #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:4865:: - 2001:4860:ffff:ffff:ffff:ffff:ffff:ffff>>]
      #
      # Return all ASN numbers for a country:
      #
      #     Network::ASN.list.country('NZ').numbers
      #     # => #<Set:
      #     #     {45177,
      #     #      55759,
      #     #      55850,
      #     #      9500,
      #     #      ...}>
      #
      # Return all ASN names for a country:
      #
      #     Network::ASN.list.country_code('NZ').names
      #     # Network::ASN.list.country('NZ').names
      #     # => 
      #     # #<Set:
      #     #  {"DEVOLI-AS-AP Devoli",
      #     #   "MFAT-NET-NZ 195 Lambton Quay",
      #     #   "MERCURYNZ-AS-AP Mercury NZ Limited",
      #     #   ...}>
      #
      # @api public
      #
      # @since 1.0.0
      #
      module ASN
        #
        # Queries the ASN information for the given IP.
        #
        # @param [IP, IPAddr, String] ip
        #   The IP address to query.
        #
        # @return [Record, nil]
        #   The ASN record or `nil` if the IP address is not routed.
        #
        # @note
        #   Performs rDNS queries using `*.nmap.asn.cymru.com` for IPv4
        #   addresses and `*.nmap6.asn.cymru.com` for IPv6 addresses.
        #
        # @example
        #   Network::ASN.query('4.2.2.1')
        #   # => 
        #   # #<Ronin::Support::Network::ASN::DNSRecord:0x00007f34424f4ac0    
        #   #  @country_code="US",                                            
        #   #  @name=nil,                                                     
        #   #  @number=3356,                                                  
        #   #  @range=#<Ronin::Support::Network::IPRange::CIDR: 4.0.0.0/9>>   
        #
        def self.query(ip)
          ip = IPAddr.new(ip) unless ip.kind_of?(IPAddr)

          if ip.ipv6?
            zone   = 'nmap6.asn.cymru.com'
            suffix = 'ip6.arpa'
          else
            zone   = 'nmap.asn.cymru.com'
            suffix = 'in-addr.arpa'
          end

          name = ip.reverse.sub(suffix,zone)

          unless (string = DNS.get_txt_string(name))
            return nil
          end

          asn, cidr_range, country_code, *rest = string.split(' | ',5)
          asn = asn.to_i
          cidr_range = IPRange::CIDR.new(cidr_range)

          return DNSRecord.new(asn,cidr_range,country_code)
        end

        #
        # Downloads/updates then loads the cached file
        # (`~/.local/share/ronin/ronin-support/ip2asn-combined.tsv.gz`).
        #
        # @return [List]
        #   The loaded list file.
        #
        # @note
        #   The first access of {list} will take a while, as the entire ASN
        #   list will need to be downloaded and parsed.
        #
        # @example Query the ASN record for the given IP address:
        #   Network::ASN.list.ip('4.2.2.1')
        #   # =>
        #   # #<Ronin::Support::Network::ASN::Record:0x00007fc46207f818
        #   #  @country_code="US",
        #   #  @name="LEVEL3",
        #   #  @number=3356,
        #   #  @range=#<Ronin::Support::Network::IPRange::Range: 4.0.0.0 - 4.23.87.255>>
        #
        # @example Query all ASN records for the given ISP name:
        #   Network::ASN.list.name('LEVEL3').to_a
        #   # => [#<Ronin::Support::Network::ASN::Record:0x00007f344164ed18
        #   #      @country_code="US",
        #   #      @name="LEVEL3",
        #   #      @number=3356,
        #   #      @range=#<Ronin::Support::Network::IPRange::Range: 4.0.0.0 - 4.23.87.255>>,
        #   #     #<Ronin::Support::Network::ASN::Record:0x00007f344164d828
        #   #      @country_code="US",
        #   #      @name="LEVEL3",
        #   #      @number=3356,
        #   #      @range=#<Ronin::Support::Network::IPRange::Range: 4.23.90.0 - 4.23.91.255>>,
        #   #     ...]
        #
        # @example Query all IPv6 ASN records for a given company:
        #   Network::ASN.list.name('GOOGLE').ipv6
        #   # =>
        #   # [#<Ronin::Support::Network::ASN::Record:0x00007fc45b411500
        #   #   @country_code="US",
        #   #   @name="GOOGLE",
        #   #   @number=15169,
        #   #   @range=
        #   #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:: - 2001:4860:1024:ffff:ffff:ffff:ffff:ffff>>,
        #   #  #<Ronin::Support::Network::ASN::Record:0x00007fc45b428d68
        #   #   @country_code="US",
        #   #   @name="GOOGLE",
        #   #   @number=15169,
        #   #   @range=
        #   #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:1026:: - 2001:4860:4804:ffff:ffff:ffff:ffff:ffff>>,
        #   #  #<Ronin::Support::Network::ASN::Record:0x00007fc45b44be08
        #   #   @country_code="US",
        #   #   @name="GOOGLE",
        #   #   @number=15169,
        #   #   @range=
        #   #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:4806:: - 2001:4860:4864:ffff:ffff:ffff:ffff:ffff>>,
        #   #  #<Ronin::Support::Network::ASN::Record:0x00007fc45b4562e0
        #   #   @country_code="US",
        #   #   @name="GOOGLE",
        #   #   @number=15169,
        #   #   @range=
        #   #    #<Ronin::Support::Network::IPRange::Range: 2001:4860:4865:: - 2001:4860:ffff:ffff:ffff:ffff:ffff:ffff>>]
        #
        # @example Return all ASN numbers for a country:
        #   Network::ASN.list.country('NZ').numbers
        #   # => #<Set:
        #   #     {45177,
        #   #      55759,
        #   #      55850,
        #   #      9500,
        #   #      ...}>
        #
        # @example Return all ASN names for a country:
        #   Network::ASN.list.country_code('NZ').names
        #   # Network::ASN.list.country('NZ').names
        #   # => 
        #   # #<Set:
        #   #  {"DEVOLI-AS-AP Devoli",
        #   #   "MFAT-NET-NZ 195 Lambton Quay",
        #   #   "MERCURYNZ-AS-AP Mercury NZ Limited",
        #   #   ...}>
        #
        def self.list
          @list ||= (
            List.update
            List.load_file
          )
        end
      end
    end
  end
end
