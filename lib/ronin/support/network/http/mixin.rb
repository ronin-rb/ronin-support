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
          # @!macro connect_kwargs
          #   @param [Boolean, Hash{Symbol => Object}, nil] ssl
          #     Specifies whether to enable SSL and/or the SSL context
          #     configuration.
          #
          #   @param [Hash{Symbol => Object}] kwargs
          #     Additional keyword arguments.
          #
          #   @option kwargs [String, URI::HTTP, Addressable::URI, nil] :proxy
          #     The optional proxy to send requests through.
          #
          #   @option kwargs [Hash{Symbol,String => String,Array}, nil] :headers
          #     Additional headers to add to each request.
          #
          #   @option kwargs [String, :text, :xml, :html, :json, nil] :content_type
          #     The `Content-Type` header value for the request.
          #     If a Symbol is given it will be resolved to a common MIME type:
          #     * `:text` - `text/plain`
          #     * `:xml` - `text/xml`
          #     * `:html` - `text/html`
          #     * `:json` - `application/json`
          #
          #   @option kwargs [String, :text, :xml, :html, :json, nil] :accept
          #     The `Accept` header value for the request.
          #     If a Symbol is given it will be resolved to a common MIME type:
          #     * `:text` - `text/plain`
          #     * `:xml` - `text/xml`
          #     * `:html` - `text/html`
          #     * `:json` - `application/json`
          #
          #   @option kwargs [String, :random, :chrome, :chrome_linux, :chrome_macos, :chrome_windows, :chrome_iphone, :chrome_ipad, :chrome_android, :firefox, :firefox_linux, :firefox_macos, :firefox_windows, :firefox_iphone, :firefox_ipad, :firefox_android, :safari, :safari_macos, :safari_iphone, :safari_ipad, :edge, :linux, :macos, :windows, :iphone, :ipad, :android, nil] user_agent (HTTP.user_agent)
          #     The default `User-Agent` string to add to each request.
          #
          #   @option ssl [String, nil] :ca_bundle
          #     The path to the CA bundle directory or file.
          #
          #   @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #     The certificate to use for the SSL/TLS connection.
          #
          #   @option ssl [OpenSSL::X509::Store, nil] :cert_store
          #     The certificate store to use for the SSL/TLS connection.
          #
          #   @option ssl [Array<(name, version, bits, alg_bits)>, nil] :ciphers
          #     The accepted ciphers to use for the SSL/TLS connection.
          #
          #   @option ssl [Crypto::Cert, OpenSSL::X509::Certificate, nil] :extra_chain_cert
          #     The extra certificate to add to the SSL/TLS certificate chain.
          #
          #   @option ssl [Crypto::Key::RSA, Crypto::Key::DSA, OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] :key
          #     The RSA or DSA key to use for the SSL/TLS connection.
          #
          #   @option ssl [Integer, nil] :timeout
          #     The connection timeout limit.
          #
          #   @option ssl [1, 1.1, 1.2, Symbol, nil] :version
          #     The desired SSL/TLS version.
          #
          #   @option ssl [1, 1.1, 1.2, Symbol, nil] :min_version
          #     The minimum SSL/TLS version.
          #
          #   @option ssl [1, 1.1, 1.2, Symbol, nil] :max_version
          #     The maximum SSL/TLS version.
          #
          #   @option ssl [Proc, nil] :verify_callback
          #     The callback to use when verifying the server's certificate.
          #
          #   @option ssl [Integer, nil] :verify_depth
          #     The verification depth limit.
          #
          #   @option ssl [:none, :peer, :fail_if_no_peer_cert, true, false, Integer, nil] :verify
          #     The verification mode.
          #
          #   @option ssl [Boolean, nil] :verify_hostname
          #     Indicates whether to verify the server's hostname.
          #

          #
          # Creates a HTTP connection to the host nad port.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @!macro connect_kwargs
          #
          # @yield [http]
          #   If a block is given, it will be passed the newly created HTTP
          #   session object. Once the block returns, the HTTP session will be
          #   closed.
          #
          # @yieldparam [HTTP] http
          #   The HTTP session object.
          #
          # @return [HTTP, nil]
          #   The HTTP session object. If a block is given, then `nil` will be
          #   returned.
          #
          # @since 1.0.0
          #
          # @api public
          #
          def http_connect(host,port, ssl: nil, **kwargs,&block)
            Network::HTTP.connect(host,port, ssl: ssl, **kwargs,&block)
          end

          #
          # Creates a HTTP connection using the URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   The URI to connect to.
          #
          # @!macro connect_kwargs
          #
          # @yield [http]
          #   If a block is given, it will be passed the newly created HTTP
          #   session object. Once the block returns, the HTTP session will be
          #   closed.
          #
          # @yieldparam [HTTP] http
          #   The HTTP session object.
          #
          # @return [HTTP, nil]
          #   The HTTP session object. If a block is given, then `nil` will be
          #   returned.
          #
          # @since 1.0.0
          #
          # @api public
          #
          def http_connect_uri(url, ssl: nil, **kwargs,&block)
            Network::HTTP.connect_uri(url, ssl: ssl, **kwargs,&block)
          end

          #
          # @!macro request_kwargs
          #   @option kwargs [String, nil] :query
          #     The query-string to append to the request path.
          #
          #   @option kwargs [Hash, nil] :query_params
          #     The query-params to append to the request path.
          #
          #   @option kwargs [String, nil] :user
          #     The user to authenticate as.
          #
          #   @option kwargs [String, nil] :password
          #     The password to authenticate with.
          #
          #   @option kwargs [Hash{Symbol,String => String}, nil] :headers
          #     Additional HTTP headers to use for the request.
          #
          #   @option kwargs [String, Hash{String => String}, Cookie, nil] :cookie
          #     Additional `Cookie` header. If a `Hash` is given, it will be
          #     converted to a `String` using {Cookie}. If the cookie value is
          #     empty, the `Cookie` header will not be set.
          #
          #   @option kwargs [String, nil] :body
          #     The body of the request.
          #
          #   @option kwargs [Hash, String, nil] :form_data
          #     The form data that may be sent in the body of the request.
          #
          #   @option kwargs [#to_json, nil] :json
          #     The JSON data that will be sent in the body of the request.
          #     Will also default the `Content-Type` header to
          #     `application/json`, unless already set.
          #

          #
          # Performs and arbitrary HTTP request.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          def http_request(method,url, ssl: nil, **kwargs,&block)
            Network::HTTP.request(method,url, ssl: ssl, **kwargs,&block)
          end

          #
          # Sends an arbitrary HTTP request and returns the response status.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [Integer]
          #   The status code of the response.
          #
          # @see Network::HTTP.response_status
          #
          # @since 1.0.0
          #
          # @api public
          #
          def http_response_status(method=:head,url, ssl: nil, **kwargs)
            Network::HTTP.response_status(method,url, ssl: ssl, **kwargs)
          end

          #
          # Sends a HTTP request and determines if the response status was 200.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [Boolean]
          #   Indicates that the response status was 200.
          #
          # @see Network::HTTP.ok?
          #
          # @api public
          #
          def http_ok?(method=:head,url, ssl: nil, **kwargs)
            Network::HTTP.ok?(method,url, ssl: ssl, **kwargs)
          end

          #
          # Sends an arbitrary HTTP request and returns the response headers.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [Hash{String => String}]
          #   The response headers.
          #
          # @see Network::HTTP.response_headers
          #
          # @since 1.0.0
          #
          # @api public
          #
          def http_response_headers(method=:head,url, ssl: nil, **kwargs)
            Network::HTTP.response_headers(method,url, ssl: ssl, **kwargs)
          end

          #
          # Sends an HTTP request and returns the `Server` header.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro connect_kwargs
          # @!macro request_kwargs
          #
          # @return [String, nil]
          #   The `Server` header.
          #
          # @see Network::HTTP.server_header
          #
          # @since 1.0.0
          #
          # @api public
          #
          def http_server_header(url, ssl: nil, **kwargs)
            Network::HTTP.server_header(url, ssl: ssl, **kwargs)
          end

          #
          # Sends an HTTP request and returns the `X-Powered-By` header.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [String, nil]
          #   The `X-Powered-By` header.
          #
          # @see Network::HTTP.powered_by_header
          #
          # @since 1.0.0
          #
          # @api public
          #
          def http_powered_by_header(url, ssl: nil, **kwargs)
            Network::HTTP.powered_by_header(url, ssl: ssl, **kwargs)
          end

          #
          # Sends an arbitrary HTTP request and returns the response body.
          #
          # @param [Symbol, String] method
          #   The HTTP method to use for the request.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [String]
          #   The response body.
          #
          # @see Network::HTTP.response_body
          #
          # @since 1.0.0
          #
          # @api public
          #
          def http_response_body(method=:get,url, ssl: nil, **kwargs)
            Network::HTTP.response_body(method,url, ssl: ssl, **kwargs)
          end

          #
          # Performs a `COPY` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_copy(url, ssl: nil, **kwargs)
            Network::HTTP.copy(url, ssl: ssl, **kwargs)
          end

          #
          # Performs a `DELETE` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_delete(url, ssl: nil, **kwargs,&block)
            Network::HTTP.delete(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `GET` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_get(url, ssl: nil, **kwargs,&block)
            Network::HTTP.get(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `GET` request for the given URI and returns the response
          # headers.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [Hash{String => String}]
          #   The response headers.
          #
          # @see Network::HTTP.get_headers
          #
          # @since 0.2.0
          #
          # @api public
          #
          def http_get_headers(url, ssl: nil, **kwargs)
            Network::HTTP.get_headers(url, ssl: ssl, **kwargs)
          end

          #
          # Sends an HTTP request and returns the parsed `Set-Cookie`
          # header(s).
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [Array<SetCookie>, nil]
          #   The parsed `SetCookie` header(s).
          #
          # @see Network::HTTP.get_cookies
          #
          # @api public
          #
          def http_get_cookies(url, ssl: nil, **kwargs)
            Network::HTTP.get_cookies(url, ssl: ssl, **kwargs)
          end

          #
          # Sends an HTTP request and returns the parsed `Set-Cookie` header(s).
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [Array<SetCookie>, nil]
          #   The parsed `Cookie` header(s).
          #
          # @see Network::HTTP.post_cookies
          #
          # @api public
          #
          def http_post_cookies(url, ssl: nil, **kwargs)
            Network::HTTP.post_cookies(url, ssl: ssl, **kwargs)
          end

          #
          # Performs a `GET` request for the given URI and returns the response
          # body.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [String]
          #   The response body.
          #
          # @see Network::HTTP.get_body
          #
          # @api public
          #
          def http_get_body(url, ssl: nil, **kwargs)
            Network::HTTP.get_body(url, ssl: ssl, **kwargs)
          end

          #
          # Performs a `HEAD` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_head(url, ssl: nil, **kwargs,&block)
            Network::HTTP.head(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `LOCK` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_lock(url, ssl: nil, **kwargs,&block)
            Network::HTTP.lock(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `MKCOL` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_mkcol(url, ssl: nil, **kwargs,&block)
            Network::HTTP.mkcol(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `MOVE` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_move(url, ssl: nil, **kwargs,&block)
            Network::HTTP.move(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `OPTIONS` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_options(url, ssl: nil, **kwargs,&block)
            Network::HTTP.options(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `OPTIONS` HTTP request for the given URI and parses the
          # `Allow` response header.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @yield [response]
          #   If a block is given it will be passed the received HTTP response.
          #
          # @yieldparam [Net::HTTPRresponse] response
          #   The received HTTP response object.
          #
          # @return [Array<Symbol>]
          #   The allowed HTTP request methods for the given URL.
          #
          # @see Network::HTTP.allowed_methods
          #
          # @api public
          #
          def http_allowed_methods(url, ssl: nil, **kwargs,&block)
            Network::HTTP.allowed_methods(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `PATCH` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_patch(url, ssl: nil, **kwargs,&block)
            Network::HTTP.patch(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `POST` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_post(url, ssl: nil, **kwargs,&block)
            Network::HTTP.post(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `POST` request on the given URI and returns the response
          # headers.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [Hash{String => String}]
          #   The response headers.
          #
          # @see Network::HTTP.post_headers
          #
          # @since 0.2.0
          #
          # @api public
          #
          def http_post_headers(url, ssl: nil, **kwargs)
            Network::HTTP.post_headers(url, ssl: ssl, **kwargs)
          end

          #
          # Performs a `POST` request for the given URI and returns the
          # response body.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
          #
          # @return [String]
          #   The response body.
          #
          # @see Network::HTTP.post_body
          #
          # @api public
          #
          def http_post_body(url, ssl: nil, **kwargs)
            Network::HTTP.post_body(url, ssl: ssl, **kwargs)
          end

          #
          # Performs a `PROPFIND` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_propfind(url, ssl: nil, **kwargs,&block)
            Network::HTTP.propfind(url, ssl: ssl, **kwargs,&block)
          end

          alias http_prop_find http_propfind

          #
          # Performs a `PROPPATCH` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_proppatch(url, ssl: nil, **kwargs,&block)
            Network::HTTP.proppatch(url, ssl: ssl, **kwargs,&block)
          end

          alias http_prop_patch http_proppatch

          #
          # Performs a `PUT` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_put(url, ssl: nil, **kwargs,&block)
            Network::HTTP.put(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `TRACE` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          def http_trace(url, ssl: nil, **kwargs,&block)
            Network::HTTP.trace(url, ssl: ssl, **kwargs,&block)
          end

          #
          # Performs a `UNLOCK` request for the given URI.
          #
          # @param [URI::HTTP, Addressable::URI, String] url
          #   Optional URL to create the HTTP request for.
          #
          # @!macro request_kwargs
          # @!macro connect_kwargs
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
          # @api public
          #
          def http_unlock(url, ssl: nil, **kwargs,&block)
            Network::HTTP.unlock(url, ssl: ssl, **kwargs,&block)
          end
        end
      end
    end
  end
end
