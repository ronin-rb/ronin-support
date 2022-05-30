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

require 'ronin/support/compression/tar/reader'
require 'ronin/support/compression/tar/writer'

module Ronin
  module Support
    module Compression
      #
      # Handles tar archive reading/writing.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Tar
        #
        # Creates a tar stream around the IO object.
        #
        # @param [IO, StringIO, String] io
        #   The IO object to read or write data to.
        #
        # @yield [gz]
        #   If a block is given, it will be passed the tar stream object.
        #
        # @yieldparam [Reader, Writer] tar
        #   The tar reader or writer object.
        #
        # @return [Reader, Writer]
        #   The gzip reader or writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @api public
        #
        def self.new(io, mode: 'r')
          tar_class = if mode.include?('w') || mode.include?('a')
                        Writer
                      elsif mode.include?('r')
                        Reader
                      else
                        raise(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
                      end

          tar = tar_class.new(io, mode: mode)

          if block_given?
            yield tar
            tar.close
          else
            return tar
          end
        end

        #
        # Opens the tar file for reading or writing.
        #
        # @param [String] path
        #   The path to the tar file.
        #
        # @param [String] mode
        #   The mode to open the file as.
        #
        # @yield [gz]
        #   If a block is given, it will be passed the gzip writer object.
        #
        # @yieldparam [Reader, Writer] tar
        #   The tar writer object.
        #
        # @return [Reader, Writer]
        #   The tar writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @api public
        #
        def self.open(path, mode: 'r', &block)
          if block
            File.open(path,mode) do |file|
              new(file, mode: mode,&block)
            end
          else
            new(File.new(path,mode), mode: mode)
          end
        end
      end
    end
  end
end
