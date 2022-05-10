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
        # Represents an RSA key.
        #
        # @see https://rubydoc.info/stdlib/openssl/OpenSSL/PKey/RSA.html
        #
        # @since 1.0.0
        #
        # @api public
        #
        class RSA < OpenSSL::PKey::RSA

          #
          # Generates a new random RSA key.
          #
          # @param [Integer] key_size
          #   The size of the key in bits.
          #
          # @return [RSA]
          #   The newly generated key.
          #
          def self.random(key_size=1024)
            # HACK: openssl-3.0.0 will return an OpenSSL::PKey::RSA instance,
            # even though we subclassed OpenSSL::PKey::RSA.
            new(generate(key_size))
          end

          #
          # Parses an PEM encoded RSA key.
          #
          # @param [String] key
          #   The key text.
          #
          # @return [RSA]
          #   The parsed RSA key.
          #
          def self.parse(key)
            new(key)
          end

          #
          # Loads a RSA key from a file.
          #
          # @param [String] path
          #   The path to the RSA key file.
          #
          # @return [RSA]
          #   The parsed RSA key.
          #
          def self.load(path)
            parse(File.read(path))
          end

          #
          # The `n` variable for the RSA key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def n
            super()
          end

          #
          # The `e` variable for the RSA key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def e
            super()
          end

          #
          # The `d` variable for the RSA key.
          #
          # @return [OpenSSL::BN]
          #
          # @see https://rubydoc.info/stdlib/openssl/OpenSSL/BN
          #
          def d
            super()
          end

          #
          # The size of the RSA key in bits.
          #
          # @return [Integer]
          #   The key size in bits.
          #
          def size
            n.num_bits
          end

        end
      end
    end
  end
end
