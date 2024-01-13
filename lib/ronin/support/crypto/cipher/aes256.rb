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

require 'ronin/support/crypto/cipher/aes'

module Ronin
  module Support
    module Crypto
      class Cipher < OpenSSL::Cipher
        #
        # The AES256 cipher.
        #
        class AES256 < AES

          #
          # Initializes the AES 256bit cipher.
          #
          # @param [Symbol] hash
          #   The hashing algorithm to use to generate the key.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {Cipher#initialize}.
          #
          def initialize(hash: :sha256, **kwargs)
            super(key_size: 256, hash: hash, **kwargs)
          end

          #
          # The list of supported AES 256bit ciphers.
          #
          # @return [Array<String>]
          #   The list of supported AES 256bit cipher names.
          #
          def self.supported
            super().grep(/^aes(?:-)?256/)
          end

        end
      end
    end
  end
end
