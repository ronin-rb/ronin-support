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

class String

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
  # @see Ronin::Crypto.hmac
  #
  # @since 0.6.0
  #
  # @api public
  #
  def hmac(key,digest=:sha1)
    hmac = Ronin::Crypto.hmac(key,digest)
    hmac.update(self)

    return hmac.hexdigest
  end

  #
  # Encrypts the String.
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
  # @return [String]
  #   The encrypted String.
  #
  # @see http://rubydoc.info/stdlib/openssl/OpenSSL/Cipher
  #
  # @since 0.6.0
  #
  # @api public
  #
  def encrypt(cipher,options={})
    cipher = Ronin::Crypto.cipher(cipher, options.merge(mode: :encrypt))

    return cipher.update(self) + cipher.final
  end

  #
  # Decrypts the String.
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
  # @return [String]
  #   The decrypted String.
  #
  # @see http://rubydoc.info/stdlib/openssl/OpenSSL/Cipher
  #
  # @since 0.6.0
  #
  # @api public
  #
  def decrypt(cipher,options={})
    cipher = Ronin::Crypto.cipher(cipher,options.merge(mode: :decrypt))

    return cipher.update(self) + cipher.final
  end

end
