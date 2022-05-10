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
        # Represents an EC key.
        #
        # ## Examples
        #
        # ### List supported curves
        #
        #     Crypto::Key::EC.supported_curves
        #     # => ["secp224r1", "secp256k1", "secp384r1", "secp521r1", "prime256v1"]
        #
        # ### Generate a random key
        #
        #     ec = Crypto::Key::EC.random("secp224r1")
        #
        # @see https://rubydoc.info/stdlib/openssl/OpenSSL/PKey/EC.html
        #
        # @since 1.0.0
        #
        # @api public
        #
        class EC < OpenSSL::PKey::EC

          #
          # The supported elliptical curves.
          #
          # @return [Array<String>]
          #   The supported curve names.
          #
          def self.supported_curves
            builtin_curves.map { |(name,desc)| name }
          end

          #
          # Generates a new random EC key.
          #
          # @param [String] curve
          #   The elliptical curve to use.
          #
          # @return [EC]
          #   The newly generated key.
          #
          def self.random(curve)
            ec = generate(curve)
            ec.generate_key
          end

          #
          # Parses an PEM encoded EC key.
          #
          # @param [String] key
          #   The key text.
          #
          # @return [EC]
          #   The parsed EC key.
          #
          def self.parse(key)
            new(key)
          end

          #
          # Opens an EC key file.
          #
          # @param [String] path
          #   The path to the RSA key file.
          #
          # @return [EC]
          #   The parsed RSA key.
          #
          def self.open(path)
            parse(File.read(path))
          end

        end
      end
    end
  end
end
