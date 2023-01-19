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

require 'date'

module Ronin
  module Support
    module Archive
      module Zip
        class Reader

          #
          # Represents an entry in a zip archive.
          #
          # @since 1.0.0
          #
          class Entry

            # The length of the file.
            #
            # @return [Integer]
            attr_reader :length

            # The compression method used.
            #
            # @return [:stored, :deflate]
            attr_reader :method

            # The size of the file.
            #
            # @return [Integer]
            attr_reader :size

            # The compression ratio of the file.
            #
            # @return [Integer]
            attr_reader :compression

            # The date of the file.
            #
            # @return [Date]
            attr_reader :date

            # The time of the file.
            #
            # @return [Time]
            attr_reader :time

            # The CRC32 checksum (in hex encoding).
            #
            # @return [String]
            attr_reader :crc32

            # The name of the file.
            #
            # @return [String]
            attr_reader :name

            #
            # Initializes the zip archive entry.
            #
            # @param [Reader] reader
            #
            # @param [Integer] length
            #
            # @param [:stored, :deflate] method
            #
            # @param [Integer] size
            #
            # @param [Integer] compression
            #
            # @param [Date] date
            #
            # @param [Time] time
            #
            # @param [String] crc32
            #
            # @param [String] name
            #
            # @api private
            #
            def initialize(reader, length: ,
                                   method: ,
                                   size:   ,
                                   compression: ,
                                   date: ,
                                   time: ,
                                   crc32: ,
                                   name: )
              @reader      = reader
              @length      = length
              @method      = method
              @size        = size
              @compression = compression
              @date        = date
              @time        = time
              @crc32       = crc32
              @name        = name
            end

            #
            # Reads the contents of the entry.
            #
            # @param [Integer, nil] length
            #   Optional number of bytes to read.
            #
            # @return [String]
            #   The read data.
            #
            def read(length=nil)
              @reader.read(@name, length: length)
            end

          end
        end
      end
    end
  end
end
