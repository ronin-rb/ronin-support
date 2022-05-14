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

module Ronin
  module Support
    module Crypto
      #
      # Provides helper methods for cryptographic functions.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Mixin
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
        #   crypto_digest(:ripemd160)
        #   # => OpenSSL::Digest::RIPEMD160
        #
        def crypto_digest(name)
          Crypto.digest(name)
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
        # @see http://rubydoc.info/stdlib/openssl/OpenSSL/HMAC
        #
        # @example
        #   crypto_hmac('secret')
        #
        def crypto_hmac(key,digest=:sha1)
          Crypto.hmac(key,digest)
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
        #   crypto_cipher('aes-128-cbc', mode: :encrypt, key 'secret'.md5)
        #   # => #<OpenSSL::Cipher:0x0000000170d108>
        #
        def crypto_cipher(name,**kwargs)
          Crypto.cipher(name,**kwargs)
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
        # @return [String]
        #   The encrypted data.
        #
        # @raise [ArgumentError]
        #   Either the the `key:` or `password:` keyword argument must be given.
        #
        def crypto_encrypt(data, cipher: ,**kwargs)
          Crypto.encrypt(data, cipher: cipher, **kwargs)
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
        # @return [String]
        #   The decrypted data.
        #
        # @raise [ArgumentError]
        #   Either the the `key:` or `password:` keyword argument must be given.
        #
        def crypto_decrypt(data, cipher: ,**kwargs)
          Crypto.decrypt(data, cipher: cipher, **kwargs)
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
        #   crypto_aes(direction: :encrypt, password: 's3cr3t')
        #   # => #<Ronin::Support::Crypto::Cipher::AES:0x00007f2b84dfa6b8 @key_size=256, @mode=:cbc>
        #
        def crypto_aes(**kwargs)
          Crypto.aes(**kwargs)
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
        def crypto_aes_encrypt(data,**kwargs)
          Crypto.aes_encrypt(data,**kwargs)
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
        def crypto_aes_decrypt(data,**kwargs)
          Crypto.aes_decrypt(data,**kwargs)
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
        #   Crypto.aes128(direction: :encrypt, password: 's3cr3t')
        #   # => #<Ronin::Support::Crypto::Cipher::AES128:0x00007f8bde789648 @key_size=128, @mode=:cbc>
        #
        def crypto_aes128(**kwargs)
          Crypto.aes128(**kwargs)
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
        def crypto_aes128_encrypt(data,**kwargs)
          Crypto.aes128_encrypt(data,**kwargs)
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
        def crypto_aes128_decrypt(data,**kwargs)
          Crypto.aes128_decrypt(data,**kwargs)
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
        #   Crypto.aes256(direction: :encrypt, password: 's3cr3t')
        #   # => #<Ronin::Support::Crypto::Cipher::AES256:0x00007f8bde789648 @key_size=256, @mode=:cbc>
        #
        def crypto_aes256(**kwargs)
          Crypto.aes256(**kwargs)
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
        def crypto_aes256_encrypt(data,**kwargs)
          Crypto.aes256_encrypt(data,**kwargs)
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
        def crypto_aes256_decrypt(data,**kwargs)
          Crypto.aes256_decrypt(data,**kwargs)
        end
      end
    end
  end
end
