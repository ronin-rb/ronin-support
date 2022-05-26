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

require 'ronin/support/compression/gzip'

class File

  #
  # Opens the gzip file for writing.
  #
  # @param [String] path
  #   The path to the file to write to.
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
  # @api public
  #
  # @since 1.0.0
  #
  def self.gzip(path,mode='w',&block)
    Ronin::Support::Compression::GZip.open(path, mode: mode, &block)
  end

  #
  # Opens the gzipped file for reading.
  #
  # @param [String] path
  #   The path to the file to read.
  #
  # @yield [gz]
  #   If a block is given, it will be passed the gzip reader object.
  #
  # @yieldparam [Zlib::GzipReader] gz
  #   The gzip reader object.
  #
  # @return [Zlib::GzipReader]
  #   The gzip reader object.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.gunzip(path,mode='r',&block)
    Ronin::Support::Compression::GZip.open(path, mode: mode, &block)
  end

end
