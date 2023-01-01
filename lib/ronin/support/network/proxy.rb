# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Support
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
      # * {#ignore!}
      # * {#close!}
      # * {#reset!}
      #
      # @since 0.5.0
      #
      class Proxy

        # Default host to bind to
        DEFAULT_HOST = '0.0.0.0'

        DEFAULT_BUFFER_SIZE = 4096

        # The host the proxy will listen on
        #
        # @return [String]
        attr_reader :host

        # The port the proxy will listen on
        #
        # @return [Integer]
        attr_reader :port

        # The remote port the proxy will relay data to
        # 
        # @return [String]
        attr_reader :server_host

        # The remote host the proxy will relay data to
        # 
        # @return [Integer]
        attr_reader :server_port

        # The size of read buffer
        #
        # @return [Integer]
        attr_accessor :buffer_size

        # The connections maintained by the proxy
        #
        # @return [Hash{Socket => Socket}]
        attr_reader :connections

        #
        # Creates a new Proxy.
        #
        # @param [String] host
        #   The host to listen on.
        #
        # @param [Integer] port
        #   The port to listen on.
        #
        # @param [String, (host, port)] server
        #   The server to forward connections to.
        #
        # @param [Integer] buffer_size
        #   The maximum amount of data to read in.
        #
        # @yield [proxy]
        #   If a block is given, it will be passed the new Proxy, before it
        #   has been configured.
        #
        # @yieldparam [Proxy] proxy
        #   The new Proxy object.
        #
        # @example Proxies `0.0.0.0:1337` to `victim.com:80`:
        #   Proxy.new(port: 1337, server: ['victim.com', 80])
        #
        # @example Proxies `localhost:25` to `victim.com:25`:
        #   Proxy.new(port: 25, host: 'localhost', server: 'victim.com')
        #
        def initialize(host: DEFAULT_HOST,
                       port: ,
                       server: ,
                       buffer_size: DEFAULT_BUFFER_SIZE)
          @host = host
          @port = port

          @server_host, @server_port = server
          @server_port ||= @port

          @callbacks = {client_data: [], server_data: []}

          @buffer_size = buffer_size
          @connections = {}

          yield self if block_given?
        end

        #
        # Creates a new Proxy and begins relaying data.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#initialize}.
        #
        # @see #initialize
        #
        # @api public
        #
        def self.start(**kwargs,&block)
          new(**kwargs,&block).start
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
          @listening = true

          while @listening
            begin
              poll
            rescue Interrupt
              @listening = false
              break
            end
          end
        end

        #
        # Sends data to a connection.
        #
        # @param [Socket] connection
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
        # @param [Socket] connection
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
        def close
          close_connections
          close_proxy
        end

        #
        # Stops the proxy from listening.
        #
        # @api public
        #
        def stop
          @listening = false
          return self
        end

        #
        # Registers a callback for when a client sends data.
        #
        # @yield [client, server, data]
        #   The given block will be passed the client connection, the server
        #   connection, and the received data.
        #
        # @yieldparam [Socket] client
        #   The connection to the client.
        #
        # @yieldparam [Socket] server
        #   The connection to the server.
        #
        # @yieldparam [String] data
        #   The recieved data.
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
        #   The given block will be passed the client connection, the server
        #   connection, and the received data.
        #
        # @yieldparam [Socket] client
        #   The connection to the client.
        #
        # @yieldparam [Socket] server
        #   The connection to the server.
        #
        # @yieldparam [String] data
        #   The recieved data.
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
        #   The given block will be passed the client connection, the server
        #   connection, and the received data.
        #
        # @yieldparam [Socket] client
        #   The connection to the client.
        #
        # @yieldparam [Socket] server
        #   The connection to the server.
        #
        # @yieldparam [String] data
        #   The recieved data.
        #
        # @api public
        #
        def on_data(&block)
          on_client_data(&block)
          on_server_data(&block)
        end

        #
        # Causes the proxy to ignore a message.
        #
        # @api public
        #
        def ignore!
          throw(:action,:ignore)
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
        # Causes the proxy to stop processing data entirely.
        #
        # @api public
        #
        def stop!
          throw(:action,:stop)
        end

        #
        # Connections from clients.
        #
        # @return [Array<Socket>]
        #   Client connections.
        #
        def client_connections
          @connections.keys
        end

        #
        # Connections to the server.
        #
        # @return [Array<Socket>]
        #   Server connections.
        #
        def server_connections
          @connections.values
        end

        #
        # Finds the connection to the server, associated with the client.
        #
        # @param [Socket] client_connection
        #   The connection from the client.
        #
        # @return [Socket]
        #   The connection to the server.
        #
        def server_connection_for(client_connection)
          @connections[client_connection]
        end

        #
        # Finds the connection from the client, associated with the server
        # connection.
        #
        # @param [Socket] server_connection
        #   The connection to the server.
        #
        # @return [Socket]
        #   The connection from the client.
        #
        def client_connection_for(server_connection)
          @connections.key(server_connection)
        end

        #
        # Converts the proxy to a String.
        #
        # @return [String]
        #   The String form of the proxy.
        #
        def to_s
          "#{@host}:#{@port} <-> #{@server_host}:#{@server_port}"
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
        # @return [Socket]
        #   The new connection.
        #
        # @abstract
        #
        def open_server_connection
        end

        #
        # Closes a client connection to the proxy.
        #
        # @param [Socket] connection
        #   The client connection.
        #
        # @abstract
        #
        def close_client_connection(connection)
        end

        #
        # Closes a connection to the server.
        #
        # @param [Socket] connection
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
        # @param [Socket] client_connection
        #   The connection from the client to the proxy.
        #
        # @param [Socket] server_connection
        #   The connection from the proxy to the server.
        #
        def reset_connection(client_connection,server_connection)
          close_server_connection(server_connection) if server_connection

          @connections[client_connection] = open_server_connection
        end

        #
        # Closes both the client and server connections.
        #
        # @param [Socket] client_connection
        #   The connection from the client to the proxy.
        #
        # @param [Socket] server_connection
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
        # @param [Socket] client_connection
        #   The connection from the client to the proxy.
        #
        # @param [Socket] server_connection
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
          when :ignore
            # no-op
          when :reset
            reset_connection(client_connection,server_connection)
          when :close
            close_connection(client_connection,server_connection)
          when :stop
            stop
          else
            yield if block_given?
          end
        end

        #
        # Triggers the `client_data` event.
        #
        # @param [Socket] client_connection
        #   The connection from a client to the proxy.
        #
        # @param [Socket] server_connection
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
        # @param [Socket] client_connection
        #   The connection from a client to the proxy.
        #
        # @param [Socket] server_connection
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
end
