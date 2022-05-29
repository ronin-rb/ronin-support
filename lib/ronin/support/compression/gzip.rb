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

require 'ronin/support/compression/zlib'

require 'stringio'
require 'tempfile'

module Ronin
  module Support
    module Compression
      #
      # Handles GZip compression.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module GZip
        # Alias for `Zlib::GzipReader`
        #
        # @see https://rubydoc.info/stdlib/zlib/Zlib/GzipReader
        Reader = Zlib::GzipReader

        # Alias for `Zlib::GzipWriter`
        #
        # @see https://rubydoc.info/stdlib/zlib/Zlib/GzipWriter
        Writer = Zlib::GzipWriter

        #
        # Creates a gzip stream around the IO object.
        #
        # @param [IO, Tempfile, StringIO, String] io
        #   The IO object to read or write data to.
        #
        # @yield [gz]
        #   If a block is given, it will be passed the gzip stream object.
        #
        # @yieldparam [Zlib::GzipReader, Zlib::GzipWriter] gz
        #   The gzip reader or writer object.
        #
        # @return [Zlib::GzipReader, Zlib::GzipWriter]
        #   The gzip reader or writer object.
        #
        # @raise [ArgumentError]
        #   The IO object must be either an `IO`, `Tempfile`, `StringIO`, or
        #   `String` object. The mode must include either `r`, `w`, or `a`.
        #
        # @see https://rubydoc.info/stdlib/zlib/Zlib/GzipReader
        # @see https://rubydoc.info/stdlib/zlib/Zlib/GzipWriter
        #
        # @api public
        #
        def self.wrap(io, mode: 'r', &block)
          io = case io
               when String                 then StringIO.new(io)
               when IO, Tempfile, StringIO then io
               else
                 raise(ArgumentError,"IO argument must be either a IO, Tempfile, StringIO, or String")
               end

          gzip_class = if mode.include?('w') || mode.include?('a')
                         Zlib::GzipWriter
                       elsif mode.include?('r')
                         Zlib::GzipReader
                       else
                         raise(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
                       end

          return gzip_class.wrap(io,&block)
        end

        #
        # Opens a gzip file for reading or writing.
        #
        # @param [String] path
        #   The path to the gzip file.
        #
        # @param [String] mode
        #   The mode to open the file as.
        #
        # @yield [gz]
        #   If a block is given, it will be passed the gzip writer object.
        #
        # @yieldparam [Zlib::GzipWriter] gz
        #   The gzip writer object.
        #
        # @return [Zlib::GzipWriter]
        #   The gzip writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @see https://rubydoc.info/stdlib/zlib/Zlib/GzipWriter
        #
        # @api public
        #
        def self.open(path, mode: 'r', &block)
          gzip_class = if mode.include?('w') || mode.include?('a')
                         Zlib::GzipWriter
                       elsif mode.include?('r')
                         Zlib::GzipReader
                       else
                         raise(ArgumentError,"mode argument must include either 'r', 'w', or 'a'")
                       end

          return gzip_class.open(path,&block)
        end
      end
    end
  end
end
