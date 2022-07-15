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

require 'ronin/support/network/http/request'
require 'ronin/support/network/http/set_cookie'
require 'ronin/support/network/http/core_ext'
require 'ronin/support/network/ssl'

require 'net/https'
require 'uri'
require 'uri/query_params'

module Ronin
  module Support
    module Network
      #
      # Provides helper methods for communicating with HTTP Servers.
      #
      # @api public
      #
      class HTTP

        #
        # The Ronin HTTP proxy to use.
        #
        # @return [URI::HTTP, nil]
        #   The Ronin HTTP proxy.
        #
        # @note
        #   If the `RONIN_HTTP_PROXY` environment variable is specified, it
        #   will be used as the default value.
        #   If the `HTTP_PROXY` environment variable is specified, it will
        #   be used as the default value.
        #
        # @api public
        #
        def self.proxy
          @proxy ||= if ENV['RONIN_HTTP_PROXY']
                       URI.parse(ENV['RONIN_HTTP_PROXY'])
                     elsif ENV['HTTP_PROXY']
                       URI.parse(ENV['HTTP_PROXY'])
                     end
        end

        #
        # Sets the Ronin HTTP proxy to use.
        #
        # @param [URI::HTTP, String, nil] new_proxy
        #   The new proxy information to use.
        #
        # @return [URI::HTTP, nil]
        #   The new proxy.
        #
        # @raise [ArgumentError]
        #   The given proxy information was not a `URI::HTTP`, `String`, or
        #   `nil`.
        #
        # @api public
        #
        def self.proxy=(new_proxy)
          @proxy = case new_proxy
                   when URI::HTTP then new_proxy
                   when String    then URI.parse(new_proxy)
                   when nil       then nil
                   else
                     raise(ArgumentError,"proxy must be either a URI::HTTP, String, or nil")
                   end
        end

        # Built-in `User-Agent` strings for impersonating various browsers.
        USER_AGENTS = {
          chrome_linux: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36',
          chrome_macos: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36',
          chrome_windows: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36',
          chrome_iphone: 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/102.0.5005.87 Mobile/15E148 Safari/604.1',
          chrome_ipad: 'Mozilla/5.0 (iPad; CPU OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/102.0.5005.87 Mobile/15E148 Safari/604.1',
          chrome_android: 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.99 Mobile Safari/537.36',

          firefox_linux: 'Mozilla/5.0 (Linux x86_64; rv:101.0) Gecko/20100101 Firefox/101.0',
          firefox_macos: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 12.4; rv:101.0) Gecko/20100101 Firefox/101.0',
          firefox_windows: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
          firefox_iphone: 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/101.0 Mobile/15E148 Safari/605.1.15',
          firefox_ipad: 'Mozilla/5.0 (iPad; CPU OS 12_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/101.0 Mobile/15E148 Safari/605.1.15',

          firefox_android: 'Mozilla/5.0 (Android 12; Mobile; rv:68.0) Gecko/68.0 Firefox/101.0',

          safari_macos: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15',
          safari_iphone: 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1',
          safari_ipad: 'Mozilla/5.0 (iPad; CPU OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1',

          edge: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36 Edg/102.0.1245.33'
        }

        #
        # The default Ronin HTTP `User-Agent` string.
        #
        # @return [String, nil]
        #   The default Ronin HTTP User-Agent.
        #
        # @api public
        #
        def self.user_agent
          @user_agent
        end

        #
        # Sets the default Ronin HTTP `User-Agent` string.
        #
        # @param [String, Symbol, nil] new_user_agent
        #   The new `User-Agent` string to use.
        #   If a Symbol is given, it will be looked up in {USER_AGENTS}.
        #   If `:random` is given, a random value from {USER_AGENTS} will be
        #   selected.
        #   If `nil` is given, then the `User-Agent` header will be deleted.
        #
        # @return [String, nil]
        #   The new `User-Agent` string.
        #
        # @api public
        #
        def self.user_agent=(new_user_agent)
          @user_agent = case new_user_agent
                        when :random
                          USER_AGENTS.values.sample
                        when Symbol
                          USER_AGENTS.fetch(new_user_agent) do
                            raise(ArgumentError,"unknown user agent alias: #{new_user_agent.inspect}")
                          end
                        else
                          new_user_agent
                        end
        end

        # The proxy to send requests through.
        #
        # @return [URI::HTTP, nil]
        attr_reader :proxy

        # The host to connect to.
        #
        # @return [String]
        attr_reader :host

        # The port to connect to.
        #
        # @return [Integer]
        attr_reader :port

        # Additional headers to add to every request.
        #
        # @return [Hash{String => String,Array}]
        attr_reader :headers

        #
        # Initializes an HTTP connection.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Integer] port
        #   The port to connect tto.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   The optional proxy to send requests through.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
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
        #
        # @since 1.0.0
        #
        def initialize(host,port, proxy:      nil,
                                  ssl:        port == 443,
                                  # header options
                                  headers:    {},
                                  user_agent: self.class.user_agent)
          @host  = host.to_s
          @port  = port.to_i

          @headers        = headers
          self.user_agent = user_agent if user_agent

          if proxy
            @proxy = URI(proxy)
            @http  = Net::HTTP.new(
              @host, @port,
              @proxy.host, @proxy.port, @proxy.user, @proxy.password
            )
          else
            @http = Net::HTTP.new(@host,@port)
          end

          case ssl
          when true then initialize_ssl()
          when Hash then initialize_ssl(**ssl)
          end

          yield self if block_given?
        end

        private

        #
        # Configures an SSL/TLS connection for HTTPS.
        #
        # @param [String, nil] ca_bundle
        #   The path to the CA bundle directory or file.
        #
        # @param [Crypto::Cert, OpenSSL::X509::Certificate, nil] cert
        #   The certificate to use for the SSL/TLS connection.
        #
        # @param [OpenSSL::X509::Store, nil] cert_store
        #   The certificate store to use for the SSL/TLS connection.
        #
        # @param [Array<(name, version, bits, alg_bits)>, nil] ciphers
        #   The accepted ciphers to use for the SSL/TLS connection.
        #
        # @param [Crypto::Cert,
        #         OpenSSL::X509::Certificate, nil] extra_chain_cert
        #   The extra certificate to add to the SSL/TLS certificate chain.
        #
        # @param [Crypto::Key::RSA, Crypto::Key::DSA,
        #         OpenSSL::PKey::RSA, OpenSSL::PKey::DSA, nil] key
        #   The RSA or DSA key to use for the SSL/TLS connection.
        #
        # @param [Integer, nil] timeout
        #   The connection timeout limit.
        #
        # @param [1, 1.1, 1.2, Symbol, nil] version
        #   The desired SSL/TLS version.
        #
        # @param [1, 1.1, 1.2, Symbol, nil] min_version
        #   The minimum SSL/TLS version.
        #
        # @param [1, 1.1, 1.2, Symbol, nil] max_version
        #   The maximum SSL/TLS version.
        #
        # @param [Proc, nil] verify_callback
        #   The callback to use when verifying the server's certificate.
        #
        # @param [Integer, nil] verify_depth
        #   The verification depth limit.
        #
        # @param [:none, :peer, :fail_if_no_peer_cert,
        #         true, false, Integer, nil] verify
        #   The verification mode.
        #
        # @param [Boolean, nil] verify_hostname
        #   Indicates whether to verify the server's hostname.
        #
        # @api private
        #
        def initialize_ssl(ca_bundle:        nil,
                           cert:             nil,
                           cert_store:       nil,
                           ciphers:          nil,
                           extra_chain_cert: nil,
                           key:              nil,
                           timeout:          nil,
                           version:          nil,
                           min_version:      nil,
                           max_version:      nil,
                           verify_callback:  nil,
                           verify_depth:     nil,
                           verify:           :none,
                           verify_hostname:  nil)
          @http.use_ssl = true

          if ca_bundle
            if File.directory?(ca_bundle)
              @http.ca_path = ca_bundle
            else
              @http.ca_file = ca_file
            end
          end

          @http.cert             = cert             if cert
          @http.ciphers          = ciphers          if ciphers
          @http.extra_chain_cert = extra_chain_cert if extra_chain_cert
          @http.key              = key              if key

          @http.ssl_timeout = timeout     if timeout
          @http.ssl_version = SSL::VERSIONS.fetch(version,version) if version
          @http.min_version = min_version if min_version
          @http.max_version = max_version if max_version

          @http.verify_callback = verify_callback if verify_callback
          @http.verify_depth    = verify_depth    if verify_depth
          @http.verify_mode     = SSL::VERIFY.fetch(verify,verify)
          @http.verify_hostname = verify_hostname if verify_hostname
        end

        public

        #
        # Creates a HTTP connection to the host nad port.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Integer] port
        #   The port to connect to.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#initialize}.
        #
        # @option kwargs [String, URI::HTTP, nil] :proxy
        #   The optional proxy to send requests through.
        #
        # @option kwargs [Hash{Symbol,String => String,Array}, nil] :headers
        #   Additional headers to add to each request.
        #
        # @option kwargs [String, Symbol, :random, nil] :user_agent (HTTP.user_agent)
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
        #
        # @since 1.0.0
        #
        def self.connect(host,port, ssl: nil, **kwargs,&block)
          new(host,port, ssl: ssl, **kwargs,&block)
        end

        #
        # Creates a HTTP connection using the URI.
        #
        # @param [URI::HTTP, String] uri
        #   The URI to connect to.
        #
        # @param [Boolean, Hash{Symbol => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @since 1.0.0
        #
        def self.connect_uri(uri, ssl: nil, **kwargs,&block)
          uri  = URI(uri)
          host = uri.host
          port = uri.port
          path = uri.request_uri

          ssl ||= uri.scheme == 'https'

          return new(host,port, ssl: ssl, **kwargs,&block)
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
        #   Additional keyword arguments for {#initialize}.
        #
        # @option kwargs [String, URI::HTTP, nil] :proxy
        #   The optional proxy to send requests through.
        #
        # @option kwargs [Hash{Symbol,String => String,Array}, nil] :headers
        #   Additional headers to add to each request.
        #
        # @option kwargs [String, Symbol, :random, nil] user_agent (HTTP.user_agent)
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
        # @see #initialize
        #
        # @api public
        #
        # @since 1.0.0
        #
        def self.session(host,port, ssl: nil, **kwargs)
          http = connect(host,port, ssl: ssl, **kwargs)
          yield http
          http.close
        end

        #
        # Creates a temporary HTTP session using the URI.
        #
        # @since 1.0.0
        #
        def self.session_uri(uri,**kwargs)
          http = connect_uri(host,port,**kwargs)
          yield http
          http.close
        end

        #
        # Determines if the HTTP connect is using SSL/TLS.
        #
        # @return [Boolean]
        #
        # @since 1.0.0
        #
        def ssl?
          @http.use_ssl?
        end

        #
        # The `User-Agent` header value.
        #
        # @return [String]
        #
        # @since 1.0.0
        #
        def user_agent
          @headers['User-Agent']
        end

        #
        # Sets the `User-Agent` header value.
        #
        # @param [String, Symbol, :random, nil] new_user_agent
        #   The `User-Agent` new value.
        #   If a Symbol is given, it will be looked up in {USER_AGENTS}.
        #   If `:random` is given, a random value from {USER_AGENTS} will be
        #   selected.
        #   If `nil` is given, then the `User-Agent` header will be deleted.
        #
        # @return [String, nil]
        #   The new `User-Agent` string.
        #
        # @since 1.0.0
        #
        def user_agent=(new_user_agent)
          if new_user_agent
            @headers['User-Agent'] = case new_user_agent
                                     when :random
                                       USER_AGENTS.values.sample
                                     when Symbol
                                       USER_AGENTS.fetch(new_user_agent) do
                                         raise(ArgumentError,"unknown user agent alias: #{new_user_agent.inspect}")
                                       end
                                     else
                                       new_user_agent
                                     end
          else
            @headers.delete('User-Agent')
            return nil
          end
        end

        #
        # Sends an arbitrary HTTP request.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [String, nil] user
        #   The user to authenticate as.
        #
        # @param [String, nil] password
        #   The password to authenticate with.
        #
        # @param [String, nil] query
        #   The query-string to append to the request path.
        #
        # @param [Hash, nil] query_params
        #   The query-params to append to the request path.
        #
        # @param [String, nil] body
        #   The body of the request.
        #
        # @param [Hash, String, nil] form_data
        #   The form data that may be sent in the body of the request.
        #
        # @param [Hash{Symbol,String => String}, nil] headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @param [Hash{Symbol => String}] additional_headers
        #   Additional headers to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @raise [ArgumentError]
        #   The `:method` option did not match a known `Net::HTTP` request
        #   class.
        #
        # @example
        #   http.request(:get, '/')
        #
        # @example Streaming response body:
        #   http.request(:get, '/big_file.txt') do |response|
        #     respnse.read_body do |chunk|
        #       # ...
        #     end
        #   end
        #
        # @example Basic-Auth
        #   http.request(:get, '/', user: 'admin', password: 'secret')
        #
        # @example Query string:
        #   http.request(:get, '/search', query: 'foo%20bar')
        #
        # @example Query params:
        #   http.request(:get, '/search', query_params: {q: 'foo bar'})
        #
        # @example Request body:
        #   http.request(:post, '/form', body: 'foo=1&bar=2')
        #
        # @example Form data:
        #   http.request(:post, '/form', form_data: {'foo' => 1, 'bar' => 2})
        #
        # @example Streaming request body:
        #   http.request(:put, '/file', body: File.new('/path/to/file'))
        #
        # @since 1.0.0
        #
        def request(method,path, # Basic-Auth keyword arguments
                                 user:     nil,
                                 password: nil,
                                 # query string keyword arguments
                                 query:        nil,
                                 query_params: nil,
                                 # request body keyword arguments
                                 body:      nil,
                                 form_data: nil,
                                 # header keyword arguments
                                 headers:    nil,
                                 **additional_headers,
                                 &block)
          request = Request.build(method,path, headers:      @headers,
                                               user:         user,
                                               password:     password,
                                               query:        query,
                                               query_params: query_params,
                                               body:         body,
                                               form_data:    form_data)

          if headers
            # populate any arbitrary headers
            headers.each do |name,value|
              request[name] = value
            end
          end

          unless additional_headers.empty?
            # set additional keyword argument headers (ex: `referer: '...'`
            additional_headers.each do |name,value|
              request[name] = value
            end
          end

          return @http.request(request,&block)
        end

        #
        # Sends an arbitrary HTTP request and returns the response status.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => String}] kwargs
        #   Additional keyword arguments for {#request}.
        #
        # @return [Integer]
        #   The response status code.
        #
        # @since 1.0.0
        #
        def response_status(method=:head,path,**kwargs)
          response = request(method,path,**kwargs)
          response.code.to_i
        end

        #
        # Sends a HTTP request and determines if the response status was 200.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => String}] kwargs
        #   Additional keyword arguments for {#request}.
        #
        # @return [Boolean]
        #   Indicates that the response status was 200.
        #
        # @since 1.0.0
        #
        def ok?(method=:head,path,**kwargs)
          response_status(method,path,**kwargs) == 200
        end

        #
        # Sends an arbitrary HTTP request and returns the response headers.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => String}] kwargs
        #   Additional keyword arguments for {#request}.
        #
        # @return [Hash{String => String}]
        #   The response headers.
        #
        # @since 1.0.0
        #
        def response_headers(method=:head,path,**kwargs)
          headers = {}

          request(method,path,**kwargs).each_capitalized do |name,value|
            headers[name] = value
          end

          return headers
        end

        #
        # Sends an HTTP request and returns the `Server` header.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => String}] kwargs
        #   Additional keyword arguments for {#request}.
        #
        # @return [String, nil]
        #   The `Server` header.
        #
        # @since 1.0.0
        #
        def server_header(method: :head, path: '/',**kwargs)
          response = request(method,path,**kwargs)
          response['Server']
        end

        #
        # Sends an HTTP request and returns the `X-Powered-By` header.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => String}] kwargs
        #   Additional keyword arguments for {#request}.
        #
        # @return [String, nil]
        #   The `X-Powered-By` header.
        #
        # @since 1.0.0
        #
        def powered_by_header(method: :head, path: '/',**kwargs)
          response = request(method,path,**kwargs)
          response['X-Powered-By']
        end

        #
        # Sends an arbitrary HTTP request and returns the response body.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => String}] kwargs
        #   Additional keyword arguments for {#request}.
        #
        # @return [String]
        #   The response body.
        #
        # @since 1.0.0
        #
        def response_body(method=:get,path,**kwargs)
          request(method,path,**kwargs).body
        end

        #
        # Sends a `COPY` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def copy(path,**kwargs,&block)
          request(:copy,path,**kwargs,&block)
        end

        #
        # Sends a `DELETE` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def delete(path,**kwargs,&block)
          request(:delete,path,**kwargs,&block)
        end

        #
        # Sends a `GET` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def get(path,**kwargs,&block)
          request(:get,path,**kwargs,&block)
        end

        #
        # Sends a `GET` HTTP request and returns the response headers.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @return [Hash{String => String}]
        #   The response headers.
        #
        # @since 1.0.0
        #
        def get_headers(path,**kwargs)
          response_headers(:get,path,**kwargs)
        end

        #
        # Sends an HTTP request and returns the parsed `Set-Cookie` header(s).
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => String}] kwargs
        #   Additional keyword arguments for {#request}.
        #
        # @return [Array<SetCookie>]
        #   The parsed `Set-Cookie` headers.
        #
        # @since 1.0.0
        #
        def get_cookies(path, **kwargs)
          response = request(:get,path,**kwargs)

          if (set_cookies = response.get_fields('Set-Cookie'))
            set_cookies.map do |cookie|
              SetCookie.parse(cookie)
            end
          else
            []
          end
        end

        #
        # Sends a `GET` HTTP request and returns the response body.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @return [String]
        #   The response body.
        #
        # @since 1.0.0
        #
        def get_body(path,**kwargs)
          response_body(:get,path,**kwargs)
        end

        #
        # Sends a `HEAD` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def head(path,**kwargs,&block)
          request(:head,path,**kwargs,&block)
        end

        #
        # Sends a `LOCK` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def lock(path,**kwargs,&block)
          request(:lock,path,**kwargs,&block)
        end

        #
        # Sends a `MKCOL` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def mkcol(path,**kwargs,&block)
          request(:mkcol,path,**kwargs,&block)
        end

        #
        # Sends a `MOVE` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def move(path,**kwargs,&block)
          request(:move,path,**kwargs,&block)
        end

        #
        # Sends a `OPTIONS` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def options(path,**kwargs,&block)
          request(:options,path,**kwargs,&block)
        end

        #
        # Sends a `PATH` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def patch(path,**kwargs,&block)
          request(:patch,path,**kwargs,&block)
        end

        #
        # Sends a `POST` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def post(path,**kwargs,&block)
          request(:post,path,**kwargs,&block)
        end

        #
        # Sends a `POST` HTTP request and returns the response headers.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @return [Hash{String => String}]
        #   The response headers.
        #
        # @since 1.0.0
        #
        def post_headers(path,**kwargs)
          response_headers(:post,path,**kwargs)
        end

        #
        # Sends a `POST` HTTP request and returns the response body.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @return [String]
        #   The response body.
        #
        # @since 1.0.0
        #
        def post_body(path,**kwargs)
          response_body(:post,path,**kwargs)
        end

        #
        # Sends a `PROPFIND` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def propfind(path,**kwargs,&block)
          request(:propfind,path,**kwargs,&block)
        end

        alias prop_find propfind

        #
        # Sends a `PROPPATCH` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def proppatch(path,**kwargs,&block)
          request(:proppatch,path,**kwargs,&block)
        end

        alias prop_patch proppatch

        #
        # Sends a `PUT` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def put(path,**kwargs,&block)
          request(:put,path,**kwargs,&block)
        end

        #
        # Sends a `TRACE` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def trace(path,**kwargs,&block)
          request(:trace,path,**kwargs,&block)
        end

        #
        # Sends a `UNLOCK` HTTP request.
        #
        # @param [String] path
        #   The path to to make the request for.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [String, nil] :user
        #   The user to authenticate as.
        #
        # @option kwargs [String, nil] :password
        #   The password to authenticate with.
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
        # @option kwargs [Hash{Symbol,String => String}, nil] :headers
        #   Additional HTTP header names and values to add to the request.
        #
        # @yield [response]
        #   If a block is given it will be passed the received HTTP response.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The received HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The new HTTP Request object.
        #
        # @since 1.0.0
        #
        def unlock(path,**kwargs,&block)
          request(:unlock,path,**kwargs,&block)
        end

        #
        # Closes the HTTP connection.
        #
        # @since 1.0.0
        #
        def close
          @http.finish if @http.started?
        end

        #
        # Performs and arbitrary HTTP request.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional arguments for {#request}.
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
        # @see .connect_uri
        # @see #request
        #
        def self.request(method,uri, proxy:      self.proxy,
                                     ssl:        nil,
                                     headers:    {},
                                     user_agent: nil,
                                     **kwargs,
                                     &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.request(method,path,**kwargs,&block)
        end

        #
        # Sends an arbitrary HTTP request and returns the response status.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
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
        # @see connect_uri
        # @see #response_status
        #
        # @since 1.0.0
        #
        def self.response_status(method=:head,uri, proxy:      self.proxy,
                                                   ssl:        nil,
                                                   headers:    {},
                                                   user_agent: nil,
                                                   **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.response_status(method,path,**kwargs)
        end

        #
        # Sends a HTTP request and determines if the response status was 200.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
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
        # @see connect_uri
        # @see #ok?
        #
        # @since 1.0.0
        #
        def self.ok?(method=:head,uri, proxy:      self.proxy,
                                       ssl:        nil,
                                       headers:    {},
                                       user_agent: nil,
                                       **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.ok?(method,path,**kwargs)
        end

        #
        # Sends an arbitrary HTTP request and returns the response headers.
        #
        # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #         :options, :patch, :post, :propfind, :proppatch, :put,
        #         :trace, :unlock] method
        #   The HTTP method to use for the request.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #response_headers
        #
        # @since 1.0.0
        #
        def self.response_headers(method=:head,uri, proxy:      self.proxy,
                                                    ssl:        nil,
                                                    headers:    {},
                                                    user_agent: nil,
                                                    **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.response_headers(method,path,**kwargs)
        end

        #
        # Sends an HTTP request and returns the `Server` header.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #                 :options, :patch, :post, :propfind, :proppatch, :put,
        #                 :trace, :unlock] :method
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
        # @see connect_uri
        # @see #server_header
        #
        # @since 1.0.0
        #
        def self.server_header(uri, proxy:      self.proxy,
                                    ssl:        nil,
                                    headers:    {},
                                    user_agent: nil,
                                    **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.server_header(path: path, **kwargs)
        end

        #
        # Sends an HTTP request and returns the `X-Powered-By` header.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #                 :options, :patch, :post, :propfind, :proppatch, :put,
        #                 :trace, :unlock] :method
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
        # @see connect_uri
        # @see #powered_by_header
        #
        # @since 1.0.0
        #
        def self.powered_by_header(uri, proxy:      self.proxy,
                                        ssl:        nil,
                                        headers:    {},
                                        user_agent: nil,
                                        **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.powered_by_header(path: path, **kwargs)
        end

        #
        # Sends an arbitrary HTTP request and returns the response body.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #                 :options, :patch, :post, :propfind, :proppatch, :put,
        #                 :trace, :unlock] :method
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
        # @see connect_uri
        # @see #response_body
        #
        # @since 1.0.0
        #
        def self.response_body(method=:get,uri, proxy:      self.proxy,
                                                ssl:        nil,
                                                headers:    {},
                                                user_agent: nil,
                                                **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.response_body(method,path,**kwargs)
        end

        #
        # Performs a `COPY` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #copy
        #
        # @since 1.0.0
        #
        def self.copy(uri, proxy:      self.proxy,
                           ssl:        nil,
                           headers:    {},
                           user_agent: nil,
                           **kwargs,
                           &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.copy(path,**kwargs,&block)
        end

        #
        # Performs a `DELETE` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #delete
        #
        # @since 1.0.0
        #
        def self.delete(uri, proxy:      self.proxy,
                             ssl:        nil,
                             headers:    {},
                             user_agent: nil,
                             **kwargs,
                             &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.delete(path,**kwargs,&block)
        end

        #
        # Performs a `GET` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #get
        #
        # @since 1.0.0
        #
        def self.get(uri, proxy:      self.proxy,
                          ssl:        nil,
                          headers:    {},
                          user_agent: nil,
                          **kwargs,
                          &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.get(path,**kwargs,&block)
        end

        #
        # Performs a `GET` request for the given URI and returns the response
        # headers.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #get_headers
        #
        # @since 1.0.0
        #
        def self.get_headers(uri, proxy:      self.proxy,
                                  ssl:        nil,
                                  headers:    {},
                                  user_agent: nil,
                                  **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.get_headers(path,**kwargs)
        end

        #
        # Sends an HTTP request and returns the parsed `Set-Cookie` header(s).
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
        #
        # @option kwargs [:copy, :delete, :get, :head, :lock, :mkcol, :move,
        #                 :options, :patch, :post, :propfind, :proppatch, :put,
        #                 :trace, :unlock] :method
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
        # @see connect_uri
        # @see #get_cookies
        #
        # @since 1.0.0
        #
        def self.get_cookies(uri, proxy:      self.proxy,
                                  ssl:        nil,
                                  headers:    {},
                                  user_agent: nil,
                                  **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.get_cookies(path, **kwargs)
        end

        #
        # Performs a `GET` request for the given URI and returns the response
        # body.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #get_body
        #
        # @since 1.0.0
        #
        def self.get_body(uri, proxy:      self.proxy,
                               ssl:        nil,
                               headers:    {},
                               user_agent: nil,
                               **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.get_body(path,**kwargs)
        end

        #
        # Performs a `HEAD` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #head
        #
        # @since 1.0.0
        #
        def self.head(uri, proxy:      self.proxy,
                           ssl:        nil,
                           headers:    {},
                           user_agent: nil,
                           **kwargs,
                           &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.head(path,**kwargs,&block)
        end

        #
        # Performs a `LOCK` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #lock
        #
        # @since 1.0.0
        #
        def self.lock(uri, proxy:      self.proxy,
                           ssl:        nil,
                           headers:    {},
                           user_agent: nil,
                           **kwargs,
                           &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.lock(path,**kwargs,&block)
        end

        #
        # Performs a `MKCOL` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #mkcol
        #
        # @since 1.0.0
        #
        def self.mkcol(uri, proxy:      self.proxy,
                            ssl:        nil,
                            headers:    {},
                            user_agent: nil,
                            **kwargs,
                            &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.mkcol(path,**kwargs,&block)
        end

        #
        # Performs a `MOVE` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #move
        #
        # @since 1.0.0
        #
        def self.move(uri, proxy:      self.proxy,
                           ssl:        nil,
                           headers:    {},
                           user_agent: nil,
                           **kwargs,
                           &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.move(path,**kwargs,&block)
        end

        #
        # Performs a `OPTIONS` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #options
        #
        # @since 1.0.0
        #
        def self.options(uri, proxy:      self.proxy,
                              ssl:        nil,
                              headers:    {},
                              user_agent: nil,
                              **kwargs,
                              &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.options(path,**kwargs,&block)
        end

        #
        # Performs a `PATCH` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #patch
        #
        # @since 1.0.0
        #
        def self.patch(uri, proxy:      self.proxy,
                            ssl:        nil,
                            headers:    {},
                            user_agent: nil,
                            **kwargs,
                            &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.patch(path,**kwargs,&block)
        end

        #
        # Performs a `POST` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #post
        #
        # @since 1.0.0
        #
        def self.post(uri, proxy:      self.proxy,
                           ssl:        nil,
                           headers:    {},
                           user_agent: nil,
                           **kwargs,
                           &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.post(path,**kwargs,&block)
        end

        #
        # Performs a `POST` request on the given URI and returns the response
        # headers.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #post_headers
        #
        # @since 1.0.0
        #
        def self.post_headers(uri, proxy:      self.proxy,
                                   ssl:        nil,
                                   headers:    {},
                                   user_agent: nil,
                                   **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.post_headers(path,**kwargs)
        end

        #
        # Performs a `POST` request for the given URI and returns the response
        # body.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #post_body
        #
        # @since 1.0.0
        #
        def self.post_body(uri, proxy:      self.proxy,
                                ssl:        nil,
                                headers:    {},
                                user_agent: nil,
                                **kwargs)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.post_body(path,**kwargs)
        end

        #
        # Performs a `PROPFIND` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #propfind
        #
        # @since 1.0.0
        #
        def self.propfind(uri, proxy:      self.proxy,
                               ssl:        nil,
                               headers:    {},
                               user_agent: nil,
                               **kwargs,
                               &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.propfind(path,**kwargs,&block)
        end

        alias prop_find propfind

        #
        # Performs a `PROPPATCH` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #proppatch
        #
        # @since 1.0.0
        #
        def self.proppatch(uri, proxy:      self.proxy,
                                ssl:        nil,
                                headers:    {},
                                user_agent: nil,
                                **kwargs,
                                &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.proppatch(path,**kwargs,&block)
        end

        alias prop_patch proppatch

        #
        # Performs a `PUT` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #put
        #
        # @since 1.0.0
        #
        def self.put(uri, proxy:      self.proxy,
                          ssl:        nil,
                          headers:    {},
                          user_agent: nil,
                          **kwargs,
                          &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.put(path,**kwargs,&block)
        end

        #
        # Performs a `TRACE` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #trace
        #
        # @since 1.0.0
        #
        def self.trace(uri, proxy:      self.proxy,
                            ssl:        nil,
                            headers:    {},
                            user_agent: nil,
                            **kwargs,
                            &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.trace(path,**kwargs,&block)
        end

        #
        # Performs a `UNLOCK` request for the given URI.
        #
        # @param [URI::HTTP, String] uri
        #   Optional URL to create the HTTP request for.
        #
        # @param [String, URI::HTTP, nil] proxy
        #   Optional proxy to use for the request.
        #
        # @param [Boolean, Hash{Symbo => Object}, nil] ssl
        #   Specifies whether to enable SSL and/or the SSL context
        #   configuration.
        #
        # @param [Hash{Symbol,String => String,Array}, nil] headers
        #   Additional headers to add to each request.
        #
        # @param [String, Symbol, :random, nil] user_agent
        #   The default `User-Agent` string to add to each request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Aditional keyword arguments and headers for {#request}.
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
        # @see connect_uri
        # @see #unlock
        #
        # @since 1.0.0
        #
        def self.unlock(uri, proxy:      self.proxy,
                             ssl:        nil,
                             headers:    {},
                             user_agent: nil,
                             **kwargs,
                             &block)
          uri  = URI(uri)
          path = uri.request_uri
          http = connect_uri(uri, proxy:      proxy,
                                  ssl:        ssl,
                                  headers:    headers,
                                  user_agent: user_agent)

          http.unlock(path,**kwargs,&block)
        end
      end
    end
  end
end
