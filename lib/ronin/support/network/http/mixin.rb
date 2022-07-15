#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
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

require 'ronin/support/network/http'

module Ronin
  module Support
    module Network
      class HTTP
        #
        # Provides helper methods for communicating with HTTP Servers.
        #
        module Mixin
          #
          # Creates a HTTP connection to the host nad port.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Boolean, Hash{Symbol => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {Network::HTTP.connect}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   The optional proxy to send requests through.
          #
          # @option kwargs [Hash{Symbol,String => String,Array}, nil] :headers
          #   Additional headers to add to each request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @since 1.0.0
          #
          def http_connect(host,port, ssl: nil, **kwargs,&block)
            Network::HTTP.connect(host,port, ssl: ssl, **kwargs,&block)
          end

          #
          # Creates a temporary HTTP session to the host and port.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {Network::HTTP.session}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   The optional proxy to send requests through.
          #
          # @option kwargs [Hash{Symbol,String => String,Array}, nil] :headers
          #   Additional headers to add to each request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbol => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          # @yield [http]
          #   If a block is given, it will be passed the newly created HTTP
          #   session object.
          #
          # @yieldparam [HTTP] http
          #   The newly created HTTP session.
          #
          # @return [nil]
          #
          # @see Network::HTTP.session
          #
          # @api public
          #
          def http_session(host,port, ssl: nil, **kwargs,&block)
            Network::HTTP.session(host,port, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs and arbitrary HTTP request.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional arguments for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @raise [ArgumentError]
          #   The `:method` option did not match a known `Net::HTTP` request
          #   class.
          #
          # @see Network::HTTP.request
          #
          # @api public
          #
          def http_request(method,uri, ssl: nil, **kwargs,&block)
            Network::HTTP.request(method,uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Sends an arbitrary HTTP request and returns the response status.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [Integer]
          #   The status code of the response.
          #
          # @see Network::HTTP.response_status
          #
          # @since 1.0.0
          #
          def http_response_status(method=:head,uri, ssl: nil, **kwargs)
            Network::HTTP.response_status(method,uri, ssl: ssl, **kwargs)
          end

          #
          # Sends a HTTP request and determines if the response status was 200.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [Boolean]
          #   Indicates that the response status was 200.
          #
          # @see Network::HTTP.ok?
          #
          def http_ok?(method=:head,uri, ssl: nil, **kwargs)
            Network::HTTP.ok?(method,uri, ssl: ssl, **kwargs)
          end

          #
          # Sends an arbitrary HTTP request and returns the response headers.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [Hash{String => String}]
          #   The response headers.
          #
          #
          # @see Network::HTTP.response_headers
          #
          def http_response_headers(method=:head,uri, ssl: nil, **kwargs)
            Network::HTTP.response_headers(method,uri, ssl: ssl, **kwargs)
          end

          #
          # Sends an HTTP request and returns the `Server` header.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [Symbol, String] :method
          #   The HTTP method to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [String, nil]
          #   The `Server` header.
          #
          # @see Network::HTTP.server_header
          #
          # @since 1.0.0
          #
          def http_server_header(uri, ssl: nil, **kwargs)
            Network::HTTP.server_header(uri, ssl: ssl, **kwargs)
          end

          #
          # Sends an HTTP request and returns the `X-Powered-By` header.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [Symbol, String] :method
          #   The HTTP method to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [String, nil]
          #   The `X-Powered-By` header.
          #
          #
          # @see Network::HTTP.powered_by_header
          #
          def http_powered_by_header(uri, ssl: nil, **kwargs)
            Network::HTTP.powered_by_header(uri, ssl: ssl, **kwargs)
          end

          #
          # Sends an arbitrary HTTP request and returns the response body.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [Symbol, String] :method
          #   The HTTP method to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [String]
          #   The response body.
          #
          # @see Network::HTTP.response_body
          #
          # @since 1.0.0
          #
          def http_response_body(method=:get,uri, ssl: nil, **kwargs)
            Network::HTTP.response_body(method,uri, ssl: ssl, **kwargs)
          end

          #
          # Performs a `COPY` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.copy
          #
          def http_copy(uri, ssl: nil, **kwargs)
            Network::HTTP.copy(uri, ssl: ssl, **kwargs)
          end

          #
          # Performs a `DELETE` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.delete
          #
          def http_delete(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.delete(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `GET` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.get
          #
          def http_get(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.get(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `GET` request for the given URI and returns the response
          # headers.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [Hash{String => String}]
          #   The response headers.
          #
          # @see Network::HTTP.get_headers
          #
          # @since 0.2.0
          #
          def http_get_headers(uri, ssl: nil, **kwargs)
            Network::HTTP.get_headers(uri, ssl: ssl, **kwargs)
          end

          #
          # Sends an HTTP request and returns the parsed `Set-Cookie`
          # header(s).
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [Array<SetCookie>, nil]
          #   The parsed `SetCookie` header(s).
          #
          # @see Network::HTTP.get_cookies
          #
          def http_get_cookies(uri, ssl: nil, **kwargs)
            Network::HTTP.get_cookies(uri, ssl: ssl, **kwargs)
          end

          #
          # Performs a `GET` request for the given URI and returns the response
          # body.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [String]
          #   The response body.
          #
          # @see Network::HTTP.get_body
          #
          def http_get_body(uri, ssl: nil, **kwargs)
            Network::HTTP.get_body(uri, ssl: ssl, **kwargs)
          end

          #
          # Performs a `HEAD` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.head
          #
          def http_head(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.head(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `LOCK` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.lock
          #
          def http_lock(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.lock(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `MKCOL` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.mkcol
          #
          def http_mkcol(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.mkcol(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `MOVE` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.move
          #
          def http_move(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.move(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `OPTIONS` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.options
          #
          def http_options(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.options(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `PATCH` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.patch
          #
          # @since 1.0.0
          #
          def http_patch(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.patch(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `POST` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.post
          #
          def http_post(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.post(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `POST` request on the given URI and returns the response
          # headers.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [Hash{String => String}]
          #   The response headers.
          #
          # @see Network::HTTP.post_headers
          #
          # @since 0.2.0
          #
          def http_post_headers(uri, ssl: nil, **kwargs)
            Network::HTTP.post_headers(uri, ssl: ssl, **kwargs)
          end

          #
          # Performs a `POST` request for the given URI and returns the response
          # body.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @return [String]
          #   The response body.
          #
          # @see Network::HTTP.post_body
          #
          def http_post_body(uri, ssl: nil, **kwargs)
            Network::HTTP.post_body(uri, ssl: ssl, **kwargs)
          end

          #
          # Performs a `PROPFIND` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.propfind
          #
          def http_propfind(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.propfind(uri, ssl: ssl, **kwargs,&block)
          end

          alias http_prop_find http_propfind

          #
          # Performs a `PROPPATCH` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.proppatch
          #
          def http_proppatch(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.proppatch(uri, ssl: ssl, **kwargs,&block)
          end

          alias http_prop_patch http_proppatch

          #
          # Performs a `PUT` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.put
          #
          # @since 0.4.0
          #
          def http_put(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.put(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `TRACE` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for {Network::HTTP.request}.
          #
          # @option kwargs [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.trace
          #
          # @api public
          #
          def http_trace(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.trace(uri, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `UNLOCK` request for the given URI.
          #
          # @param [URI::HTTP, String] uri
          #   Optional URL to create the HTTP request for.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Aditional keyword arguments and headers for
          #   {Network::HTTP.request}.
          #
          # @option [String, URI::HTTP, nil] :proxy
          #   Optional proxy to use for the request.
          #
          # @option kwargs [String, nil] :query
          #   The query-string to append to the request path.
          #
          # @option kwargs [Hash, nil] :query_params
          #   The query-params to append to the request path.
          #
          # @option kwargs [String, nil] :body
          #   The body of the request.
          #
          # @option kwargs [Hash, String, nil] :form_data
          #   The form data that may be sent in the body of the request.
          #
          # @option kwargs [String, nil] :user
          #   The user to authenticate as.
          #
          # @option kwargs [String, nil] :password
          #   The password to authenticate with.
          #
          # @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #   Additional HTTP headers to use for the request.
          #
          # @option kwargs [String, nil] :user_agent (HTTP.user_agent)
          #   The default `User-Agent` string to add to each request.
          #
          # @param [Boolean, Hash{Symbo => Object}, nil] ssl
          #   Specifies whether to enable SSL and/or the SSL context
          #   configuration.
          #
          # @option ssl [String, nil] :ca_bundle
          #   The path to the CA bundle directory or file.
          #
          # @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The certificate to use for the SSL/TLS connection.
          #
          # @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #   The certificate store to use for the SSL/TLS connection.
          #
          # @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #   The accepted ciphers to use for the SSL/TLS connection.
          #
          # @option ssl [Crypto::Cert,
          #         OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #   The extra certificate to add to the SSL/TLS certificate chain.
          #
          # @option ssl [Crypto::Key::RSA, Crypto::Key::DSA,
          #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #   The RSA or DSA key to use for the SSL/TLS connection.
          #
          # @option ssl [Integer, nil] :timeout
          #   The connection timeout limit.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #   The desired SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #   The minimum SSL/TLS version.
          #
          # @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #   The maximum SSL/TLS version.
          #
          # @option ssl [Proc, nil] :verify_callback
          #   The callback to use when verifying the server's certificate.
          #
          # @option ssl [Integer, nil] :verify_depth
          #   The verification depth limit.
          #
          # @option ssl [:none, :peer, :fail_if_no_peer_cert,
          #         true, false, Integer, nil] :verify
          #   The verification mode.
          #
          # @option ssl [Boolean, nil] :verify_hostname
          #   Indicates whether to verify the server's hostname.
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Net::HTTPResponse]
          #   The new HTTP Request object.
          #
          # @see Network::HTTP.unlock
          #
          def http_unlock(uri, ssl: nil, **kwargs,&block)
            Network::HTTP.unlock(uri, ssl: ssl, **kwargs,&block)
          end
        end
      end
    end
  end
end
