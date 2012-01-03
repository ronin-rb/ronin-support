#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'digest/md5'
require 'digest/sha1'
require 'digest/sha2'

class String

  #
  # @return [String]
  #   The MD5 checksum of the String.
  #
  # @example
  #   "hello".md5
  #   # => "5d41402abc4b2a76b9719d911017c592"
  #
  # @api public
  #
  def md5
    Digest::MD5.hexdigest(self)
  end

  #
  # @return [String]
  #   The SHA1 checksum of the String.
  #
  # @example
  #   "hello".sha1
  #   # => "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"
  #
  # @api public
  #
  def sha1
    Digest::SHA1.hexdigest(self)
  end

  alias sha128 sha1

  #
  # @return [String]
  #   The SHA2 checksum of the String.
  #
  # @example
  #   "hello".sha2
  #   # => "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
  #
  # @api public
  #
  def sha256
    Digest::SHA256.hexdigest(self)
  end

  alias sha2 sha256

  #
  # @return [String]
  #   The SHA512 checksum of the String.
  #
  # @example
  #   "hello".sha512
  #   # => "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"
  #
  # @api public
  #
  def sha512
    Digest::SHA512.hexdigest(self)
  end

end
