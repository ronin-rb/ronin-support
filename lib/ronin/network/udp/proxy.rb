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
    module UDP
      class Proxy < Network::Proxy

        #
        # Opens the UDP Proxy.
        #
        def open
          @proxy_socket = UDPSocket.new
          @proxy_socket.bind(@proxy_host,@proxy_port)
        end

        #
        # Polls the connections for data/errors and the proxy socket for
        # new client connections.
        #
        def poll
          server_sockets = @connections.values
          sockets = [@proxy_socket] + server_sockets

          readable, writtable, errors = IO.select(sockets,nil,sockets)

          (errors & server_sockets).each do |server_socket|
            client_socket = @connections.key(server_socket)

            close_connection(client_socket,server_socket)
          end

          (readable & server_sockets).each do |server_socket|
            client_socket  = @connections.key(server_socket)
            data, addrinfo = recv(server_socket)

            server_data(client_socket,server_socket,data)
          end

          if readable.include?(@proxy_socket)
            data, addrinfo = recv(@proxy_socket)

            client_socket = [@proxy_socket, [addrinfo[3], addrinfo[1]]]
            server_socket = (@connections[client_socket] ||= new_server_connection)

            client_data(client_socket,server_socket,data)
          end
        end

        #
        # Sends data to a connection.
        #
        # @param [UDPSocket, (UDPSocket, (String, Integer))] connection
        #   The connection from the proxy to the server, or the proxy socket
        #   and host/port of the client.
        #
        # @param [String] data
        #   The data to be sent.
        #
        def send(connection,data)
          case connection
          when Array
            socket, (host, port) = connection

            socket.send(data,0,host,port)
          when UDPSocket
            connection.send(data,0)
          end
        end

        #
        # Receives data from a connection.
        #
        # @param [UDPSocket, (UDPSocket, (String, Integer))] connection
        #   The connection from the proxy to the server, or the proxy socket
        #   and the address of a client.
        #
        # @return [String, (String, Array)]
        #   The data received.
        #
        def recv(connection)
          case connection
          when Array
            socket, (host, port) = connection

            socket.recvfrom(@buffer_size)
          when UDPSocket
            socket.recv(@buffer_size)
          end
        end

        protected

        #
        # Creates a new connection from the proxy to the server.
        #
        # @return [UDPSocket]
        #   The new UDPSocket to the server.
        #
        def new_server_connection
          socket = UDPSocket.new
          socket.connect(@server_host,@server_port)

          return socket
        end

        #
        # Closes a connection from the client to the proxy.
        #
        # @param [(UDPSocket, (String, Integer))] connection
        #   The UDP Proxy socket and the host/port of the client.
        #
        # @note no-op
        #
        def close_client_connection(connection)
          # no-op
        end

        #
        # Closes the connection from the proxy to the server.
        #
        # @param [UDPSocket] connection
        #   The UDPSocket from the proxy to the server.
        #
        def close_server_connection(connection)
          connection.close
        end

        #
        # Closes the UDP proxy socket.
        #
        def close_proxy
          @proxy_socket.close
        end

      end
    end
  end
end
