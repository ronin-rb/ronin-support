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

require 'ronin/support/binary/types/object_type'
require 'ronin/support/binary/types/struct_type'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Represents a {Binary::Struct} type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class StructObjectType < ObjectType

          # The {Struct} class.
          #
          # @return [Struct.class]
          attr_reader :struct_class

          # The type used for packing literal `Hash` values.
          #
          # @return [StructType]
          attr_reader :struct_type

          #
          # Initializes the memory-mapped struct type.
          #
          # @param [Struct.class] struct_class
          #   The {Struct} class.
          #
          # @param [Hash{Symbol => Type}] struct_members
          #
          def initialize(struct_class,struct_members)
            @struct_class = struct_class
            @struct_type  = StructType.new(struct_members)

            super(@struct_type.size)
          end

          #
          # The size of the structure type.
          #
          # @return [Integer, Float::INFINITY]
          #
          def size
            @struct_type.size
          end

          #
          # The alignment, in bytes, of the memory-mapped {Struct}.
          #
          # @return [Integer]
          #
          def alignment
            @struct_type.alignment
          end

          #
          # The members of the structure type.
          #
          # @return [Hash{Symbol => StructType::Member}]
          #
          def members
            @struct_type.members
          end

          #
          # Packs the memory-mapped {Struct}.
          #
          # @param [Binary::Struct, Hash] struct
          #   The memory-mapped {Struct} object.
          #
          # @return [String]
          #   The underlying binary data for the memory object.
          #
          def pack(struct)
            case struct
            when Binary::Struct
              struct.to_s
            when Hash
              @struct_type.pack(struct)
            end
          end

          #
          # Unpacks the memory-mapped {Struct}.
          #
          # @param [String] data
          #   The raw binary data to unpack.
          #
          # @return [Binary::Struct]
          #   the unpacked {Struct} object.
          #
          def unpack(data)
            @struct_class.unpack(data)
          end

          #
          # Enqueues the memory-mapped {Struct} into the list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [Binary::Struct, Hash] struct
          #   The {Struct} object to enqueue.
          #
          def enqueue_value(values,struct)
            case struct
            when Binary::Struct
              values.push(struct.to_s)
            when Hash
              values.push(@struct_type.pack(struct))
            end
          end

          #
          # Dequeues a memory object from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [Struct]
          #   The dequued {Struct} object.
          #
          def dequeue_value(values)
            @struct_class.new(values.shift)
          end

        end
      end
    end
  end
end
