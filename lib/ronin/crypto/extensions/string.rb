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
  # @see http://rubydoc.info/stdlib/openssl/OpenSSL/HMAC
  #
  # @since 0.6.0
  #
  # @api public
  #
  def hmac(key,digest=:sha1)
    digest = Ronin::Crypto.digest(digest).new

    return OpenSSL::HMAC.hexdigest(digest,key,self)
  end

  #
  # Encrypts the String.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [String] key
  #   The secret key to use.
  #
  # @param [String] iv
  #   The optional Initial Vector (IV).
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
  def encrypt(cipher,key,iv=nil)
    cipher = Ronin::Crypto.cipher(cipher)
    cipher.encrypt
    cipher.key = key
    cipher.iv  = iv if iv

    return cipher.update(self) + cipher.final
  end

  #
  # Decrypts the String.
  #
  # @param [String] cipher
  #   The cipher to use.
  #
  # @param [String] key
  #   The secret key to use.
  #
  # @param [String] iv
  #   The optional Initial Vector (IV).
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
  def decrypt(cipher,key,iv=nil)
    cipher = Ronin::Crypto.cipher(cipher)
    cipher.decrypt
    cipher.key = key
    cipher.iv  = iv if iv

    return cipher.update(self) + cipher.final
  end

end
