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

require 'ronin/crypto'

require 'digest'

class File

  #
  # Calculates the MD5 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The MD5 checksum of the file.
  #
  # @example
  #   File.md5('data.txt')
  #   # => "5d41402abc4b2a76b9719d911017c592"
  #
  # @api public
  #
  def File.md5(path)
    Digest::MD5.file(path).hexdigest
  end

  #
  # Calculates the SHA1 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The SHA1 checksum of the file.
  #
  # @example
  #   File.sha1('data.txt')
  #   # => "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"
  #
  # @api public
  #
  def File.sha1(path)
    Digest::SHA1.file(path).hexdigest
  end

  #
  # @see File.sha1
  #
  # @api public
  #
  def File.sha128(path)
    File.sha1(path)
  end

  #
  # Calculates the SHA256 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The SHA256 checksum of the file.
  #
  # @example
  #   File.sha256('data.txt')
  #   # => "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
  #
  # @api public
  #
  def File.sha256(path)
    Digest::SHA256.file(path).hexdigest
  end

  #
  # @see File.sha256
  #
  # @api public
  #
  def File.sha2(path)
    File.sha256(path)
  end

  #
  # Calculates the SHA512 checksum of a file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The SHA512 checksum of the file.
  #
  # @example
  #   File.sha512('data.txt')
  #   # => "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"
  #
  # @api public
  #
  def File.sha512(path)
    Digest::SHA512.file(path).hexdigest
  end

  #
  # @see File.sha512
  #
  # @api public
  #
  def File.sha5(path)
    File.sha512(path)
  end

  #
  # Calculates the RMD160 checksum for the File.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @return [String]
  #   The RMD160 checksum of the File.
  #
  # @example
  #   File.rmd160('data.txt')
  #   # => "108f07b8382412612c048d07d13f814118445acd"
  #
  # @api public
  #
  # @since 0.6.0
  #
  def File.rmd160(path)
    Digest::RMD160.file(path).hexdigest
  end

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
