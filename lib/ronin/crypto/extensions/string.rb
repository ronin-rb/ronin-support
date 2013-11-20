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

require 'ronin/crypto'

require 'digest'

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

  #
  # Calculates the RMD160 checksum for the String.
  #
  # @return [String]
  #   The RMD160 checksum of the String.
  #
  # @example
  #   "hello".rmd160
  #   # => "108f07b8382412612c048d07d13f814118445acd"
  #
  # @api public
  #
  # @since 0.6.0
  #
  def rmd160
    Digest::RMD160.hexdigest(self)
  end

  #
  # Calculates the HMAC of the String.
  #
  # @param [String] key
  #   The secret key for the HMAC.
  #
  # @param [Symbol] digest
  #   The digest algorithm for the HMAC.
  #
  # @return [String]
  #   The hex-encoded HMAC for the String.
  #
  # @see Ronin::Crypto.hmac
  #
  # @since 0.6.0
  #
  # @api public
  #
  def hmac(key,digest=:sha1)
    hmac = Ronin::Crypto.hmac(key,digest)
    hmac.update(self)

    return hmac.hexdigest
  end

  #
  # Encrypts the String.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Symbol] :hash (:sha1)
  #   The algorithm to hash the `:password`.
  #
  # @option options [String] :key
  #   The secret key to use.
  #
  # @option options [String] :password
  #   The password for the cipher.
  #
  # @option options [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option options [Integer] :padding
  #   Sets the padding for the cipher.
  #
  # @return [String]
  #   The encrypted String.
  #
  # @see http://rubydoc.info/stdlib/openssl/OpenSSL/Cipher
  #
  # @since 0.6.0
  #
  # @api public
  #
  def encrypt(cipher,options={})
    cipher = Ronin::Crypto.cipher(cipher, options.merge(mode: :encrypt))

    return cipher.update(self) + cipher.final
  end

  #
  # Decrypts the String.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Symbol] :hash (:sha1)
  #   The algorithm to hash the `:password`.
  #
  # @option options [String] :key
  #   The secret key to use.
  #
  # @option options [String] :password
  #   The password for the cipher.
  #
  # @option options [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option options [Integer] :padding
  #   Sets the padding for the cipher.
  #
  # @return [String]
  #   The decrypted String.
  #
  # @see http://rubydoc.info/stdlib/openssl/OpenSSL/Cipher
  #
  # @since 0.6.0
  #
  # @api public
  #
  def decrypt(cipher,options={})
    cipher = Ronin::Crypto.cipher(cipher,options.merge(mode: :decrypt))

    return cipher.update(self) + cipher.final
  end

end
