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

module Ronin
  module Support
    module Network
      module ASN
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
          alias to_s name

          #
          # Determines if the ASN is routed.
          #
          # @return [Boolean]
          #
          def routed?
            !@country_code.nil? && !@name.nil?
          end

          #
          # Determines if the ASN is not routed.
          #
          # @return [Boolean]
          #
          def not_routed?
            @country_code.nil? || @name.nil?
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

        end
      end
    end
  end
end
