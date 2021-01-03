#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  # @api public
  #
  def File.md5(path)
    Digest::MD5.file(path).hexdigest
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
  # @api public
  #
  def File.sha1(path)
    Digest::SHA1.file(path).hexdigest
  end

  #
  # @see File.sha1
  #
  # @api public
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
  # @api public
  #
  def File.sha256(path)
    Digest::SHA256.file(path).hexdigest
  end

  #
  # @see File.sha256
  #
  # @api public
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
  # @api public
  #
  def File.sha512(path)
    Digest::SHA512.file(path).hexdigest
  end

  #
  # @see File.sha512
  #
  # @api public
  #
  def File.sha5(path)
    File.sha512(path)
  end

end
