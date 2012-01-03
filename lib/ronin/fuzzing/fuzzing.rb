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
  module Fuzzing
    SHORT_LENGTHS = SortedSet[1, 100, 500, 1_000, 10_000]

    LONG_LENGTHS = SortedSet[
      128, 255, 256, 257, 511, 512, 513, 1023, 1024, 2048, 2049, 4095,
      4096, 4097, 5_000, 10_000, 20_000, 32762, 32763, 32764, 32765, 32766,
      32767, 32768, 32769,
      0xffff-2, 0xffff-1, 0xffff, 0xffff+1, 0xffff+2,
      99_999, 100_000, 500_000, 1_000_000
    ]

    # Null bytes in various encodings
    NULL_BYTES = ['%00', '%u0000', "\x00"]

    # Newline characters
    NEW_LINES = ["\n", "\r", "\n\r"]

    # Format String flags
    FORMAT_STRINGS = ['%p', '%s', '%n']

    #
    # Returns a fuzzer method.
    #
    # @param [Symbol] name
    #   The name of the fuzzer to return.
    #
    # @return [Enumerator]
    #   An Enumerator for the fuzzer method.
    #
    # @api semipublic
    #
    # @since 0.4.0
    #
    def self.[](name)
      if (!Object.respond_to?(name) && respond_to?(name))
        enum_for(name)
      end
    end

    def self.bad_strings(&block)
      yield ''

      chars = [
        'A', 'a', '1', '<', '>', '"', "'", '/', "\\", '?', '=', 'a=', '&',
        '.', ',', '(', ')', ']', '[', '%', '*', '-', '+', '{', '}',
        "\x14", "\xfe", "\xff"
      ]
      
      chars.each do |c|
        LONG_LENGTHS.each { |length| yield c * length }
      end

      yield '!@#$%%^#$%#$@#$%$$@#$%^^**(()'
      yield '%01%02%03%04%0a%0d%0aADSF'
      yield '%01%02%03@%04%0a%0d%0aADSF'

      NULL_BYTES.each do |c|
        SHORT_LENGTHS.each { |length| yield c * length }
      end

      yield "%\xfe\xf0%\x00\xff"
      yield "%\xfe\xf0%\x00\xff" * 20

      SHORT_LENGTHS.each do |length|
        yield "\xde\xad\xbe\xef" * length
      end

      yield "\n\r" * 100
      yield "<>"   * 500
    end

    def self.format_strings(&block)
      FORMAT_STRINGS.each do |fmt|
        yield fmt
        yield fmt * 100
        yield fmt * 500
        yield "\"#{fmt}\"" * 500
      end
    end

    def self.bad_paths(&block)
      padding = 'A' * 5_000

      yield "/.:/#{padding}\x00\x00"
      yield "/.../#{padding}\x00\x00"

      yield "\\\\*"
      yield "\\\\?\\"

      yield "/\\" * 5_000
      yield '/.'  * 5_000

      NULL_BYTES.each do |c|
        if c.start_with?('%')
          yield "#{c}/"
          yield "/#{c}"
          yield "/#{c}/"
        end
      end
    end

    def self.bit_fields(&block)
      ("\x00".."\xff").each do |c|
        yield c
        yield c << c # x2
        yield c << c # x4
        yield c << c # x8
      end
    end

    def self.signed_bit_fields(&block)
      ("\x80".."\xff").each do |c|
        yield c
        yield c << c # x2
        yield c << c # x4
        yield c << c # x8
      end
    end

    def self.uint8(&block)
      ("\x00".."\xff").each(&block)
    end

    def self.uint16
      uint8 { |c| yield c * 2 }
    end

    def self.uint32
      uint8 { |c| yield c * 4 }
    end

    def self.uint64
      uint8 { |c| yield c * 8 }
    end

    def self.int8(&block)
      ("\x00".."\x70").each(&block)
    end

    def self.int16
      int8 { |c| yield c * 2 }
    end

    def self.int32
      int8 { |c| yield c * 4 }
    end

    def self.int64
      int8 { |c| yield c * 8 }
    end

    def self.sint8(&block)
      ("\x80".."\xff").each(&block)
    end

    def self.sint16
      sint8 { |c| yield c * 2 }
    end

    def self.sint32
      sint8 { |c| yield c * 4 }
    end

    def self.sint64
      sint8 { |c| yield c * 8 }
    end

  end
end
