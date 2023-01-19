# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes'

require 'chars'

module Ronin
  module Support
    module Binary
      module Unhexdump
        #
        # @since 0.5.0
        #
        # @api semipublic
        #
        class Parser

          # The character type.
          #
          # @note it uses `'C'` as the pack string.
          CHAR_TYPE = CTypes::CharType.new(signed: false, pack_string: 'C')

          # Supported types.
          #
          # @note The `:char` and `:uchar` types to a custom char type that uses
          # `'C'` as it's pack string.
          TYPES = CTypes::TYPES.merge(
            char:  CHAR_TYPE,
            uchar: CHAR_TYPE
          )

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

          #
          # Initializes the hexdump parser.
          #
          # @param [:od, :hexdump] format
          #   The expected format of the hexdump. Must be either `:od` or
          #   `:hexdump`.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option kwargs [Symbol] :type
          #   Denotes the encoding used for the bytes within the hexdump.
          #   Must be one of the following:
          #   * `:byte` (default for `format: :hexdump`)
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
          #   * `:uint16_le` (default for `format: :od`)
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
          # @option kwargs [2, 8, 10, 16, nil] :address_base
          #   The numerical base that the offset addresses are encoded in.
          #   Defaults to 16 when `format: :hexdump` and 8 when `format: :od`.
          #
          # @option kwargs [2, 8, 10, 16, nil] :base
          #   The numerical base that the hexdumped numbers are encoded in.
          #   Defaults to 16 when `format: :hexdump` and 8 when `format: :od`.
          #
          # @option kwargs [Boolean] :named_chars
          #   Indicates to parse `od`-style named characters (ex: `nul`,
          #   `del`, etc). Only recognized when `format: :od` is also given.
          #
          # @raise [ArgumentError]
          #   Unsupported `type:` value, the `type:` value was not a scalar
          #   type, or the `format:` was not `:hexdump` or `:od`.
          #
          def initialize(format: :hexdump, **kwargs)
            case format
            when :od      then initialize_od(**kwargs)
            when :hexdump then initialize_hexdump(**kwargs)
            else
              raise(ArgumentError,"format: must be either :hexdump or :od, was #{format.inspect}")
            end

            case @type
            when CTypes::FloatType
              @parse_method = method(:parse_float)
            when CTypes::CharType
              @parse_method = method(:parse_char_or_int)
            when CTypes::ScalarType
              @parse_method = method(:parse_int)
            else
              raise(ArgumentError,"only scalar types are support: #{kwargs[:type].inspect}")
            end
          end

          private

          #
          # Initializes instance variables for the `od` hexdump format.
          #
          def initialize_od(type: :uint16_le,
                            base: nil,
                            address_base: nil,
                            named_chars: nil)
            @format = :od

            @type           = TYPES[type]
            @base           = base         || 8
            @address_base   = address_base || 8

            case @type
            when CTypes::CharType
              @chars = if named_chars then NAMED_CHARS
                       else                CHARS
                       end
            end
          end

          #
          # Initializes instance variables for the `hexdump` hexdump format.
          #
          def initialize_hexdump(type: :byte, base: nil, address_base: nil)
            @format = :hexdump

            @type           = TYPES[type]
            @base           = base         || 16
            @address_base   = address_base || 16

            case @type
            when CTypes::CharType
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
                previous_row_size    = (previous_row.length * @type.size)
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
          # Unhexdumps a hexdump and returns the unpacked values.
          #
          # @return [Array<Integer>, Array<String>, Array<Float>]
          #   The Array of unpacked values from the hexdump.
          #
          # @since 1.0.0
          #
          def unpack(hexdump)
            values = []

            parse(hexdump) do |address,row|
              values.concat(row)
            end

            return values
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
            if @type.kind_of?(CTypes::CharType)
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
            values.pack(@type.pack_string * values.length)
          end

        end
      end
    end
  end
end
