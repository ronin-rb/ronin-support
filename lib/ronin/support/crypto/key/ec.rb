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

require 'ronin/support/crypto/key/class_methods'
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

          extend ClassMethods

          #
          # Initializes the EC key.
          #
          # @note
          #   Will print a warning message when running on JRuby about
          #   jruby-openssl's EC key bugs:
          #   * https://github.com/jruby/jruby-openssl/issues/256
          #   *https://github.com/jruby/jruby-openssl/issues/257
          #
          def initialize(*args)
            if RUBY_ENGINE == 'jruby'
              warn "WARNING: jruby-openssl has multiple bugs wrt parsing EC keys"
              warn " * https://github.com/jruby/jruby-openssl/issues/256"
              warn " * https://github.com/jruby/jruby-openssl/issues/257"
            end

            super(*args)
          end

          if RUBY_ENGINE == 'jruby'
            #
            # Generates a new DH key.
            #
            # @param [String] curve
            #   The elliptical curve to use.
            #
            # @return [EC]
            #   The newly generated key.
            #
            # @note
            #   jruby's openssl does not define `OpenSSL::PKey::EC.generate`.
            #   See https://github.com/jruby/jruby-openssl/issues/255
            #
            def self.generate(curve)
              new(curve)
            end
          end

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

        end
      end
    end
  end
end
