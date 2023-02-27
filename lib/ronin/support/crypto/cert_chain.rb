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
require 'ronin/support/crypto/cert'

module Ronin
  module Support
    module Crypto
      #
      # Represents a X509 or TLS certificate chain.
      #
      # @api public
      #
      # @since 1.0.0
      #
      class CertChain

        include Enumerable

        # The certificates in the certificate chain.
        #
        # @return [Array<Cert>]
        attr_reader :certs

        #
        # The certificates in the certificate chain.
        #
        # @param [Array<Cert>] certs
        #   The certificates that make up the certificate chain.
        #
        def initialize(certs)
          @certs = certs
        end

        #
        # Parses a certificate chain.
        #
        # @param [String] string
        #   The string to parse.
        #
        # @return [CertChain]
        #   The parsed certificate chain.
        #
        def self.parse(string)
          cert_buffer = String.new
          certs       = []

          string.each_line do |line|
            cert_buffer << line

            if line.chomp == '-----END CERTIFICATE-----'
              certs << Cert.parse(cert_buffer)
              cert_buffer.clear
            end
          end

          return new(certs)
        end

        #
        # Alias for {parse}.
        #
        # @param [String] string
        #   The string to parse.
        #
        # @return [CertChain]
        #   The parsed certificate chain.
        #
        # @see parse
        #
        def self.load(string)
          parse(string)
        end

        #
        # Reads and parses the certificate chain from a file.
        #
        # @param [String] path
        #   The path to the file to parse.
        #
        # @return [CertChain]
        #   The parsed certificate chain.
        #
        def self.load_file(path)
          parse(File.read(path))
        end

        #
        # Enumerates over the certificates in the certificate chain.
        #
        # @yield [cert]
        #   If a block is given, it will be passed each certificate in the
        #   certificate chain.
        #
        # @yieldparam [Cert] cert
        #   A parsed certificate object in the certificate chain.
        #
        # @return [Enumerator]
        #   If no block is given an Enumerator object will be returned.
        #
        def each(&block)
          @certs.each(&block)
        end

        #
        # Accesses one or more certificates at the index or range/length.
        #
        # @param [Integer, Range<Integer,Integer>] index_or_range
        #   The index or range of indices.
        #
        # @param [Integer, nil] length
        #   Optional length.
        #
        # @return [Cert, Array<Cert>, nil]
        #   The certificate(s) at the index or range of indices.
        #
        def [](index_or_range,length=nil)
          @certs[index_or_range,*length]
        end

        #
        # The leaf certificate.
        #
        # @return [Cert]
        #   The last certificate in the certiificate chain.
        #
        def leaf
          @certs.first
        end

        #
        # The issuer certificate.
        #
        # @return [Cert]
        #   The second-to-last certificate in the certificate chain.
        #
        def issuer
          if @certs.length == 1
            @certs[0]
          else
            @certs[1]
          end
        end

        #
        # The intermediary certificates.
        #
        # @return [Array<Cert>]
        #   The certificates between the {#root} and {#leaf} certificates.
        #
        def intermediates
          @certs[1..-2]
        end

        #
        # The root certificate.
        #
        # @return [Cert]
        #   The first certificate in the certificate chain.
        #
        def root
          @certs.last
        end

        #
        # The number of certificates in the certificate chain.
        #
        # @return [Integer]
        #
        def length
          @certs.length
        end

        #
        # Converts the certificate chain to a PEM encoded certificate chain.
        #
        # @return [String]
        #
        def to_pem
          @certs.map(&:to_pem).join
        end

        alias to_s to_pem

      end
    end
  end
end
