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

require 'ronin/network/http/exceptions/unknown_request'
require 'ronin/network/http/proxy'
require 'ronin/network/ssl'

require 'uri/query_params'
require 'net/http'

begin
  require 'net/https'
rescue ::LoadError
  warn "WARNING: could not load 'net/https'"
end

module Ronin
  module Network
    #
    # Provides helper methods for communicating with HTTP Servers.
    #
    module HTTP
      #
      # The Ronin HTTP proxy to use.
      #
      # @return [Proxy]
      #   The Ronin HTTP proxy.
      #
      # @note
      #   If the `HTTP_PROXY` environment variable is specified, it will
      #   be used as the default value.
      #
      # @see Proxy.new
      # @see Proxy.parse
      #
      # @api public
      #
      def self.proxy
        @proxy ||= if ENV['HTTP_PROXY']
                     Proxy.parse(ENV['HTTP_PROXY'])
                   else
                     Proxy.new
                   end
      end

      #
      # Sets the Ronin HTTP proxy to use.
      #
      # @param [Proxy, URI::HTTP, Hash, String] new_proxy
      #   The new proxy information to use.
      #
      # @return [Proxy]
      #   The new proxy.
      #
      # @raise [ArgumentError]
      #   The given proxy information was not a {Proxy}, `URI::HTTP`,
      #   `Hash` or {String}.
      #
      # @api public
      #
      def self.proxy=(new_proxy)
        @proxy = Proxy.create(new_proxy)
      end

      #
      # The default Ronin HTTP User-Agent string.
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
      # Sets the default Ronin HTTP User-Agent string.
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
      # @option options [String] :port (Net::HTTP.default_port)
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
      # @option options [String, Hash] :proxy (HTTP.proxy)
      #   The Proxy information.
      #
      # @return [Hash]
      #   The expanded version of options.
      #
      # @api private
      #
      def self.normalize_options(options={})
        new_options = options.dup

        new_options[:port] ||= Net::HTTP.default_port
        new_options[:path] ||= '/'

        if new_options[:ssl] == true
          new_options[:ssl] = {}
        end

        if (url = new_options.delete(:url))
          new_options.merge!(HTTP.options_from(url))
        end

        new_options[:proxy] = if new_options.has_key?(:proxy)
                                HTTP::Proxy.create(new_options[:proxy])
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
      # @param [Hash{Symbol,String => String}] options
      #   Ronin HTTP headers.
      #
      # @return [Hash]
      #   The camel-cased HTTP headers created from the given options.
      #
      # @api private
      #
      def self.headers(options={})
        headers = {}

        if user_agent
          headers['User-Agent'] = user_agent
        end

        if options
          options.each do |name,value|
            headers[HTTP.header_name(name)] = value.to_s
          end
        end

        return headers
      end

      #
      # Creates a specific type of HTTP request object.
      #
      # @param [Hash] options
      #   The HTTP options for the request.
      #
      # @option options [Symbol, String] :method
      #   The HTTP method to use for the request.
      #
      # @option options [String] :path ('/')
      #   The path to request.
      #
      # @option options [String] :query
      #   The query-string to append to the request path.
      #
      # @option options [String] :query_params
      #   The query-params to append to the request path.
      #
      # @option options [String] :body
      #   The body of the request.
      #
      # @option options [Hash, String] :form_data
      #   The form data that may be sent in the body of the request.
      #
      # @option options [String] :user
      #   The user to authenticate as.
      #
      # @option options [String] :password
      #   The password to authenticate with.
      #
      # @option options [Hash{Symbol,String => String}] :headers
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
      def self.request(options={})
        unless options[:method]
          raise(ArgumentError,"the :method option must be specified")
        end

        name = options[:method].capitalize

        unless Net::HTTP.const_defined?(name)
          raise(UnknownRequest,"unknown HTTP request type #{name}")
        end

        headers = headers(options[:headers])
        path    = (options[:path] || '/').to_s
        query   = if options[:query]
                    options[:query].to_s
                  elsif options[:query_params]
                    URI::QueryParams.dump(options[:query_params])
                  end

        if query
          # append the query-string onto the path
          path += if path.include?('?') then "&#{query}"
                  else                       "?#{query}"
                  end
        end

        request = Net::HTTP.const_get(name).new(path,headers)

        if options[:form_data]
          case options[:form_data]
          when String
            request.content_type = 'application/x-www-form-urlencoded'
            request.body         = options[:form_data]
          else
            request.form_data = options[:form_data]
          end
        elsif options[:body]
          request.body = options[:body]
        end

        if options[:user]
          user     = options[:user].to_s
          password = if options[:password]
                       options[:password].to_s
                     end

          request.basic_auth(user,password)
        end

        return request
      end

      #
      # Starts a HTTP connection with the server.
      #
      # @param [Hash] options
      #   Additional options
      #
      # @option options [String, URI::HTTP] :url
      #   The full URL to request.
      #
      # @option options [String] :host
      #   The host the HTTP server is running on.
      #
      # @option options [Integer] :port (Net::HTTP.default_port)
      #   The port the HTTP server is listening on.
      #
      # @option options [String, Hash] :proxy (HTTP.proxy)
      #   A Hash of proxy settings to use when connecting to the HTTP server.
      #
      # @option options [String] :user
      #   The user to authenticate with when connecting to the HTTP server.
      #
      # @option options [String] :password
      #   The password to authenticate with when connecting to the HTTP server.
      #
      # @option options [Boolean, Hash] :ssl
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
      def http_connect(options={},&block)
        options = HTTP.normalize_options(options)

        host  = options[:host].to_s
        port  = options[:port]
        proxy = options[:proxy]

        http = if proxy
                 Net::HTTP.new(
                   host,
                   port,
                   (proxy[:host].to_s if proxy[:host]),
                   proxy[:port],
                   proxy[:user],
                   proxy[:password]
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
      # @param [Hash] options
      #   Additional options
      #
      # @option options [String, URI::HTTP] :url
      #   The full URL to request.
      #
      # @option options [String] :host
      #   The host the HTTP server is running on.
      #
      # @option options [Integer] :port (Net::HTTP.default_port)
      #   The port the HTTP server is listening on.
      #
      # @option options [String] :user
      #   The user to authenticate with when connecting to the HTTP server.
      #
      # @option options [String] :password
      #   The password to authenticate with when connecting to the HTTP server.
      #
      # @option options [String, Hash] :proxy (HTTP.proxy)
      #   A Hash of proxy settings to use when connecting to the HTTP server.
      #
      # @option options [Boolean, Hash] :ssl
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
      def http_session(options={},&block)
        http_connect(options) do |http,expanded_options|
          if block
            if block.arity == 2
              block.call(http,expanded_options)
            else
              block.call(http)
            end
          end

          http.finish
        end

        return nil
      end

      #
      # Connects to the HTTP server and sends an HTTP Request.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol, String] :method
      #   The HTTP method to use in the request.
      #
      # @option options [String] :path ('/')
      #   The path to request from the HTTP server.
      #
      # @option options [String] :query
      #   The query-string to append to the request path.
      #
      # @option options [String] :query_params
      #   The query-params to append to the request path.
      #
      # @option options [String] :body
      #   The body of the request.
      #
      # @option options [Hash] :headers
      #   The Hash of the HTTP headers to send with the request.
      #   May contain either Strings or Symbols, lower-case or camel-case keys.
      #
      # @option options [String] :body
      #   The body of the request.
      #
      # @option options [Hash, String] :form_data
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
      def http_request(options={},&block)
        response = nil

        http_session(options) do |http,expanded_options|
          req = HTTP.request(expanded_options)

          if block
            if block.arity == 2
              block.call(req,expanded_options)
            else
              block.call(req)
            end
          end

          response = http.request(req)
        end

        return response
      end

      #
      # Returns the Status Code of the Response.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol, String] :method (:head)
      #   The method to use for the request.
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
      def http_status(options={})
        options = {method: :head}.merge(options)

        return http_request(options).code.to_i
      end

      #
      # Checks if the response has an HTTP OK status code.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol, String] :method (:head)
      #   The method to use for the request.
      #
      # @return [Boolean]
      #   Specifies whether the response had an HTTP OK status code or not.
      #
      # @see #http_status
      #
      # @api public
      #
      def http_ok?(options={})
        http_status(options) == 200
      end

      #
      # Sends a HTTP Head request and returns the HTTP Server header.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol, String] :method (:head)
      #   The method to use for the request.
      #
      # @return [String]
      #   The HTTP `Server` header.
      #
      # @see #http_request
      #
      # @api public
      #
      def http_server(options={})
        options = {method: :head}.merge(options)

        return http_request(options)['server']
      end

      #
      # Sends an HTTP Head request and returns the HTTP X-Powered-By header.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol, String] :method (:get)
      #   The method to use for the request.
      #
      # @return [String]
      #   The HTTP `X-Powered-By` header.
      #
      # @see #http_request
      #
      # @api public
      #
      def http_powered_by(options={})
        options = {method: :get}.merge(options)

        return http_request(options)['x-powered-by']
      end

      #
      # Performs an HTTP Copy request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_copy(options={})
        response = http_request(options.merge(method: :copy))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Delete request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_delete(options={},&block)
        original_headers = options[:headers]

        # set the HTTP Depth header
        options[:headers] = {depth: 'Infinity'}

        if original_headers
          options[:header].merge!(original_headers)
        end

        response = http_request(options.merge(method: :delete))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Get request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_get(options={},&block)
        response = http_request(options.merge(method: :get))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Get request and returns the Response Headers.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_get_headers(options={})
        headers = {}

        http_get(options).each_header do |name,value|
          headers[HTTP.header_name(name)] = value
        end

        return headers
      end

      #
      # Performs an HTTP Get request and returns the Respond Body.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @return [String]
      #   The body of the HTTP response.
      #
      # @see #http_get
      #
      # @api public
      #
      def http_get_body(options={})
        http_get(options).body
      end

      #
      # Performs an HTTP Head request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_head(options={},&block)
        response = http_request(options.merge(method: :head))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Lock request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_lock(options={},&block)
        response = http_request(options.merge(method: :lock))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Mkcol request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_mkcol(options={},&block)
        response = http_request(options.merge(method: :mkcol))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Move request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_move(options={},&block)
        response = http_request(options.merge(method: :move))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Options request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_options(options={},&block)
        response = http_request(options.merge(method: :options))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Post request.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Hash, String] :form_data
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
      def http_post(options={},&block)
        response = http_request(options.merge(method: :post))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Post request and returns the Response Headers.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Hash, String] :form_data
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
      def http_post_headers(options={})
        headers = {}

        http_post(options).each_header do |name,value|
          headers[HTTP.header_name(name)] = value
        end

        return headers
      end

      #
      # Performs an HTTP Post request and returns the Response Body.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Hash, String] :form_data
      #   The form data to send with the HTTP Post request.
      #
      # @return [String]
      #   The body of the HTTP response.
      #
      # @see #http_post
      #
      # @api public
      #
      def http_post_body(options={})
        http_post(options).body
      end

      #
      # Performs an HTTP PUT request.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :body
      #   The body for the request.
      #
      # @option options [Hash, String] :form_data
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
      def http_put(options={})
        response = http_request(options.merge(method: :put))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Propfind request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_prop_find(options={},&block)
        original_headers = options[:headers]

        # set the HTTP Depth header
        options[:headers] = {depth: '0'}

        if original_headers
          options[:header].merge!(original_headers)
        end

        response = http_request(options.merge(method: :propfind))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Proppatch request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_prop_patch(options={},&block)
        response = http_request(options.merge(method: :proppatch))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Trace request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_trace(options={},&block)
        response = http_request(options.merge(method: :trace))

        yield response if block_given?
        return response
      end

      #
      # Performs an HTTP Unlock request.
      #
      # @param [Hash] options
      #   Additional options.
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
      def http_unlock(options={},&block)
        response = http_request(options.merge(method: :unlock))

        yield response if block_given?
        return response
      end
    end
  end
end
