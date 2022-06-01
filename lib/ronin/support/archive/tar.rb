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

require 'ronin/support/archive/tar/reader'
require 'ronin/support/archive/tar/writer'

module Ronin
  module Support
    module Archive
      #
      # Handles tar archive reading/writing.
      #
      # ## Examples
      #
      # Create a tar reader stream around an existing IO object:
      #
      #     Tar.new(io) do |tar|
      #       file = tar['file.txt']
      #       puts "#{file.full_name} (#{file.header.umode})"
      #       puts file.read
      #     end
      #
      # Opening a tar writer stream around an existing IO object:
      #
      #     Tar.new(io, mode: 'w') do |tar|
      #       # add a file
      #       tar.add_file('file1.txt', "...")
      #     
      #       # add a file and open an output stream
      #       tar.add_file('file2.txt') do |io|
      #         io.write("...")
      #       end
      #     
      #       # add a symlink 'link' pointing to 'file1.txt'
      #       tar.add_symlink('link','file1.txt')
      #     
      #       # add a directory
      #       tar.mkdir('foo')
      #     end
      #
      # Opening 
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
        # @yield [tar]
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
        # @example Creates a tar reader stream around an existing IO object:
        #   Tar.new(io) do |tar|
        #     # ...
        #   end
        #
        # @example Creates a tar writer stream around an existing IO object:
        #   Tar.new(io, mode: 'w') do |tar|
        #     # ...
        #   end
        #
        # @api public
        #
        def self.new(io, mode: 'r', &block)
          tar_class = if mode.include?('w') || mode.include?('a')
                        Writer
                      elsif mode.include?('r')
                        Reader
                      else
                        raise(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
                      end

          return tar_class.new(io, mode: mode, &block)
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
        # @example Open a tar file for reading:
        #   Tar.open(path) do |tar|
        #     # ...
        #   end
        #
        # @example Open a tar file for writing:
        #   Tar.open(path, mode: 'w') do |tar|
        #     # ...
        #   end
        #
        # @api public
        #
        def self.open(path, mode: 'r', &block)
          tar_class = if mode.include?('w') || mode.include?('a')
                        Writer
                      elsif mode.include?('r')
                        Reader
                      else
                        raise(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
                      end

          return tar_class.open(path,&block)
        end
      end
    end
  end
end
