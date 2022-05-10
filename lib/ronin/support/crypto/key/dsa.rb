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
        # Represents an DSA key.
        #
        # @see https://rubydoc.info/stdlib/openssl/OpenSSL/PKey/DSA.html
        #
        # @since 1.0.0
        #
        # @api public
        #
        class DSA < OpenSSL::PKey::DSA

          #
          # Generates a new random DSA key.
          #
          # @param [Integer] key_size
          #   The size of the key in bits.
          #
          # @return [DSA]
          #   The newly generated key.
          #
          def self.random(key_size=1024)
            # HACK: openssl-3.0.0 will return an OpenSSL::PKey::SAA instance,
            # even though we subclassed OpenSSL::PKey::SAA.
            new(generate(key_size))
          end

          #
          # Parses an PEM encoded DSA key.
          #
          # @param [String] key
          #   The key text.
          #
          # @return [DSA]
          #   The parsed DSA key.
          #
          def self.parse(key)
            new(key)
          end

          #
          # Opens an DSA key file.
          #
          # @param [String] path
          #   The path to the DSA key file.
          #
          # @return [DSA]
          #   The parsed DSA key.
          #
          def self.open(path)
            parse(File.read(path))
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
