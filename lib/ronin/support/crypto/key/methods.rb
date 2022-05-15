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
        # Common methods for {Key} classes.
        #
        # @api private
        #
        # @since 1.0.0
        #
        module Methods
          #
          # Extends {ClassMethods}.
          #
          # @param [Class] key_class
          #   The {Key} class that is including {Methods}.
          #
          def self.included(key_class)
            key_class.extend ClassMethods
          end

          module ClassMethods
            #
            # Parses an PEM encoded key.
            #
            # @param [String] key
            #   The PEM or DER encoded key string.
            #
            # @param [String, nil] password
            #   Optional password to decrypt the key.
            #
            # @return [OpenSSL::PKey]
            #   The parsed key.
            #
            # @api public
            #
            def parse(key, password: nil)
              new(key,*password)
            end

            #
            # @see parse
            #
            # @api public
            #
            def load(key,**kwargs)
              parse(key,**kwargs)
            end

            #
            # Loads a key from a file.
            #
            # @param [String] path
            #   The path to the PEM or DER encoded key file.
            #
            # @param [Hash{Symbol => Object}] kwargs
            #   Additional keyword arguments for {parse}.
            #
            # @option kwargs [String, nil] :password
            #   Optional password to decrypt the key.
            #
            # @return [OpenSSL::PKey]
            #   The parsed key.
            #
            # @api public
            #
            def load_file(path,**kwargs)
              parse(File.read(path),**kwargs)
            end
          end

          #
          # Saves the key to the given path.
          #
          # @param [String] path
          #   The path to write the exported key to.
          #
          # @param [String, nil] cipher
          #   Optional cipher to use to encrypt the key file.
          #
          # @param [String, nil] password
          #   Optional password to use to encrypt the key file.
          #
          def save(path, cipher: 'aes-256-cbc', password: nil)
            pem = if  password
                    export(OpenSSL::Cipher.new(cipher),password)
                  else
                    export()
                  end

            File.write(path,pem)
          end
        end
      end
    end
  end
end
