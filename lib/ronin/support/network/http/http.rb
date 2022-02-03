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

require 'ronin/support/network/http/exceptions/unknown_request'
require 'ronin/support/network/ssl'

require 'uri/query_params'
require 'net/http'

begin
  require 'net/https'
rescue ::LoadError
  warn "WARNING: could not load 'net/https'"
end

module Ronin
  module Support
    module Network
      #
      # Provides helper methods for communicating with HTTP Servers.
      #
      module HTTP
        # The default `http://` port.
        #
        # @return [80]
        #
        # @since 1.0.0
        DEFAULT_PORT = Net::HTTP.default_port

        #
        # The Ronin HTTP proxy to use.
        #
        # @return [URI::HTTP, nil]
        #   The Ronin HTTP proxy.
        #
        # @note
        #   If the `HTTP_PROXY` environment variable is specified, it will
        #   be used as the default value.
        #
        # @api public
        #
        def self.proxy
          @proxy ||= if ENV['HTTP_PROXY']
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
                     raise(ArgumentError,"proxy must be a URI::HTTP, String, or nil")
                   end
        end

        #
        # The default Ronin HTTP `User-Agent` string.
        #
        # @return [String, nil]
        #   The default Ronin HTTP User-Agent.
        #
        # @api public
        #
        def self.user_agent
          @user_agent ||= nil
        end

        #
        # Sets the default Ronin HTTP `User-Agent` string.
        #
        # @param [String] agent
        #   The new User-Agent string to use.
        #
        # @api public
        #
        def self.user_agent=(agent)
          @user_agent = agent
        end

        #
        # Expands the URL into options.
        #
        # @param [URI::HTTP, String] url
        #   The URL to expand.
        #
        # @return [Hash{Symbol => Object}]
        #   The options for the URL.
        #
        # @api private
        #
        def self.options_from(url)
          url = case url
                when Hash then URI::HTTP.build(url)
                else           URI(url)
                end

          new_options = {}
          new_options[:ssl] = {} if url.scheme == 'https'

          new_options[:host] = url.host
          new_options[:port] = url.port

          new_options[:user]     = url.user     if url.user
          new_options[:password] = url.password if url.password

          new_options[:path] = url.path  unless url.path.empty?
          new_options[:query] = url.query unless url.query.nil?

          return new_options
        end

        #
        # Expands the given HTTP options.
        #
        # @param [Hash] options
        #   HTTP options.
        #
        # @option options [String, URI::HTTP, URI::HTTPS] :url
        #   The URL to request.
        #
        # @option options [String] :host
        #   The host to connect to.
        #
        # @option options [String] :port (DEFAULT_PORT)
        #   The port to connect to.
        #
        # @option options [String] :user
        #   The user to authenticate as.
        #
        # @option options [String] :password
        #   The password to authenticate with.
        #
        # @option options [String] :path ('/')
        #   The path to request.
        #
        # @option options [URI::HTTP, String, nil] :proxy (HTTP.proxy)
        #   The Proxy information.
        #
        # @return [Hash]
        #   The expanded version of options.
        #
        # @raise [ArgumentError]
        #   The `:proxy` option was not a `URI::HTTP`, `String`, or `nil`.
        #
        # @api private
        #
        def self.normalize_options(options={})
          new_options = options.dup

          new_options[:port] ||= DEFAULT_PORT
          new_options[:path] ||= '/'

          if new_options[:ssl] == true
            new_options[:ssl] = {}
          end

          if (url = new_options.delete(:url))
            new_options.merge!(HTTP.options_from(url))
          end

          new_options[:proxy] = if new_options.has_key?(:proxy)
                                  case options[:proxy]
                                  when URI::HTTP then options[:proxy]
                                  when String    then URI.parse(options[:proxy])
                                  when nil       then nil
                                  else
                                    raise(ArgumentError,":proxy option must be a URI::HTTP, String, or nil")
                                  end
                                else
                                  HTTP.proxy
                                end

          return new_options
        end

        #
        # Converts an underscored, dashed, lowercase or uppercase HTTP header
        # name to the standard camel-case HTTP header name.
        #
        # @param [Symbol, String] name
        #   The unformatted HTTP header name.
        #
        # @return [String]
        #   The camel-case HTTP header name.
        #
        # @api private
        #
        def self.header_name(name)
          words = name.to_s.split(/[\s+_-]/)

          words.each { |word| word.capitalize! }
          return words.join('-')
        end

        #
        # Converts underscored, dashed, lowercase and uppercase HTTP headers
        # to standard camel-cased HTTP headers.
        #
        # @param [Hash{Symbol,String => String}] headers
        #   Ronin HTTP headers.
        #
        # @return [Hash]
        #   The camel-cased HTTP headers created from the given options.
        #
        # @api private
        #
        def self.headers(headers)
          normalized_headers = {}

          if user_agent
            normalized_headers['User-Agent'] = user_agent
          end

          headers.each do |name,value|
            normalized_headers[HTTP.header_name(name)] = value.to_s
          end

          return normalized_headers
        end

        #
        # Creates a specific type of HTTP request object.
        #
        # @param [Symbol, String] method
        #   The HTTP method to use for the request.
        #
        # @param [String, nil] url
        #   Optional URL to create the HTTP request for.
        #
        # @param [String] path
        #   The path to request.
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
        # @param [String, nil] user
        #   The user to authenticate as.
        #
        # @param [String, nil] password
        #   The password to authenticate with.
        #
        # @param [Hash{Symbol,String => String}, nil] headers
        #   Additional HTTP headers to use for the request.
        #
        # @return [HTTP::Request]
        #   The new HTTP Request object.
        #
        # @raise [ArgumentError]
        #   The `:method` option must be specified.
        #
        # @raise [UnknownRequest]
        #   The `:method` option did not match a known Net::HTTP request
        #   class.
        #
        # @see HTTP.normalize_options
        #
        # @api private
        #
        def self.request(method:  ,
                         headers: {},
                         # URL options
                         url:   nil,
                         path:  '/',
                         query: nil,
                         query_params: nil,
                         # body options
                         body:      nil,
                         form_data: nil,
                         # authentication options
                         user:     nil,
                         password: nil)
          name = method.capitalize

          unless Net::HTTP.const_defined?(name)
            raise(UnknownRequest,"unknown HTTP request type #{name}")
          end

          headers = self.headers(headers)

          if url
            url = URI(url)

            path  = url.path
            query = url.query
          else
            path    = path.to_s
            query   = if query
                        query.to_s
                      elsif query_params
                        URI::QueryParams.dump(query_params)
                      end

            if query
              # append the query-string onto the path
              path += if path.include?('?') then "&#{query}"
                      else                       "?#{query}"
                      end
            end
          end

          request = Net::HTTP.const_get(name).new(path,headers)

          if form_data
            case form_data
            when String
              request.content_type = 'application/x-www-form-urlencoded'
              request.body         = form_data
            else
              request.form_data    = form_data
            end
          elsif body
            request.body = body
          end

          if user
            user     = user.to_s
            password = if password
                         password.to_s
                       end

            request.basic_auth(user,password)
          end

          return request
        end

        #
        # Starts a HTTP connection with the server.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [String, URI::HTTP] :url
        #   The full URL to request.
        #
        # @option kwargs [String] :host
        #   The host the HTTP server is running on.
        #
        # @option kwargs [Integer] :port (DEFAULT_PORT)
        #   The port the HTTP server is listening on.
        #
        # @option kwargs [URI::HTTP, String, nil] :proxy (HTTP.proxy)
        #   A Hash of proxy settings to use when connecting to the HTTP server.
        #
        # @option kwargs [String] :user
        #   The user to authenticate with when connecting to the HTTP server.
        #
        # @option kwargs [String] :password
        #   The password to authenticate with when connecting to the HTTP server.
        #
        # @option kwargs [Boolean, Hash] :ssl
        #   Enables SSL for the HTTP connection.
        #
        # @option :ssl [Symbol] :verify
        #   Specifies the SSL certificate verification mode.
        #   
        # @yield [http]
        #   If a block is given, it will be passed the newly created HTTP
        #   session object.
        #
        # @yieldparam [Net::HTTP] http
        #   The newly created HTTP session.
        #
        # @return [Net::HTTP]
        #   The HTTP session object.
        #
        # @api public
        #
        def http_connect(**kwargs,&block)
          options = HTTP.normalize_options(kwargs)

          host  = options[:host].to_s
          port  = options[:port]
          proxy = options[:proxy]

          http = if proxy
                   Net::HTTP.new(
                     host, port,
                     proxy.host, proxy.port, proxy.user, proxy.password
                   )
                 else
                   Net::HTTP.new(host,port)
                 end

          if options[:ssl]
            http.use_ssl     = true
            http.verify_mode = SSL::VERIFY[options[:ssl][:verify]]
          end

          http.start()

          if block
            if block.arity == 2
              block.call(http,options)
            else
              block.call(http)
            end
          end

          return http
        end

        #
        # Creates a new temporary HTTP session with the server.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_connect}.
        #
        # @option kwargs [String, URI::HTTP] :url
        #   The full URL to request.
        #
        # @option kwargs [String] :host
        #   The host the HTTP server is running on.
        #
        # @option kwargs [Integer] :port (DEFAULT_PORT)
        #   The port the HTTP server is listening on.
        #
        # @option kwargs [String] :user
        #   The user to authenticate with when connecting to the HTTP server.
        #
        # @option kwargs [String] :password
        #   The password to authenticate with when connecting to the HTTP server.
        #
        # @option kwargs [URI::HTTP, String, nil] :proxy (HTTP.proxy)
        #   A Hash of proxy settings to use when connecting to the HTTP server.
        #
        # @option kwargs [Boolean, Hash] :ssl
        #   Enables SSL for the HTTP connection.
        #
        # @option :ssl [Symbol] :verify
        #   Specifies the SSL certificate verification mode.
        #   
        # @yield [http]
        #   If a block is given, it will be passed the newly created HTTP
        #   session object.
        #
        # @yieldparam [Net::HTTP] http
        #   The newly created HTTP session.
        #
        # @return [nil]
        #
        # @see #http_connect
        #
        # @api public
        #
        def http_session(**kwargs)
          http_connect(**kwargs) do |http|
            yield http if block_given?

            http.finish
          end

          return nil
        end

        #
        # Connects to the HTTP server and sends an HTTP Request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_session}.
        #
        # @option kwargs [Symbol, String] :method
        #   The HTTP method to use in the request.
        #
        # @option kwargs [String] :path ('/')
        #   The path to request from the HTTP server.
        #
        # @option kwargs [String] :query
        #   The query-string to append to the request path.
        #
        # @option kwargs [String] :query_params
        #   The query-params to append to the request path.
        #
        # @option kwargs [String] :body
        #   The body of the request.
        #
        # @option kwargs [Hash] :headers
        #   The Hash of the HTTP headers to send with the request.
        #   May contain either Strings or Symbols, lower-case or camel-case
        #   keys.
        #
        # @option kwargs [String] :body
        #   The body of the request.
        #
        # @option kwargs [Hash, String] :form_data
        #   The form data that may be sent in the body of the request.
        #
        # @yield [request, (options)]
        #   If a block is given, it will be passed the HTTP request object.
        #   If the block has an arity of 2, it will also be passed the expanded
        #   version of the given _options_.
        #
        # @yieldparam [Net::HTTPRequest] request
        #   The HTTP request object to use in the request.
        #
        # @yieldparam [Hash] options
        #   The expanded version of the given _options_.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @raise [ArgumentError]
        #   The `:method` option must be specified.
        #
        # @raise [UnknownRequest]
        #   The `:method` option did not match a known Net::HTTP request
        #   class.
        #
        # @see #http_session
        # @see http_request
        #
        # @api public
        #
        def http_request(**kwargs)
          response = nil

          http_session(**kwargs) do |http|
            req = HTTP.request(**kwargs)

            yield req if block_given?

            response = http.request(req)
          end

          return response
        end

        #
        # Returns the Status Code of the Response.
        #
        # @param [Symbol, String] method
        #   The method to use for the request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @return [Integer]
        #   The HTTP Response Status.
        #
        # @see #http_request
        #
        # @since 0.2.0
        #
        # @api public
        #
        def http_status(method: :head, **kwargs)
          return http_request(method: method, **kwargs).code.to_i
        end

        #
        # Checks if the response has an HTTP `OK` status code.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_status}.
        #
        # @option kwargs [Symbol, String] :method (:head)
        #   The method to use for the request.
        #
        # @return [Boolean]
        #   Specifies whether the response had an HTTP OK status code or not.
        #
        # @see #http_status
        #
        # @api public
        #
        def http_ok?(**kwargs)
          http_status(**kwargs) == 200
        end

        #
        # Sends a HTTP Head request and returns the HTTP `Server` header.
        #
        # @param [Symbol, String] method
        #   The method to use for the request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @return [String]
        #   The HTTP `Server` header.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_server(method: :head, **kwargs)
          http_request(method: method, **kwargs)['server']
        end

        #
        # Sends an HTTP Head request and returns the HTTP `X-Powered-By`
        # header.
        #
        # @param [Symbol, String] method
        #   The method to use for the request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @return [String]
        #   The HTTP `X-Powered-By` header.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_powered_by(method: :head, **kwargs)
          return http_request(method: method, **kwargs)['x-powered-by']
        end

        #
        # Performs an HTTP `COPY` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_copy(**kwargs)
          response = http_request(method: :copy, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `DELETE` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @param [Hash, nil] headers
        #   Additional headers to send.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_delete(headers: nil, **kwargs, &block)
          original_headers = headers

          # set the HTTP Depth header
          headers = {depth: 'Infinity'}
          headers.merge!(original_headers) if original_headers

          response = http_request(
            method: :delete,
            headers: headers,
            **kwargs
          )

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `GET` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_get(**kwargs,&block)
          response = http_request(method: :get, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `GET` request and returns the Response Headers.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_get}.
        #
        # @return [Hash{String => Array<String>}]
        #   The Headers of the HTTP response.
        #
        # @see #http_get
        #
        # @since 0.2.0
        #
        # @api public
        #
        def http_get_headers(**kwargs)
          headers = {}

          http_get(**kwargs).each_header do |name,value|
            headers[HTTP.header_name(name)] = value
          end

          return headers
        end

        #
        # Performs an HTTP `GET` request and returns the Respond Body.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_get}.
        #
        # @return [String]
        #   The body of the HTTP response.
        #
        # @see #http_get
        #
        # @api public
        #
        def http_get_body(**kwargs)
          http_get(**kwargs).body
        end

        #
        # Performs an HTTP `HEAD` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_head(**kwargs,&block)
          response = http_request(method: :head, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `LOCK` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_lock(**kwargs,&block)
          response = http_request(method: :lock, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `MKCOL` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_mkcol(**kwargs,&block)
          response = http_request(method: :mkcol, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `MOVE` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_move(**kwargs,&block)
          response = http_request(method: :move, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `OPTIONS` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_options(**kwargs,&block)
          response = http_request(method: :options, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `POST` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @option kwargs [Hash, String] :form_data
        #   The form data to send with the HTTP Post request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_post(**kwargs,&block)
          response = http_request(method: :post, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `POST` request and returns the Response Headers.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_post}.
        #
        # @option kwargs [Hash, String] :form_data
        #   The form data to send with the HTTP Post request.
        #
        # @return [Hash{String => Array<String>}]
        #   The headers of the HTTP response.
        #
        # @see #http_post
        #
        # @since 0.2.0
        #
        # @api public
        #
        def http_post_headers(**kwargs)
          headers = {}

          http_post(**kwargs).each_header do |name,value|
            headers[HTTP.header_name(name)] = value
          end

          return headers
        end

        #
        # Performs an HTTP `POST` request and returns the Response Body.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_post}.
        #
        # @option kwargs [Hash, String] :form_data
        #   The form data to send with the HTTP Post request.
        #
        # @return [String]
        #   The body of the HTTP response.
        #
        # @see #http_post
        #
        # @api public
        #
        def http_post_body(**kwargs)
          http_post(**kwargs).body
        end

        #
        # Performs an HTTP `PUT` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @option kwargs [String] :body
        #   The body for the request.
        #
        # @option kwargs [Hash, String] :form_data
        #   The form data to send with the HTTP PUT request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @since 0.4.0
        #
        # @api public
        #
        def http_put(**kwargs)
          response = http_request(method: :put, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `PROPFIND` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_prop_find(headers: nil, **kwargs,&block)
          original_headers = headers

          # set the HTTP Depth header
          headers = {depth: '0'}
          headers.merge!(original_headers) if original_headers

          response = http_request(
            method: :propfind,
            headers: headers,
            **kwargs
          )

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `PROPPATCH` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_prop_patch(**kwargs,&block)
          response = http_request(method: :proppatch, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `TRACE` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_trace(**kwargs,&block)
          response = http_request(method: :trace, **kwargs)

          yield response if block_given?
          return response
        end

        #
        # Performs an HTTP `UNLOCK` request.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#http_request}.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received from
        #   the request.
        #
        # @yieldparam [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see #http_request
        #
        # @api public
        #
        def http_unlock(**kwargs,&block)
          response = http_request(method: :unlock, **kwargs)

          yield response if block_given?
          return response
        end
      end
    end
  end
end
