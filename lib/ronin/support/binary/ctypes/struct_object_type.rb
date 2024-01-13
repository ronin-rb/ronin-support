# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes/object_type'
require 'ronin/support/binary/ctypes/struct_type'

module Ronin
  module Support
    module Binary
      module CTypes
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
          # @return [Class<Binary::Struct>]
          attr_reader :struct_class

          # The type used for packing literal `Hash` values.
          #
          # @return [StructType]
          attr_reader :struct_type

          #
          # Initializes the memory-mapped struct type.
          #
          # @param [<Binary::Struct>] struct_class
          #   The {Struct} class.
          #
          # @param [StructType] struct_type
          #   The struct type for the struct class.
          #
          def initialize(struct_class,struct_type)
            @struct_class = struct_class
            @struct_type  = struct_type

            super(@struct_type.size)
          end

          #
          # The size of the struct type.
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
          # Creates a copy of the struct object type with a different
          # {#alignment}.
          #
          # @param [Integer] new_alignment
          #   The new alignment for the new struct object type.
          #
          # @return [ScalarType]
          #   The new struct object type.
          #
          def align(new_alignment)
            self.class.new(@struct_class,@struct_type.align(new_alignment))
          end

          #
          # The members of the struct type.
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
          # @raise [ArgumentError]
          #   The given value was not a {Binary::Struct} or `Hash`.
          #
          def pack(struct)
            case struct
            when Binary::Struct
              struct.to_s
            when Hash
              @struct_type.pack(struct)
            else
              raise(ArgumentError,"value must be either a #{Binary::Struct} or an #{Hash}: #{struct.inspect}")
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
