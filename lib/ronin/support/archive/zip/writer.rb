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

require 'tmpdir'
require 'fileutils'

module Ronin
  module Support
    module Archive
      module Zip
        #
        # Handles creating zip archives.
        #
        # @note
        #   This provides a simple interface for creating zip archives using
        #   the `zip` command. If you need something more powerful, use the
        #   [archive-zip] gem instead.
        #
        # [archive-zip]: https://github.com/javanthropus/archive-zip
        #
        # @api public
        #
        # @since 1.0.0
        #
        class Writer

          # The path to the zip archive.
          #
          # @return [String]
          attr_reader :path

          # The optional password for the zip archive.
          #
          # @return [String, nil]
          attr_reader :password

          # The temp directory where the contents of the zip archive will be
          # written into before zipping.
          #
          # @return [String]
          #
          # @api private
          attr_reader :tempdir

          #
          # Initializes the zip writer.
          #
          # @param [String] path
          #   The path to the zip archive.
          #
          # @param [String, nil] password
          #   The optional password for the zip archive.
          #
          # @yield [self]
          #   If a block is given it will be passed the zip archive writer.
          #
          def initialize(path, password: nil)
            @path     = File.expand_path(path)
            @password = password

            @tempdir  = Dir.mktmpdir('ronin-support')

            if block_given?
              yield self
              close
            end
          end

          #
          # Alias for {new}.
          #
          # @param [String] path
          #   The path to the zip archive.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {new}.
          #
          # @option kwargs [String, nil] :password
          #   The optional password for the zip archive.
          #
          # @yield [zip]
          #   If a block is given it will be passed the zip archive writer.
          #
          # @yieldparam [Writer] zip
          #   The newly created zip archive writer.
          #
          # @see new
          #
          def self.open(path,**kwargs,&block)
            new(path,**kwargs,&block)
          end

          #
          # Adds a file to the zip archive.
          #
          # @param [String] name
          #   The relative path to the file.
          #
          # @param [String, nil] contents
          #   The optional contents for the file.
          #
          # @yield [file]
          #   If a block is given, it will be passed the opened file for
          #   writing.
          #
          # @yieldparam [File] file
          #   The opened file for writing.
          #
          def add_file(name,contents=nil,&block)
            file_path = File.join(@tempdir,name)

            if contents
              File.write(file_path,contents)
            else
              File.open(file_path,'w',&block)
            end
          end

          #
          # Saves the contents of the zip archive to {#path}.
          #
          # @api private
          #
          def save
            Dir.chdir(@tempdir) do
              args = ['-q']

              if @password
                args << '-P' << @password
              end

              system('zip',*args,'-r',@path,'.')
            end
          end

          #
          # Cleanup the zip archive's {#tempdir}.
          #
          # @api private
          #
          def cleanup
            FileUtils.rm_r(@tempdir)
          end

          #
          # Closes the zip archive.
          #
          def close
            save
            cleanup
          end

        end
      end
    end
  end
end
