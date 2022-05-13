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
      #   Crypto.digest(:ripemd160)
      #   # => OpenSSL::Digest::RIPEMD160
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
      # @see http://rubydoc.info/stdlib/openssl/OpenSSL/HMAC
      #
      # @example
      #   Crypto.hmac('secret')
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
      # @return [String]
      #   The encrypted data.
      #
      # @raise [ArgumentError]
      #   Either the the `key:` or `password:` keyword argument must be given.
      #
      # @since 1.0.0
      #
      def self.encrypt(data, cipher: ,**kwargs)
        cipher = self.cipher(cipher, direction: :encrypt, **kwargs)

        return cipher.update(data) + cipher.final
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
      # @since 1.0.0
      #
      def self.decrypt(data, cipher: ,**kwargs)
        cipher = self.cipher(cipher, direction: :decrypt, **kwargs)

        return cipher.update(data) + cipher.final
      end

      #
      # Creates a new AES cipher.
      #
      # @param [Integer] key_size
      #   The desired key size in bits.
      #
      # @param [:cbc, :cfb, :ofb, :ctr, Symbol] mode
      #   The desired AES cipher mode.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Cipher::AES#initialize}.
      #
      # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] :mode (:cbc)
      #   The desired AES cipher mode.
      #
      # @return [Cipher::AES]
      #   The new AES cipher.
      #
      # @example
      #   Crypto.aes(direction: :encrypt, password: 's3cr3t')
      #   # => #<Ronin::Support::Crypto::Cipher::AES:0x00007f2b84dfa6b8 @key_size=256, @mode=:cbc>
      #
      def self.aes(key_size: 256, mode: :cbc, **kwargs)
        Cipher::AES.new(key_size: key_size, mode: mode,**kwargs)
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
      # @option kwargs [Integer] :key_size (256)
      #   The desired key size in bits.
      #
      # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] mode (:cbc)
      #   The desired AES cipher mode.
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
        aes = self.aes(direction: :encrypt, **kwargs)

        return aes.update(data) + aes.final
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
      # @option kwargs [Integer] :key_size (256)
      #   The desired key size in bits.
      #
      # @option kwargs [:cbc, :cfb, :ofb, :ctr, Symbol] mode (:cbc)
      #   The desired AES cipher mode.
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
        aes = self.aes(direction: :decrypt, **kwargs)

        return aes.update(data) + aes.final
      end
    end
  end
end
