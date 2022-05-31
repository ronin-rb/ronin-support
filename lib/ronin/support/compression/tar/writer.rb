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

require 'rubygems/package'
require 'stringio'

module Ronin
  module Support
    module Compression
      module Tar
        #
        # Handles writing tar encoded archive data.
        #
        # @see https://rubydoc.info/stdlib/rubygems/Gem/Package/TarWriter
        #
        # @api public
        #
        # @since 1.0.0
        #
        class Writer < Gem::Package::TarWriter

          #
          # Initializes the tar writer.
          #
          # @param [IO, StringIO, String] io_or_buffer
          #   The IO object or buffer to write to. If a `String` is given, then
          #   it will be wrapped in a `StringIO` object using the optional
          #   `mode` argument.
          #
          # @param [String] mode
          #   The optional mode to initialize the `StringIO` object to wrap
          #   around the given buffer `String`.
          #
          # @yield [tar]
          #   If a block is given, it will be passed the new tar writer object.
          #
          # @yieldparam [Writer] tar
          #   The tar writer object.
          #
          # @return [Writer]
          #   The gzip writer object.
          #
          # @example Initializing with an IO object:
          #   tar = Compression::Tar::Writer.new(io)
          #
          # @example Initializing with a buffer:
          #   buffer = ""
          #   tar   = Compression::Tar::Writer.new(buffer)
          #
          # @example Initializin with a buffer and append mode:
          #   buffer = "foo"
          #   tar   = Compression::Tar::Writer.new(buffer, mode: 'a')
          #
          def self.new(io_or_buffer, mode: 'w', &block)
            io = case io_or_buffer
                 when String then StringIO.new(io_or_buffer,mode)
                 else             io_or_buffer
                 end

            return super(io,&block)
          end

          #
          # Opens the tar archive file for writing.
          #
          # @param [String] path
          #   The path to the tar archive.
          #
          # @yield [tar]
          #   If a block is given, then it will be passed the new tar writer
          #   object.
          #
          # @yieldparam [Writer] tar
          #   The newly created tar writer object.
          #
          # @return [Writer]
          #   If no block is given, than the tar writer object will be returned.
          #
          def self.open(path,&block)
            if block
              File.open(path,'wb') do |file|
                new(file,&block)
              end
            else
              return new(File.new(path,'wb'))
            end
          end

          #
          # Adds a file to the tar archive.
          #
          # @param [String] name
          #   The name or relative path of the new file.
          #
          # @param [String, nil] contents
          #   The optional contents of the file.
          #
          # @param [Integer] mode
          #   The permission mode for the new file.
          #
          # @yield [file]
          #   If a block is given, it will be yielded an output stream for the
          #   file that can be written to.
          #
          # @yieldparam [Gem::Package::TarWriter::RestrictedStream] file
          #
          # @return [self]
          #
          # @see https://rubydoc.info/stdlib/rubygems/Gem/Package/TarWriter/RestrictedStream
          #   
          def add_file(name,contents=nil, mode: 0644, &block)
            if contents
              super(name,mode) do |io|
                io.write(contents)
              end
            else
              super(name,mode,&block)
            end
          end

          #
          # Adds a file, with the exact size, to the tar archive.
          #
          # @param [String] name
          #   The name or relative path of the new file.
          #
          # @param [Integer] mode
          #   The permission mode for the new file.
          #
          # @yield [file]
          #   If a block is given, it will be yielded an output stream for the
          #   file that can be written to.
          #
          # @yieldparam [Gem::Package::TarWriter::BoundedStream] file
          #
          # @return [self]
          #
          # @see https://rubydoc.info/stdlib/rubygems/Gem/Package/TarWriter/BoundedStream
          #   
          def allocate_file(name,size, mode: 0644, &block)
            add_file_simple(name,mode,size,&block)
          end

          #
          # Adds a symlink to the tar archive.
          #
          # @param [String] name
          #   The name or relative path of the new symlink.
          #
          # @param [String] target
          #   The destination of the new symlink.
          #
          # @param [Integer] mode
          #   The permission mode of the new symlink.
          #
          def add_symlink(name,target, mode: 0777)
            super(name,target,mode)
          end

          #
          # Adds a directory to the tar archive.
          #
          # @param [String] name
          #   The name or relative path of the new directory.
          #
          # @param [Integer] mode
          #   The permission mode of the new directory.
          #
          # @return [self]
          #
          def mkdir(name, mode: 0755)
            super(name,mode)
          end

        end
      end
    end
  end
end
