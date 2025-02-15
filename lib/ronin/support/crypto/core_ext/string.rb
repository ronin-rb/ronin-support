# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  # Calculates the MD5 checksum of the String.
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
  # Calculates the SHA1 checksum of the String.
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
  # Calculates the SHA256 checksum of the String.
  #
  # @return [String]
  #   The SHA256 checksum of the String.
  #
  # @example
  #   "hello".sha256
  #   # => "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
  #
  # @api public
  #
  def sha256
    Digest::SHA256.hexdigest(self)
  end

  alias sha2 sha256

  #
  # Calculates the SHA512 checksum of the String.
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
  def hmac(key: , digest: :sha1)
    hmac = Ronin::Support::Crypto.hmac(self, key: key, digest: digest)
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
  #   The encrypted String.
  #
  # @example
  #   "top secret".encrypt('aes-256-cbc', password: 's3cr3t')
  #   # => "\xF0[\x17\xDA\xA2\x82\x93\xF4\xB6s\xB5\xD8\x1F\xF2\xC6\\"
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
  #   The decrypted String.
  #
  # @example
  #  "\xF0[\x17\xDA\xA2\x82\x93\xF4\xB6s\xB5\xD8\x1F\xF2\xC6\\".decrypt('aes-256-cbc', password: 's3cr3t')
  #  # => "top secret"
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
  # Encrypts data using DES3.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.des3_encrypt}.
  #
  # @option kwargs [:wrap, Symbol, nil] :mode
  #   The desired DES3 cipher mode.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
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
  #   The `key:` keyword argument must be given.
  #
  # @since 1.2.0
  #
  def des3_encrypt(**kwargs)
    Ronin::Support::Crypto.des3_encrypt(self,**kwargs)
  end

  #
  # Decrypts data using DES3.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.des3_decrypt}.
  #
  # @option kwargs [:wrap, Symbol, nil] :mode
  #   The desired DES3 cipher mode.
  #
  # @option kwargs [String] :key
  #   The secret key to use.
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
  #   The `key:` keyword argument must be given.
  #
  # @since 1.2.0
  #
  def des3_decrypt(**kwargs)
    Ronin::Support::Crypto.des3_decrypt(self,**kwargs)
  end

  #
  # Encrypts the String using AES.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.aes_cipher}.
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
  #   Either the `key:` or `password:` keyword argument must be given.
  #
  # @example
  #   "top secret".aes_encrypt(key_size: 256, password: 's3cr3t')
  #   # => "\xF0[\x17\xDA\xA2\x82\x93\xF4\xB6s\xB5\xD8\x1F\xF2\xC6\\"
  #
  # @since 1.0.0
  #
  def aes_encrypt(**kwargs)
    Ronin::Support::Crypto.aes_encrypt(self,**kwargs)
  end

  #
  # Decrypts the String using AES.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.aes_cipher}.
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
  #   Either the `key:` or `password:` keyword argument must be given.
  #
  # @example
  #   "\xF0[\x17\xDA\xA2\x82\x93\xF4\xB6s\xB5\xD8\x1F\xF2\xC6\\".aes_decrypt(key_size: 256, password: 's3cr3t')
  #   # => "top secret"
  #
  # @since 1.0.0
  #
  def aes_decrypt(**kwargs)
    Ronin::Support::Crypto.aes_decrypt(self,**kwargs)
  end

  #
  # Encrypts the String using AES-128.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.aes128_cipher}.
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
  #   Either the `key:` or `password:` keyword argument must be given.
  #
  # @example
  #   "top secret".aes128_encrypt(password: 's3cr3t')
  #   # => "\x88\xA53\xE9|\xE2\x8E\xA0\xABv\xCF\x94\x17\xBB*\xC5"
  #
  # @since 1.0.0
  #
  def aes128_encrypt(**kwargs)
    Ronin::Support::Crypto.aes128_encrypt(self,**kwargs)
  end

  #
  # Decrypts the String using AES-128.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.aes128_cipher}.
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
  #   Either the `key:` or `password:` keyword argument must be given.
  #
  # @example
  #   "\x88\xA53\xE9|\xE2\x8E\xA0\xABv\xCF\x94\x17\xBB*\xC5".aes128_decrypt(password: 's3cr3t')
  #   # => "top secret"
  #
  # @since 1.0.0
  #
  def aes128_decrypt(**kwargs)
    Ronin::Support::Crypto.aes128_decrypt(self,**kwargs)
  end

  #
  # Encrypts the String using AES-256.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.aes256_cipher}.
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
  #   Either the `key:` or `password:` keyword argument must be given.
  #
  # @example
  #   "top secret".aes256_encrypt(password: 's3cr3t')
  #   # => "\xF0[\x17\xDA\xA2\x82\x93\xF4\xB6s\xB5\xD8\x1F\xF2\xC6\\"
  #
  # @since 1.0.0
  #
  def aes256_encrypt(**kwargs)
    Ronin::Support::Crypto.aes256_encrypt(self,**kwargs)
  end

  #
  # Decrypts the String using AES-256.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.aes256_cipher}.
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
  #   Either the `key:` or `password:` keyword argument must be given.
  #
  # @example
  #   "\xF0[\x17\xDA\xA2\x82\x93\xF4\xB6s\xB5\xD8\x1F\xF2\xC6\\".aes256_decrypt(password: 's3cr3t')
  #   # => "top secret"
  #
  # @since 1.0.0
  #
  def aes256_decrypt(**kwargs)
    Ronin::Support::Crypto.aes256_decrypt(self,**kwargs)
  end

  #
  # Encrypts the String using the given RSA key.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.rsa_encrypt}.
  #
  # @option kwargs [String, nil] :key
  #   The PEM or DER encoded RSA key string.
  #
  # @option kwargs [String, nil] :key_file
  #   The path to the PEM or DER encoded RSA key file.
  #
  # @option kwargs [String, nil] :key_password
  #   The optional password to decrypt the encrypted RSA key.
  #
  # @option kwargs [:pkcs1_oaep, :pkcs1, :sslv23,
  #                 nil, false] :padding (:pkcs1)
  #   Optional padding mode. `nil` and `false` will disable padding.
  #
  # @return [String]
  #   The encrypted data.
  #
  # @raise [ArgumentError]
  #   Either the `key:` or `key_file:` keyword argument must be given.
  #
  # @since 1.0.0
  #
  def rsa_encrypt(**kwargs)
    Ronin::Support::Crypto.rsa_encrypt(self,**kwargs)
  end

  #
  # Decrypts the String using the given RSA key.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Ronin::Support::Crypto.rsa_decrypt}.
  #
  # @option kwargs [String, nil] :key
  #   The PEM or DER encoded RSA key string.
  #
  # @option kwargs [String, nil] :key_file
  #   The path to the PEM or DER encoded RSA key file.
  #
  # @option kwargs [String, nil] :key_password
  #   The optional password to decrypt the encrypted RSA key.
  #
  # @option kwargs [:pkcs1_oaep, :pkcs1, :sslv23,
  #                 nil, false] :padding (:pkcs1)
  #   Optional padding mode. `nil` and `false` will disable padding.
  #
  # @return [String]
  #   The decrypted data.
  #
  # @raise [ArgumentError]
  #   Either the `key:` or `key_file:` keyword argument must be given.
  #
  # @since 1.0.0
  #
  def rsa_decrypt(**kwargs)
    Ronin::Support::Crypto.rsa_decrypt(self,**kwargs)
  end

  #
  # Rotates the characters in the string using the given alphabet.
  #
  # @param [Integer] n
  #   The number of characters to shift each character by.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [Array<Array<String>>] :alphabets
  #   The alphabet(s) to use.
  #
  # @return [String]
  #   The rotated string.
  #
  # @note
  #   This method was added as a joke and should not be used for secure
  #   cryptographic communications.
  #
  # @example ROT13 "encryption":
  #   "The quick brown fox jumps over 13 lazy dogs.".rot
  #   # => "Gur dhvpx oebja sbk whzcf bire 46 ynml qbtf."
  #
  # @example ROT13 "decryption":
  #   "Gur dhvpx oebja sbk whzcf bire 46 ynml qbtf.".rot(-13)
  #   # => "The quick brown fox jumps over 13 lazy dogs."
  #
  # @since 1.0.0
  #
  def rot(n=13,**kwargs)
    Ronin::Support::Crypto.rot(self,n,**kwargs)
  end

  #
  # XOR encodes the String.
  #
  # @param [Enumerable, Integer] key
  #   The byte to XOR against each byte in the String.
  #
  # @return [String]
  #   The XOR encoded String.
  #
  # @example
  #   "hello".xor(0x41)
  #   # => ")$--."
  #
  # @example
  #   "hello again".xor([0x55, 0x41, 0xe1])
  #   # => "=$\x8d9.\xc14&\x80</"
  #
  # @api public
  #
  def xor(key)
    Ronin::Support::Crypto.xor(self,key)
  end

  alias ^ xor

end
