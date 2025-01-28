# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'set'

module Ronin
  module Support
    module Network
      module ASN
        #
        # A sub-set of ASN records.
        #
        class RecordSet

          include Enumerable

          # The records in the record set.
          #
          # @return [Array<Record>, Enumerator::Lazy<Record>]
          attr_reader :records

          #
          # Initializes the record-set.
          #
          # @param [Enumerator::Lazy<Record>] records
          #   The optional records to initialize the record set with.
          #
          # @api private
          #
          def initialize(records=[])
            @records = records
          end

          #
          # Adds a record to the record-set.
          #
          # @param [Record] record
          #
          # @return [self]
          #
          # @api private
          #
          def <<(record)
            @records << record
            return self
          end

          #
          # Enumerates over each IP within all of the records.
          #
          # @yield [record]
          #
          # @yieldparam [Record] record
          #
          # @return [Enumerator]
          #
          def each(&block)
            @records.each(&block)
          end

          #
          # Returns all AS numbers within the record set.
          #
          # @return [Set<Integer>]
          #
          def numbers
            set = Set.new
            each { |record| set << record.number }
            set
          end

          #
          # Selects all records with the matching AS number.
          #
          # @param [Integer] number
          #   The AS number.
          #
          # @return [RecordSet]
          #   The new sub-set of records.
          #
          def number(number)
            RecordSet.new(
              lazy.select { |record| record.number == number }
            )
          end

          #
          # Retruns all country codes within the record set.
          #
          # @return [Set<String>]
          #
          def countries
            set = Set.new
            each { |record| set << record.country_code }
            set
          end

          #
          # Selects all records with the matching country code.
          #
          # @param [String] country_code
          #   The two-letter country code.
          #
          # @return [RecordSet]
          #   The new sub-set of records.
          #
          def country(country_code)
            RecordSet.new(
              lazy.select { |record| record.country_code == country_code }
            )
          end

          #
          # Returns all IP ranges within the record set.
          #
          # @return [Array<IPRange::Range>]
          #
          def ranges
            map(&:range)
          end

          #
          # Selects only the records with IPv4 ranges.
          #
          # @return [RecordSet]
          #   The new sub-set of records.
          #
          def ipv4
            RecordSet.new(lazy.select(&:ipv4?))
          end

          #
          # Selects only the records with IPv6 ranges.
          #
          # @return [RecordSet]
          #   The new sub-set of records.
          #
          def ipv6
            RecordSet.new(lazy.select(&:ipv6?))
          end

          #
          # Finds the ASN record for the given IP address.
          #
          # @param [IP, IPaddr, String] ip
          #   The IP address to search for.
          #
          # @return [Record, nil]
          #   The ASN record for the IP address or `nil` if none could be found.
          #
          def ip(ip)
            find { |record| record.range.include?(ip) }
          end

          #
          # Determines if the IP belongs to any of the records.
          #
          # @param [IPAddr, String] ip
          #
          # @return [Boolean]
          #
          def include?(ip)
            !ip(ip).nil?
          end

          #
          # Returns all company names within the record-set.
          #
          # @return [Set<String>]
          #
          def names
            set = Set.new
            each { |record| set << record.name }
            set
          end

          #
          # Selects all records with the matching company name.
          #
          # @param [String] name
          #   The company name to search for.
          #
          # @return [RecordSet]
          #   The new sub-set of records.
          #
          def name(name)
            RecordSet.new(
              lazy.select { |record| record.name == name }
            )
          end

          #
          # The number of records within the record-set.
          #
          # @return [Integer]
          #
          def length
            @records.length
          end

          #
          # Converts the record-set to an Array of records.
          #
          # @return [Array<Range>]
          #
          def to_a
            @records.to_a
          end

        end
      end
    end
  end
end
