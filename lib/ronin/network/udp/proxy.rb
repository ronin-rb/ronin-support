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

require 'ronin/network/proxy'

require 'socket'

module Ronin
  module Network
    module UDP
      #
      # The UDP Proxy allows for inspecting and manipulating UDP protocols.
      #
      # ## Example
      #
      #     require 'ronin/network/udp/proxy'
      #     require 'hexdump'
      #
      #     Ronin::Network::UDP::Proxy.start(:port => 1337, :server => ['4.2.2.1', 53]) do |proxy|
      #       hex = Hexdump::Dumper.new
      #
      #       proxy.on_client_data do |(client,(host,port)),server,data|
      #         puts "#{host}:#{port} -> #{proxy}"
      #         hex.dump(data)
      #       end
      #
      #       proxy.on_server_data do |(client,(host,port)),server,data|
      #         puts "#{host}:#{port} <- #{proxy}"
      #         hex.dump(data)
      #       end
      #     
      #     end
      #
      # @since 0.5.0
      #
      class Proxy < Network::Proxy

        #
        # Opens the UDP Proxy.
        #
        # @api public
        #
        def open
          @socket = UDPSocket.new
          @socket.bind(@host,@port)
        end

        #
        # Polls the connections for data/errors and the proxy socket for
        # new client connections.
        #
        # @api public
        #
        def poll
          sockets = [@socket] + server_connections

          readable, writtable, errors = IO.select(sockets,nil,sockets)

          (errors & server_connections).each do |server_socket|
            client_socket = client_connection_for(server_socket)

            close_connection(client_socket,server_socket)
          end

          (readable & server_connections).each do |server_socket|
            client_socket  = client_connection_for(server_socket)
            data, addrinfo = recv(server_socket)

            server_data(client_socket,server_socket,data)
          end

          if readable.include?(@socket)
            data, addrinfo = recv(@socket)

            client_socket = [@socket, [addrinfo[3], addrinfo[1]]]
            server_socket = (@connections[client_socket] ||= open_server_connection)

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
        # @api public
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
        # @api public
        #
        def recv(connection)
          case connection
          when Array
            socket, (host, port) = connection

            socket.recvfrom(@buffer_size)
          when UDPSocket
            connection.recvfrom(@buffer_size)
          end
        end

        protected

        #
        # Creates a new connection from the proxy to the server.
        #
        # @return [UDPSocket]
        #   The new UDPSocket to the server.
        #
        def open_server_connection
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
          @socket.close
        end

      end
    end
  end
end
