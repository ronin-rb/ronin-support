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

module Ronin
  module Support
    module Network
      module ASN
        #
        # Represents an individual ASN record.
        #
        class Record

          # The ASN number.
          #
          # @return [Integer]
          attr_reader :number

          # The IP range of the ASN record.
          #
          # @return [IPRange::CIDR, IPRange::Range]
          attr_reader :range

          # The country code of the ASN record.
          #
          # @return [String, nil]
          attr_reader :country_code

          # The name of the ASN record.
          #
          # @return [String, nil]
          attr_reader :name

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
          # @param [String] name
          #   The name of the ASN record.
          #
          def initialize(number,range,country_code,name)
            @number       = number
            @range        = range
            @country_code = country_code
            @name         = name
          end

          alias to_i number

          #
          # Determines if the ASN is routed.
          #
          # @return [Boolean]
          #
          def routed?
            @number != 0
          end

          #
          # Determines if the ASN is not routed.
          #
          # @return [Boolean]
          #
          def not_routed?
            @number == 0
          end

          #
          # Determines if the ASN record has an IPv4 IP range.
          #
          # @return [Boolean]
          #
          def ipv4?
            @range.ipv4?
          end

          #
          # Determines if the ASN record has an IPv6 IP range.
          #
          # @return [Boolean]
          #
          def ipv6?
            @range.ipv6?
          end

          #
          # Determines if the IP belongs to the ASN range.
          #
          # @param [IPAddr, String] ip
          #
          # @return [Boolean]
          #
          def include?(ip)
            @range.include?(ip)
          end

          #
          # Enumerates over every IP within the ASN range.
          #
          # @yield [ip]
          #
          # @yieldparam [IP] ip
          #
          # @return [Enumerator]
          #
          def each(&block)
            @range.each(&block)
          end

          #
          # Compares the record to another object.
          #
          # @param [Object] other
          #   The other object to compare to.
          #
          # @return [Boolean]
          #
          def ==(other)
            self.class == other.class &&
              @number       == other.number &&
              @range        == other.range &&
              @country_code == other.country_code &&
              @name         == other.name
          end

          #
          # Converts the record into a humanly readable String.
          #
          # @return [String]
          #   The String including the {#range}, {#number}, {#country_code},
          #   and {#name}.
          #
          def to_s
            if routed?
              "#{range} AS#{number} (#{country_code}) #{name}"
            else
              "#{range} Not routed"
            end
          end

        end
      end
    end
  end
end
