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

require 'ronin/extensions/ip_addr'
require 'ronin/network/network'

module Ronin
  module Network
    module HTTP
      #
      # The {Proxy} class represents the information needed to connect
      # to a HTTP Proxy. The {Proxy} class can also test the reliability
      # of a HTTP proxy.
      #
      class Proxy < Struct.new(:host, :port, :user, :password)

        #
        # Creates a new Proxy object that represents a proxy to connect to.
        #
        # @param [Hash] options
        #   Additional options for the proxy.
        #
        # @option options [String] :host
        #   The host-name of the proxy.
        #
        # @option options [Integer] :port
        #   The port that the proxy is running on.
        #
        # @option options [String] :user
        #   The user-name to authenticate as.
        #
        # @option options [String] :password
        #   The password to authenticate with.
        #
        # @api public
        #
        def initialize(options={})
          super(
            options[:host],
            options[:port],
            options[:user],
            options[:password]
          )
        end

        #
        # Parses a proxy URL.
        #
        # @param [String, URI::HTTP] proxy
        #   The proxy URL in String form.
        #
        # @return [Proxy]
        #   The parsed proxy information.
        #
        # @example
        #   Proxy.parse('217.31.51.77:443')
        #
        # @example
        #   Proxy.parse('joe:lol@127.0.0.1:8080')
        #
        # @example
        #   Proxy.parse('http://201.26.192.61:8080')
        #
        # @api public
        #
        def self.parse(proxy)
          proxy = proxy.to_s.gsub(/^http(s)?:\/*/,'')

          if proxy.include?('@')
            auth, proxy = proxy.split('@',2)
            user, password = auth.split(':')
          else
            user = nil
            password = nil
          end

          host, port = proxy.split(':',2)
          port = port.to_i if port

          return new(
            host:     host,
            port:     port,
            user:     user,
            password: password
          )
        end

        #
        # Creates a new proxy.
        #
        # @param [Proxy, URI::HTTP, Hash, String] proxy
        #   The proxy information.
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
        def self.create(proxy)
          case proxy
          when Proxy
            proxy
          when URI::HTTP
            new(
              host:       proxy.host,
              port:       proxy.port,
              user:       proxy.user,
              password:   proxy.password
            )
          when Hash
            new(proxy)
          when String
            parse(proxy)
          when nil
            new
          else
            raise(ArgumentError,"argument must be either a #{self}, URI::HTTP, Hash or String")
          end
        end

        #
        # Tests the proxy.
        #
        # @return [Boolean]
        #   Specifies if the proxy can proxy requests.
        #
        # @api public
        #
        def valid?
          begin
            Net.http_get_body(
              url:   'http://www.example.com/',
              proxy: self
            ).include?('Example Web Page')
          rescue Timeout::Error, StandardError
            return false
          end
        end

        #
        # Measures the latency of the proxy.
        #
        # @return [Float]
        #   The extra number of seconds it takes the proxy to process the
        #   request, compared to sending the request directly.
        #
        # @api public
        #
        def latency
          time = lambda { |proxy|
            t1 = Time.now
            Net.http_head(
              url:   'http://www.example.com/',
              proxy: proxy
            )
            t2 = Time.now

            (t2 - t1)
          }

          begin
            return (time.call(self) - time.call(nil))
          rescue Timeout::Error, StandardError
            return (1.0/0)
          end
        end

        alias lag latency

        #
        # The IP address the proxy sends with proxied requests.
        #
        # @return [String]
        #   The IP address the proxy uses for our requests.
        #
        # @api public
        #
        def proxied_ip
          IPAddr.extract(Net.http_get_body(
            host: 'checkip.dyndns.org',
            proxy: self
          )).first
        end

        #
        # Determines whether the proxy forwards our IP address.
        #
        # @return [Boolean]
        #   Specifies whether the proxy will forward our IP address.
        #
        # @api public
        #
        def transparent?
          Network.ip == proxied_ip
        end

        #
        # Determines whether the proxy will hide our IP address.
        #
        # @return [Boolean]
        #   Specifies whether the proxy will hide our IP address.
        #
        # @api public
        #
        def anonymous?
          !(transparent?)
        end

        #
        # Disables the Proxy object.
        #
        # @api public
        #
        def disable!
          self.host = nil
          self.port = nil
          self.user = nil
          self.password = nil

          return self
        end

        #
        # Specifies whether the proxy object is usable.
        #
        # @return [Boolean]
        #   Specifies whether the proxy object is usable by
        #   Net::HTTP::Proxy.
        #
        # @api public
        #
        def enabled?
          !(host.nil?)
        end

        #
        # Builds a HTTP URI from the proxy information.
        #
        # @return [URI::HTTP, nil]
        #   The HTTP URI representing the proxy. If the proxy is disabled,
        #   then `nil` will be returned.
        #
        # @api public
        #
        def url
          return nil unless enabled?

          userinfo = if user
                       if password
                         "#{user}:#{password}"
                       else
                         user
                       end
                     end
          
          return URI::HTTP.build(
            userinfo: userinfo,
            host:     host,
            port:     port
          )
        end

        #
        # Converts the proxy object to a String.
        #
        # @return [String]
        #   The host-name of the proxy.
        #
        # @api public
        #
        def to_s
          host.to_s
        end

        #
        # Inspects the proxy object.
        #
        # @return [String]
        #   The inspection of the proxy object.
        #
        # @api public
        #
        def inspect
          unless host
            str = 'disabled'
          else
            str = ''
            
            str << host.to_s
            str << ":#{port}" if port

            if user
              auth_str = ''
              auth_str << user.to_s

              if password
                auth_str << ":#{password}"
              end

              str = "#{auth_str}@#{str}"
            end
          end

          return "#<#{self.class}: #{str}>"
        end

      end
    end
  end
end
