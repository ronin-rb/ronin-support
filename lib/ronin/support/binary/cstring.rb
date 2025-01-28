# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/memory'

module Ronin
  module Support
    module Binary
      #
      # Represents a null terminated C string.
      #
      # ## Examples
      #
      # ### Initializing C Strings
      #
      # From a String:
      #
      #     str = Binary::CString.new("hello ")
      #     # => #<Ronin::Support::Binary::CString:0x00007fc94ba577f8 @string="hello \u0000">
      #
      # From a binary C string:
      #
      #     str = Binary::CString.new("world\0".b)
      #     # => #<Ronin::Support::Binary::CString:0x00007fc94ba06f88 @string="world\u0000">
      #
      # From characters:
      #
      #     str = Binary::CString['A', 'B', 'C']
      #     # => #<Ronin::Support::Binary::CString:0x00007fc94ba6f268 @string="ABC\x00">
      #
      # ### Modifying C Strings
      #
      # Concating Strings to a C String:
      #
      #     str = Binary::CString.new("hello ")
      #     str.concat("world")
      #     # => #<Ronin::Support::Binary::CString:0x00007fc94b978df0 @string="hello world\u0000">
      #     str.to_s
      #     # => "hello world"
      #
      # Appending two C Strings:
      #
      #     str1 = Binary::CString.new("hello ")
      #     str2 = Binary::CString.new("world\0")
      #     str = str1 + str2
      #     # => #<Ronin::Support::Binary::CString:0x00007fc94b9523f8 @string="hello world\u0000">
      #
      # Setting characters:
      #
      #     str = Binary::CString.new("hello")
      #     str[0] = 'X'
      #     str.to_s
      #     # => "Xello"
      #
      # @api public
      #
      # @since 1.0.0
      #
      class CString < Memory

        # Null byte
        NULL = "\0".encode(Encoding::ASCII_8BIT).freeze

        #
        # Initializes the C string.
        #
        # @param [String, ByteSlice, nil] value
        #   The contents of the C string.
        #
        def initialize(value=nil)
          case value
          when String
            if value.include?(NULL)
              super(value)
            else
              # ensure the C String ends in or contains a NULL byte.
              super("#{value}#{NULL}")
            end
          when nil
            # initialize with a single \0 byte
            super(1)
          else
            super(value)
          end
        end

        #
        # Creates a C string.
        #
        # @param [Array<Integer>, Array<String>] values
        #   The bytes or characters for the new C string.
        #
        # @return [CString]
        #   The newly created C string.
        #
        # @example Create a C string from a series of bytes:
        #   Binary::CString[0x41, 0x41, 0x41, 0x00, 0x00, 0x00]
        #
        # @example Create a C string from a series of chars:
        #   Binary::CString['A', 'A', 'A']
        #
        # @example Create a C string from a String:
        #   Binary::CString["AAA"]
        #
        # @see #initialize
        #
        def self.[](*values)
          buffer = String.new

          values.each do |element|
            buffer << case element
                      when Integer then element.chr
                      else              element.to_s
                      end
          end

          # ensure the C String ends in or contains a NULL byte.
          buffer << NULL unless buffer.include?(NULL)

          return new(buffer)
        end

        #
        # Concatinates a character, byte, or String to the C string.
        #
        # @param [String, Integer, #to_s] value
        #   The other String to concat to the C string.
        #
        # @return [self]
        #
        def concat(value)
          value      = case value
                       when Integer then value.chr
                       else              value.to_s
                       end
          value_size = value.bytesize

          unless value.include?(NULL)
            value = "#{value}#{NULL}"

            value_size += 1
          end

          self[null_index,value_size] = value
          return self
        end

        alias << concat

        #
        # Creates a new C string by adding two C strings together.
        #
        # @param [#to_s, Integer] other
        #   The other String or an offset.
        #
        # @return [CString, ByteSlice]
        #   The new combined C string, or a {ByteSlice} if an offset Integer
        #   was given.
        #
        def +(other)
          case other
          when Integer then super(other)
          else              CString.new(to_s + other.to_s)
          end
        end

        #
        # Enumerates over each characters within the C string.
        #
        # @yield [char]
        #   If a block is given, it will be passed each character within the C
        #   string.
        #
        # @yieldparam [String] char
        #   A character within the C string.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        def each_char
          return enum_for(__method__) unless block_given?

          @string.each_char do |char|
            break if char == NULL

            yield char
          end
        end

        #
        # The characters within the C string.
        #
        # @return [Array<String>]
        #   The Array of characters within the C string.
        #
        def chars
          each_char.to_a
        end

        #
        # Enumerates over each byte within the C string.
        #
        # @yield [byte]
        #   If a block is given, it will be passed each character within the C
        #   string.
        #
        # @yieldparam [Integer] byte
        #   A byte within the C string.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        def each_byte(&block)
          return enum_for(__method__) unless block_given?

          @string.each_byte do |byte|
            break if byte == 0x00

            yield byte
          end
        end

        #
        # The bytes within the C string.
        #
        # @return [Array<Integer>]
        #   The Array of bytes within the C string.
        #
        def bytes
          each_byte.to_a
        end

        #
        # Searches for the char, byte, substring, or regexp within the C string.
        #
        # @param [String, Integer, Regexp] key
        #   The char, byte, substring, or Regexp to search for.
        #
        # @return [Integer, nil]
        #   The index of the char, byte, substring, or Regexp.
        #
        def index(key)
          if (index = @string.index(key))
            if index < null_index
              return index
            end
          end
        end

        #
        # The length of the C string.
        #
        # @return [Integer]
        #   The number of non-null characters in the String.
        #
        def length
          null_index || size
        end

        alias len length

        #
        # Converts the C stirng into a regular String.
        #
        # @return [String]
        #   The C string without it's terminating null byte.
        #
        def to_s
          if (length = null_index)
            @string[0,length]
          else
            @string.to_s
          end
        end

        private

        #
        # Finds the index of the first null byte (`\0`).
        #
        # @return [Integer, nil]
        #
        def null_index
          @string.index(NULL)
        end

      end
    end
  end
end
