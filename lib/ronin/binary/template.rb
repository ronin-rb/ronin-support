#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'set'

module Ronin
  module Binary
    #
    # Provides a translation layer between C-types and Ruby `Array#pack`
    # codes.
    #
    # ## Types
    #
    # * `:uint8` (`C`) - unsigned 8-bit integer.
    # * `:uint16` (`S`) - unsigned 16-bit integer.
    # * `:uint32` (`L`) - unsigned 32-bit integer.
    # * `:uint64` (`Q`) - unsigned 64-bit integer.
    # * `:int8` (`c`) - signed 8-bit integer.
    # * `:int16` (`s`) - signed 16-bit integer.
    # * `:int32` (`l`) - signed 32-bit integer.
    # * `:int64` (`q`) - signed 64-bit integer.
    # * `:uint16_le` (`v`) - unsigned 16-bit integer, little endian.
    # * `:uint32_le` (`V`) - unsigned 32-bit integer, little endian.
    # * `:uint16_be` (`n`) - unsigned 16-bit integer, big endian.
    # * `:uint32_be` (`N`) - unsigned 32-bit integer, big endian.
    # * `:uchar` (`Z`) - unsigned character.
    # * `:ushort` (`S!`) - unsigned short integer, native endian.
    # * `:uint` (`I!`) - unsigned integer, native endian.
    # * `:ulong` (`L!`) - unsigned long integer, native endian.
    # * `:ulong_long` (`Q`) - unsigned quad integer, native endian.
    # * `:char` (`Z`) - signed character.
    # * `:short` (`s!`) - signed short integer, native endian.
    # * `:int` (`i!`) - signed integer, native endian.
    # * `:long` (`l!`) - signed long integer, native endian.
    # * `:long_long` (`q`) - signed quad integer, native endian.
    # * `:utf8` (`U`) - UTF8 character.
    # * `:float` (`F`) - single-precision float, native format.
    # * `:double` (`D`) - double-precision float, native format.
    # * `:float_le` (`e`) - single-precision float, little endian.
    # * `:double_le` (`E`) - double-precision float, little endian.
    # * `:float_be` (`g`) - single-precision float, big endian.
    # * `:double_be` (`G`) - double-precision float, big endian.
    # * `:ubyte` (`C`) - unsigned byte.
    # * `:byte` (`c`) - signed byte.
    # * `:string` (`Z*`) - binary String, `\0` terminated.
    #
    # ### Ruby 1.9 specific C-types
    #
    # * `:uint16_le` (`S<`) - unsigned 16-bit integer, little endian.
    # * `:uint32_le` (`L<`) - unsigned 32-bit integer, little endian.
    # * `:uint64_le` (`Q<`) - unsigned 64-bit integer, little endian.
    # * `:int16_le` (`s<`) - signed 16-bit integer, little endian.
    # * `:int32_le` (`l<`) - signed 32-bit integer, little endian.
    # * `:int64_le` (`q<`) - signed 64-bit integer, little endian.
    # * `:uint16_be` (`S>`) - unsigned 16-bit integer, big endian.
    # * `:uint32_be` (`L>`) - unsigned 32-bit integer, big endian.
    # * `:uint64_be` (`Q>`) - unsigned 64-bit integer, big endian.
    # * `:int16_be` (`s>`) - signed 16-bit integer, big endian.
    # * `:int32_be` (`l>`) - signed 32-bit integer, big endian.
    # * `:int64_be` (`q>`) - signed 64-bit integer, big endian.
    # * `:ushort_le` (`S<`) - unsigned short integer, little endian.
    # * `:uint_le` (`I<`) - unsigned integer, little endian.
    # * `:ulong_le` (`L<`) - unsigned long integer, little endian.
    # * `:ulong_long_le` (`Q<`) - unsigned quad integer, little endian.
    # * `:short_le` (`s<`) - signed short integer, little endian.
    # * `:int_le` (`i<`) - signed integer, little endian.
    # * `:long_le` (`l<`) - signed long integer, little endian.
    # * `:long_long_le` (`q<`) - signed quad integer, little endian.
    # * `:ushort_be` (`S>`) - unsigned short integer, little endian.
    # * `:uint_be` (`I>`) - unsigned integer, little endian.
    # * `:ulong_be` (`L>`) - unsigned long integer, little endian.
    # * `:ulong_long_be` (`Q>`) - unsigned quad integer, little endian.
    # * `:short_be` (`s>`) - signed short integer, little endian.
    # * `:int_be` (`i>`) - signed integer, little endian.
    # * `:long_be` (`l>`) - signed long integer, little endian.
    # * `:long_long_be` (`q>`) - signed quad integer, little endian.
    #
    # @see http://rubydoc.info/stdlib/core/Array:pack
    #
    # @api semipbulic
    #
    # @since 0.5.0
    #
    class Template

      # Supported C-types and corresponding `Array#pack` codes.
      TYPES = {
        uint8:  'C',
        uint16: 'S',
        uint32: 'L',
        uint64: 'Q',

        int8:  'c',
        int16: 's',
        int32: 'l',
        int64: 'q',

        uchar:      'Z',
        ushort:     'S!',
        uint:       'I!',
        ulong:      'L!',
        ulong_long: 'Q',

        char:      'Z',
        short:     's!',
        int:       'i!',
        long:      'l!',
        long_long: 'q',

        utf8: 'U',

        float:  'F',
        double: 'D',

        float_le:  'e',
        double_le: 'E',

        float_be:  'g',
        double_be: 'G',

        ubyte:  'C',
        byte:   'c',
        string: 'Z*',

        uint16_le: 'S<',
        uint32_le: 'L<',
        uint64_le: 'Q<',

        int16_le: 's<',
        int32_le: 'l<',
        int64_le: 'q<',

        uint16_be: 'S>',
        uint32_be: 'L>',
        uint64_be: 'Q>',

        int16_be: 's>',
        int32_be: 'l>',
        int64_be: 'q>',

        ushort_le:     'S!<',
        uint_le:       'I!<',
        ulong_le:      'L!<',
        ulong_long_le: 'Q<',

        short_le:     's!<',
        int_le:       'i!<',
        long_le:      'l!<',
        long_long_le: 'q<',

        ushort_be:     'S!>',
        uint_be:       'I!>',
        ulong_be:      'L!>',
        ulong_long_be: 'Q>',

        short_be:     's!>',
        int_be:       'i!>',
        long_be:      'l!>',
        long_long_be: 'q>'
      }

      # Big and little endian types
      ENDIAN_TYPES = {
        big: {
          uint16:     :uint16_be,
          uint32:     :uint32_be,
          uint64:     :uint64_be,

          int16_be:   :int16_be,
          int32_be:   :int32_be,
          int64_be:   :int64_be,

          ushort:     :ushort_be,
          uint:       :uint_be,
          ulong:      :ulong_be,
          ulong_long: :ulong_long_be,

          short:      :short_be,
          int:        :int_be,
          long:       :long_be,
          long_long:  :long_long_be,

          float:      :float_be,
          double:     :double_be
        },

        little: {
          uint16:     :uint16_le,
          uint32:     :uint32_le,
          uint64:     :uint64_le,

          int16_le:   :int16_le,
          int32_le:   :int32_le,
          int64_le:   :int64_le,

          ushort:     :ushort_le,
          uint:       :uint_le,
          ulong:      :ulong_le,
          ulong_long: :ulong_long_le,

          short:      :short_le,
          int:        :int_le,
          long:       :long_le,
          long_long:  :long_long_le,

          float:      :float_le,
          double:     :double_le
        }
      }

      # Integer C-types
      INT_TYPES = Set[
        :uint8, :uint16, :uint32, :uint64,
        :int8, :int16, :int32, :int64,
        :ubyte, :ushort, :uint, :ulong, :ulong_long,
        :byte, :short, :int, :long, :long_long,
        :uint16_le, :uint32_le, :uint64_le,
        :int16_le, :int32_le, :int64_le,
        :ushort_le, :uint_le, :ulong_le, :ulong_long_le,
        :short_le, :int_le, :long_le, :long_long_le,
        :uint16_be, :uint32_be, :uint64_be,
        :int16_be, :int32_be, :int64_be,
        :ushort_be, :uint_be, :ulong_be, :ulong_long_be,
        :short_be, :int_be, :long_be, :long_long_be
      ]

      # Float C-types
      FLOAT_TYPES = Set[
        :float,    :double,
        :float_le, :double_le,
        :float_be, :double_be
      ]

      # Character C-types
      CHAR_TYPES = Set[:uchar, :char]

      # String C-types
      STRING_TYPES = CHAR_TYPES + Set[:string]

      # The fields of the template
      attr_reader :fields

      #
      # Creates a new Binary Template.
      #
      # @param [Array<type, (type, length)>] fields
      #   The C-types which the packer will use.
      #
      # @param [Hash] options
      #   Template options.
      #
      # @option options [:little, :big, :network] :endian
      #   The endianness to apply to the C-types.
      #
      # @raise [ArgumentError]
      #   A given type is not known.
      #
      # @example
      #   Template.new(:uint32, [:char, 100])
      #
      def initialize(fields,options={})
        @fields   = fields
        @template = self.class.compile(@fields,options)
      end

      #
      # @see #initialize
      #
      def self.[](*fields)
        new(fields)
      end

      #
      # Compiles C-types into an `Array#pack` / `String#unpack`
      # template.
      #
      # @param [Array<type, (type, length)>] fields
      #   The C-types which the packer will use.
      #
      # @param [Hash] options
      #   Type options.
      #
      # @option options [:little, :big, :network] :endian
      #   The endianness to apply to the C-types.
      #
      # @return [String]
      #   The `Array#pack` / `String#unpack` template.
      #
      # @raise [ArgumentError]
      #   A given type is not known.
      #
      def self.compile(fields,options={})
        string = ''
        endian = options[:endian]

        fields.each do |(type,length)|
          if endian
            type = ENDIAN_TYPES[endian].fetch(type,type)
          end

          unless (code = TYPES[type])
            raise(ArgumentError,"#{type.inspect} not supported")
          end

          string << code << length.to_s
        end

        return string
      end

      #
      # Packs the data.
      #
      # @param [Array] data
      #   The data to pack.
      #
      # @return [String]
      #   The packed data.
      #
      def pack(*data)
        data.pack(@template)
      end

      #
      # Unpacks the string.
      #
      # @param [String] string
      #   The raw String to unpack.
      #
      # @return [Array]
      #   The unpacked data.
      #
      def unpack(string)
        string.unpack(@template)
      end

      #
      # Converts the template to a `Array#pack` template String.
      #
      # @return [String]
      #   The template String.
      #
      # @see http://rubydoc.info/stdlib/core/Array:pack
      #
      def to_s
        @template
      end

      #
      # Inspects the template.
      #
      # @return [String]
      #   The inspected template.
      #
      # @since 1.5.1
      #
      def inspect
        "<#{self.class}: #{@fields.inspect}>"
      end

    end
  end
end
