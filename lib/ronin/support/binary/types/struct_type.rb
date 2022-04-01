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
        # Represents a `struct` type.
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

              if pack_string
                if member.pack_string then pack_string << member.pack_string
                else                       pack_string = nil
                end
              end
            end

            @members = members
            @size    = size

            super(pack_string: pack_string)
          end

          #
          # Creates a new Hash of the structure's uninitialized members.
          #
          # @return [Hash{Symbol => Object}]
          #   The uninitialized values for the new structure's members.
          #
          def uninitialized_value
            Hash[@members.map { |name,type|
              [name, type.uninitialized_value]
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
          # Packs a hash of values into the member's binary format.
          #
          # @param [Hash{Symbol => Integer, Float, String}] value
          #   The array to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          def pack(hash)
            if @pack_string
              super(hash)
            else
              buffer = String.new('', encoding: Encoding::ASCII_8BIT)

              @members.each do |name,type|
                buffer << type.pack(hash[name])
              end

              return buffer
            end
          end

          #
          # Unpacks a Hash of binary data.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [Hash{Symbol => Integer, Float, String, nil}]
          #   The unpacked hash.
          #
          def unpack(data)
            if @pack_string
              super(data)
            else
              hash   = {}
              offset = 0

              @members.each do |name,type|
                hash[name] = type.unpack(data.byteslice(offset,type.size))

                offset += type.size
              end

              return hash
            end
          end

          #
          # Enqueues a Hash of values onto the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [Hash] hash
          #   The hash to enqueue.
          #
          # @api private
          #
          def enqueue_value(values,hash)
            @members.each do |name,type|
              type.enqueue_value(values,hash[name])
            end
          end

          #
          # Dequeues a Hash from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [Hash]
          #   The dequeued hash.
          #
          # @api private
          #
          def dequeue_value(values)
            hash = {}

            @members.each do |name,type|
              hash[name] = type.dequeue_value(values)
            end

            return hash
          end

        end
      end
    end
  end
end
