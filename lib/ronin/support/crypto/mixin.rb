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
        # @option kwargs [:encrypt, :decrypt] mode
        #   The cipher mode.
        #
        # @option kwargs [Symbol] hash
        #   The algorithm to hash the `:password`.
        #
        # @option kwargs [String] key
        #   The secret key to use.
        #
        # @option kwargs [String] password
        #   The password for the cipher.
        #
        # @option kwargs [String] iv
        #   The optional Initial Vector (IV).
        #
        # @option kwargs [Integer] padding
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
      end
    end
  end
end
