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

require 'ronin/support/binary/types'

module Ronin
  module Support
    module Binary
      #
      # Represents a stack that can have binary data pushed to or popped from
      # it.
      #
      # ## Examples
      #
      # Creating a new stack:
      #
      #     stack = Stack.new
      #     # => #<Ronin::Support::Binary::Stack: "">
      #     stack.push 10
      #     # => #<Ronin::Support::Binary::Stack: "\n\x00\x00\x00\x00\x00\x00\x00">
      #     stack.push 0x41414141
      #     # => #<Ronin::Support::Binary::Stack: "\n\x00\x00\x00\x00\x00\x00\x00AAAA\x00\x00\x00\x00">
      #     stack.psuh -1
      #     # => #<Ronin::Support::Binary::Stack: "\n\x00\x00\x00\x00\x00\x00\x00AAAA\x00\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF">
      #
      # Creating a stack from an existing String:
      #
      #     stack = Stack.new("\x41\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x00\x00\x00\x00\x00")
      #     stack[0]
      #     # => 65
      #     stack[8]
      #     # => 66
      #
      # Negative indexing within the stack:
      #
      #     stack.push(65)
      #     stack.push(66)
      #     stack[-8]
      #     # => 65
      #     stack[-16]
      #     # => 66
      #
      # Note: negative indexes are treated relative to the beginning of the
      # stack, since stacks grow downward in the address space.
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Stack

        # The endianness of data within the array buffer.
        #
        # @return [:little, :big, :net, nil]
        attr_reader :endian

        # The desired architecture for the array buffer.
        #
        # @return [Symbol, nil]
        attr_reader :arch

        # The type system that the buffer is using.
        #
        # @return [Types, Types::LittleEndian,
        #                 Types::BigEndian,
        #                 Types::Network]
        attr_reader :type_system

        # The "machine word" from the {#type_system}.
        #
        # @return [Types::UInt32Type, Types::UInt64Type]
        attr_reader :machine_word

        # The number of machine words on the stack.
        #
        # @return [Integer]
        attr_reader :length

        # The size of the stack in bytes.
        #
        # @return [Integer]
        attr_reader :size

        # The underlying buffer for the stack.
        #
        # @return [String]
        attr_reader :string

        #
        # Initializes the stack.
        #
        # @param [String, nil] string
        #   Optional existing stack contents.
        #
        # @param [:little, :big, :net, nil] endian
        #   The desired endianness of the values within the buffer.
        #
        # @param [:x86, :x86_64,
        #         :ppc, :ppc64,
        #         :mips, :mips_le, :mips_be,
        #         :mips64, :mips64_le, :mips64_be,
        #         :arm, :arm_le, :arm_be,
        #         :arm64, :arm64_le, :arm64_be] arch
        #   The desired architecture for the values within the buffer.
        #
        def initialize(string=nil, endian: nil, arch: nil)
          @endian = endian
          @arch   = arch

          @type_system = if arch then Types.arch(arch)
                         else         Types.endian(endian)
                         end

          @machine_word = @type_system::MACHINE_WORD

          if string
            @string = string
            @size   = @string.bytesize
            @length = @size / @machine_word.size
          else
            @string = String.new("", encoding: Encoding::ASCII_8BIT)
            @size   = 0
            @length = 0
          end
        end

        #
        # Accesses a machine word at the given index within the stack.
        #
        # @param [Integer] index
        #   The byte offset within the stack to read from.
        #
        # @return [Integer]
        #   The value at the index within the stack.
        #
        # @raise [IndexError]
        #
        # @note
        #   negative offsets are treated as relative to the bottom or the
        #   beginning of the stack, since stack grow downward in the address
        #   space.
        #
        def [](index)
          offset = if index < 0 then index.abs - @machine_word.size
                   else              index
                   end

          if offset+@machine_word.size > @size
            raise(IndexError,"index #{index} is out of bounds: 0...#{@size}")
          end

          data = @string[offset,@machine_word.size]
          return @machine_word.unpack(data)
        end

        #
        # Sets a machine word at the given index within the stack.
        #
        # @param [Integer] index
        #   The byte offset within the stack to write to.
        #
        # @param [Integer] value
        #   The value to write at the index within the stack.
        #
        # @return [Integer]
        #   The written value.
        #
        # @raise [IndexError]
        #
        # @note
        #   negative offsets are treated as relative to the bottom or the
        #   beginning of the stack, since stacks grow downward in the address
        #   space.
        #
        def []=(index,value)
          offset = if index < 0 then index.abs - @machine_word.size
                   else              index
                   end

          if offset+@machine_word.size > @size
            raise(IndexError,"index #{index} is out of bounds: 0...#{@size}")
          end

          data = @machine_word.pack(value)
          @string[offset,@machine_word.size] = data
          return value
        end

        #
        # Pushes a value onto the top of the stack (or to the end of the
        # underlying buffer).
        #
        # @param [Integer] value
        #   The value to push onto the stack.
        #
        # @return [self]
        #
        def push(value)
          data = @machine_word.pack(value)

          @string << data
          @length += 1
          @size   += @machine_word.size
          return self
        end

        #
        # Pops a value off the top of the stack (or to the end of the underlying
        # buffer).
        #
        # @return [Integer]
        #   The value popped from the stack.
        #
        def pop
          data  = @string[-@machine_word.size..]
          value = @machine_word.unpack(data)

          @length -= 1
          @size   -= @machine_word.size

          @string = @string.byteslice(0,@size)
          return value
        end

        #
        # Cnnverts the stack into a String.
        #
        # @return [String]
        #   The underlying buffer for the stack.
        #
        def to_s
          @string
        end

        alias to_str to_s

        #
        # Inspects the stack object.
        #
        # @return [String]
        #
        def inspect
          "#<#{self.class}: #{@string.inspect}>"
        end

      end
    end
  end
end
