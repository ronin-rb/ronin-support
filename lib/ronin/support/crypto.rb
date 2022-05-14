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

require 'ronin/support/crypto/openssl'
require 'ronin/support/crypto/cipher'
require 'ronin/support/crypto/cipher/aes'
require 'ronin/support/crypto/cipher/aes128'
require 'ronin/support/crypto/cipher/aes256'
require 'ronin/support/crypto/mixin'
require 'ronin/support/crypto/core_ext'

module Ronin
  module Support
    #
    # {Crypto} provides a nicer more user-friendly API ontop of `OpenSSL`.
    #
    # @api public
    #
    # @since 1.0.0
    #
    module Crypto
      #
      # Looks up a digest.
      #
      # @param [String, Symbol] name
      #   The name of the digest.
      #
      # @return [OpenSSL::Digest]
      #   The OpenSSL Digest class.
      #
      # @example
      #   Crypto.digest(:sha256)
      #   # => OpenSSL::Digest::SHA256
      #
      # @see http://rubydoc.info/stdlib/openssl/OpenSSL/Digest
      #
      def self.digest(name)
        OpenSSL::Digest.const_get(name.upcase)
      end

      #
      # Creates a new HMAC.
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
      # @example
      #   Crypto.hmac('secret')
      #
      # @see http://rubydoc.info/stdlib/openssl/OpenSSL/HMAC
      #
      def self.hmac(key,digest=:sha1)
        OpenSSL::HMAC.new(key,digest(digest).new)
      end

      #
      # The list of supported ciphers.
      #
      # @return [Array<String>]
      #   The list of supported cipher names.
      #
      # @see Cipher.supported
      #
      # @example
      #   Cipher.supported
      #   # => ["RC5",
      #   #     "aes-128-cbc",
      #   #     "aes-128-cbc-hmac-sha1",
      #   #     "aes-128-cbc-hmac-sha256",
      #   #     ...]
      #
      # @see Cipher.supported
      #
      def self.ciphers
        Cipher.supported
      end

      #
      # Creates a cipher.
      #
      # @param [String] name
      #   The cipher name.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Cipher#initialize}.
      #
      # @option kwargs [:encrypt, :decrypt] :direction
      #   Specifies whether to encrypt or decrypt data.
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
      # @return [OpenSSL::Cipher]
      #   The newly created cipher.
      #
      # @raise [ArgumentError]
      #   Either the the `key:` or `password:` keyword argument must be given.
      #
      # @example
      #   Crypto.cipher('aes-128-cbc', direction: :encrypt, key 'secret'.md5)
      #   # => #<OpenSSL::Cipher:0x0000000170d108>
      #
      # @see Cipher
      #
      def self.cipher(name,**kwargs)
        Cipher.new(name,**kwargs)
      end

      #
      # Encrypts data using the cipher.
      #
      # @param [#to_s] data
      #   The data to encrypt.
      #
      # @param [String] cipher
      #   The cipher name (ex: `"aes-256-cbc"`).
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {cipher}.
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
      # @see Cipher#encrypt
      #
      # @since 1.0.0
      #
      def self.encrypt(data, cipher: ,**kwargs)
        self.cipher(cipher, direction: :encrypt, **kwargs).encrypt(data)
      end

      #
      # Decrypts data using the cipher.
      #
      # @param [#to_s] data
      #   The data to decrypt.
      #
      # @param [String] cipher
      #   The cipher name (ex: `"aes-256-cbc"`).
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {cipher}.
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
      #   The decrypted data.
      #
      # @raise [ArgumentError]
      #   Either the the `key:` or `password:` keyword argument must be given.
      #
      # @see Cipher#decrypt
      #
      # @since 1.0.0
      #
      def self.decrypt(data, cipher: ,**kwargs)
        self.cipher(cipher, direction: :decrypt, **kwargs).decrypt(data)
      end

      #
      # Creates a new AES cipher.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Cipher::AES#initialize}.
      #
      # @option kwargs [Integer] :key_size
      #   The desired key size in bits.
      #
      # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] :mode (:cbc)
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
      # @return [Cipher::AES]
      #   The new AES cipher.
      #
      # @example
      #   Crypto.aes_cipher(key_size: 256, direction: :encrypt, password: 's3cr3t', hash: :sha256)
      #   # => #<Ronin::Support::Crypto::Cipher::AES:0x00007f2b84dfa6b8 @key_size=256, @mode=:cbc>
      #
      # @see Cipher::AES
      #
      def self.aes_cipher(**kwargs)
        Cipher::AES.new(**kwargs)
      end

      #
      # Encrypts data using AES.
      #
      # @param [#to_s] data
      #   The data to encrypt.
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
      def self.aes_encrypt(data,**kwargs)
        self.aes_cipher(direction: :encrypt, **kwargs).encrypt(data)
      end

      #
      # Decrypts data using AES.
      #
      # @param [#to_s] data
      #   The data to encrypt.
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
      def self.aes_decrypt(data,**kwargs)
        self.aes_cipher(direction: :decrypt, **kwargs).decrypt(data)
      end

      #
      # Creates a new AES-128 cipher.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Cipher::AES128#initialize}.
      #
      # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] :mode (:cbc)
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
      # @return [Cipher::AES]
      #   The new AES cipher.
      #
      # @example
      #   Crypto.aes128_cipher(direction: :encrypt, password: 's3cr3t')
      #   # => #<Ronin::Support::Crypto::Cipher::AES128:0x00007f8bde789648 @key_size=128, @mode=:cbc>
      #
      # @see Cipher::AES128
      #
      def self.aes128_cipher(**kwargs)
        Cipher::AES128.new(**kwargs)
      end

      #
      # Encrypts data using AES-128.
      #
      # @param [#to_s] data
      #   The data to encrypt.
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
      def self.aes128_encrypt(data,**kwargs)
        self.aes128_cipher(direction: :encrypt, **kwargs).encrypt(data)
      end

      #
      # Decrypts data using AES-128.
      #
      # @param [#to_s] data
      #   The data to encrypt.
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
      def self.aes128_decrypt(data,**kwargs)
        self.aes128_cipher(direction: :decrypt, **kwargs).decrypt(data)
      end

      #
      # Creates a new AES-256 cipher.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Cipher::AES256#initialize}.
      #
      # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] :mode (:cbc)
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
      # @return [Cipher::AES]
      #   The new AES cipher.
      #
      # @example
      #   Crypto.aes256_cipher(direction: :encrypt, password: 's3cr3t')
      #   # => #<Ronin::Support::Crypto::Cipher::AES256:0x00007f8bde789648 @key_size=256, @mode=:cbc>
      #
      # @see Cipher::AES256
      #
      def self.aes256_cipher(**kwargs)
        Cipher::AES256.new(**kwargs)
      end

      #
      # Encrypts data using AES-256.
      #
      # @param [#to_s] data
      #   The data to encrypt.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {aes}.
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
      def self.aes256_encrypt(data,**kwargs)
        self.aes256_cipher(direction: :encrypt, **kwargs).encrypt(data)
      end

      #
      # Decrypts data using AES-256.
      #
      # @param [#to_s] data
      #   The data to encrypt.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {aes}.
      #
      # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] mode (:cbc)
      #   The desired AES cipher mode.
      #
      # @option kwargs [Symbol] :hash (:sh256)
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
      def self.aes256_decrypt(data,**kwargs)
        self.aes256_cipher(direction: :decrypt, **kwargs).decrypt(data)
      end
    end
  end
end
