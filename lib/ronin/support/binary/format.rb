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

require 'ronin/support/binary/ctypes/mixin'
require 'ronin/support/binary/array'

module Ronin
  module Support
    module Binary
      #
      # Provides a translation layer between C-types and Ruby `Array#pack`
      # codes.
      #
      # ## Supported Types
      #
      # * `:uint8` - unsigned 8-bit integer.
      # * `:uint16` - unsigned 16-bit integer.
      # * `:uint32` - unsigned 32-bit integer.
      # * `:uint64` - unsigned 64-bit integer.
      # * `:int8` - signed 8-bit integer.
      # * `:int16` - signed 16-bit integer.
      # * `:int32` - signed 32-bit integer.
      # * `:int64` - signed 64-bit integer.
      # * `:uint16_le` - unsigned 16-bit integer, little endian.
      # * `:uint32_le` - unsigned 32-bit integer, little endian.
      # * `:uint16_be` - unsigned 16-bit integer, big endian.
      # * `:uint32_be` - unsigned 32-bit integer, big endian.
      # * `:uchar` - unsigned character.
      # * `:ushort` - unsigned short integer, native endian.
      # * `:uint` - unsigned integer, native endian.
      # * `:ulong` - unsigned long integer, native endian.
      # * `:ulong_long` - unsigned quad integer, native endian.
      # * `:char` - signed character.
      # * `:short` - signed short integer, native endian.
      # * `:int` - signed integer, native endian.
      # * `:long` - signed long integer, native endian.
      # * `:long_long` - signed quad integer, native endian.
      # * `:float` - single-precision float, native format.
      # * `:double` - double-precision float, native format.
      # * `:float_le` - single-precision float, little endian.
      # * `:double_le` - double-precision float, little endian.
      # * `:float_be` - single-precision float, big endian.
      # * `:double_be` - double-precision float, big endian.
      # * `:byte` - signed byte.
      # * `:string` - binary String, `\0` terminated.
      # * `:uint16_le` - unsigned 16-bit integer, little endian.
      # * `:uint32_le` - unsigned 32-bit integer, little endian.
      # * `:uint64_le` - unsigned 64-bit integer, little endian.
      # * `:int16_le` - signed 16-bit integer, little endian.
      # * `:int32_le` - signed 32-bit integer, little endian.
      # * `:int64_le` - signed 64-bit integer, little endian.
      # * `:uint16_be` - unsigned 16-bit integer, big endian.
      # * `:uint32_be` - unsigned 32-bit integer, big endian.
      # * `:uint64_be` - unsigned 64-bit integer, big endian.
      # * `:int16_be` - signed 16-bit integer, big endian.
      # * `:int32_be` - signed 32-bit integer, big endian.
      # * `:int64_be` - signed 64-bit integer, big endian.
      # * `:ushort_le` - unsigned short integer, little endian.
      # * `:uint_le` - unsigned integer, little endian.
      # * `:ulong_le` - unsigned long integer, little endian.
      # * `:ulong_long_le` - unsigned quad integer, little endian.
      # * `:short_le` - signed short integer, little endian.
      # * `:int_le` - signed integer, little endian.
      # * `:long_le` - signed long integer, little endian.
      # * `:long_long_le` - signed quad integer, little endian.
      # * `:ushort_be` - unsigned short integer, little endian.
      # * `:uint_be` - unsigned integer, little endian.
      # * `:ulong_be` - unsigned long integer, little endian.
      # * `:ulong_long_be` - unsigned quad integer, little endian.
      # * `:short_be` - signed short integer, little endian.
      # * `:int_be` - signed integer, little endian.
      # * `:long_be` - signed long integer, little endian.
      # * `:long_long_be` - signed quad integer, little endian.
      #
      # @see https://rubydoc.info/stdlib/core/Array:pack
      #
      # @api pbulic
      #
      # @since 1.0.0
      #
      class Format

        include CTypes::Mixin

        # The fields of the binary format.
        #
        # @return [::Array<Symbol, (Symbol, Integer), Range(Symbol)>]
        attr_reader :fields

        # The field types of the binary format.
        #
        # @return [::Array<CTypes::Type,
        #                  CTypes::ArrayType,
        #                  CTypes::UnboundArrayType>]
        attr_reader :types

        # The `Array#pack` string for the binary format.
        #
        # @return [String]
        attr_reader :pack_string

        #
        # Creates a new Binary format.
        #
        # @param [::Array<type, (type, length)>] fields
        #   The C-types which the packer will use.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [:little, :big, :net, nil] :endian
        #   The desired endianness of the values within the format.
        #
        # @option kwargs [:x86, :x86_64,
        #                 :ppc, :ppc64,
        #                 :mips, :mips_le, :mips_be,
        #                 :mips64, :mips64_le, :mips64_be,
        #                 :arm, :arm_le, :arm_be,
        #                 :arm64, :arm64_le, :arm64_be] :arch
        #   The desired architecture for the values within the format.
        #
        # @raise [ArgumentError]
        #   A given type is not known.
        #
        # @example
        #   Format.new(:uint32, [:char, 100])
        #
        def initialize(fields, **kwargs)
          initialize_type_system(**kwargs)

          @fields = []
          @types  = []
          @pack_string = String.new

          fields.each do |field|
            type = @type_resolver.resolve(field)

            @fields      << field
            @types       << type

            if @pack_string
              if type.pack_string then @pack_string << type.pack_string
              else                     @pack_string = nil
              end
            end
          end
        end

        #
        # @see #initialize
        #
        def self.[](*fields,**kwargs)
          new(fields,**kwargs)
        end

        #
        # Packs the data.
        #
        # @param [::Array] arguments
        #   The values to pack.
        #
        # @return [String]
        #   The packed data.
        #
        def pack(*arguments)
          if @pack_string
            values = []

            @types.each do |type|
              # shift off the next value(s) and enqueue them
              type.enqueue_value(values,arguments.shift)
            end

            values.pack(@pack_string)
          else
            buffer = String.new('', encoding: Encoding::ASCII_8BIT)

            @types.each do |type|
              # shift off the next value and pack it
              buffer << type.pack(arguments.shift)
            end

            return buffer
          end
        end

        #
        # Unpacks the string.
        #
        # @param [String] string
        #   The raw String to unpack.
        #
        # @return [::Array]
        #   The unpacked data.
        #
        def unpack(string)
          if @pack_string
            values = string.unpack(@pack_string)

            @types.map do |type|
              type.dequeue_value(values)
            end
          else
            array  = []
            offset = 0

            @types.each do |type|
              array  << type.unpack(data.byteslice(offset,type.size))
              offset += type.size
            end

            return array
          end
        end

        #
        # Converts the template to a `Array#pack` template String.
        #
        # @return [String]
        #   The template String.
        #
        # @see https://rubydoc.info/stdlib/core/Array:pack
        #
        def to_s
          @pack_string
        end

        alias to_str to_s

      end
    end
  end
end
