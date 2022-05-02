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
require 'ronin/support/binary/types/union_type'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Represents a {Binary::Union} type.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class UnionObjectType < ObjectType

          # The {Union} class.
          #
          # @return [Union.class]
          attr_reader :union_class

          # The type used for packing literal `Hash` values.
          #
          # @return [UnionType]
          attr_reader :union_type

          #
          # Initializes the memory-mapped union type.
          #
          # @param [Union.class] union_class
          #   The {Union} class.
          #
          # @param [Hash{Symbol => Type}] union_members
          #
          def initialize(union_class,union_members)
            @union_class = union_class
            @union_type  = UnionType.build(union_members)

            super(@union_type.size)
          end

          #
          # The size of the union type.
          #
          # @return [Integer, Float::INFINITY]
          #
          def size
            @union_type.size
          end

          #
          # The alignment, in bytes, of the memory-mapped {Union}.
          #
          # @return [Integer]
          #
          def alignment
            @union_type.alignment
          end

          #
          # The members of the union type.
          #
          # @return [Hash{Symbol => UnionType::Member}]
          #
          def members
            @union_type.members
          end

          #
          # Packs the memory-mapped {Union}.
          #
          # @param [Binary::Union, Hash] union
          #   The memory-mapped {Union} object.
          #
          # @return [String]
          #   The underlying binary data for the memory object.
          #
          def pack(union)
            case union
            when Binary::Union
              union.to_s
            when Hash
              @union_type.pack(union)
            end
          end

          #
          # Unpacks the memory-mapped {Union}.
          #
          # @param [String] data
          #   The raw binary data to unpack.
          #
          # @return [Binary::Union]
          #   the unpacked {Union} object.
          #
          def unpack(data)
            @union_class.unpack(data)
          end

          #
          # Enqueues the memory-mapped {Union} into the list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [Binary::Union, Hash] union
          #   The {Union} object to enqueue.
          #
          def enqueue_value(values,union)
            case union
            when Binary::Union
              values.push(union.to_s)
            when Hash
              values.push(@union_type.pack(union))
            end
          end

          #
          # Dequeues a memory object from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [Union]
          #   The dequued {Union} object.
          #
          def dequeue_value(values)
            @union_class.new(values.shift)
          end

        end
      end
    end
  end
end
