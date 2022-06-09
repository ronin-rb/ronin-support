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
require 'ronin/support/network/ip_range/cidr'
require 'ronin/support/network/asn/record'
require 'ronin/support/network/asn/list'

module Ronin
  module Support
    module Network
      #
      # Handles Autonomous System Numbers (ASN).
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
        #   addresses, `*.nmap6.asn.cymru.com` for IPv6 addresses,
        #   and `AS<nnn>.asn.cymru.com` for ASN information.
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

          string   = DNS.get_txt_string("AS#{asn}.asn.cymru.com")
          assignee = string.split(' | ',5).last
          assignee.chomp!(", #{country_code}")

          return Record.new(asn,cidr_range,country_code,assignee)
        end

        #
        # Downloads/updates then loads the cached file
        # (`~/.local/share/ronin/ronin-support/ip2asn-combined.tsv.gz`).
        #
        # @return [List]
        #   The loaded list file.
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
