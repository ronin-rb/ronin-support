# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/crypto/key/methods'
require 'ronin/support/crypto/openssl'

module Ronin
  module Support
    module Crypto
      module Key
        #
        # Represents an DSA key.
        #
        # @see https://rubydoc.info/stdlib/openssl/OpenSSL/PKey/DSA.html
        #
        # @since 1.0.0
        #
        # @api public
        #
        class DSA < OpenSSL::PKey::DSA

          include Methods

          #
          # Generates a new random DSA key.
          #
          # @param [Integer] key_size
          #   The size of the key in bits.
          #
          # @return [DSA]
          #   The newly generated key.
          #
          def self.generate(key_size=1024)
            # HACK: openssl-3.0.0 will return an OpenSSL::PKey::SAA instance,
            # even though we subclassed OpenSSL::PKey::SAA.
            new_key = allocate
            new_key.send(:initialize_copy,super(key_size))
            new_key
          end

          #
          # The `p` variable for the DSA key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def p
            super()
          end

          #
          # The `q` variable for the DSA key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def q
            super()
          end

          #
          # The `g` variable for the DSA key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def g
            super()
          end

          #
          # The size of the DSA key in bits.
          #
          # @return [Integer]
          #   The key size in bits.
          #
          def size
            p.num_bits
          end

        end
      end
    end
  end
end
