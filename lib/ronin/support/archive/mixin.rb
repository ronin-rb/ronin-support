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

require 'ronin/support/archive'

module Ronin
  module Support
    module Archive
      #
      # Provides helper methods for reading/writing archives.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Mixin
        #
        # Creates a tar stream around the IO object.
        #
        # @param [IO, StringIO] io
        #   The IO object to read or write data to.
        #
        # @param [String] mode
        #   The mode to open the tar stream with.
        #
        # @yield [tar]
        #   If a block is given, it will be passed the tar stream object.
        #
        # @yieldparam [Tar::Reader, Tar::Writer] tar
        #   The tar reader or writer object.
        #
        # @return [Tar::Reader, Tar::Writer]
        #   The tar reader or writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @see Tar.new
        #
        # @api public
        #
        def tar_stream(io, mode: 'r', &block)
          Archive.tar_stream(io, mode: mode, &block)
        end

        #
        # Opens a tar file for reading or writing.
        #
        # @param [String] path
        #   The path to the tar file.
        #
        # @param [String] mode
        #   The mode to open the file as.
        #
        # @yield [tar]
        #   If a block is given, it will be passed the tar writer object.
        #
        # @yieldparam [Tar::Writer] tar
        #   The tar writer object.
        #
        # @return [Tar::Writer]
        #   The tar writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @see Tar.open
        #
        # @api public
        #
        def tar_open(path, mode: 'r', &block)
          Archive.tar_open(path, mode: mode, &block)
        end

        #
        # Opens the tarped file for reading.
        #
        # @param [String] path
        #   The path to the file to read.
        #
        # @yield [tar]
        #   If a block is given, it will be passed the tar reader object.
        #
        # @yieldparam [Tar::Reader] tar
        #   The tar reader object.
        #
        # @return [Tar::Reader]
        #   The tar reader object.
        #
        # @see tar_open
        #
        # @api public
        #
        def untar(path,&block)
          Archive.untar(path,&block)
        end

        #
        # Opens the tar file for writing.
        #
        # @param [String] path
        #   The path to the file to write to.
        #
        # @yield [tar]
        #   If a block is given, it will be passed the tar writer object.
        #
        # @yieldparam [Tar::Writer] tar
        #   The tar writer object.
        #
        # @return [Tar::Writer]
        #   The tar writer object.
        #
        # @see tar_open
        #
        # @api public
        #
        def tar(path,&block)
          Archive.tar(path,&block)
        end

        #
        # Opens a zip file for reading or writing.
        #
        # @param [String] path
        #   The path to the zip file.
        #
        # @param [String] mode
        #   The mode to open the file as.
        #
        # @yield [zip]
        #   If a block is given, it will be passed the zip writer object.
        #
        # @yieldparam [Zip::Writer] zip
        #   The zip writer object.
        #
        # @return [Zip::Writer]
        #   The zip writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @see Zip.open
        #
        # @api public
        #
        def zip_open(path, mode: 'r', &block)
          Archive.zip_open(path, mode: mode, &block)
        end

        #
        # Opens the zipped file for reading.
        #
        # @param [String] path
        #   The path to the file to read.
        #
        # @yield [zip]
        #   If a block is given, it will be passed the zip reader object.
        #
        # @yieldparam [Zip::Reader] zip
        #   The zip reader object.
        #
        # @return [Zip::Reader]
        #   The zip reader object.
        #
        # @see zip_open
        #
        # @api public
        #
        def unzip(path,&block)
          Archive.unzip(path,&block)
        end

        #
        # Opens the zip file for writing.
        #
        # @param [String] path
        #   The path to the file to write to.
        #
        # @yield [zip]
        #   If a block is given, it will be passed the zip writer object.
        #
        # @yieldparam [Zip::Writer] zip
        #   The zip writer object.
        #
        # @return [Zip::Writer]
        #   The zip writer object.
        #
        # @see zip_open
        #
        # @api public
        #
        def zip(path,&block)
          Archive.zip(path,&block)
        end
      end
    end
  end
end
