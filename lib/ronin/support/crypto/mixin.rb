# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
        # @see Crypto.digest
        #
        def crypto_digest(name)
          Crypto.digest(name)
        end

        alias digest crypto_digest

        #
        # Creates a new HMAC.
        #
        # @param [String, nil] data
        #   The optional data to sign.
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
        # @see Crypto.hmac
        #
        def crypto_hmac(data=nil, key: , digest: :sha1)
          Crypto.hmac(data, key: key, digest: digest)
        end

        alias hmac crypto_hmac

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
        #   Either the `key:` or `password:` keyword argument must be given.
        #
        # @example
        #   crypto_cipher('aes-128-cbc', mode: :encrypt, key 'secret'.md5)
        #   # => #<OpenSSL::Cipher:0x0000000170d108>
        #
        # @see Crypto.cipher
        #
        def crypto_cipher(name,**kwargs)
          Crypto.cipher(name,**kwargs)
        end

        alias cipher crypto_cipher

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
        #   Either the `key:` or `password:` keyword argument must be given.
        #
        # @see Crypto.encrypt
        #
        def crypto_encrypt(data, cipher: ,**kwargs)
          Crypto.encrypt(data, cipher: cipher, **kwargs)
        end

        alias encrypt crypto_encrypt

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
        #   Either the `key:` or `password:` keyword argument must be given.
        #
        # @see Crypto.decrypt
        #
        def crypto_decrypt(data, cipher: ,**kwargs)
          Crypto.decrypt(data, cipher: cipher, **kwargs)
        end

        alias decrypt crypto_decrypt

        #
        # Creates a new DES3 cipher.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher::DES3#initialize}.
        #
        # @option kwargs [:wrap, Symbol, nil] :mode
        #   The desired AES cipher mode.
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
        # @return [Cipher::DES3]
        #   The new DES3 cipher.
        #
        # @example
        #   crypto_des3_cipher(direction: :encrypt, key: 'A' * 24)
        #   # => #<Ronin::Support::Crypto::Cipher::DES3:0x00007f54c3752b90 @mode=nil>
        #
        # @see Crypto.des3_cipher
        #
        # @since 1.2.0
        #
        def crypto_des3_cipher(**kwargs)
          Crypto.des3_cipher(**kwargs)
        end

        alias des3_cipher crypto_des3_cipher

        #
        # Encrypts data using DES3.
        #
        # @param [#to_s] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher::DES3#initialize}.
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
        # @see Crypto.des3_encrypt
        #
        # @since 1.2.0
        #
        def crypto_des3_encrypt(data,**kwargs)
          Crypto.des3_encrypt(data,**kwargs)
        end

        alias des3_encrypt crypto_des3_encrypt

        #
        # Decrypts data using DES3.
        #
        # @param [#to_s] data
        #   The data to decrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher::DES3#initialize}.
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
        # @see Crypto.des3_decrypt
        #
        # @since 1.2.0
        #
        def crypto_des3_decrypt(data,**kwargs)
          Crypto.des3_decrypt(data,**kwargs)
        end

        alias des3_decrypt crypto_des3_decrypt

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
        #   crypto_aes_cipher(direction: :encrypt, password: 's3cr3t')
        #   # => #<Ronin::Support::Crypto::Cipher::AES:0x00007f2b84dfa6b8 @key_size=256, @mode=:cbc>
        #
        # @see Crypto.aes_cipher
        #
        def crypto_aes_cipher(**kwargs)
          Crypto.aes_cipher(**kwargs)
        end

        alias aes_cipher crypto_aes_cipher

        #
        # Encrypts data using AES.
        #
        # @param [#to_s] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher.aes_cipher}.
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
        # @see Crypto.aes_encrypt
        #
        def crypto_aes_encrypt(data,**kwargs)
          Crypto.aes_encrypt(data,**kwargs)
        end

        alias aes_encrypt crypto_aes_encrypt

        #
        # Decrypts data using AES.
        #
        # @param [#to_s] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher.aes_cipher}.
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
        # @see Crypto.aes_decrypt
        #
        def crypto_aes_decrypt(data,**kwargs)
          Crypto.aes_decrypt(data,**kwargs)
        end

        alias aes_decrypt crypto_aes_decrypt

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
        # @see Crypto.aes128_cipher
        #
        def crypto_aes128_cipher(**kwargs)
          Crypto.aes128_cipher(**kwargs)
        end

        alias aes128_cipher crypto_aes128_cipher

        #
        # Encrypts data using AES-128.
        #
        # @param [#to_s] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher.aes128_cipher}.
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
        # @see Crypto.aes128_encrypt
        #
        def crypto_aes128_encrypt(data,**kwargs)
          Crypto.aes128_encrypt(data,**kwargs)
        end

        alias aes128_encrypt crypto_aes128_encrypt

        #
        # Decrypts data using AES-128.
        #
        # @param [#to_s] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher.aes128_cipher}.
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
        # @see Crypto.aes128_decrypt
        #
        def crypto_aes128_decrypt(data,**kwargs)
          Crypto.aes128_decrypt(data,**kwargs)
        end

        alias aes128_decrypt crypto_aes128_decrypt

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
        # @see Crypto.aes256_cipher
        #
        def crypto_aes256_cipher(**kwargs)
          Crypto.aes256_cipher(**kwargs)
        end

        alias aes256_cipher crypto_aes256_cipher

        #
        # Encrypts data using AES-256.
        #
        # @param [#to_s] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher.aes256_cipher}.
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
        # @see Crypto.aes256_encrypt
        #
        def crypto_aes256_encrypt(data,**kwargs)
          Crypto.aes256_encrypt(data,**kwargs)
        end

        alias aes256_encrypt crypto_aes256_encrypt

        #
        # Decrypts data using AES-256.
        #
        # @param [#to_s] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Cipher.aes256_cipher}.
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
        #   Either the `key:` or `password:` keyword argument must be given.
        #
        # @see Crypto.aes256_decrypt
        #
        def crypto_aes256_decrypt(data,**kwargs)
          Crypto.aes256_decrypt(data,**kwargs)
        end

        alias aes256_decrypt crypto_aes256_decrypt

        #
        # Encrypts the given data using the given RSA key.
        #
        # @param [String] data
        #   The data to encrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Crypto.rsa_encrypt}.
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
        def crypto_rsa_encrypt(data,**kwargs)
          Crypto.rsa_encrypt(data,**kwargs)
        end

        alias rsa_encrypt crypto_rsa_encrypt

        #
        # Decrypts the given data using the given RSA key.
        #
        # @param [String] data
        #   The data to decrypt.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Crypto.rsa_decrypt}.
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
        def crypto_rsa_decrypt(data,**kwargs)
          Crypto.rsa_decrypt(data,**kwargs)
        end

        alias rsa_decrypt crypto_rsa_decrypt
      end
    end
  end
end
