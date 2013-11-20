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

require 'ronin/fuzzing/extensions'

require 'set'

module Ronin
  #
  # Contains class-methods which generate malicious data for fuzzing.
  #
  # @see Fuzzing.[]
  #
  # @since 0.4.0
  #
  module Fuzzing
    # Short String lengths
    SHORT_LENGTHS = SortedSet[1, 100, 500, 1_000, 10_000]

    # Long String lengths
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
    # @raise [NoMethodError]
    #   The fuzzing method could not be found.
    #
    # @api semipublic
    #
    def self.[](name)
      if (!respond_to?(name) || Module.respond_to?(name))
        raise(NoMethodError,"no such fuzzing method: #{name}")
      end

      return enum_for(name)
    end

    module_function

    #
    # Various bad-strings.
    #
    # @yield [string]
    #   The given block will be passed each bad-string.
    #
    # @yieldparam [String] string
    #   A bad-string containing known control characters, deliminators
    #   or null-bytes (see {NULL_BYTES}), of varying length
    #   (see {SHORT_LENGTHS} and {LONG_LENGTHS}).
    #
    def bad_strings(&block)
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

    #
    # Various format-strings.
    #
    # @yield [fmt_string]
    #   The given block will be passed each format-string.
    #
    # @yieldparam [String] fmt_string
    #   A format-string containing format operators (see {FORMAT_STRINGS}).
    #
    def format_strings(&block)
      FORMAT_STRINGS.each do |fmt|
        yield fmt
        yield fmt * 100
        yield fmt * 500
        yield "\"#{fmt}\"" * 500
      end
    end

    #
    # Various bad paths and directory traversals.
    #
    # @yield [path]
    #   The given block will be passed each path.
    #
    # @yieldparam [String] path
    #   A known bad path.
    #
    def bad_paths(&block)
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

    #
    # The range of bit-fields.
    #
    # @yield [bitfield]
    #   The given block will be passed each bit-field.
    #
    # @yieldparam [String] bitfield
    #   A bit-field (8bit - 64bit).
    #
    def bit_fields(&block)
      ("\x00".."\xff").each do |c|
        yield c
        yield c << c # x2
        yield c << c # x4
        yield c << c # x8
      end
    end

    #
    # The range of signed bit-fields.
    #
    # @yield [bitfield]
    #   The given block will be passed each bit-field.
    #
    # @yieldparam [String] bitfield
    #   A signed bit-field (8bit - 64bit).
    #
    def signed_bit_fields(&block)
      ("\x80".."\xff").each do |c|
        yield c
        yield c << c # x2
        yield c << c # x4
        yield c << c # x8
      end
    end

    #
    # The range of unsigned 8bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A unsigned 8bit integer.
    #
    def uint8(&block)
      ("\x00".."\xff").each(&block)
    end

    #
    # The range of unsigned 16bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A unsigned 16bit integer.
    #
    def uint16
      uint8 { |c| yield c * 2 }
    end

    #
    # The range of unsigned 32bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A unsigned 32bit integer.
    #
    def uint32
      uint8 { |c| yield c * 4 }
    end

    #
    # The range of unsigned 64bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A unsigned 64bit integer.
    #
    def uint64
      uint8 { |c| yield c * 8 }
    end

    #
    # The range of signed 8bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A signed 8bit integer.
    #
    def int8(&block)
      ("\x00".."\x70").each(&block)
    end

    #
    # The range of signed 16bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A signed 16bit integer.
    #
    def int16
      int8 { |c| yield c * 2 }
    end

    #
    # The range of signed 32bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A signed 32bit integer.
    #
    def int32
      int8 { |c| yield c * 4 }
    end

    #
    # The range of signed 64bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A signed 64bit integer.
    #
    def int64
      int8 { |c| yield c * 8 }
    end

    #
    # The range of negative-signed 8bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A negative-signed 8bit integer.
    #
    def sint8(&block)
      ("\x80".."\xff").each(&block)
    end

    #
    # The range of negative-signed 16bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A negative-signed 16bit integer.
    #
    def sint16
      sint8 { |c| yield c * 2 }
    end

    #
    # The range of negative-signed 32bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A negative-signed 32bit integer.
    #
    def sint32
      sint8 { |c| yield c * 4 }
    end

    #
    # The range of negative-signed 64bit integers.
    #
    # @yield [int]
    #   The given block will be passed each integer.
    #
    # @yieldparam [String] int
    #   A negative-signed 64bit integer.
    #
    def sint64
      sint8 { |c| yield c * 8 }
    end

  end
end
