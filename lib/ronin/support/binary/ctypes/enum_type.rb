#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes/type'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Base class for all enum types.
        #
        class EnumType < Type

          # The underlying integer type.
          #
          # @return [IntType]
          attr_reader :int_type

          # The enum's mapping of symbols to their integer values.
          #
          # @return [Hash{Symbol => Integer}]
          attr_reader :mapping

          # The reverse mapping of the enum's integers to their symbol values.
          #
          # @return [Hash{Integer => Symbol}]
          attr_reader :reverse_mapping

          #
          # Initializes the enum type.
          #
          # @param [IntType] int_type
          #   The underlying int type for the enum.
          #
          # @param [Hash{Symbol => Integer}] mapping
          #   The mapping of Symbols to Integer values for the enum.
          #
          def initialize(int_type,mapping)
            super(pack_string: nil)

            @int_type = int_type
            @mapping  = mapping
            @reverse_mapping = @mapping.invert
          end

          #
          # The uninitinalized value for the enum.
          #
          # @return [Symbol, Integer]
          #   The enum Symbol which maps to `0` or `0`.
          #
          def uninitialized_value
            default_value = @int_type.uninitialized_value

            @reverse_mapping.fetch(default_value,default_value)
          end

          #
          # The size of the enum type.
          #
          # @return [Integer]
          #   The size of the underlying {#int_type} in bytes.
          #
          def size
            @int_type.size
          end

          #
          # The alignment of the enum type.
          #
          # @return [Integer]
          #   The alignment of the underlying {#int_type} in bytes.
          #
          def alignment
            @int_type.alignment
          end

          #
          # Creates a copy of the enum type with different alignment.
          #
          # @param [Integer] new_alignment
          #   The new alignment for the enum type.
          #
          # @return [EnumType]
          #   The new enum type.
          #
          def align(new_alignment)
            self.class.new(@int_type.align(new_alignment),@mapping)
          end

          #
          # Packs an enum value.
          #
          # @param [Symbol, Integer] value
          #   The enum value. Can be either a Symbol from the enum or an
          #   Integer.
          #
          # @return [String]
          #   The packed enum value.
          #
          # @raise [ArgumentError]
          #   The enum value either was not a Symbol or an Integer, or was a
          #   Symbol value not in {#mapping}.
          #
          def pack(value)
            int = case value
                  when Integer then value
                  when Symbol
                    @mapping.fetch(value) do
                      raise(ArgumentError,"invalid enum value: #{value.inspect}")
                    end
                  else
                    raise(ArgumentError,"enum value must be a Symbol or an Integer: #{value.inspect}")
                  end

            @int_type.pack(int)
          end

          #
          # Unpacks a previously packed enum value.
          #
          # @param [String] data
          #   The packed enum value.
          #
          # @return [Symbol, Integer]
          #   The enum Symbol value or an Integer if the Integer was not in
          #   {#reverse_mapping}.
          #
          def unpack(data)
            int = @int_type.unpack(data)

            return @reverse_mapping.fetch(int,int)
          end

          #
          # Enqueues a value onto the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @param [Symbol, Integer] value
          #   The value to enqueue.
          #
          def enqueue_value(values,value)
            @int_type.enqueue_value(values,value)
          end

          #
          # Dequeues a value from the flat list of values.
          #
          # @param [Array] values
          #   The flat array of values.
          #
          # @return [Symbol, Integer]
          #   The dequeued value.
          #
          def dequeue_value(values)
            @int_type.dequeue_value(values)
          end

        end
      end
    end
  end
end
