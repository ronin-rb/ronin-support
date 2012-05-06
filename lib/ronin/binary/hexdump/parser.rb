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

require 'ronin/formatting/extensions/binary/string'

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
        CHARS['nul'] = 0x00
        CHARS['soh'] = 0x01
        CHARS['stx'] = 0x02
        CHARS['etx'] = 0x03
        CHARS['eot'] = 0x04
        CHARS['enq'] = 0x05
        CHARS['ack'] = 0x06
        CHARS['bel'] = 0x07
        CHARS['bs']  = 0x08
        CHARS['ht']  = 0x09
        CHARS['lf']  = 0x0a
        CHARS['nl']  = 0x0a
        CHARS['vt']  = 0x0b
        CHARS['ff']  = 0x0c
        CHARS['cr']  = 0x0d
        CHARS['so']  = 0x0e
        CHARS['si']  = 0x0f
        CHARS['dle'] = 0x10
        CHARS['dc1'] = 0x11
        CHARS['dc2'] = 0x12
        CHARS['dc3'] = 0x13
        CHARS['dc4'] = 0x14
        CHARS['nak'] = 0x15
        CHARS['syn'] = 0x16
        CHARS['etb'] = 0x17
        CHARS['can'] = 0x18
        CHARS['em']  = 0x19
        CHARS['sub'] = 0x1a
        CHARS['esc'] = 0x1b
        CHARS['fs']  = 0x1c
        CHARS['gs']  = 0x1d
        CHARS['rs']  = 0x1e
        CHARS['us']  = 0x1f
        CHARS['sp']  = 0x20
        CHARS['del'] = 0x7f

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
        #   * `:hex_bytes`
        #   * `:hex_shorts`
        #   * `:hex_ints`
        #   * `:hex_quads`
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

          case options[:encoding]
          when :binary
            @base = 2
          when :octal, :octal_bytes, :octal_shorts, :octal_ints, :octal_quads
            @base = 8
          when :decimal, :decimal_bytes, :decimal_shorts, :decimal_ints, :decimal_quads
            @base = 10
          when :hex, :hex_bytes, :hex_shorts, :hex_ints, :hex_quads
            @base = 16
          end

          case options[:encoding]
          when :binary, :octal_bytes, :decimal_bytes, :hex_bytes
            @word_size = 1
          when :octal_shorts, :decimal_shorts, :hex_shorts
            @word_size = 2
          when :octal_ints, :decimal_ints, :hex_ints
            @word_size = 4
          when :octal_quads, :decimal_quads, :hex_quads
            @word_size = 8
          end

          @segment_length = options.fetch(:segment,16)
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
              current_addr = words.shift.to_i(@address_base)
              first_addr ||= current_addr

              if repeated
                (((current_addr - last_addr) / segment.length) - 1).times do
                  buffer += segment
                end

                repeated = false
              end

              segment.clear

              words.each do |word|
                if (@base != 10 && CHARS.has_key?(word))
                  segment << CHARS[word]
                else
                  segment += word.to_i(@base).bytes(@word_size)
                end
              end

              segment = segment[0,@segment_length]
              buffer += segment
              last_addr = current_addr
            end
          end

          return buffer[0,(last_addr - first_addr)]
        end

      end
    end
  end
end
