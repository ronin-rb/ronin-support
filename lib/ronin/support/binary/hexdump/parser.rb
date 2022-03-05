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

require 'chars'
require 'set'

module Ronin
  module Support
    module Binary
      module Hexdump
        #
        # @since 0.5.0
        #
        # @api semipublic
        #
        class Parser

          TYPES = Set[
            :byte,
            :char,

            :uint8,
            :uint16,
            :uint32,
            :uint64,

            :int8,
            :int16,
            :int32,
            :int64,

            :uchar,
            :ushort,
            :uint,
            :ulong,
            :ulong_long,

            :short,
            :int,
            :long,
            :long_long,

            :float,
            :double,

            :float_le,
            :double_le,

            :float_be,
            :double_be,

            :uint16_le,
            :uint32_le,
            :uint64_le,

            :int16_le,
            :int32_le,
            :int64_le,

            :uint16_be,
            :uint32_be,
            :uint64_be,

            :int16_be,
            :int32_be,
            :int64_be,

            :ushort_le,
            :uint_le,
            :ulong_le,
            :ulong_long_le,

            :short_le,
            :int_le,
            :long_le,
            :long_long_le,

            :ushort_be,
            :uint_be,
            :ulong_be,
            :ulong_long_be,

            :short_be,
            :int_be,
            :long_be,
            :long_long_be
          ]

          # Word-sizes for various C types
          WORD_SIZES = {
            byte:       1,
            char:       1,

            uint8:  1,
            uint16: 2,
            uint32: 4,
            uint64: 8,

            int8:  1,
            int16: 2,
            int32: 4,
            int64: 8,

            ushort:     2,
            uint:       4,
            ulong:      8,
            ulong_long: 8,

            short:     2,
            int:       4,
            long:      8,
            long_long: 8,

            float:  4,
            double: 8,

            float_le:  4,
            double_le: 8,

            float_be:  4,
            double_be: 8,

            uint16_le: 2,
            uint32_le: 4,
            uint64_le: 8,

            int16_le: 2,
            int32_le: 4,
            int64_le: 8,

            uint16_be: 2,
            uint32_be: 4,
            uint64_be: 8,

            int16_be: 2,
            int32_be: 4,
            int64_be: 8,

            ushort_le:     2,
            uint_le:       4,
            ulong_le:      8,
            ulong_long_le: 8,

            short_le:     2,
            int_le:       4,
            long_le:      8,
            long_long_le: 8,

            ushort_be:     2,
            uint_be:       4,
            ulong_be:      8,
            ulong_long_be: 8,

            short_be:     2,
            int_be:       4,
            long_be:      8,
            long_long_be: 8
          }

          # Pack strings for supported C types
          PACK_STRINGS = {
            byte:       'C',
            char:       'C',

            uint8:  'C',
            uint16: 'S',
            uint32: 'L',
            uint64: 'Q',

            int8:  'c',
            int16: 's',
            int32: 'l',
            int64: 'q',

            ushort:     'S!',
            uint:       'I!',
            ulong:      'L!',
            ulong_long: 'Q',

            short:     's!',
            int:       'i!',
            long:      'l!',
            long_long: 'q',

            float:  'F',
            double: 'D',

            float_le:  'e',
            double_le: 'E',

            float_be:  'g',
            double_be: 'G',

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

          # Visible characters
          VISIBLE_CHARS = Hash[
            Chars::VISIBLE.chars.sort.zip(Chars::VISIBLE.bytes.sort)
          ]

          # Escaped characters
          CHARS = {
            '\0' => 0x00,
            '\a' => 0x07,
            '\b' => 0x08,
            '\t' => 0x09,
            '\n' => 0x0a,
            '\v' => 0x0b,
            '\f' => 0x0c,
            '\r' => 0x0d,
            ' '  => 0x20
          }.merge(VISIBLE_CHARS)

          # od named characters
          NAMED_CHARS = {
            'nul' => 0x00,
            'soh' => 0x01,
            'stx' => 0x02,
            'etx' => 0x03,
            'eot' => 0x04,
            'enq' => 0x05,
            'ack' => 0x06,
            'bel' => 0x07,
            'bs'  => 0x08,
            'ht'  => 0x09,
            'lf'  => 0x0a,
            'nl'  => 0x0a,
            'vt'  => 0x0b,
            'ff'  => 0x0c,
            'cr'  => 0x0d,
            'so'  => 0x0e,
            'si'  => 0x0f,
            'dle' => 0x10,
            'dc1' => 0x11,
            'dc2' => 0x12,
            'dc3' => 0x13,
            'dc4' => 0x14,
            'nak' => 0x15,
            'syn' => 0x16,
            'etb' => 0x17,
            'can' => 0x18,
            'em'  => 0x19,
            'sub' => 0x1a,
            'esc' => 0x1b,
            'fs'  => 0x1c,
            'gs'  => 0x1d,
            'rs'  => 0x1e,
            'us'  => 0x1f,
            'sp'  => 0x20,
            'del' => 0x7f
          }.merge(VISIBLE_CHARS)

          # The format to parse.
          #
          # @return [:hexdump, :od]
          attr_reader :format

          # The type of data to parse.
          #
          # @return [:integer, :float]
          attr_reader :type

          # The base of all addresses to parse
          #
          # @return [2, 8, 10, 16]
          attr_reader :address_base

          # The base of all words to parse
          #
          # @return [2, 8, 10, 16]
          attr_reader :base

          # The size of words to parse
          #
          # @return [1, 2, 4, 8]
          attr_reader :word_size

          # The `Array#unpack` string.
          #
          # @return [String]
          attr_reader :pack_string

          #
          # Initializes the hexdump parser.
          #
          # @param [:od, :hexdump] format
          #   The expected format of the hexdump. Must be either `:od` or
          #   `:hexdump`.
          #
          # @param [Symbol] type
          #   Denotes the encoding used for the bytes within the hexdump.
          #   Must be one of the following:
          #   * `:byte`
          #   * `:char`
          #   * `:uint8`
          #   * `:uint16`
          #   * `:uint32`
          #   * `:uint64`
          #   * `:int8`
          #   * `:int16`
          #   * `:int32`
          #   * `:int64`
          #   * `:uchar`
          #   * `:ushort`
          #   * `:uint`
          #   * `:ulong`
          #   * `:ulong_long`
          #   * `:short`
          #   * `:int`
          #   * `:long`
          #   * `:long_long`
          #   * `:float`
          #   * `:double`
          #   * `:float_le`
          #   * `:double_le`
          #   * `:float_be`
          #   * `:double_be`
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
          # @param [2, 8, 10, 16, nil] address_base
          #   The numerical base that the offset addresses are encoded in.
          #
          # @param [2, 8, 10, 16, nil] base
          #   The numerical base that the hexdumped numbers are encoded in.
          #
          # @param [Boolean] named_chars
          #   Indicates to parse `od`-style named characters (ex: `nul`,
          #   `del`, etc).
          #
          # @raise [ArgumentError]
          #   Unsupported `type:` value, or the `format:` was not `:hexdump` or
          #   `:od`.
          #
          def initialize(format:         :hexdump,
                         type:           :byte,
                         address_base:   nil,
                         base:           nil,
                         named_chars:    nil)
            unless TYPES.include?(type)
              raise(ArgumentError,"unsupported C type: value (#{type.inspect})")
            end

            @type = type

            @base         = base
            @address_base = address_base

            case format
            when :od      then initialize_od(named_chars: named_chars)
            when :hexdump then initialize_hexdump
            else
              raise(ArgumentError,"format: must be either :hexdump or :od, was #{format.inspect}")
            end

            case @type
            when :float, :float_le, :float_be, :double, :double_le, :double_be
              @parse_method = method(:parse_float)
            when :char
              @parse_method = method(:parse_char_or_int)
            else
              @parse_method = method(:parse_int)
            end

            @word_size   = WORD_SIZES.fetch(@type)
            @pack_string = PACK_STRINGS.fetch(@type)
          end

          private

          #
          # Initializes instance variables for the `od` hexdump format.
          #
          def initialize_od(named_chars: nil)
            @format = :od

            @base         ||= 8
            @address_base ||= 8

            if @type == :char
              @chars = if named_chars then NAMED_CHARS
                       else                CHARS
                       end
            end
          end

          #
          # Initializes instance variables for the `hexdump` hexdump format.
          #
          def initialize_hexdump
            @format = :hexdump

            @base         ||= 16
            @address_base ||= 16

            if @type == :char
              @base  = 8
              @chars = CHARS 
            end
          end

          public

          #
          # Parses a hexdump.
          #
          # @param [String, IO] hexdump
          #   The hexdump output.
          #
          # @yield [address, values]
          #   If a block is given, it will be passed each parsed line of the
          #   hexdump.
          #
          # @yieldparam [Integer] address
          #   The parsed address from the hexdump line.
          #
          # @yieldparam [Array<Integer, Float>] values
          #   The parsed values from a line in the hexdump.
          #
          # @return [Integer, Enumerator]
          #   If a block is given, then the last address will be returned
          #   representing the total length of the hexdump.
          #   If no block is given, an Enumerator will be returned.
          #
          def parse(hexdump)
            return enum_for(__method__,hexdump) unless block_given?

            previous_address = nil
            first_address    = nil

            previous_row         = nil
            previous_row_repeats = false
            previous_row_size    = nil
            starts_repeating_at  = nil

            hexdump.each_line do |line|
              line.chomp!
              # remove GNU hexdump's ASCII column
              line.sub!(/\s+\|.{1,16}\|\s*$/,'') if @format == :hexdump

              if line == '*'
                previous_row_repeats = true
                previous_row_size    = (previous_row.length * @word_size)
                starts_repeating_at  = previous_address + previous_row_size
              else
                address, row = parse_line(line)
                first_address ||= address

                if previous_row_repeats
                  # fill in the omitted repeating rows
                  range     = starts_repeating_at...address
                  addresses = range.step(previous_row_size)

                  addresses.each do |address|
                    yield address, previous_row
                  end

                  previous_row_repeats = false
                end

                yield address, row if row

                previous_address = address
                previous_row     = row
              end
            end

            # return the last address as the length
            return previous_address - first_address
          end

          #
          # Unhexdumps a hexdump and returns the raw data.
          #
          # @param [String, IO] hexdump
          #   The contents of the hexdump.
          #
          # @return [String]
          #   The raw data from the hexdump.
          #
          # @since 1.0.0
          #
          def unhexdump(hexdump)
            buffer = String.new(encoding: Encoding::ASCII_8BIT)

            length = parse(hexdump) do |address,row|
              first_address ||= address
              buffer << pack(row)
            end

            return buffer.byteslice(0,length)
          end

          #
          # Parses an address.
          #
          # @param [String] address
          #   The text of the address.
          #
          # @return [Integer]
          #   The parsed address.
          #
          # @api private
          #   
          def parse_address(address)
            address.to_i(@address_base)
          end

          #
          # Parses an Integer.
          #
          # @param [String] string
          #   The text of the Integer.
          #
          # @return [Integer]
          #   The parsed Integer.
          #
          # @api private
          #   
          def parse_int(string)
            string.to_i(@base)
          end

          #
          # Parses an integer or a ASCII character.
          #
          # @param [String] string
          #   The text of the integer or character.
          #
          # @return [Integer]
          #   The parsed integer or byte value of the character.
          #
          def parse_char_or_int(string)
            @chars.fetch(string) do |string|
              string.to_i(@base)
            end
          end

          #
          # Parses a float.
          #
          # @param [String] string
          #   The text of the float.
          #
          # @return [Float]
          #   The parsed float.
          #
          def parse_float(string)
            string.to_f
          end

          #
          # Parses a line from the hexdump.
          #
          # @param [String] line
          #   A line from a hexdump.
          #
          # @return [(Integer, Array<Integer, Float>)]
          #   The parse address and the parsed numbers from the line.
          #
          def parse_line(line)
            if @type == :char
              # because od/hexdump print the ' ' char as white space,
              # we need special parsing logic here.
              if (start_index = line.index(' '))
                address = parse_address(line[0,start_index])
                rest    = line[start_index..]
                numbers = rest.scan(/   ( )|([^\s]+)/)
                numbers.map! { |(sp,char)| sp || char }
                numbers.map!(&@parse_method)

                return address, numbers
              else
                return parse_address(line)
              end
            else
              address, *numbers = line.split
              address = parse_address(address)
              numbers.map!(&@parse_method)

              unless numbers.empty?
                return address, numbers
              else
                return address
              end
            end
          end

          #
          # Packs a segment back into bytes.
          #
          # @param [Array<Integer, Float>] values
          #   A segment of words.
          #
          # @return [String]
          #   The packed segment.
          #
          # @api private
          #   
          def pack(values)
            values.pack(@pack_string * values.length)
          end

        end
      end
    end
  end
end
