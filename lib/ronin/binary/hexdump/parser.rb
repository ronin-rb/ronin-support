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

        include Chars

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
          :named_chars    => 16
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
          :hex_quads      => 8
        }

        CHARS = Hash[PRINTABLE.chars.sort.zip(PRINTABLE.bytes.sort)]
        CHARS['\0'] = 0x00
        CHARS['\a'] = 0x07
        CHARS['\b'] = 0x08
        CHARS['\t'] = 0x09
        CHARS['\n'] = 0x0a
        CHARS['\v'] = 0x0b
        CHARS['\f'] = 0x0c
        CHARS['\r'] = 0x0d

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

        # Default segment length
        SEGMENT_LENGTH = 16

        # The base of all addresses to parse
        attr_accessor :address_base

        # The base of all words to parse
        attr_accessor :base

        # The size of words to parse
        attr_accessor :word_size

        # The length of the segment to parse
        attr_accessor :segment_length

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
        #   * `:octal_quads`
        #   * `:decimal`
        #   * `:decimal_bytes`
        #   * `:decimal_shorts`
        #   * `:decimal_ints`
        #   * `:decimal_quads`
        #   * `:hex`
        #   * `:hex_chars`
        #   * `:hex_bytes`
        #   * `:hex_shorts`
        #   * `:hex_ints`
        #   * `:hex_quads`
        #   * `:named_chars`
        #
        # @option options [:little, :big, :network] :endian (:little)
        #   The endianness of the words.
        #
        # @option options [Integer] :segment (16)
        #   The length in bytes of each segment in the hexdump.
        #
        def initialize(options={})
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
            @base      = BASES.fetch(options[:encoding])
            @word_size = WORD_SIZES.fetch(options[:encoding])
          end

          @endian = options.fetch(:endian,:little)

          case options[:encoding]
          when :hex_chars
            @chars = CHARS
          when :named_chars
            @chars = CHARS.merge(NAMED_CHARS)
          end

          @segment_length = options.fetch(:segment,SEGMENT_LENGTH)
        end

        #
        # Parses a hexdump.
        #
        # @param [#each_line] hexdump
        #   The hexdump output.
        #
        # @return [Array<Integer>]
        #   The raw-data from the hexdump.
        #
        def parse(hexdump)
          current_addr = last_addr = first_addr = nil
          repeated = false

          segment = []
          buffer  = []

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
                  buffer += segment
                end

                repeated = false
              end

              segment.clear

              words.each do |word|
                parse_bytes(parse_word(word)) do |byte|
                  segment << byte
                end
              end

              segment   = segment[0,@segment_length]
              buffer   += segment
              last_addr = current_addr
            end
          end

          return buffer[0,(last_addr - first_addr)]
        end

        protected

        def parse_address(address)
          address.to_i(@address_base)
        end

        def parse_word(word)
          if (@chars && @chars.has_key?(word))
            @chars[word]
          else
            word.to_i(@base)
          end
        end

        def parse_bytes(word,&block)
          case @endian
          when :little
            mask = 0xff
            shift = 0

            @word_size.times do
              yield (word & mask) >> shift

              mask <<= 8
              shift += 8
            end
          when :big, :network
            mask = 0xff << (8 * (@word_size - 1))
            shift = (@word_size - 1)

            @word_size.times do
              yield (word & mask) >> shift

              mask >>= 8
              shift -= 8
            end
          else
            raise(StandardError,"invalid endianness: #{@endian}")
          end
        end

      end
    end
  end
end
