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
require 'ronin/support/binary/stream/methods'

module Ronin
  module Support
    module Binary
      #
      # Represents a binary stream of data.
      #
      # ## Examples
      #
      # Creates a binary stream around a file:
      #
      #     stream = Stream.open('path/to/file.bin')
      #     stream.read_uint32
      #     # => 1234
      #
      # Creates a binary stream around a socket:
      #
      #     socket = TCPSocket.new('example.com',1337)
      #     stream = Stream.new(socket)
      #     stream.read_uint32
      #     # => 1234
      #     stream.write_uint32(0xffffffff)
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Stream

        include Methods

        # The endianness of data within the buffer.
        #
        # @return [:little, :big, :net, nil]
        attr_reader :endian

        # The desired architecture for the buffer.
        #
        # @return [Symbol, nil]
        attr_reader :arch

        # The type system that the buffer is using.
        #
        # @return [Types, Types::LittleEndian,
        #                 Types::BigEndian,
        #                 Types::Network]
        attr_reader :type_system

        # The underlying IO stream.
        #
        # @return [IO, StringIO]
        attr_reader :io

        #
        # Initializes the stream.
        #
        # @param [IO, StringIO] io
        #   The underlying IO stream.
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
        def initialize(io, endian: nil, arch: nil)
          @endian = endian
          @arch   = arch

          @type_system = if arch then Types.arch(arch)
                         else         Types.endian(endian)
                         end

          @io = io
        end

        #
        # Opens a file in binary mode and returns a stream.
        #
        # @param [String] path
        #   The path to the file.
        #
        # @param ["r", "w", "r+", "w+"] mode
        #   The mode to open the file in.
        #
        # @return [Stream]
        #   The newly created stream.
        #
        def self.open(path,mode='r')
          new(File.new(path,"#{mode}b"))
        end

        #
        # @group IO Compatibility Methods
        #

        #
        # Returns the external encoding for the stream.
        #
        # @return [Encoding]
        #
        def external_encoding
          @io.external_encoding
        end

        #
        # Determines if EOF has been reached.
        #
        # @return [Boolean]
        #
        def eof?
          @io.eof?
        end

        #
        # Reads a string from the IO stream.
        #
        # @param [Integer, nil] length
        #   The desired length of the string.
        #
        # @return [String]
        #   The read String.
        #
        def read(length=nil)
          @io.read(length)
        end

        #
        # Writes String to the IO stream.
        #
        # @param [String] data
        #   The data to write to the IO stream.
        #
        # @return [Integer]
        #   The number of bytes written to the IO stream.
        #
        def write(data)
          @io.write(data)
        end

      end
    end
  end
end
