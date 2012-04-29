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

module Ronin
  module Network
    #
    # Base class for {TCP::Proxy TCP} and {UDP::Proxy UDP} Proxies.
    #
    # ## Callbacks
    #
    # The Proxy base class supports several callbacks for proxy events.
    #
    # ### client_data
    #
    # When a client sends data to the proxy.
    #
    #     on_client_data do |client,server,data|
    #       data.gsub!(/foo/,'bar')
    #     end
    #
    # ### server_data
    #
    # When the server sends data to the proxy.
    #
    #     on_server_data do |client,server,data|
    #       data.gsub!(/foo/,'bar')
    #     end
    #
    # ### data
    #
    # Alias for {#on_client_data} and {#on_server_data}.
    #
    # ## Actions
    #
    # The Proxy base class also provides methods to change how events are
    # handled.
    #
    # * {#drop!}
    # * {#close!}
    # * {#reset!}
    #
    # @since 0.5.0
    #
    class Proxy

      # The port the proxy will listen on
      attr_reader :proxy_port

      # The host the proxy will listen on
      attr_reader :proxy_host

      # The remote port the proxy will relay data to
      attr_reader :server_host

      # The remote host the proxy will relay data to
      attr_reader :server_port

      # The size of read buffer
      attr_accessor :buffer_size

      # The connections maintained by the proxy
      attr_reader :connections

      #
      # Creates a new Proxy.
      #
      # @param [(Integer, (String))] proxy
      #   The port and optional address to listen on.
      #
      # @param [(String, Integer)] server
      #   The address and port of the remote server.
      #
      # @yield [proxy]
      #   If a block is given, it will be passed the new Proxy, before it
      #   has been configured.
      #
      # @yieldparam [Proxy] proxy
      #   The new Proxy object.
      #
      # @example Proxies `0.0.0.0:1337` to `victim.com:80`:
      #   Proxy.new(1337, ['victim.com', 80])
      #
      # @example Proxies `localhost:1337` to `victim.com:80`:
      #   Proxy.new([1337, 'localhost'], ['victim.com', 80])
      #
      def initialize(proxy,server)
        @proxy_port, @proxy_host   = proxy
        @server_host, @server_port = server

        @callbacks = {
          :client_data => [],
          :server_data => []
        }

        @buffer_size = 4096
        @connections = {}

        yield self if block_given?
      end

      #
      # Creates a new Proxy and begins relaying data.
      #
      # @see #initialize
      #
      # @api public
      #
      def self.start(proxy,server,&block)
        new(proxy,server,&block).start
      end

      #
      # Starts the proxy and begins relaying data.
      #
      # @return [Proxy]
      #   The proxy object.
      #
      # @api public
      #
      def start
        open
        listen
        close
        return self
      end

      #
      # Opens the proxy.
      #
      # @api public
      #
      # @abstract
      #
      def open
      end

      #
      # Polls the connections for data or errors.
      #
      # @api public
      #
      # @abstract
      #
      def poll
      end

      #
      # Polls the connections for data.
      #
      # @api public
      #
      def listen
        loop do
          begin
            poll
          rescue Interrupt
            break
          end
        end
      end

      #
      # Sends data to a connection.
      #
      # @param [connection] connection
      #   The connection.
      #
      # @param [String] data
      #   The data to send.
      #
      # @api public
      #
      # @abstract
      #
      def send(connection,data)
      end

      #
      # Receives data from a connection.
      #
      # @param [connection] connection
      #   The connection.
      #
      # @api public
      #
      # @abstract
      #
      def recv(connection)
      end

      #
      # Closes the proxy.
      #
      # @api public
      # 
      # @abstract
      #
      def close
        close_connections
        close_proxy
      end

      #
      # Registers a callback for when a client sends data.
      #
      # @yield [client, server, data]
      #
      # @yieldparam [String] data
      #
      # @api public
      #
      def on_client_data(&block)
        @callbacks[:client_data] << block
      end

      #
      # Registers a callback for when a server sends data.
      #
      # @yield [client, server, data]
      #
      # @yieldparam [String] data
      #
      # @api public
      #
      def on_server_data(&block)
        @callbacks[:server_data] << block
      end

      #
      # Registers a callback for when either the client or the server sends
      # data.
      #
      # @yield [client, server, data]
      #
      # @yieldparam [String] data
      #
      # @api public
      #
      def on_data(&block)
        on_client_data(&block)
        on_server_data(&block)
      end

      #
      # Causes the proxy to drop a message.
      #
      # @api public
      #
      def drop!
        throw(:action,:drop)
      end

      #
      # Causes the proxy to close a connection.
      #
      # @api public
      #
      def close!
        throw(:action,:close)
      end

      #
      # Causes the proxy to restart a connection.
      #
      # @api public
      #
      def reset!
        throw(:action,:reset)
      end

      #
      # Converts the proxy to a String.
      #
      # @return [String]
      #   The String form of the proxy.
      #
      def to_s
        "#{@proxy_host}:#{@proxy_port} <-> #{@server_host}:#{@server_port}"
      end

      #
      # Inspects the proxy.
      #
      # @return [String]
      #   The inspected proxy.
      #
      def inspect
        "#<#{self.class}:#{self.object_id}: #{self}>"
      end

      protected

      #
      # Creates a new connection to the server.
      #
      # @return [connection]
      #   The new connection.
      #
      # @abstract
      #
      def new_server_connection
      end

      #
      # Closes a client connection to the proxy.
      #
      # @param [connection] connection
      #   The client connection.
      #
      # @abstract
      #
      def close_client_connection(connection)
      end

      #
      # Closes a connection to the server.
      #
      # @param [connection] connection
      #   The server connection.
      #
      # @abstract
      #
      def close_server_connection(connection)
      end

      #
      # Closes the proxy.
      #
      # @abstract
      #
      def close_proxy
      end

      #
      # Resets a server connection.
      #
      # @param [connection] client_connection
      #   The connection from the client to the proxy.
      #
      # @param [connection] server_connection
      #   The connection from the proxy to the server.
      #
      def reset_connection(client_connection,server_connection)
        close_server_connection(server_connection) if server_connection

        @connections[client_connection] = new_server_connection
      end

      #
      # Closes both the client and server connections.
      #
      # @param [connection] client_connection
      #   The connection from the client to the proxy.
      #
      # @param [connection] server_connection
      #   The connection from the proxy to the server.
      #
      def close_connection(client_connection,server_connection=nil)
        close_server_connection(server_connection) if server_connection
        close_client_connection(client_connection)

        @connections.delete(client_connection)
      end

      #
      # Closes all active connections.
      #
      def close_connections
        @connections.each do |client_connection,server_connection|
          close_server_connection(server_connection)
          close_client_connection(client_connection)
        end

        @connections.clear
      end

      #
      # Triggers the callbacks registered for an event.
      #
      # @param [Symbol] event
      #   The event being triggered.
      #
      # @param [connection] client_connection
      #   The connection from the client to the proxy.
      #
      # @param [connection] server_connection
      #   The connection from the proxy to the server.
      #
      # @param [String] data
      #   The data being sent.
      #
      # @yield []
      #   If none of the callbacks interrupted the event, the given block
      #   will be called.
      #
      def callback(event,client_connection,server_connection=nil,data=nil)
        action = catch(:action) do
          @callbacks[event].each do |block|
            case block.arity
            when 1
              block.call(client_connection)
            when 2
              block.call(client_connection,server_connection)
            when 3, -1
              block.call(client_connection,server_connection,data)
            end
          end
        end

        case action
        when :drop
          # no-op
        when :reset
          reset_connection(client_connection,server_connection)
        when :close
          close_connection(client_connection,server_connection)
        else
          yield if block_given?
        end
      end

      #
      # Triggers the `client_data` event.
      #
      # @param [connection] client_connection
      #   The connection from a client to the proxy.
      #
      # @param [connection] server_connection
      #   The connection from the proxy to the server.
      #
      # @param [String] data
      #   The data sent by the client.
      #
      def client_data(client_connection,server_connection,data)
        callback(:client_data,client_connection,server_connection,data) do
          send(server_connection,data)
        end
      end

      #
      # Triggers the `server_data` event.
      #
      # @param [connection] client_connection
      #   The connection from a client to the proxy.
      #
      # @param [connection] server_connection
      #   The connection from the proxy to the server.
      #
      # @param [String] data
      #   The data sent from the server.
      #
      def server_data(client_connection,server_connection,data)
        callback(:server_data,client_connection,server_connection,data) do
          send(client_connection,data)
        end
      end

    end
  end
end
