#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/network/extensions/http'

module Ronin
  module Network
    #
    # Settings and helper methods for HTTP.
    #
    module HTTP
      #
      # The Ronin HTTP proxy to use. Parses the value of the `HTTP_PROXY`
      # environment variable if set.
      #
      # @return [Proxy]
      #   The Ronin HTTP proxy.
      #
      # @see Proxy.new
      # @see Proxy.parse
      #
      def HTTP.proxy
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
      def HTTP.proxy=(new_proxy)
        @proxy = Proxy.create(new_proxy)
      end

      #
      # The default Ronin HTTP User-Agent string.
      #
      # @return [String, nil]
      #   The default Ronin HTTP User-Agent.
      #
      def HTTP.user_agent
        @user_agent ||= nil
      end

      #
      # Sets the default Ronin HTTP User-Agent string.
      #
      # @param [String] agent
      #   The new User-Agent string to use.
      #
      def HTTP.user_agent=(agent)
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
      def HTTP.expand_url(url)
        new_options = {}

        url = case url
              when URI
                url
              when Hash
                URI::HTTP.build(url)
              else
                URI(url.to_s)
              end

        new_options[:ssl] = {} if url.scheme == 'https'

        new_options[:host] = url.host
        new_options[:port] = url.port

        new_options[:user] = url.user if url.user
        new_options[:password] = url.password if url.password

        new_options[:path] = unless url.path.empty?
                               url.path
                             else
                               '/'
                             end
        new_options[:path] += "?#{url.query}" if url.query

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
      # @option options [String] :port (::Net::HTTP.default_port)
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
      # @option options [String, Hash] :proxy (Ronin::Network::HTTP.proxy)
      #   The Proxy information.
      #
      # @return [Hash]
      #   The expanded version of options.
      #
      def HTTP.expand_options(options={})
        new_options = options.dup

        new_options[:port] ||= Net::HTTP.default_port
        new_options[:path] ||= '/'

        if new_options[:ssl] == true
          new_options[:ssl] = {}
        end

        if (url = new_options.delete(:url))
          new_options.merge!(HTTP.expand_url(url))
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
      def HTTP.header_name(name)
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
      def HTTP.headers(options={})
        headers = {}

        if HTTP.user_agent
          headers['User-Agent'] = HTTP.user_agent
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
      # @see HTTP.expand_options
      #
      def HTTP.request(options={})
        unless options[:method]
          raise(ArgumentError,"the :method option must be specified")
        end

        name = options[:method].to_s.capitalize

        unless Net::HTTP.const_defined?(name)
          raise(UnknownRequest,"unknown HTTP request type #{name.dump}")
        end

        headers = HTTP.headers(options[:headers])
        path = (options[:path] || '/').to_s

        request = Net::HTTP.const_get(name).new(path,headers)

        if request.request_body_permitted?
          if options[:form_data]
            request.set_form_data(options[:form_data])
          elsif options[:body]
            request.body = options[:body]
          end
        end

        if (user = options.delete(:user))
          user = user.to_s

          if (password = options.delete(:password))
            password = password.to_s
          end

          request.basic_auth(user,password)
        end

        return request
      end
    end
  end
end
