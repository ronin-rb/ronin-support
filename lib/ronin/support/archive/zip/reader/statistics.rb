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
          # Represents the overall statistics for the zip archive.
          #
          class Statistics

            # The total zip archive length.
            #
            # @return [Integer]
            attr_reader :length

            # The total zip archive size.
            #
            # @return [Integer]
            attr_reader :size

            # The total compression ratio of the zip archive.
            #
            # @return [Integer]
            attr_reader :compression

            # The total number of files in the zip archive.
            #
            # @return [Integer]
            attr_reader :files

            #
            # Initializes the statistics object.
            #
            # @param [Integer] length
            #
            # @param [Integer] size
            #
            # @param [Integer] compression
            #
            # @param [Integer] files
            #
            # @api private
            #
            def initialize(length: , size: , compression: , files: )
              @length      = length
              @size        = size
              @compression = compression
              @files       = files
            end

          end
        end
      end
    end
  end
end
