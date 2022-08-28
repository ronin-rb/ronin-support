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

require 'ronin/support/compression'
require 'ronin/support/compression/gzip/reader'
require 'ronin/support/compression/gzip/writer'

class String

  #
  # Zlib inflate a string.
  #
  # @return [String]
  #   The Zlib inflated form of the string.
  #
  # @example
  #   "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15".zlib_inflate
  #   # => "hello"
  #
  # @api public
  #
  def zlib_inflate
    Ronin::Support::Compression.zlib_inflate(self)
  end

  #
  # Zlib deflate a string.
  #
  # @return [String]
  #   The Zlib deflated form of the string.
  #
  # @example
  #   "hello".zlib_deflate
  #   # => "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15"
  #
  # @api public
  #
  def zlib_deflate
    Ronin::Support::Compression.zlib_deflate(self)
  end

  #
  # Gzip uncompresses the string.
  #
  # @return [String]
  #   The gunzipped version of the string.
  #
  # @example
  #   "\x1F\x8B\b\x00K\x05\x8Fb\x00\x03\xCBH\xCD\xC9\xC9W(\xCF/\xCAI\xE1\x02\x00-;\b\xAF\f\x00\x00\x00".gunzip
  #   # => "hello world\n"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def gunzip
    gz = Ronin::Support::Compression::Gzip::Reader.new(self)

    return gz.read
  end

  #
  # Gzip compresses the string.
  #
  # @return [String]
  #   The gzipped version of the string.
  #
  # @example
  #   "hello world\n".gzip
  #   # => "\x1F\x8B\b\x00K\x05\x8Fb\x00\x03\xCBH\xCD\xC9\xC9W(\xCF/\xCAI\xE1\x02\x00-;\b\xAF\f\x00\x00\x00"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def gzip
    buffer = StringIO.new(encoding: Encoding::ASCII_8BIT)

    Ronin::Support::Compression::Gzip::Writer.wrap(buffer) do |gz|
      gz.write(self)
    end

    return buffer.string
  end

end
