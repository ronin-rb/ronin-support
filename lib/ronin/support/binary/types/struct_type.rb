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

require 'ronin/support/binary/types/aggregate_type'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Represents a bounded array type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class StructType < AggregateType

          # The members of the structure type.
          #
          # @return [Hash{Symbol => Type}]
          attr_reader :members

          # The size of the structure type.
          #
          # @return [Integer, Float::INFINITY]
          attr_reader :size

          #
          # Initializes the structure type.
          #
          # @param [Hash{Symbol => Type}] members
          #   The members names and types of the structure type.
          #
          def initialize(members={})
            size = 0
            pack_string = ''

            members.each_value do |member|
              size        += member.size
              pack_string << member.pack_string
            end

            @members = members
            @size    = size

            super(pack_string: pack_string)
          end

          #
          # Initializes a new Hash for the structure's members.
          #
          # @return [Hash{Symbol => Object}]
          #   The default values for the new structure's members.
          #
          def initialize_value
            Hash[@members.map { |name,type|
              [name, type.initialize_value]
            }]
          end

          #
          # The number of members within the structure.
          #
          # @return [Integer]
          #
          def length
            @members.length
          end

          #
          # Calculates the total number of members that can exist within the
          # structure or it's array members or nested structures.
          #
          # @return [Integer, Float::INFINITY]
          #
          def total_length
            count = 0

            @members.each_value do |type|
              case type
              when AggregateType
                count += type.total_length
              else
                count += 1
              end
            end

            return count
          end

        end
      end
    end
  end
end
