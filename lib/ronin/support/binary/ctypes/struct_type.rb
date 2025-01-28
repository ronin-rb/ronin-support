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

require 'ronin/support/binary/ctypes/aggregate_type'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Represents a `struct` type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class StructType < AggregateType

          #
          # Represents a member within a struct.
          #
          # @api private
          #
          # @since 1.0.0
          #
          class Member

            # The offset, in bytes, of the member from the beginning of the
            # struct.
            #
            # @return [Integer]
            attr_reader :offset

            # The type of the member.
            #
            # @return [Type]
            attr_reader :type

            #
            # Initializes the member.
            #
            # @param [Integer] offset
            #   The offset, in bytes, of the member from the beginning of the
            #   struct.
            #
            # @param [Type] type
            #   The type of the member.
            #
            def initialize(offset,type)
              @offset = offset
              @type   = type
            end

            #
            # Calculates padding for the given type at the given offset.
            #
            # @param [Integer] offset
            #
            # @param [Type] type
            #
            # @return [Integer]
            #
            # @api private
            #
            # @see https://en.wikipedia.org/wiki/Data_structure_alignment#Computing_padding
            #
            def self.padding_for(offset,type)
              (type.alignment - (offset % type.alignment)) % type.alignment
            end

            #
            # Calculates the pack string for the given type and optional
            # padding.
            #
            # @param [Type] type
            #
            # @param [Integer] padding
            #
            # @return [String]
            #   The pack string for the member.
            #
            # @api private
            #
            def self.pack_string_for(type,padding=0)
              if padding > 0 then "#{'x' * padding}#{type.pack_string}"
              else                type.pack_string
              end
            end

            #
            # The size, in bytes, of the member within the struct.
            #
            # @return [Integer]
            #
            def size
              @type.size
            end

            #
            # The alignment, in bytes, of the member within the struct.
            #
            # @return [Integer]
            #
            def alignment
              @type.alignment
            end

          end

          # The members of the struct type.
          #
          # @return [Hash{Symbol => Member}]
          attr_reader :members

          # The size of the struct type.
          #
          # @return [Integer, Float::INFINITY]
          attr_reader :size

          # The alignment, in bytes, for the struct type, so that all members
          # within the struct type are themselves aligned.
          #
          # @return [Integer]
          attr_reader :alignment

          #
          # Initializes the struct type.
          #
          # @param [Hash{Symbol => Member}] members
          #   The members for the struct type.
          #
          # @param [Integer, nil] alignment
          #   Optional custom alignment the struct type.
          #
          # @param [String, nil] pack_string
          #   The String for `Array#pack` or `String#unpack`.
          #
          def initialize(members, size: , alignment: , pack_string: )
            @members   = members
            @size      = size
            @alignment = alignment

            super(pack_string: pack_string)
          end

          #
          # Builds the struct type from the given fields.
          #
          # @param [Hash{Symbol => Type}] fields
          #   The field names and types for the struct type.
          #
          # @param [Integer, nil] alignment
          #   Optional custom alignment the struct type.
          #
          # @param [Boolean] padding
          #   Controls whether to pad struct members for alignment.
          #
          # @return [StructType]
          #   The new struct type.
          #
          def self.build(fields, alignment: nil, padding: true)
            members       = {}
            max_alignment = 0
            pack_string   = String.new(encoding: Encoding::ASCII_8BIT)

            offset = 0

            fields.each do |name,type|
              pad = if padding then Member.padding_for(offset,type)
                    else            0
                    end

              members[name] = Member.new(offset + pad,type)
              max_alignment = type.alignment if type.alignment > max_alignment

              if pack_string
                if type.pack_string
                  pack_string << Member.pack_string_for(type,pad)
                else
                  pack_string = nil
                end
              end

              # omit infinite sizes from the struct size
              unless type.size == Float::INFINITY
                offset += type.size + pad
              end
            end

            return new(members, size:        offset,
                                alignment:   alignment || max_alignment,
                                pack_string: pack_string)
          end

          #
          # Creates a new Hash of the struct's uninitialized members.
          #
          # @return [Hash{Symbol => Object}]
          #   The uninitialized values for the new struct's members.
          #
          def uninitialized_value
            @members.transform_values do |member|
              member.type.uninitialized_value
            end
          end

          #
          # The number of members within the struct.
          #
          # @return [Integer]
          #
          def length
            @members.length
          end

          #
          # Creates a copy of the struct type with a different {#alignment}.
          #
          # @param [Integer] new_alignment
          #   The new alignment for the new struct type.
          #
          # @return [ScalarType]
          #   The new struct type.
          #
          def align(new_alignment)
            self.class.new(@members, size:        @size,
                                     alignment:   new_alignment,
                                     pack_string: pack_string)
          end

          #
          # Packs the hash of values into the struct's binary layout.
          #
          # @param [Hash{Symbol => Integer, Float, String}] hash
          #   The hash of values to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          def pack(hash)
            if @pack_string
              super(hash)
            else
              buffer = String.new("\0" * @size, encoding: Encoding::ASCII_8BIT)

              hash.each do |name,value|
                member = @members.fetch(name) do
                  raise(ArgumentError,"unknown struct member (#{name.inspect}), must be: #{@members.keys.map(&:inspect).join(', ')}")
                end

                data = member.type.pack(value)

                if member.size == Float::INFINITY
                  buffer[member.offset..] = data
                else
                  buffer[member.offset,member.size] = data
                end
              end

              return buffer
            end
          end

          #
          # Unpacks binary data into a Hash of values using the struct's binary
          # layout.
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
              hash = {}

              @members.each do |name,member|
                slice = if member.size == Float::INFINITY
                          data.byteslice(member.offset..)
                        else
                          data.byteslice(member.offset,member.size)
                        end

                hash[name] = member.type.unpack(slice)
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
            unknown_keys = hash.keys - @members.keys

            unless unknown_keys.empty?
              raise(ArgumentError,"unknown struct members: #{unknown_keys.map(&:inspect).join(', ')}")
            end

            @members.each do |name,member|
              value = hash[name] || member.type.uninitialized_value

              member.type.enqueue_value(values,value)
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

            @members.each do |name,member|
              hash[name] = member.type.dequeue_value(values)
            end

            return hash
          end

        end
      end
    end
  end
end
