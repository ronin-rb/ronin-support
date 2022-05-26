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

module Ronin
  module Support
    module Crypto
      #
      # Represents a cryptographic cipher.
      #
      # ## Examples
      #
      # ### Encrypt Data
      #
      #     aes256 = Crypto::Cipher.new('aes-256-cbc', direction: :encrypt,
      #                                                password: 'secret')
      #     aes256.encrypt("message in a bottle")
      #     # => "\x18\xC7\x00~\xA2\xA1\x80\x84c\x98,81mo\xBAZ\xDD\xF4\xF2\xEF\xA9\xDE\xB3\xD6!\xB9\xA8WT\x9D\xE0"
      #
      # ### Decrypt Data
      #
      #     aes256 = Crypto::Cipher.new('aes-256-cbc', direction: :decrypt,
      #                                                password: 'secret')
      #     aes256.decrypt("\x18\xC7\x00~\xA2\xA1\x80\x84c\x98,81mo\xBAZ\xDD\xF4\xF2\xEF\xA9\xDE\xB3\xD6!\xB9\xA8WT\x9D\xE0")
      #     # => "message in a bottle"
      #
      # @see https://rubydoc.info/stdlib/openssl/OpenSSL/Cipher.html
      #
      # @since 1.0.0
      # 
      # @api public
      #
      class Cipher < OpenSSL::Cipher

        #
        # Initializes the cipher.
        #
        # @param [:encrypt, :decrypt] direction
        #   Specifies whether the cipher will be used to encrypt or decrypt
        #   data.
        #
        # @param [Symbol, nil] hash
        #   The algorithm to hash the `:password`.
        #
        # @param [String, nil] key
        #   The secret key to use.
        #
        # @param [String, nil] password
        #   The password for the cipher.
        #
        # @param [String, nil] iv
        #   The optional Initial Vector (IV).
        #
        # @param [Integer, nil] padding
        #   Sets the padding for the cipher.
        #
        # @raise [ArgumentError]
        #   The `key:` or `password:` keyword arguments were not given.
        #
        def initialize(name, direction: ,
                             key:       nil,
                             hash:      :sha256,
                             password:  nil,
                             iv:        nil,
                             padding:   nil)
          super(name)

          case direction
          when :encrypt then self.encrypt
          when :decrypt then self.decrypt
          end

          if password && hash
            self.key = OpenSSL::Digest.const_get(hash.upcase).digest(password)
          elsif key
            self.key = key
          else
            raise(ArgumentError,"the the key: or password: keyword argument must be given")
          end

          self.iv      = iv      if iv
          self.padding = padding if padding
        end

        #
        # The list of supported ciphers.
        #
        # @return [Array<String>]
        #   The list of supported cipher names.
        #
        def self.supported
          ciphers
        end

        #
        # Encrypts the given data.
        #
        # @param [String] data
        #   The data to encrypt.
        #
        # @return [String]
        #   The encrypted data.
        #
        def encrypt(data=nil)
          if data
            update(data) + final
          else
            super()
          end
        end

        #
        # Decrypts the given data.
        #
        # @param [String] data
        #   The data to decrypt.
        #
        # @return [String]
        #   The decrypted data.
        #
        def decrypt(data=nil)
          if data
            update(data) + final
          else
            super()
          end
        end

        #
        # Pipes the IO stream through the cipher.
        #
        # @param [IO] io
        #   The IO stream to encrypt or decrypt.
        #
        # @param [Integer] block_size
        #   The block size to read the data with.
        #
        # @param [String, #<<, nil] output
        #   The optional output buffer to append processed data to.
        #   Defaults to an empty ASCII 8bit encoded String.
        #
        # @yield [block]
        #   If a block is given, each processed block will be passed to it.
        #
        # @yieldparam [String] block
        #   A processed block from the file.
        #
        # @return [String]
        #   The processed data, if no block was given.
        #
        def stream(io, block_size: 16384, output: nil)
          unless block_given?
            output ||= String.new(encoding: Encoding::ASCII_8BIT)
          end

          until io.eof?
            block = update(io.read(block_size))

            if block_given? then yield block
            else                 output << block
            end
          end

          if block_given?
            yield final
          else
            output << final
            return output
          end
        end

      end
    end
  end
end
