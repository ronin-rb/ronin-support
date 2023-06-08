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

require 'ronin/support/archive/tar/reader'
require 'ronin/support/archive/tar/writer'
require 'ronin/support/archive/zip/reader'
require 'ronin/support/archive/zip/writer'

class File

  #
  # Opens the tar archive file for reading.
  #
  # @param [String] path
  #   The path to the file to read.
  #
  # @yield [tar]
  #   If a block is given, it will be passed the tar reader object.
  #
  # @yieldparam [Ronin::Support::Archive::Tar::Reader] tar
  #   The tar reader object.
  #
  # @return [Ronin::Support::Archive::Tar::Reader]
  #   The tar reader object.
  #
  # @example Enumerating over each entry in the tar archive:
  #   File.untar('file.tar') do |tar|
  #     tar.each do |entry|
  #       puts entry.full_name
  #       puts '-' * 80
  #       puts entry.read
  #       puts '-' * 80
  #     end
  #   end
  #
  # @example Reads a specific file from the tar archive:
  #   File.untar('file.tar') do |tar|
  #     data = tar.read('foo.txt')
  #     # ...
  #   end
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.untar(path,&block)
    Ronin::Support::Archive::Tar::Reader.open(path,&block)
  end

  #
  # Opens the tar archive file for writing.
  #
  # @param [String] path
  #   The path to the file to write to.
  #
  # @yield [tar]
  #   If a block is given, it will be passed the tar writer object.
  #
  # @yieldparam [Ronin::Support::Archive::Tar::Writer] tar
  #   The tar writer object.
  #
  # @return [Ronin::Support::Archive::Tar::Writer]
  #   The tar writer object.
  #
  # @example
  #   File.tar('output.tar') do |tar|
  #     tar.mkdir('foo')
  #     tar.add_file('foo/bar.txt','Hello World!')
  #   end
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.tar(path,&block)
    Ronin::Support::Archive::Tar::Writer.open(path,&block)
  end

  #
  # Opens the zip archive file for reading.
  #
  # @param [String] path
  #   The path to the file to read.
  #
  # @yield [zip]
  #   If a block is given, it will be passed the zip reader object.
  #
  # @yieldparam [Ronin::Support::Archive::Zip::Reader] zip
  #   The zip reader object.
  #
  # @return [Ronin::Support::Archive::Zip::Reader]
  #   The zip reader object.
  #
  # @example Enumerating over each file in a zip archive:
  #   File.unzip('file.zip') do |zip|
  #     zip.each do |entry|
  #       puts entry.name
  #       puts '-' * 80
  #       puts entry.read
  #       puts '-' * 80
  #     end
  #   end
  #
  # @example Reads a specific file from a zip archive:
  #   File.unzip('file.zip') do |zip|
  #     data = zip.read('foo.txt')
  #     # ...
  #   end
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.unzip(path,&block)
    Ronin::Support::Archive::Zip::Reader.open(path,&block)
  end

  #
  # Opens the zip archive file for writing.
  #
  # @param [String] path
  #   The path to the file to write to.
  #
  # @yield [zip]
  #   If a block is given, it will be passed the zip writer object.
  #
  # @yieldparam [Ronin::Support::Archive::Zip::Writer] zip
  #   The zip writer object.
  #
  # @return [Ronin::Support::Archive::Zip::Writer]
  #   The zip writer object.
  #
  # @example
  #   File.zip('output.zip') do |zip|
  #     zip.add_file('foo/bar.txt','Hello World!')
  #   end
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.zip(path,&block)
    Ronin::Support::Archive::Zip::Writer.open(path,&block)
  end

end
