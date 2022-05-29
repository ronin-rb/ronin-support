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
                                  when URI::HTTP
                                    options[:proxy]
                                  when String
                                    URI.parse(options[:proxy])
                                  when nil
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
        #   The `:method` option did not match a known `Net::HTTP` request
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
            case body
            when IO, StringIO
              request.body_stream = body
            else
              request.body = body
            end
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
      end
    end
  end
end
