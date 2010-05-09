#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

require 'digest/md5'
require 'digest/sha1'
require 'digest/sha2'

class File

  #
  # Calculates the MD5 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The MD5 checksum of the file.
  #
  # @example
  #   File.md5('data.txt')
  #   # => "5d41402abc4b2a76b9719d911017c592"
  #
  def File.md5(path)
    md5sum = Digest::MD5.new

    File.open(path,'rb') do |file|
      until file.eof?
        md5sum << file.read(1024)
      end
    end

    return md5sum.hexdigest
  end

  #
  # Calculates the SHA1 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The SHA1 checksum of the file.
  #
  # @example
  #   File.sha1('data.txt')
  #   # => "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"
  #
  def File.sha1(path)
    sha1sum = Digest::SHA1.new

    File.open(path,'rb') do |file|
      until file.eof?
        sha1sum << file.read(1024)
      end
    end

    return sha1sum.hexdigest
  end

  #
  # @see File.sha1
  #
  def File.sha128(path)
    File.sha1(path)
  end

  #
  # Calculates the SHA256 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The SHA256 checksum of the file.
  #
  # @example
  #   File.sha256('data.txt')
  #   # => "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
  #
  def File.sha256(path)
    sha256sum = Digest::SHA256.new

    File.open(path,'rb') do |file|
      until file.eof?
        sha256sum << file.read(1024)
      end
    end

    return sha256sum.hexdigest
  end

  #
  # @see File.sha256
  #
  def File.sha2(path)
    File.sha256(path)
  end

  #
  # Calculates the SHA512 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The SHA512 checksum of the file.
  #
  # @example
  #   File.sha512('data.txt')
  #   # => "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"
  #
  def File.sha512(path)
    sha512sum = Digest::SHA512.new

    File.open(path,'rb') do |file|
      until file.eof?
        sha512sum << file.read(1024)
      end
    end

    return sha512sum.hexdigest
  end

  #
  # @see File.sha512
  #
  def File.sha5(path)
    File.sha512(path)
  end

end
