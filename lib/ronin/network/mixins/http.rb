#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/network/mixins/mixin'
require 'ronin/network/http'

module Ronin
  module Network
    module Mixins
      #
      # Adds HTTP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - HTTP host.
      # * `port` (`Integer`) - HTTP port. Defaults to `Net::HTTP.default_port`.
      # * `http_vhost` (`String`) - HTTP Host header to send.
      # * `http_user` (`String`) - HTTP user to authenticate as.
      # * `http_password` (`String`) - HTTP password to authenticate with.
      # * `http_proxy` - HTTP proxy information.
      # * `http_user_agent` (`String`) - HTTP User-Agent header to send.
      #
      module HTTP
        include Mixin, Network::HTTP

        # HTTP host
        parameter :host, :type => String,
                         :description => 'HTTP host'

        # HTTP port
        parameter :port, :default => Net::HTTP.default_port,
                         :description => 'HTTP port'

        # HTTP `Host` header to send
        parameter :http_vhost, :type => String,
                               :description => 'HTTP Host header to send'

        # HTTP user to authenticate as
        parameter :http_user, :type => String,
                              :description => 'HTTP user to authenticate as'

        # HTTP password to authenticate with
        parameter :http_password, :type => String,
                                  :description => 'HTTP password to authenticate with'

        # HTTP proxy information
        parameter :http_proxy, :description => 'HTTP proxy information'

        # HTTP `User-Agent` header to send
        parameter :http_user_agent, :type => String,
                                    :description => 'HTTP User-Agent header to send'

        protected

        #
        # Resets the HTTP proxy settings.
        #
        # @api public
        #
        def disable_http_proxy
          @http_proxy = nil
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
        #   The password to authenticate with when connecting to the HTTP
        #   server.
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
        # @see Network::HTTP#http_connect
        #
        # @api public
        #
        # @since 0.5.0
        #
        def http_connect(options={},&block)
          super(http_merge_options(options),&block)
        end

        #
        # Connects to the HTTP server and sends an HTTP Request.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Hash{String,Symbol => Object}] :headers
        #   The Hash of the HTTP headers to send with the request.
        #   May contain either Strings or Symbols, lower-case or
        #   camel-case keys.
        #
        # @yield [request, (options)]
        #   If a block is given, it will be passed the HTTP request object.
        #   If the block has an arity of 2, it will also be passed the
        #   expanded version of the given options.
        #
        # @yieldparam [Net::HTTPRequest] request
        #   The HTTP request object to use in the request.
        #
        # @yieldparam [Hash] options
        #   The expanded version of the given options.
        #
        # @return [Net::HTTPResponse]
        #   The response of the HTTP request.
        #
        # @see Network::HTTP#http_request
        #
        # @api public
        #
        def http_request(options={},&block)
          response = super(options) do |request,expanded_options|
            if block
              if block.arity == 2
                block.call(request,expanded_options)
              else
                block.call(request)
              end
            end

            host = options.fetch(:host,self.host)
            port = options.fetch(:port,self.port)

            print_info "HTTP #{request.method} #{host}:#{port} #{request.path}"

            request.each_capitalized do |name,value|
              print_debug "  #{name}: #{value}"
            end
          end

          print_info "HTTP #{response.code} #{response.message}"

          response.each_capitalized do |name,value|
            print_debug "  #{name}: #{value}"
          end

          return response
        end

        private

        #
        # Merges the HTTP parameters into the HTTP options.
        #
        # @param [Hash] options
        #   The HTTP options to merge into.
        #
        # @return [Hash]
        #   The merged HTTP options.
        #
        # @since 1.0.0
        #
        # @api private
        #
        def http_merge_options(options={})
          options = options.dup

          options[:proxy] ||= self.http_proxy if self.http_proxy
          options[:host]  ||= self.host       if self.host
          options[:port]  ||= self.port       if self.port

          if (self.http_vhost || self.http_user_agent)
            headers = (options[:headers] ||= {})

            headers[:host]       ||= self.http_vhost      if self.http_vhost
            headers[:user_agent] ||= self.http_user_agent if self.http_user_agent
          end

          options[:user]     ||= self.http_user     if self.http_user
          options[:password] ||= self.http_password if self.http_password

          return options
        end

      end
    end
  end
end
