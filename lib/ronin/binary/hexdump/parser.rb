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

require 'chars'

module Ronin
  module Binary
    module Hexdump
      #
      # @since 0.5.0
      #
      # @api semipublic
      #
      class Parser

        # Bases for various encodings
        BASES = {
          :binary         => 2,
          :octal          => 8,
          :octal_bytes    => 8,
          :octal_shorts   => 8,
          :octal_ints     => 8,
          :octal_quads    => 8,
          :decimal        => 10,
          :decimal_bytes  => 10,
          :decimal_shorts => 10,
          :decimal_ints   => 10,
          :decimal_quads  => 10,
          :hex            => 16,
          :hex_bytes      => 16,
          :hex_shorts     => 16,
          :hex_ints       => 16,
          :hex_quads      => 16,
          :named_chars    => 16,
          :floats         => 10,
          :doubles        => 10
        }

        # Wordsizes for various encodings
        WORD_SIZES = {
          :binary         => 1,
          :octal_bytes    => 1,
          :decimal_bytes  => 1,
          :hex_bytes      => 1,
          :hex_chars      => 1,
          :named_chars    => 1,
          :octal_shorts   => 2,
          :decimal_shorts => 2,
          :hex_shorts     => 2,
          :octal_ints     => 4,
          :decimal_ints   => 4,
          :hex_ints       => 4,
          :octal_quads    => 8,
          :decimal_quads  => 8,
          :hex_quads      => 8,
          :floats         => 4,
          :doubles        => 8
        }

        # The type of data to parse (`:integer` / `:float`)
        attr_reader :type

        # The endianness of data to parse (`:little`, `:big`, `:network`)
        attr_reader :endian

        # The size of words to parse
        attr_reader :word_size

        # The base of all addresses to parse
        attr_reader :address_base

        # The base of all words to parse
        attr_reader :base

        #
        # Initializes the hexdump parser.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Symbol] :format
        #   The expected format of the hexdump. Must be either `:od` or
        #   `:hexdump`.
        #
        # @option options [Symbol] :encoding
        #   Denotes the encoding used for the bytes within the hexdump.
        #   Must be one of the following:
        #
        #   * `:binary`
        #   * `:octal`
        #   * `:octal_bytes`
        #   * `:octal_shorts`
        #   * `:octal_ints`
        #   * `:octal_quads` (Ruby 1.9 only)
        #   * `:decimal`
        #   * `:decimal_bytes`
        #   * `:decimal_shorts`
        #   * `:decimal_ints`
        #   * `:decimal_quads` (Ruby 1.9 only)
        #   * `:hex`
        #   * `:hex_chars`
        #   * `:hex_bytes`
        #   * `:hex_shorts`
        #   * `:hex_ints`
        #   * `:hex_quads` (Ruby 1.9 only)
        #   * `:named_chars`
        #   * `:floats`
        #   * `:doubles`
        #
        # @option options [:little, :big, :network] :endian (:little)
        #   The endianness of the words.
        #
        def initialize(options={})
          @type   = :integer
          @endian = options.fetch(:endian,:little)

          case (@format = options[:format])
          when :od
            @address_base = 8
            @base         = 8
            @word_size    = 2
          when :hexdump
            @address_base = 16
            @base         = 16
            @word_size    = 2
          else
            @address_base = 16
            @base         = 16
            @word_size    = 1
          end

          if options[:encoding]
            case options[:encoding]
            when :floats, :doubles
              @type = :float
            end

            @base      = BASES.fetch(options[:encoding])
            @word_size = WORD_SIZES.fetch(options[:encoding])
          end

          case options[:encoding]
          when :hex_chars
            @chars = CHARS.merge(ESCAPED_CHARS)
          when :named_chars
            @chars = CHARS.merge(NAMED_CHARS)
          end
        end

        #
        # Parses a hexdump.
        #
        # @param [#each_line] hexdump
        #   The hexdump output.
        #
        # @return [String]
        #   The raw-data from the hexdump.
        #
        def parse(hexdump)
          current_addr = last_addr = first_addr = nil
          repeated = false

          segment = ''
          buffer  = ''

          hexdump.each_line do |line|
            if @format == :hexdump
              line = line.gsub(/\s+\|.+\|\s*$/,'')
            end

            words = line.split

            if words.first == '*'
              repeated = true
            elsif words.length > 0
              current_addr = parse_address(words.shift)
              first_addr ||= current_addr

              if repeated
                (((current_addr - last_addr) / segment.length) - 1).times do
                  buffer << segment
                end

                repeated = false
              end

              segment = pack(words.map { |word| parse_word(word) })

              buffer   << segment
              last_addr = current_addr
            end
          end

          return buffer[0,last_addr - first_addr]
        end

        protected

        # Visible characters
        CHARS = Hash[Chars::VISIBLE.chars.sort.zip(Chars::VISIBLE.bytes.sort)]

        # Escaped characters
        ESCAPED_CHARS = {
          '\0' => 0x00,
          '\a' => 0x07,
          '\b' => 0x08,
          '\t' => 0x09,
          '\n' => 0x0a,
          '\v' => 0x0b,
          '\f' => 0x0c,
          '\r' => 0x0d
        }

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
        }

        # `Array#pack` codes for various types/endianness/word-sizes
        FORMATS = {
          :integer => {
            :little => {
              1 => 'C',
              2 => (RUBY_VERSION > '1.9' ? 'S<' : 'v'),
              4 => (RUBY_VERSION > '1.9' ? 'L<' : 'V'),
              8 => 'Q<' # Ruby 1.9 only
            },

            :big => {
              1 => 'C',
              2 => (RUBY_VERSION > '1.9' ? 'S>' : 'n'),
              4 => (RUBY_VERSION > '1.9' ? 'L>' : 'N'),
              8 => 'Q>' # Ruby 1.9 only
            }
          },

          :float => {
            :little => {
              4 => 'e',
              8 => 'E'
            },

            :big => {
              4 => 'g',
              8 => 'G'
            }
          }
        }

        # alias network endianness to big endian
        FORMATS[:integer][:network] = FORMATS[:integer][:big]
        FORMATS[:float][:network]   = FORMATS[:float][:big]

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
        # Parses a character or hex-byte.
        #
        # @param [String] char
        #   The character to parse.
        #
        # @return [Integer]
        #   The parsed byte.
        #
        def parse_char(char)
          @chars.fetch(char) do |hex_byte|
            hex_byte.to_i(16)
          end
        end

        #
        # Parses an Integer.
        #
        # @param [String] int
        #   The text of the Integer.
        #
        # @return [Integer]
        #   The parsed word.
        #
        # @api private
        #   
        def parse_int(int)
          if @chars
            parse_char(int)
          else
            int.to_i(@base)
          end
        end

        #
        # Parses a float.
        #
        # @param [String] float
        #   The text of the float.
        #
        # @return [Float]
        #   The parsed float.
        #
        def parse_float(float)
          float.to_f
        end

        #
        # Parses a word within a segment.
        #
        # @param [String] word
        #   The word to parse.
        #
        # @return [Integer, Float]
        #   The value of the word.
        #  
        def parse_word(word)
          case @type
          when :integer
            parse_int(word)
          when :float
            parse_float(word)
          end
        end

        #
        # Packs a segment back into bytes.
        #
        # @param [Array<Integer, Float>] segment
        #   A segment of words.
        #
        # @return [String]
        #   The packed segment.
        #
        # @api private
        #   
        def pack(values)
          values.pack(FORMATS[@type][@endian][@word_size] * values.length)
        end

      end
    end
  end
end
