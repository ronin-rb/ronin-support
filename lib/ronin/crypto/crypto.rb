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

begin
  require 'openssl'
rescue ::LoadError
  warn "WARNING: Ruby was not compiled with OpenSSL support"
end

module Ronin
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
    # Creates a cipher.
    #
    # @param [String] name
    #   The cipher name.
    #
    # @return [OpenSSL::Cipher]
    #   The newly created cipher.
    #
    # @example
    #   Crypto.cipher('aes-128-cbc')
    #   # => #<OpenSSL::Cipher:0x0000000170d108>
    #
    def self.cipher(name)
      OpenSSL::Cipher.new(name)
    end
  end
end
