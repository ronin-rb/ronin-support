# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/crypto/key/rsa'
require 'ronin/support/crypto/key/ec'
require 'ronin/support/network/ip'

module Ronin
  module Support
    module Crypto
      #
      # Represents a X509 or TLS certificate.
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Cert < OpenSSL::X509::Certificate

        #
        # Represents the `Subject` and `Issuer` fields in a X509 Certificate.
        #
        # @api semipublic
        #
        class Name < OpenSSL::X509::Name

          #
          # Builds a X509 `Subject` or `Issuer` string.
          #
          # @param [String, nil] common_name
          #   The "common name" for the cert (ex: `github.com`).
          #
          # @param [String, nil] email_address
          #   The email address for the cert (ex: `admin@github.com`).
          #
          # @param [String, nil] organizational_unit
          #   The organizational unit for the cert.
          #
          # @param [String, nil] organization
          #   The organization name for the cert (ex: `GitHub, Inc.`).
          #
          # @param [String, nil] locality
          #   The locality or city for the cert (ex: `San Francisco`).
          #
          # @param [String, nil] state
          #   The state for the cert (ex: `Californa`).
          #
          # @param [String, nil] province
          #   The province for the cert.
          #
          # @param [String, nil] country
          #   The country for the cert (ex: `US`).
          #
          # @return [Name]
          #   The populated name.
          #
          def self.build(common_name: nil, email_address: nil, organizational_unit: nil, organization: nil, locality: nil, state: nil, province: nil, country: nil)
            name = new
            name.add_entry("CN",common_name)             if common_name
            name.add_entry('emailAddress',email_address) if email_address
            name.add_entry("OU",organizational_unit)     if organizational_unit
            name.add_entry("O",organization)             if organization
            name.add_entry("L",locality)                 if locality
            name.add_entry("ST",state || province)       if (state || province)
            name.add_entry("C",country)                  if country

            return name
          end

          #
          # The parsed entries in the name.
          #
          # @return [Hash{String => String}]
          #
          def entries
            @entries ||= to_a.to_h do |(oid,value,type)|
              [oid, value && value.force_encoding(Encoding::UTF_8)]
            end
          end

          alias to_h entries

          #
          # Finds the entry with the given OID name.
          #
          # @param [String] oid
          #
          # @return [String, nil]
          #
          def [](oid)
            entries[oid]
          end

          #
          # The common name (`CN`) entry.
          #
          # @return [String, nil]
          #
          def common_name
            self['CN']
          end

          #
          # The email address (`emailAddress`) entry.
          #
          # @return [String, nil]
          #
          # @since 1.1.0
          #
          def email_address
            self['emailAddress']
          end

          #
          # The organization (`O`) entry.
          #
          # @return [String, nil]
          #
          def organization
            self['O']
          end

          #
          # The organizational unit (`OU`) entry.
          #
          # @return [String, nil]
          #
          def organizational_unit
            self['OU']
          end

          #
          # The locality (`L`) entry.
          #
          # @return [String, nil]
          #
          def locality
            self['L']
          end

          #
          # The state or province (`ST`) entry.
          #
          # @return [String, nil]
          #
          def state
            self['ST']
          end

          alias province state

          #
          # The country (`C`) entry.
          #
          # @return [String, nil]
          #
          def country
            self['C']
          end

        end

        #
        # Coerces a value into a {Name} object.
        #
        # @param [String, Hash, OpenSSL::X509::Name, Name] name
        #   The name value to coerce.
        #
        # @return [Cert::Name]
        #   The name object.
        #
        # @api semipublic
        #
        def self.Name(name)
          case name
          when String then Name.parse(name)
          when Hash   then Name.build(**name)
          when Name   then name
          when OpenSSL::X509::Name
            new_name = Name.allocate
            new_name.send(:initialize_copy,name)
            new_name
          else
            raise(ArgumentError,"value must be either a String, Hash, or a OpenSSL::X509::Name object: #{name.inspect}")
          end
        end

        #
        # Parses the PEM encoded certificate string.
        #
        # @param [String] string
        #   The certificate string.
        #
        # @return [Cert]
        #   The parsed certificate.
        #
        def self.parse(string)
          new(string)
        end

        #
        # Parses the PEM encoded certificate.
        #
        # @param [String] buffer
        #   The String containing the certificate.
        #
        # @return [Cert]
        #   The parsed certificate.
        #
        def self.load(buffer)
          new(buffer)
        end

        #
        # Loads the certificate from the file.
        #
        # @param [String] path
        #   The path to the file.
        #
        # @return [Cert]
        #   The loaded certificate.
        #
        def self.load_file(path)
          new(File.read(path))
        end

        # One year in seconds
        ONE_YEAR = 60 * 60 * 24 * 365

        #
        # Generates and signs a new certificate.
        #
        # @param [Integer] version
        #   The version of the encoded certificate.
        #   See [RFC 5280](https://datatracker.ietf.org/doc/html/rfc5280).
        #
        # @param [Integer] serial
        #   The certificate serial number.
        #
        # @param [String, Hash{Symbol => String,nil}, Name, nil] subject
        #   The subject field for the certificate. If a `Hash` is given it will
        #   be passed to {Name.build}.
        #
        # @param [Time] not_before
        #   Beginning time when the certificate is valid.
        #
        # @param [Time] not_after
        #   When the certificate expires and is no longer valid.
        #
        # @param [Hash{String => Object}] extensions
        #   Additional extensions to add to the new certificate.
        #
        # @param [Key::RSA] key
        #   The public/private key pair used with the certificate.
        #
        # @param [Key::RSA, nil] ca_key
        #   The optional Certificate Authority (CA) key to use to sign the new
        #   certificate.
        #
        # @param [Cert, nil] ca_cert
        #   The optional Certificate Authority (CA) certificate to attach to the
        #   new certificate.
        #
        # @param [Boolean] ca
        #   Indicates whether to add the basicConstraints extension.
        #
        # @param [Array<String>, nil] subject_alt_names
        #   List of subject alt names to add into subjectAltName extension.
        #
        # @param [Symbol] signing_hash
        #   The hashing algorithm to use to sign the new certificate.
        #
        # @return [Cert]
        #   The newly generated and signed certificate.
        #
        # @example Generate a self-signed certificate for `localhost`:
        #   key  = Ronin::Support::Crypto::Key::RSA.random
        #   cert = Ronin::Support::Crypto::Cert.generate(
        #     key: key,
        #     subject: {
        #       common_name:         'localhost',
        #       organization:        'Test Co.',
        #       organizational_unit: 'Test Dept',
        #       locality:            'Test City',
        #       state:               'XX',
        #       country:             'US'
        #     },
        #     extensions: {
        #       'subjectAltName' => 'DNS: localhost, IP: 127.0.0.1'
        #     }
        #   )
        #   key.save('cert.key')
        #   cert.save('cert.pem')
        #
        # @example Generate a CA certificate:
        #   ca_key  = Ronin::Support::Crypto::Key::RSA.random
        #   ca_cert = Ronin::Support::Crypto::Cert.generate(
        #     key: ca_key,
        #     subject: {
        #       common_name:         'Test CA',
        #       organization:        'Test CA, Inc.',
        #       organizational_unit: 'Test Dept',
        #       locality:            'Test City',
        #       state:               'XX',
        #       country:             'US'
        #     },
        #     extensions: {
        #       'basicConstraints' => ['CA:TRUE', true]
        #     }
        #   )
        #   key.save('ca.key')
        #   cert.save('ca.pem')
        #
        # @example Generate a sub-certificate from a CA certificate:
        #   key  = Ronin::Support::Crypto::Key::RSA.random
        #   cert = Ronin::Support::Crypto::Cert.generate(
        #     key:     key,
        #     ca_key:  ca_key,
        #     ca_cert: ca_cert,
        #     subject: {
        #       common_name:         'test.com',
        #       organization:        'Test Co.',
        #       organizational_unit: 'Test Dept',
        #       locality:            'Test City',
        #       state:               'XX',
        #       country:             'US'
        #     },
        #     extensions: {
        #       'subjectAltName'   => 'DNS: *.test.com',
        #       'basicConstraints' => ['CA:FALSE', true]
        #     }
        #   )
        #   key.save('cert.key')
        #   cert.save('cert.pem')
        #
        def self.generate(version:    2,
                          serial:     0,
                          not_before: Time.now,
                          not_after:  not_before + ONE_YEAR,
                          subject:    nil,
                          extensions: nil,
                          # signing arguments
                          key: ,
                          ca_cert: nil,
                          ca_key:  nil,
                          ca:      false,
                          subject_alt_names: nil,
                          signing_hash: :sha256)
          cert = new

          cert.version = version
          cert.serial  = if ca_cert then ca_cert.serial + 1
                         else            serial
                         end

          cert.not_before = not_before
          cert.not_after  = not_after
          cert.public_key = case key
                            when OpenSSL::PKey::EC then key
                            else                        key.public_key
                            end
          cert.subject    = Name(subject) if subject
          cert.issuer     = if ca_cert then ca_cert.subject
                            else            cert.subject
                            end

          if subject_alt_names
            subject_alt_name = subject_alt_names.map { |alt_name|
              if alt_name.match?(Network::IP::REGEX)
                "IP:#{alt_name}"
              else
                "DNS:#{alt_name}"
              end
            }.join(', ')

            extensions ||= {}
            extensions   = extensions.merge('subjectAltName' => subject_alt_name)
          end

          if ca
            extensions ||= {}
            extensions   = extensions.merge('basicConstraints' => ['CA:TRUE', true])
          end

          if extensions
            extension_factory = OpenSSL::X509::ExtensionFactory.new

            extension_factory.subject_certificate = cert
            extension_factory.issuer_certificate  = ca_cert || cert

            extensions.each do |name,(value,critical)|
              ext = extension_factory.create_extension(name,value,critical)
              cert.add_extension(ext)
            end
          end

          signing_key    = ca_key || key
          signing_digest = OpenSSL::Digest.const_get(signing_hash.upcase).new

          cert.sign(signing_key,signing_digest)
          return cert
        end

        #
        # The issuer of the certificate.
        #
        # @return [Name, nil]
        #
        def issuer
          @issuer ||= if (issuer = super)
                        Cert::Name(issuer)
                      end
        end

        #
        # The subject of the certificate.
        #
        # @return [Name, nil]
        #
        def subject
          @subject ||= if (subject = super)
                         Cert::Name(subject)
                       end
        end

        #
        # The subjects common name (`CN`) entry.
        #
        # @return [String, nil]
        #
        def common_name
          if (subject = self.subject)
            subject.common_name
          end
        end

        #
        # The extension OID names.
        #
        # @return [Array<String>]
        #
        def extension_names
          extensions.map(&:oid)
        end

        #
        # Converts the certificate's extensions into a Hash.
        #
        # @return [Hash{String => OpenSSL::X509::Extension}]
        #   The Hash of extension OID names and extension objects.
        #
        def extensions_hash
          extensions.to_h { |ext| [ext.oid, ext] }
        end

        #
        # Gets the value for the extension with the matching OID.
        #
        # @param [String] oid
        #   The OID to search for.
        #
        # @return [String, nil]
        #   The value of the matching extension.
        #
        def extension_value(oid)
          if (ext = find_extension(oid))
            ext.value
          end
        end

        #
        # Retrieves the `subjectAltName` extension and parses it's contents.
        #
        # @return [String, nil]
        #   The `subjectAltName` value or `nil` if the certificate does not
        #   have the extension.
        #
        def subject_alt_name
          extension_value('subjectAltName')
        end

        #
        # Retrieves the `subjectAltName` extension and parses it's value.
        #
        # @return [Array<String>, nil]
        #   The parsed `subjectAltName` or `nil` if the certificate does not
        #   have the extension.
        #
        def subject_alt_names
          if (value = subject_alt_name)
            value.split(', ').map do |name|
              name.split(':',2).last
            end
          end
        end

        #
        # Saves the certificate to the given path.
        #
        # @param [String] path
        #   The path to write the exported certificate to.
        #
        # @param [:pem, :der] encoding
        #   The desired encoding of the exported key.
        #   * `:pem` - PEM encoding.
        #   * `:der` - DER encoding.
        #
        # @raise [ArgumentError]
        #   The `endcoding:` value must be either `:pem` or `:der`.
        #
        def save(path, encoding: :pem)
          exported = case encoding
                     when :pem then to_pem
                     when :der then to_der
                     else
                       raise(ArgumentError,"encoding: keyword argument (#{encoding.inspect}) must be either :pem or :der")
                     end

          File.write(path,exported)
        end

      end

      #
      # Coerces a value into a {Cert} object.
      #
      # @param [String, OpenSSL::X509::Certificate, Cert] cert
      #   The certificate String or `OpenSSL::X509::Certificate` value.
      #
      # @return [Cert]
      #   The coerced certificate.
      #
      # @raise [ArgumentError]
      #   The certificate value was not a String or a `OpenSSL::X509::Certificate` object.
      #
      # @api semipublic
      #
      def self.Cert(cert)
        case cert
        when String then Cert.parse(cert)
        when Cert   then cert
        when OpenSSL::X509::Certificate
          new_cert = Cert.allocate
          new_cert.send(:initialize_copy,cert)
          new_cert
        else
          raise(ArgumentError,"value must be either a String or a OpenSSL::X509::Certificate object: #{cert.inspect}")
        end
      end
    end
  end
end
