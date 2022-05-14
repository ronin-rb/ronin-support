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

require 'ronin/support/crypto'

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
  # @note JRuby and TruffleRuby do not yet support RMD160.
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
  # @see Ronin::Support::Crypto.hmac
  #
  # @since 0.6.0
  #
  # @api public
  #
  def hmac(key,digest=:sha1)
    hmac = Ronin::Support::Crypto.hmac(key,digest)
    hmac.update(self)

    return hmac.hexdigest
  end

  #
  # Encrypts the String.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.cipher}.
  #
  # @option kwargs [Symbol] :hash (:sha1)
  #   The algorithm to hash the `:password`.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
  #
  # @option kwargs [String] :password
  #   The password for the cipher.
  #
  # @option kwargs [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option kwargs [Integer] :padding
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
  def encrypt(cipher,**kwargs)
    Ronin::Support::Crypto.encrypt(self, cipher:    cipher,
                                         direction: :encrypt,
                                         **kwargs)
  end

  #
  # Decrypts the String.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.cipher}.
  #
  # @option kwargs [Symbol] :hash (:sha1)
  #   The algorithm to hash the `:password`.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
  #
  # @option kwargs [String] :password
  #   The password for the cipher.
  #
  # @option kwargs [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option kwargs [Integer] :padding
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
  def decrypt(cipher,**kwargs)
    Ronin::Support::Crypto.decrypt(self, cipher:    cipher,
                                         direction: :decrypt,
                                         **kwargs)
  end

  #
  # Encrypts data using AES.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {aes}.
  #
  # @option kwargs [Integer] :key_size
  #   The desired key size in bits.
  #
  # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] mode (:cbc)
  #   The desired AES cipher mode.
  #
  # @option kwargs [Symbol] :hash (:sha256)
  #   The algorithm to hash the `:password`.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
  #
  # @option kwargs [String] :password
  #   The password for the cipher.
  #
  # @option kwargs [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option kwargs [Integer] :padding
  #   Sets the padding for the cipher.
  #
  # @return [String]
  #   The encrypted data.
  #
  # @raise [ArgumentError]
  #   Either the the `key:` or `password:` keyword argument must be given.
  #
  # @since 1.0.0
  #
  def aes_encrypt(**kwargs)
    Ronin::Support::Crypto.aes_encrypt(self,**kwargs)
  end

  #
  # Decrypts data using AES.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {aes}.
  #
  # @option kwargs [Integer] :key_size
  #   The desired key size in bits.
  #
  # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] mode (:cbc)
  #   The desired AES cipher mode.
  #
  # @option kwargs [Symbol] :hash (:sha256)
  #   The algorithm to hash the `:password`.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
  #
  # @option kwargs [String] :password
  #   The password for the cipher.
  #
  # @option kwargs [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option kwargs [Integer] :padding
  #   Sets the padding for the cipher.
  #
  # @return [String]
  #   The encrypted data.
  #
  # @raise [ArgumentError]
  #   Either the the `key:` or `password:` keyword argument must be given.
  #
  # @since 1.0.0
  #
  def aes_decrypt(**kwargs)
    Ronin::Support::Crypto.aes_decrypt(self,**kwargs)
  end

  #
  # Encrypts data using AES-128.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {aes}.
  #
  # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] mode (:cbc)
  #   The desired AES cipher mode.
  #
  # @option kwargs [Symbol] :hash (:md5)
  #   The algorithm to hash the `:password`.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
  #
  # @option kwargs [String] :password
  #   The password for the cipher.
  #
  # @option kwargs [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option kwargs [Integer] :padding
  #   Sets the padding for the cipher.
  #
  # @return [String]
  #   The encrypted data.
  #
  # @raise [ArgumentError]
  #   Either the the `key:` or `password:` keyword argument must be given.
  #
  # @since 1.0.0
  #
  def aes128_encrypt(**kwargs)
    Ronin::Support::Crypto.aes128_encrypt(self,**kwargs)
  end

  #
  # Decrypts data using AES-128.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {aes}.
  #
  # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] mode (:cbc)
  #   The desired AES cipher mode.
  #
  # @option kwargs [Symbol] :hash (:md5)
  #   The algorithm to hash the `:password`.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
  #
  # @option kwargs [String] :password
  #   The password for the cipher.
  #
  # @option kwargs [String] :iv
  #   The optional Initial Vector (IV).
  #
  # @option kwargs [Integer] :padding
  #   Sets the padding for the cipher.
  #
  # @return [String]
  #   The encrypted data.
  #
  # @raise [ArgumentError]
  #   Either the the `key:` or `password:` keyword argument must be given.
  #
  # @since 1.0.0
  #
  def aes128_decrypt(**kwargs)
    Ronin::Support::Crypto.aes128_decrypt(self,**kwargs)
  end

end
