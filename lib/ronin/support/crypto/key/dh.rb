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
      module Key
        #
        # Represents an Diffie-Hellman (DH) key.
        #
        # @see https://rubydoc.info/stdlib/openssl/OpenSSL/PKey/DH.html
        #
        # @since 1.0.0
        #
        # @api public
        #
        class DH < OpenSSL::PKey::DH

          #
          # Generates a new random DH key.
          #
          # @param [Integer] key_size
          #   The size of the key in bits.
          #
          # @param [Integer] generator
          #   A small number > 1, typically 2 or 5.
          #
          # @return [DH]
          #   The newly generated key.
          #
          def self.random(key_size=1024, generator: nil)
            new(generate(key_size,*generator))
          end

          #
          # Parses an DER encoded DH key.
          #
          # @param [String] key
          #   The key text.
          #
          # @return [DH]
          #   The parsed DH key.
          #
          def self.parse(key)
            new(key)
          end

          #
          # Opens an DH key file.
          #
          # @param [String] path
          #   The path to the DH key file.
          #
          # @return [DH]
          #   The parsed DH key.
          #
          def self.open(path)
            parse(File.read(path))
          end

          #
          # The `p` variable for the DH key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def p
            super()
          end

          #
          # The `q` variable for the DH key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def q
            super()
          end

          #
          # The `g` variable for the DH key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def g
            super()
          end

          #
          # The size of the DH key in bits.
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
