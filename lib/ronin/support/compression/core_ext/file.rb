# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/compression/gzip/reader'
require 'ronin/support/compression/gzip/writer'

class File

  #
  # Opens the gzipped file for reading.
  #
  # @param [String] path
  #   The path to the file to read.
  #
  # @yield [gz]
  #   If a block is given, it will be passed the gzip reader object.
  #
  # @yieldparam [Ronin::Support::Compression::Gzip::Reader] gz
  #   The gzip reader object.
  #
  # @return [Ronin::Support::Compression::Gzip::Reader]
  #   The gzip reader object.
  #
  # @example
  #   File.gunzip('wordlist.gz') do |gz|
  #     gz.each_line do |line|
  #       # ...
  #     end
  #   end
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.gunzip(path,&block)
    Ronin::Support::Compression::Gzip::Reader.open(path,&block)
  end

  #
  # Opens the gzip file for writing.
  #
  # @param [String] path
  #   The path to the file to write to.
  #
  # @yield [gz]
  #   If a block is given, it will be passed the gzip writer object.
  #
  # @yieldparam [Ronin::Support::Compression::Gzip::Writer] gz
  #   The gzip writer object.
  #
  # @return [Ronin::Support::Compression::Gzip::Writer]
  #   The gzip writer object.
  #
  # @example
  #   File.gunzip('file.gz') do |gz|
  #     # gzip header info
  #     gz.mtime = Time.now
  #     gz.orig_name = 'file.txt'
  #
  #     gz.write('Hello World!')
  #   end
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.gzip(path,&block)
    Ronin::Support::Compression::Gzip::Writer.open(path,&block)
  end

end
