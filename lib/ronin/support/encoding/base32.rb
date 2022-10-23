# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    class Encoding < ::Encoding
      #
      # Base32 encoding.
      #
      # @see https://datatracker.ietf.org/doc/html/rfc3548#page-6
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Base32
        #
        # Base32 encodes the given String.
        #
        # @param [String] data
        #   The String to encode.
        #
        # @return [String]
        #   The Base32 encoded String.
        #
        def self.encode(data)
          encoded = String.new

          each_chunk(data,5) do |chunk|
            chunk.encode(encoded)
          end

          return encoded
        end

        #
        # Base32 decodes the given String.
        #
        # @param [String] data
        #   The String to decode.
        #
        # @return [String]
        #   The Base32 decoded String.
        #
        def self.decode(data)
          decoded = String.new

          each_chunk(data,8) do |chunk|
            chunk.decode(decoded)
          end

          return decoded
        end

        private

        # Base32 alphabet
        TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'

        #
        # Represents a chunk of data.
        #
        class Chunk

          #
          # Initializes the chunk.
          #
          # @param [Array<Integer>] bytes
          #   The bytes for the chunk.
          #
          def initialize(bytes)
            @bytes = bytes
          end

          #
          # Decodes the chunk.
          #
          # @param [String] output
          #   Optional output buffer.
          #
          # @return [String]
          #   The Base32 decoded chunk.
          #
          def decode(output=String.new)
            bytes = @bytes.take_while { |b| b != 61 } # strip padding
            n = (bytes.length * 5.0 / 8.0).floor
            p = bytes.length < 8 ? 5 - (n * 8) % 5 : 0
            c = bytes.reduce(0) { |m,o|
              unless (i = Base32::TABLE.index(o.chr))
                raise ArgumentError, "invalid character '#{o.chr}'"
              end

              (m << 5) + i
            } >> p

            (0..n-1).reverse_each.each do |i|
              output << ((c >> i * 8) & 0xff).chr
            end

            return output
          end

          #
          # Encodes the chunk.
          #
          # @param [String] output
          #   Optional output buffer.
          #
          # @return [String]
          #   The Base32 encoded chunk.
          #
          def encode(output=String.new)
            n = (@bytes.length * 8.0 / 5.0).ceil
            p = n < 8 ? 5 - (@bytes.length * 8) % 5 : 0
            c = @bytes.inject(0) {|m,o| (m << 8) + o} << p

            (0..n-1).reverse_each do |i|
              output << Base32::TABLE[(c >> i * 5) & 0x1f].chr
            end

            return output << ("=" * (8-n))
          end

        end

        #
        # Enumerates over the consecutive chunks within the given data.
        #
        # @param [String] data
        #
        # @param [Integer] size
        #
        # @yield [chunk]
        #
        # @yieldparam [Chunk] chunk
        #
        def self.each_chunk(data,size)
          bytes  = data.bytes

          data.bytes.each_slice(size) do |bytes|
            yield Chunk.new(bytes)
          end
        end
      end
    end
  end
end

require 'ronin/support/encoding/base32/core_ext'
