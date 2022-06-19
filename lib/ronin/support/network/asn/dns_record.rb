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

require 'ronin/support/network/asn/record'
require 'ronin/support/network/dns'

require 'date'

module Ronin
  module Support
    module Network
      module ASN
        #
        # Represents a DNS record returned by
        # [Team Cymru's ASN rDNS service][1].
        #
        # [1]: https://team-cymru.com/community-services/ip-asn-mapping/
        #
        class DNSRecord < Record

          #
          # Initializes the record.
          #
          # @param [Integer] number
          #   The ASN number.
          #
          # @param [IPRange::CIDR, IPRange::Range] range
          #   The IP range of the ASN record.
          #
          # @param [String, nil] country_code
          #   The country code of the ASN record.
          #
          def initialize(number,range,country_code)
            super(number,range,country_code,nil)
          end

          #
          # The name of the ASN record.
          #
          # @return [String]
          #
          # @note
          #   Calling this method for the first time will lazy query
          #   `AS<nnn>.asn.cymru.com` for the additional ASN information.
          #
          def name
            query_additional_info! if @name.nil?
            return @name
          end

          #
          # The registry's name of the ASN record.
          #
          # @return [String]
          #
          # @note
          #   Calling this method for the first time will lazy query
          #   `AS<nnn>.asn.cymru.com` for the additional ASN information.
          #
          def registry
            query_additional_info! if @registry.nil?
            return @registry
          end

          #
          # The date the ASN record was registered.
          #
          # @return [Date]
          #
          # @note
          #   Calling this method for the first time will lazy query
          #   `AS<nnn>.asn.cymru.com` for the additional ASN information.
          #
          def date
            query_additional_info! if @date.nil?
            return @date
          end

          private

          #
          # Queries the additional information for the AS number.
          #
          def query_additional_info!
            string = DNS.get_txt_string("AS#{@number}.asn.cymru.com")

            _, _, @registry, @date, @name = string.split(' | ',5)

            @date = Date.parse(@date)
            @name.chomp!(", #{country_code}")
          end

        end
      end
    end
  end
end
