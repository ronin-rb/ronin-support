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

require 'ronin/support/crypto/key/dh'
require 'ronin/support/crypto/key/dsa'
require 'ronin/support/crypto/key/ec'
require 'ronin/support/crypto/key/rsa'

module Ronin
  module Support
    module Crypto
      #
      # Top-level methods for working with public/private keys.
      #
      module Key
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
        # @return [DH, DSA, EC, RSA]
        #   The parsed key.
        #
        # @raise [ArgumentError]
        #   The key type could not be determined from the key file.
        #
        # @api public
        #
        def self.parse(key, password: nil)
          key_class = if key.start_with?('-----BEGIN RSA PRIVATE KEY-----')
                        RSA
                      elsif key.start_with?('-----BEGIN DSA PRIVATE KEY-----')
                        DSA
                      elsif key.start_with?('-----BEGIN DH PARAMETERS-----')
                        DH
                      elsif key.start_with?('-----BEGIN EC PRIVATE KEY-----')
                        EC
                      else
                        raise(ArgumentError,"cannot determine the key type for key: #{key.inspect}")
                      end

          key_class.parse(key, password: password)
        end

        #
        # Alias for {parse}.
        #
        # @param [String] key
        #   The PEM or DER encoded key string.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {parse}.
        #
        # @option kwargs [String, nil] :password
        #   Optional password to decrypt the key.
        #
        # @return [DH, DSA, EC, RSA]
        #   The parsed key.
        #
        # @see parse
        #
        # @api public
        #
        def self.load(key,**kwargs)
          parse(key,**kwargs)
        end

        #
        # Loads the key from the file.
        #
        # @param [String] path
        #   The path to the key file.
        #
        # @return [DH, DSA, EC, RSA]
        #   The loaded key.
        #
        # @raise [ArgumentError]
        #   The key type could not be determined from the key file.
        #
        # @api public
        #
        def self.load_file(path)
          parse(File.read(path))
        end
      end

      #
      # Coerces a value into a {Key} object.
      #
      # @param [String, OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, OpenSSL::PKey::DH , OpenSSL::PKey::EC] key
      #   The key String or `OpenSSL::PKey::PKey` value.
      #
      # @return [RSA, DSA, DH, EC]
      #   The coerced certificate.
      #
      # @raise [ArgumentError]
      #   The key value was not a String or a `OpenSSL::PKey::PKey` object.
      #
      # @raise [NotImplementedError]
      #   A new `OpenSSL::PKey::PKey` value that was not `OpenSSL::PKey::RSA`,
      #   `OpenSSL::PKey::DSA`, `OpenSSL::PKey::DH`, or `OpenSSL::PKey::EC`
      #   was given.
      #
      # @api semipublic
      #
      # @since 1.1.0
      #
      def self.Key(key)
        case key
        when String then Key.parse(key)
        when OpenSSL::PKey::PKey
          key_class = case key
                      when OpenSSL::PKey::RSA then Key::RSA
                      when OpenSSL::PKey::DSA then Key::DSA
                      when OpenSSL::PKey::DH  then Key::DH
                      when OpenSSL::PKey::EC  then Key::EC
                      else
                        raise(NotImplementedError,"#{key.inspect} is not supported")
                      end

          new_key = key_class.allocate
          new_key.send(:initialize_copy,key)
          new_key
        else
          raise(ArgumentError,"value must be either a String or a OpenSSL::PKey::PKey object: #{key.inspect}")
        end
      end
    end
  end
end
