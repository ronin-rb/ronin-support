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
        # Represents a `union` type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class UnionType < AggregateType

          #
          # Represents a member within a union.
          #
          # @api private
          #
          # @since 1.0.0
          #
          class Member

            # The type of the member.
            #
            # @return [Type]
            attr_reader :type

            #
            # Initializes the member.
            #
            # @param [Type] type
            #   The type of the member.
            #
            def initialize(type)
              @type = type
            end

            #
            # The offset of the member within the union.
            #
            # @return [0]
            #
            # @note This method is mainly for compatibility with
            # {StructType::Member#offset}.
            #
            def offset
              0
            end

            #
            # The size, in bytes, of the member within the union.
            #
            # @return [Integer]
            #
            def size
              @type.size
            end

            #
            # The alignment, in bytes, of the member within the union.
            #
            # @return [Integer]
            #
            def alignment
              @type.alignment
            end

          end

          # The members of the union type.
          #
          # @return [Hash{Symbol => Member}]
          attr_reader :members

          # The size of the union type.
          #
          # @return [Integer, Float::INFINITY]
          attr_reader :size

          # The alignment, in bytes, for the union type, so that all members
          # within the union type are themselves aligned.
          #
          # @return [Integer]
          attr_reader :alignment

          #
          # Initializes the union type.
          #
          # @param [Hash{Symbol => Member}] members
          #   The members for the union type.
          #
          def initialize(members, size: , alignment: )
            @members   = members
            @size      = size
            @alignment = alignment

            super(pack_string: nil)
          end

          #
          # Builds the union type from the given fields.
          #
          # @param [Hash{Symbol => Type}] fields
          #   The field names and types for the union type.
          #
          # @return [UnionType]
          #   The new union type.
          #
          def self.build(fields)
            members       = {}
            max_size      = 0
            max_alignment = 0

            fields.each do |name,type|
              members[name] = Member.new(type)

              # omit infinite sizes from the union size
              if (type.size > max_size) && (type.size != Float::INFINITY)
                max_size = type.size
              end

              max_alignment = type.alignment if type.alignment > max_alignment
            end

            return new(members, size: max_size, alignment: max_alignment)
          end

          #
          # Creates a new Hash of the union's uninitialized members.
          #
          # @return [Hash]
          #   The uninitialized values for the new union's members.
          #
          def uninitialized_value
            Hash[@members.map { |name,member|
              [name, member.type.uninitialized_value]
            }]
          end

          #
          # The number of members within the union.
          #
          # @return [Integer]
          #
          def length
            @members.length
          end

          #
          # Creates a copy of the union type with a different {#alignment}.
          #
          # @param [Integer] new_alignment
          #   The new alignment for the new union type.
          #
          # @return [ScalarType]
          #   The new union type.
          #
          def align(new_alignment)
            self.class.new(@members, size:        @size,
                                     alignment:   new_alignment)
          end

          #
          # Packs a hash of values into the member's binary format.
          #
          # @param [Hash{Symbol => Integer, Float, String}] hash
          #   The hash of values to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          def pack(hash)
            unknown_keys = hash.keys - @members.keys

            unless unknown_keys.empty?
              raise(ArgumentError,"unknown union members: #{unknown_keys.map(&:inspect).join(', ')}")
            end

            buffer = if @size == Float::INFINITY
                       String.new(encoding: Encoding::ASCII_8BIT)
                     else
                       String.new("\0" * @size, encoding: Encoding::ASCII_8BIT)
                     end

            hash.each do |name,value|
              member = @members.fetch(name)
              data   = member.type.pack(value)

              if data.bytesize <= @size
                # if the packed data fits into buffer, overlay it
                buffer[0,data.bytesize] = data
              else
                # otherwise replace the buffer with the larger data
                buffer = data
              end
            end

            return buffer
          end

          #
          # Unpacks binary data into a Hash of values using the union's binary
          # format.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [Hash{Symbol => Integer, Float, String, nil}]
          #   The unpacked hash.
          #
          def unpack(data)
            hash = {}

            @members.each do |name,member|
              slice = if member.size == Float::INFINITY
                        data
                      else
                        data.byteslice(0,member.size)
                      end

              hash[name] = member.type.unpack(slice)
            end

            return hash
          end

        end
      end
    end
  end
end
