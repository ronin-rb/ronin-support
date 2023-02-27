# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/support/network/ssl/openssl'
require 'ronin/support/network/ssl/local_key'
require 'ronin/support/network/ssl/local_cert'
require 'ronin/support/network/ssl/proxy'

module Ronin
  module Support
    module Network
      #
      # Top-level SSL methods.
      #
      module SSL
        # SSL/TLS versions
        VERSIONS = {
          1   => :TLSv1,
          1.1 => :TLSv1_1,
          1.2 => :TLSv1_2
        }

        # SSL verify modes
        VERIFY = {
          none:                 OpenSSL::SSL::VERIFY_NONE,
          peer:                 OpenSSL::SSL::VERIFY_PEER,
          fail_if_no_peer_cert: OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT,
          client_once:          OpenSSL::SSL::VERIFY_CLIENT_ONCE,
          true               => OpenSSL::SSL::VERIFY_PEER,
          false              => OpenSSL::SSL::VERIFY_NONE
        }

        #
        # The default RSA key used for all SSL server sockets.
        #
        # @return [Crypto::Key::RSA]
        #   The default RSA key.
        #
        def self.key
          @key ||= LocalKey.fetch
        end

        #
        # Overrides the default RSA key.
        #
        # @param [Crypto::Key::RSA, OpenSSL::PKey::RSA] new_key
        #   The new RSA key.
        #
        # @return [Crypto::Key::RSA, OpenSSL::PKey::RSA]
        #   The new default RSA key.
        #
        def self.key=(new_key)
          @key = new_key
        end

        #
        # The default SSL certificate used for all SSL server sockets.
        #
        # @return [Crypto::Cert]
        #   The default SSL certificate.
        #
        def self.cert
          @cert ||= LocalCert.fetch
        end

        #
        # Overrides the default SSL certificate.
        #
        # @param [Crypto::Cert, OpenSSL::X509::Certificate] new_cert
        #   The new SSL certificate.
        #
        # @return [Crypto::Cert, OpenSSL::X509::Certificate]
        #   The new default SSL certificate.
        #
        def self.cert=(new_cert)
          @cert = new_cert
        end

        #
        # Creates a new SSL Context.
        #
        # @param [1, 1.1, 1.2, String, Symbol, nil] version
        #   The SSL version to use.
        #
        # @param [Symbol, Boolean] verify
        #   Specifies whether to verify the SSL certificate.
        #   May be one of the following:
        #
        #   * `:none`
        #   * `:peer`
        #   * `:fail_if_no_peer_cert`
        #   * `:client_once`
        #
        # @param [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] key
        #   The RSA key to use for the SSL context.
        #
        # @param [String, nil] key_file
        #   The path to the RSA `.key` file.
        #
        # @param [Crypto::Cert, OpenSSL::X509::Certificate, nil] cert
        #   The X509 certificate to use for the SSL context.
        #
        # @param [String, nil] cert_file
        #   The path to the SSL `.crt` or `.pem` file.
        #
        # @param [String, nil] ca_bundle
        #   Path to the CA bundle file or directory.
        #
        # @return [OpenSSL::SSL::SSLContext]
        #   The newly created SSL Context.
        #
        # @raise [ArgumentError]
        #   `cert_file:` or `cert:` keyword arguments also require a `key_file:`
        #   or `key:` keyword argument.
        #
        # @api semipublic
        #
        # @since 1.0.0
        #
        def self.context(version:   nil,
                         verify:    :none,
                         key:       nil,
                         key_file:  nil,
                         cert:      nil,
                         cert_file: nil,
                         ca_bundle: nil)
          context = OpenSSL::SSL::SSLContext.new()

          if version
            context.ssl_version = VERSIONS.fetch(version,version)
          end

          context.verify_mode = VERIFY[verify]

          if (key_file || key) && (cert_file || cert)
            context.key  = if key_file then Crypto::Key::RSA.load_file(key_file)
                           else             key
                           end

            context.cert = if cert_file then Crypto::Cert.load_file(cert_file)
                           else              cert
                           end
          elsif (key_file || key) || (cert_file || cert)
            raise(ArgumentError,"cert_file: and cert: keyword arguments also require a key_file: or key: keyword argument")
          end

          if ca_bundle
            if File.file?(ca_bundle)
              context.ca_file = ca_bundle
            elsif File.directory?(ca_bundle)
              context.ca_path = ca_bundle
            end
          end

          return context
        end

      end
    end
  end
end
