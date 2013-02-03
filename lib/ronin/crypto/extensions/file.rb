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

require 'ronin/crypto/crypto'

class File

  #
  # Calculates the HMAC for a file.
  #
  # @param [String] path
  #   The path to the file.
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
  # @see Ronin::Crypt.hmac
  #
  # @since 0.6.0
  #
  # @api public
  #
  def self.hmac(path,key,digest=:sha1)
    hmac = Ronin::Crypto.hmac(key,digest)

    open(path,'rb') do |file|
      until file.eof?
        hmac.update(file.read(16384))
      end
    end

    return hmac.hexdigest
  end

  #
  # Encrypts the file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [:encrypt, :decrypt] :mode
  #   The cipher mode.
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
  # @yield [block]
  #   If a block is given, each encrypted block will be passed to it.
  #
  # @yieldparam [String] block
  #   An encrypted block from the file.
  #
  # @return [String]
  #   The encrypted data.
  #
  # @see http://rubydoc.info/stdlib/openssl/OpenSSL/Cipher
  #
  # @since 0.6.0
  #
  # @api public
  #
  def self.encrypt(path,cipher,options={})
    cipher = Ronin::Crypto.cipher(cipher,options.merge(mode: :encrypt))
    output = ''

    open(path,'rb') do |file|
      until file.eof?
        block = cipher.update(file.read(16384))

        if block_given? then yield block
        else                 output << block
        end
      end
    end

    if block_given?
      yield cipher.final
    else
      output << cipher.final
      return output
    end
  end

  #
  # Decrypts the file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [:encrypt, :decrypt] :mode
  #   The cipher mode.
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
  # @yield [block]
  #   If a block is given, each encrypted block will be passed to it.
  #
  # @yieldparam [String] block
  #   An encrypted block from the file.
  #
  # @return [String]
  #   The decrypted data.
  #
  # @see http://rubydoc.info/stdlib/openssl/OpenSSL/Cipher
  #
  # @since 0.6.0
  #
  # @api public
  #
  def self.decrypt(path,cipher,options={})
    cipher = Ronin::Crypto.cipher(cipher,options.merge(mode: :decrypt))
    output = ''

    open(path,'rb') do |file|
      until file.eof?
        block = cipher.update(file.read(16384))

        if block_given? then yield block
        else                 output << block
        end
      end
    end

    if block_given?
      yield cipher.final
    else
      output << cipher.final
      return output
    end
  end

end
