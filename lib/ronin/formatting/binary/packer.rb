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

module Ronin
  module Formatting
    module Binary
      #
      # Provides a translation layer between C types and Ruby [Array#pack]
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
      # * `:uchar` (`C`) - unsigned character.
      # * `:ushort` (`S!`) - unsigned short integer, native endian.
      # * `:uint` (`I!`) - unsigned integer, native endian.
      # * `:ulong` (`L!`) - unsigned long integer, native endian.
      # * `:ulong_long` (`Q`) - unsigned quad integer, native endian.
      # * `:char` (`c`) - signed character.
      # * `:short` (`s!`) - signed short integer, native endian.
      # * `:int` (`i!`) - signed integer, native endian.
      # * `:long` (`l!`) - signed long integer, native endian.
      # * `:long_long` (`q`) - signed quad integer, native endian.
      # * `:pointer` (`L!`) - pointer, native endian.
      # * `:wchar` (`U`) - UTF8 character.
      # * `:float` (`F`) - single-percision float, native format.
      # * `:double` (`D`) - double-percision float, native format.
      # * `:float_le` (`e`) - single-percision float, little endian.
      # * `:double_le` (`E`) - double-percision float, little endian.
      # * `:float_be` (`g`) - single-percision float, big endian.
      # * `:double_be` (`G`) - double-percision float, big endian.
      # * `:string` (`Z*`) - binary String, `\0` terminated.
      #
      # ### Ruby 1.9 specific types
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
      # [Array#pack]: http://rubydoc.info/stdlib/core/Array:pack
      #
      # @api semipbulic
      #
      # @since 0.5.0
      #
      class Packer

        # Supported types and corresponding `Array#pack` codes.
        TYPES = {
          :uint8  => 'C',
          :uint16 => 'S',
          :uint32 => 'L',
          :uint64 => 'Q',

          :int8   => 'c',
          :int16  => 's',
          :int32  => 'l',
          :int64  => 'q',

          :uint16_le => 'v',
          :uint16_le => 'V',
          :uint16_be => 'n',
          :uint32_be => 'N',

          :uchar      => 'C',
          :ushort     => 'S!',
          :uint       => 'I!',
          :ulong      => 'L!',
          :ulong_long => 'Q',

          :char      => 'C',
          :short     => 'S!',
          :int       => 'I!',
          :long      => 'L!',
          :long_long => 'Q',

          :pointer => 'L!',

          :wchar => 'U',

          :float     => 'F',
          :double    => 'D',

          :float_le  => 'e',
          :double_le => 'E',

          :float_be  => 'g',
          :double_be => 'G',

          :string => 'Z*'
        }

        # Additional types, not available on Ruby 1.8:
        if RUBY_VERSION > '1.9'
          TYPES.merge!(
            :uint16_le => 'S<',
            :uint32_le => 'L<',
            :uint64_le => 'Q<',

            :int16_le => 's<',
            :int32_le => 'l<',
            :int64_le => 'q<',

            :uint16_be => 'S>',
            :uint32_be => 'L>',
            :uint64_be => 'Q>',

            :int16_be => 's>',
            :int32_be => 'l>',
            :int64_be => 'q>',

            :ushort_le     => 'S!<',
            :uint_le       => 'I!<',
            :ulong_le      => 'L!<',
            :ulong_long_le => 'Q<',

            :short_le     => 's!<',
            :int_le       => 'i!<',
            :long_le      => 'l!<',
            :long_long_le => 'q<',

            :ushort_be     => 'S!>',
            :uint_be       => 'I!>',
            :ulong_be      => 'L!>',
            :ulong_long_be => 'Q>',

            :short_be     => 's!>',
            :int_be       => 'i!>',
            :long_be      => 'l!>',
            :long_long_be => 'q>'
          )
        end

        #
        # Creates a new Binary Packer.
        #
        # @param [Array<type, (type, length)>] template
        #   The template for the packer.
        #
        # @raise [ArgumentError]
        #   A given type is not known.
        #
        # @note
        #   The following types are **not supported** on Ruby 1.8:
        #
        #   * `:uint16_le`
        #   * `:uint32_le`
        #   * `:uint64_le`
        #   * `:int16_le`
        #   * `:int32_le`
        #   * `:int64_le`
        #   * `:uint16_be`
        #   * `:uint32_be`
        #   * `:uint64_be`
        #   * `:int16_be`
        #   * `:int32_be`
        #   * `:int64_be`
        #   * `:ushort_le`
        #   * `:uint_le`
        #   * `:ulong_le`
        #   * `:ulong_long_le`
        #   * `:short_le`
        #   * `:int_le`
        #   * `:long_le`
        #   * `:long_long_le`
        #   * `:ushort_be`
        #   * `:uint_be`
        #   * `:ulong_be`
        #   * `:ulong_long_be`
        #   * `:short_be`
        #   * `:int_be`
        #   * `:long_be`
        #   * `:long_long_be`
        #
        # @example
        #   Packer.new(:uint32, [:char, 100])
        #
        def initialize(*template)
          @template = ''

          template.each do |format|
            type, length = format

            unless (code = TYPES[type])
              raise(ArgumentError,"#{code.inspect} not supported")
            end

            @template << code << length.to_s
          end
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

      end
    end
  end
end
