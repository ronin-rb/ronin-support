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

module Ronin
  module Support
    module Binary
      #
      # Methods for performing bit-flipping.
      #
      # ## Core-Ext Methods
      #
      # * {::Integer#each_bit_flip}
      # * {::Integer#bit_flips}
      # * {::String#each_bit_flip}
      # * {::String#bit_flips}
      #
      # @api semipublic
      #
      module BitFlip
        #
        # Methods for bit-flipping Integers.
        #
        module Integer
          #
          # Enumerates over every bit flip in the integer.
          #
          # @param [Integer, Range(Integer)] bits
          #   The number of bits to flip or a range of bit indexes to flip.
          #
          # @yield [int]
          #   If a block is given, it will be passed each bit-flipped integer.
          #
          # @yieldparam [Integer] int
          #   The integer but with one of it's bits flipped.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator object will be returned.
          #
          # @raise [ArgumentError]
          #   The given bits must be either a Range or an Integer.
          #
          # @example bit-flip all eight bits:
          #   Binary::BitFlip::Byte.each_bit_flip(0x41,8) { |int| puts "%.8b" % int }
          #
          # @example bit-flip bits 8-16:
          #   Binary::BitFlip::Byte.each_bit_flip(0xffff,8...16) { |int| puts "%.16b" % int }
          #
          # @see Integer#each_bit_flip
          #
          def self.each_bit_flip(int,bits,&block)
            return enum_for(__method__,int,bits) unless block_given?

            bits = case bits
                   when ::Range   then bits
                   when ::Integer then (0...bits)
                   else
                     raise(ArgumentError,"bits must be an Integer or a Range: #{bits.inspect}")
                   end

            bits.each do |bit_index|
              mask = 1 << bit_index

              yield int ^ mask
            end
          end

          #
          # Returns every bit flip in the integer.
          #
          # @param [Integer, Range(Integer)] bits
          #   The number of bits to flip or a range of bit indexes to flip.
          #
          # @return [Array<Integer>]
          #   The bit-flipped integers.
          #
          # @raise [ArgumentError]
          #   The given bits must be either a Range or an Integer.
          #
          # @example bit-flip all eight bits:
          #   0x41.bit_flips(8)
          #
          # @example bit-flip bits 8-16:
          #   0xffff.bit_flips(8...16)
          #
          # @see Integer#bit_flips
          #
          def self.bit_flips(int,bits)
            each_bit_flip(int,bits).to_a
          end
        end

        #
        # Methods for bit-flipping Strings.
        #
        module String
          #
          # Enumerates over every bit flip of every byte in the string.
          #
          # @param [String] string
          #   The string to bit flip.
          #
          # @yield [string]
          #   If a block is given, it will be passed each bit-flipped string.
          #
          # @yieldparam [String] string
          #   The String, but with one of it's bits flipped.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator object will be returned.
          #
          # @example bit-flip all bytes in the String:
          #   Binary::BitFlip.each_bit_flip("foo") { |string| puts string }
          #
          # @see String#each_bit_flip
          #
          def self.each_bit_flip(string)
            return enum_for(__method__,string) unless block_given?

            bits = (0...8)

            string.each_byte.with_index do |byte,index|
              Integer.each_bit_flip(byte,bits) do |flipped_byte|
                new_string = string.dup
                new_string.force_encoding(Encoding::ASCII_8BIT)
                new_string.setbyte(index,flipped_byte)
                yield new_string
              end
            end

            return nil
          end

          #
          # Returns every bit flip of every byte in the string.
          #
          # @return [Array<String>]
          #   The bit-flipped strings.
          #
          # @example bit-flip all bytes in the String:
          #   Binary::BitFlip.bit_flips("foo")
          #
          # @api public
          #
          # @see String#bit_flips
          #
          def self.bit_flips(string)
            each_bit_flip(string).to_a
          end
        end
      end
    end
  end
end

require 'ronin/support/binary/bit_flip/core_ext'
