# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/crypto/hmac'
require 'ronin/support/crypto/cipher'
require 'ronin/support/crypto/cipher/des3'
require 'ronin/support/crypto/cipher/aes'
require 'ronin/support/crypto/cipher/aes128'
require 'ronin/support/crypto/cipher/aes256'
require 'ronin/support/crypto/key/rsa'
require 'ronin/support/crypto/cert'
require 'ronin/support/crypto/cert_chain'
require 'ronin/support/crypto/mixin'
require 'ronin/support/crypto/core_ext'

module Ronin
  module Support
    #
    # {Crypto} provides a nicer more user-friendly API ontop of `OpenSSL`.
    #
    # ## Core-Ext Methods
    #
    # * {File.md5}
    # * {File.sha1}
    # * {File.sha128}
    # * {File.sha256}
    # * {File.sha512}
    # * {File.sha2}
    # * {File.sha5}
    # * {File.rmd160}
    # * {File.hmac}
    # * {File.encrypt}
    # * {File.decrypt}
    # * {File.aes_encrypt}
    # * {File.aes_decrypt}
    # * {File.aes128_encrypt}
    # * {File.aes128_decrypt}
    # * {File.aes256_encrypt}
    # * {File.aes256_decrypt}
    # * {File.rsa_encrypt}
    # * {File.rsa_decrypt}
    # * {String#md5}
    # * {String#sha1}
    # * {String#sha256}
    # * {String#sha512}
    # * {String#rmd160}
    # * {String#hmac}
    # * {String#encrypt}
    # * {String#decrypt}
    # * {String#aes_encrypt}
    # * {String#aes_decrypt}
    # * {String#aes128_encrypt}
    # * {String#aes128_decrypt}
    # * {String#aes256_encrypt}
    # * {String#aes256_decrypt}
    # * {String#rsa_encrypt}
    # * {String#rsa_decrypt}
    # * {String#rot}
    # * {String#xor}
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
      # @param [String, nil] data
      #   The optional data to sign.
      #
      # @param [String] key
      #   The secret key for the HMAC.
      #
      # @param [Symbol] digest
      #   The digest algorithm for the HMAC.
      #
      # @yield [hmac]
      #   If a block is given, it will be passed the new HMAC object, which can
      #   then be populated.
      #
      # @yieldparam [OpenSSL::HMAC] hmac
      #   The new HMAC object.
      #
      # @return [OpenSSL::HMAC]
      #   The HMAC object.
      #
      # @example
      #   hmac = Crypto.hmac("hello world", key: 'secret')
      #   # => #<Ronin::Support::Crypto::HMAC: 03376ee7ad7bbfceee98660439a4d8b125122a5a>
      #   hmac.hexdigest
      #   # => "03376ee7ad7bbfceee98660439a4d8b125122a5a"
      #   hmac.digest
      #   # => "\x037n\xE7\xAD{\xBF\xCE\xEE\x98f\x049\xA4\xD8\xB1%\x12*Z"
      #
      # @example with a block:
      #   hmac = Crypto.hmac("hello world", key: 'secret') do |hmac|
      #     hmac << "hello"
      #     hmac << " world"
      #   end
      #   # => #<Ronin::Support::Crypto::HMAC: 03376ee7ad7bbfceee98660439a4d8b125122a5a>
      #
      # @see HMAC
      #
      def self.hmac(data=nil, key: , digest: :sha1)
        hmac = HMAC.new(key,digest(digest).new)

        if    block_given? then yield hmac
        elsif data         then hmac.update(data)
        end

        return hmac
      end

      #
      # The list of supported ciphers.
      #
      # @return [Array<String>]
      #   The list of supported cipher names.
      #
      # @example
      #   Crypto.ciphers
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
      #   Either the `key:` or `password:` keyword argument must be given.
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
      #   Either the `key:` or `password:` keyword argument must be given.
      #
      # @see Cipher#encrypt
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
      #   Either the `key:` or `password:` keyword argument must be given.
      #
      # @see Cipher#decrypt
      #
      def self.decrypt(data, cipher: ,**kwargs)
        self.cipher(cipher, direction: :decrypt, **kwargs).decrypt(data)
      end

      #
      # Creates a new DES3 cipher.
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
      # @return [Cipher::DES3]
      #   The new DES3 cipher.
      #
      # @example
      #   Crypto.des3_cipher(direction: :encrypt, key: 'A' * 24)
      #   # => #<Ronin::Support::Crypto::Cipher::DES3:0x00007f54c3752b90 @mode=nil>
      #
      # @see Cipher::DES3
      #
      # @since 1.2.0
      #
      def self.des3_cipher(**kwargs)
        Cipher::DES3.new(**kwargs)
      end

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
      # @since 1.2.0
      #
      def self.des3_encrypt(data,**kwargs)
        self.des3_cipher(direction: :encrypt, **kwargs).encrypt(data)
      end

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
      # @since 1.2.0
      #
      def self.des3_decrypt(data,**kwargs)
        self.des3_cipher(direction: :decrypt, **kwargs).decrypt(data)
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
      #   Additional keyword arguments for {aes_cipher}.
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
      #   Additional keyword arguments for {aes_cipher}.
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
      #   Additional keyword arguments for {aes128_cipher}.
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
      #   Additional keyword arguments for {aes128_cipher}.
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
      #   Additional keyword arguments for {aes256_cipher}.
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
      #   Additional keyword arguments for {aes256_cipher}.
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
      def self.aes256_decrypt(data,**kwargs)
        self.aes256_cipher(direction: :decrypt, **kwargs).decrypt(data)
      end

      #
      # Loads an RSA key.
      #
      # @param [String, nil] key
      #   The PEM or DER encoded RSA key string.
      #
      # @param [String, nil] path
      #   The path to the PEM or DER encoded RSA key file.
      #
      # @param [String, nil] password
      #   The optional password to decrypt the encrypted RSA key.
      #
      # @return [Key::RSA]
      #
      # @raise [ArgumentError]
      #   Either the `key:` or `key_file:` keyword argument must be given.
      #
      def self.rsa_key(key=nil, path: nil, password: nil)
        if path
          Key::RSA.load_file(path, password: password)
        elsif key
          case key
          when Key::RSA           then key
          when OpenSSL::PKey::RSA then Key::RSA.new(key)
          when String             then Key::RSA.load(key, password: password)
          end
        else
          raise(ArgumentError,"either key: or key_file: keyword arguments must be given")
        end
      end

      #
      # Encrypts data using a RSA key.
      #
      # @param [String] data
      #   The data to encrypt.
      #
      # @param [String, nil] key
      #   The PEM or DER encoded RSA key string.
      #
      # @param [String, nil] key_file
      #   The path to the PEM or DER encoded RSA key file.
      #
      # @param [String, nil] key_password
      #   The optional password to decrypt the encrypted RSA key.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Key::RSA#public_encrypt}.
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
      def self.rsa_encrypt(data, key: nil, key_file: nil, key_password: nil, **kwargs)
        rsa = rsa_key(key, path: key_file, password: key_password)

        return rsa.public_encrypt(data,**kwargs)
      end

      #
      # Decrypts data using a RSA key.
      #
      # @param [String] data
      #   The data to decrypt.
      #
      # @param [String, nil] key
      #   The PEM or DER encoded RSA key string.
      #
      # @param [String, nil] key_file
      #   The path to the PEM or DER encoded RSA key file.
      #
      # @param [String, nil] key_password
      #   The optional password to decrypt the encrypted RSA key.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Key::RSA#private_decrypt}.
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
      def self.rsa_decrypt(data, key: nil, key_file: nil, key_password: nil, **kwargs)
        rsa = rsa_key(key, path: key_file, password: key_password)

        return rsa.private_decrypt(data,**kwargs)
      end

      #
      # Rotates the characters in the given string using the given alphabet.
      #
      # @param [String] string
      #   The String to rotate.
      #
      # @param [Integer] n
      #   The number of characters to shift each character by.
      #
      # @param [Array<Array<String>>] alphabets
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
      #   Crypto.rot("The quick brown fox jumps over 13 lazy dogs.")
      #   # => "Gur dhvpx oebja sbk whzcf bire 46 ynml qbtf."
      #
      # @example ROT13 "decryption":
      #   Crypto.rot("Gur dhvpx oebja sbk whzcf bire 46 ynml qbtf.", -13)
      #   # => "The quick brown fox jumps over 13 lazy dogs."
      #
      def self.rot(string,n=13, alphabets: [('A'..'Z').to_a, ('a'..'z').to_a, ('0'..'9').to_a])
        translation_table = {}

        alphabets.each do |alphabet|
          modulo = alphabet.count

          alphabet.each_with_index do |char,index|
            translation_table[char] = alphabet[(index + n) % modulo]
          end
        end

        new_string = String.new(encoding: string.encoding)

        string.each_char do |char|
          new_string << translation_table.fetch(char,char)
        end

        return new_string
      end

      #
      # XOR encodes the String.
      #
      # @param [String] string
      #   The String to XOR.
      #
      # @param [Enumerable, Integer] key
      #   The byte to XOR against each byte in the String.
      #
      # @return [String]
      #   The XOR encoded String.
      #
      # @example
      #   Crypto.xor("hello", 0x41)
      #   # => ")$--."
      #
      # @example
      #   Crypto.xor("hello again", [0x55, 0x41, 0xe1])
      #   # => "=$\x8d9.\xc14&\x80</"
      #
      def self.xor(string,key)
        key = case key
              when Integer then [key]
              when String  then key.bytes
              else              key
              end

        key    = key.cycle
        result = String.new(encoding: string.encoding)

        string.bytes.each do |b|
          result << (b ^ key.next).chr
        end

        return result
      end
    end
  end
end
