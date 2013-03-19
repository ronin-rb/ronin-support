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

require 'ronin/network/proxy'

require 'socket'

module Ronin
  module Network
    module TCP
      #
      # The TCP Proxy allows for inspecting and manipulating TCP protocols.
      #
      # ## Example
      # 
      #     require 'ronin/network/tcp/proxy'
      #     require 'hexdump'
      #
      #     Ronin::Network::TCP::Proxy.start(port: 1337, server: ['www.wired.com', 80]) do |proxy|
      #       address = lambda { |socket|
      #         addrinfo = socket.peeraddr
      #
      #        "#{addrinfo[3]}:#{addrinfo[1]}"
      #       }
      #       hex = Hexdump::Dumper.new
      #
      #       proxy.on_client_data do |client,server,data|
      #         puts "#{address[client]} -> #{proxy}"
      #         hex.dump(data)
      #       end
      #
      #       proxy.on_client_connect do |client|
      #         puts "#{address[client]} -> #{proxy} [connected]"
      #       end
      #
      #       proxy.on_client_disconnect do |client,server|
      #         puts "#{address[client]} <- #{proxy} [disconnected]"
      #       end
      #
      #       proxy.on_server_data do |client,server,data|
      #         puts "#{address[client]} <- #{proxy}"
      #         hex.dump(data)
      #       end
      #
      #       proxy.on_server_connect do |client,server|
      #         puts "#{address[client]} <- #{proxy} [connected]"
      #       end
      #
      #       proxy.on_server_disconnect do |client,server|
      #         puts "#{address[client]} <- #{proxy} [disconnected]"
      #       end
      #     end
      #
      # ## Callbacks
      #
      # In addition to the events supported by the {Network::Proxy Proxy}
      # base class, the TCP Proxy also supports the following callbacks.
      #
      # ### client_connect
      #
      # When a client connects to the proxy:
      #
      #     on_client_connect do |client|
      #       puts "[connected] #{client.remote_address.ip_address}:#{client.remote_addre
      #     end
      #
      # ### client_disconnect
      #
      # When a client disconnects from the proxy:
      #
      #     on_client_disconnect do |client,server|
      #       puts "[disconnected] #{client.remote_address.ip_address}:#{client.remote_ad
      #     end
      #
      # ### server_connect
      #
      # When the server accepts a connection from the proxy:
      #
      #     on_server_connect do |client,server|
      #       puts "[connected] #{proxy}"
      #     end
      #
      # ### server_disconnect
      #
      # When the server closes a connection from the proxy.
      #
      #     on_server_disconnect do |client,server|
      #       puts "[disconnected] #{proxy}"
      #     end
      #
      # ### connect
      #
      # Alias for {#on_server_connect}.
      #
      # ### disconnect
      #
      # Alias for {#on_client_disconnect}.
      #
      # @since 0.5.0
      #
      class Proxy < Network::Proxy

        #
        # Creates a new TCP Proxy.
        #
        # @see Network::Proxy#initialize
        #
        def initialize(options={})
          super(options) do |proxy|
            @callbacks[:client_connect]    = []
            @callbacks[:client_disconnect] = []
            @callbacks[:server_connect]    = []
            @callbacks[:server_disconnect] = []

            yield proxy if block_given?
          end
        end

        #
        # Opens the proxy.
        #
        # @api public
        #
        def open
          @socket = TCPServer.new(@host,@port)
        end

        #
        # Polls the connections for data.
        #
        # @api public
        #
        def poll
          sockets = [@socket] + client_connections + server_connections

          readable, writtable, errors = IO.select(sockets,nil,sockets)

          (errors & client_connections).each do |client_socket|
            server_socket = server_connection_for(client_socket)

            client_disconnect(client_socket,server_socket)
          end

          (errors & server_connections).each do |server_socket|
            client_socket = client_connection_for(server_socket)

            server_disconnect(client_socket,server_socket)
          end

          (readable & client_connections).each do |client_socket|
            server_socket = server_connection_for(client_socket)
            data          = recv(client_socket)

            unless data.empty?
              client_data(client_socket,server_socket,data)
            else
              client_disconnect(client_socket,server_socket)
            end
          end

          (readable & server_connections).each do |server_socket|
            client_socket = client_connection_for(server_socket)
            data          = recv(server_socket)

            unless data.empty?
              server_data(client_socket,server_socket,data)
            else
              server_disconnect(client_socket,server_socket)
            end
          end

          if readable.include?(@socket)
            client_connect(accept_client_connection)
          end
        end

        #
        # Sends data to a connection.
        #
        # @param [TCPSocket] connection
        #   A TCP connection to write data to.
        # 
        # @param [String] data
        #   The data to write.
        #
        # @api public
        #
        def send(connection,data)
          connection.send(data,0)
        end

        #
        # Receives data from a connection.
        #
        # @param [TCPSocket] connection
        #   The TCP connection to receive data from.
        #
        # @return [String, nil]
        #   The received data.
        #
        # @api public
        #
        def recv(connection)
          connection.recv(@buffer_size)
        end

        #
        # Registers a callback for when a client connects.
        #
        # @yield [client]
        #   The block will be passed each newly connected client.
        #
        # @yieldparam [TCPSocket] client
        #   The connection from the client to the proxy.
        #
        # @example
        #   on_client_connect do |client|
        #     puts "[connected] #{client.remote_address.ip_address}:#{client.remote_address.ip_port}"
        #   end
        #
        # @api public
        #
        def on_client_connect(&block)
          @callbacks[:client_connect] << block
        end

        #
        # Registers a callback for when a client disconnects.
        #
        # @yield [client, server]
        #   The block will be passed each disconnected client and their
        #   connection to the server.
        #
        # @yieldparam [TCPSocket] client
        #   The connection from the client to the proxy.
        #
        # @yieldparam [TCPSocket] server
        #   The connection from the proxy to the server.
        #
        # @example
        #   on_client_disconnect do |client,server|
        #     puts "[disconnected] #{client.remote_address.ip_address}:#{client.remote_address.ip_port}"
        #   end
        #
        # @api public
        #
        def on_client_disconnect(&block)
          @callbacks[:client_disconnect] << block
        end

        alias on_disconnect on_client_disconnect

        #
        # Registers a callback for when the server accepts a connection.
        #
        # @yield [client, server]
        #   The block will be passed each connected client and their newly
        #   formed connection to the server.
        #
        # @yieldparam [TCPSocket] client
        #   The connection from the client to the proxy.
        #
        # @yieldparam [TCPSocket] server
        #   The connection from the proxy to the server.
        #
        # @example
        #   on_server_connect do |client,server|
        #     puts "[connected] #{proxy}"
        #   end
        #
        # @api public
        #
        def on_server_connect(&block)
          @callbacks[:server_connect] << block
        end

        alias on_connect on_server_connect

        #
        # Registers a callback for when the server closes a connection.
        #
        # @yield [client, server]
        #   The block will be passed the each client connection and the
        #   recently disconnected server connection.
        #
        # @yieldparam [TCPSocket] client
        #   The connection from the client to the proxy.
        #
        # @yieldparam [TCPSocket] server
        #   The connection from the proxy to the server.
        #
        # @example
        #   on_server_disconnect do |client,server|
        #     puts "[disconnected] #{proxy}"
        #   end
        #
        # @api public
        #
        def on_server_disconnect(&block)
          @callbacks[:server_disconnect] << block
        end

        protected

        #
        # Accepts a new client connection.
        #
        # @return [TCPSocket]
        #   A new connection.
        #
        # @since 0.6.0
        #
        def accept_client_connection
          @socket.accept
        end

        #
        # Creates a new connection to the server.
        #
        # @return [TCPSocket]
        #   A new connection.
        #
        def open_server_connection
          TCPSocket.new(@server_host,@server_port)
        end

        #
        # Closes a connection from the client.
        #
        # @param [TCPSocket] socket
        #   The connection from the client.
        #
        def close_client_connection(socket)
          socket.close
        end

        #
        # Closes a connection to the server.
        #
        # @param [TCPSocket] socket
        #   The connection to the server.
        #
        def close_server_connection(socket)
          socket.close
        end

        #
        # Closes the TCP proxy.
        #
        def close_proxy
          @socket.close
        end

        #
        # Triggers the `client_connect` event.
        #
        # @param [connection] client_connection
        #   The new connection from a client to the proxy.
        #
        def client_connect(client_connection)
          callback(:client_connect,client_connection) do
            server_connect(client_connection)
          end
        end

        #
        # Triggers the `client_disconnect` event.
        #
        # @param [connection] client_connection
        #   The connection from a client to the proxy.
        #
        # @param [connection] server_connection
        #   The connection from the proxy to the server.
        #
        def client_disconnect(client_connection,server_connection)
          callback(:client_disconnect,client_connection,server_connection) do
            close_connection(client_connection,server_connection)
          end
        end

        #
        # Triggers the `server_connect` event.
        #
        # @param [connection] client_connection
        #   The connection from a client to the proxy.
        #
        def server_connect(client_connection)
          server_connection = open_server_connection

          callback(:server_connect,client_connection,server_connection) do
            @connections[client_connection] = server_connection
          end
        end

        #
        # Triggers the `server_disconnect` event.
        #
        # @param [connection] client_connection
        #   The connection from a client to the proxy.
        #
        # @param [connection] server_connection
        #   The connection from the proxy to the server.
        #
        def server_disconnect(client_connection,server_connection)
          callback(:server_disconnect,client_connection,server_connection) do
            close_connection(client_connection)
          end
        end

      end
    end
  end
end
