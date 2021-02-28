#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'socket'
require 'timeout'

module Ronin
  module Network
    #
    # Provides helper methods for using the UDP protocol.
    #
    module UDP
      #
      # Tests whether a remote UDP port is open.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [String] local_host (nil)
      #   The local host to bind to.
      #
      # @param [Integer] local_port (nil)
      #   The local port to bind to.
      #
      # @param [Integer] timeout (5)
      #   The maximum time to attempt connecting.
      #
      # @return [Boolean, nil]
      #   Specifies whether the remote UDP port is open.
      #   If no data or ICMP error were received, `nil` will be returned.
      #
      # @example
      #   udp_open?('4.2.2.1',53)
      #   # => true
      #
      # @example Using a timeout:
      #   udp_open?('example.com',1111,nil,nil,5)
      #   # => nil
      #
      # @api public
      #
      # @since 0.5.0
      #
      def udp_open?(host,port,local_host=nil,local_port=nil,timeout=nil)
        timeout ||= 5

        begin
          Timeout.timeout(timeout) do
            udp_session(host,port,local_host,local_port) do |socket|
              # send an empty UDP packet, just like nmap
              socket.syswrite('')

              # send an empty UDP packet again, to elicit an Errno::ECONNREFUSED
              socket.syswrite('')
            end
          end

          return true
        rescue Timeout::Error
          return nil
        rescue SocketError, SystemCallError
          return false
        end
      end

      #
      # Creates a new UDPSocket object connected to a given host and port.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [String] local_host (nil)
      #   The local host to bind to.
      #
      # @param [Integer] local_port (nil)
      #   The local port to bind to.
      #
      # @yield [socket]
      #   If a block is given, it will be passed the newly created socket.
      #
      # @yieldparam [UDPsocket] socket
      #   The newly created UDPSocket object.
      #
      # @return [UDPSocket]
      #   The newly created UDPSocket object.
      #
      # @example
      #   udp_connect('www.hackety.org',80)
      #   # => UDPSocket
      #
      # @example
      #   udp_connect('www.wired.com',80) do |socket|
      #     puts socket.readlines
      #   end
      #
      # @see https://rubydoc.info/stdlib/socket/UDPSocket
      #
      # @api public
      #
      def udp_connect(host,port,local_host=nil,local_port=nil)
        host = host.to_s
        port = port.to_i

        socket = UDPSocket.new

        if local_host || local_port
          local_host = local_host.to_s
          local_port = local_port.to_i

          socket.bind(local_host,local_port)
        end

        socket.connect(host,port)

        yield socket if block_given?
        return socket
      end

      #
      # Creates a new UDPSocket object, connected to a given host and port.
      # The given data will then be written to the newly created UDPSocket.
      #
      # @param [String] data
      #   The data to send through the connection.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [String] local_host (nil)
      #   The local host to bind to.
      #
      # @param [Integer] local_port (nil)
      #   The local port to bind to.
      #
      # @yield [socket]
      #   If a block is given, it will be passed the newly created socket.
      #
      # @yieldparam [UDPsocket] socket
      #   The newly created UDPSocket object.
      #
      # @return [UDPSocket]
      #   The newly created UDPSocket object.
      #
      # @api public
      #
      def udp_connect_and_send(data,host,port,local_host=nil,local_port=nil)
        socket = udp_connect(host,port,local_host,local_port)
        socket.write(data)

        yield socket if block_given?
        return socket
      end

      #
      # Creates a new temporary UDPSocket object, connected to the given host
      # and port.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [String] local_host (nil)
      #   The local host to bind to.
      #
      # @param [Integer] local_port (nil)
      #   The local port to bind to.
      #
      # @yield [socket]
      #   If a block is given, it will be passed the newly created socket.
      #   After the block has returned, the socket will then be closed.
      #
      # @yieldparam [UDPsocket] socket
      #   The newly created UDPSocket object.
      #
      # @return [nil]
      #
      # @api public
      #
      def udp_session(host,port,local_host=nil,local_port=nil)
        socket = udp_connect(host,port,local_host,local_port)

        yield socket if block_given?
        socket.close
        return nil
      end

      #
      # Connects to a specified host and port, sends the given data and then
      # closes the connection.
      #
      # @param [String] data
      #   The data to send through the connection.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [String] local_host (nil)
      #   The local host to bind to.
      #
      # @param [Integer] local_port (nil)
      #   The local port to bind to.
      #
      # @return [true]
      #   The data was successfully sent.
      #
      # @example
      #   buffer = "GET /" + ('A' * 4096) + "\n\r"
      #   udp_send(buffer,'victim.com',80)
      #   # => true
      #
      # @api public
      #
      # @since 0.4.0
      #
      def udp_send(data,host,port,local_host=nil,local_port=nil)
        udp_session(host,port,local_host,local_port) do |socket|
          socket.write(data)
        end

        return true
      end

      #
      # Reads the banner from the service running on the given host and port.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [String] local_host (nil)
      #   The local host to bind to.
      #
      # @param [Integer] local_port (nil)
      #   The local port to bind to.
      #
      # @yield [banner]
      #   If a block is given, it will be passed the grabbed banner.
      #
      # @yieldparam [String] banner
      #   The grabbed banner.
      #
      # @return [String]
      #   The grabbed banner.
      #
      # @api public
      #
      def udp_banner(host,port,local_host=nil,local_port=nil)
        banner = nil

        udp_session(host,port,local_host,local_port) do |socket|
          banner = socket.readline
        end

        yield banner if block_given?
        return banner
      end

      #
      # Creates a new UDPServer listening on a given host and port.
      #
      # @param [Integer] port (nil)
      #   The local port to listen on.
      #
      # @param [String] host (nil)
      #   The host to bind to.
      #
      # @return [UDPServer]
      #   The new UDP server.
      #
      # @example
      #   udp_server(1337)
      #
      # @see https://rubydoc.info/stdlib/socket/UDPSocket
      #
      # @api public
      #
      def udp_server(port=nil,host=nil)
        port   = port.to_i
        host   = host.to_s

        server = UDPSocket.new
        server.bind(host,port)

        yield server if block_given?
        return server
      end

      #
      # Creates a new temporary UDPServer listening on a given host and port.
      #
      # @param [Integer] port (nil)
      #   The local port to bind to.
      #
      # @param [String] host (nil)
      #   The host to bind to.
      #
      # @yield [server]
      #   The block which will be called after the server has been created.
      #   After the block has finished, the server will be closed.
      #
      # @yieldparam [UDPServer] server
      #   The newly created UDP server.
      #
      # @return [nil]
      #
      # @example
      #   udp_server_session(1337) do |server|
      #     data, sender = server.recvfrom(1024)
      #   end
      #
      # @api public
      #
      def udp_server_session(port=nil,host=nil,&block)
        server = udp_server(port,host,&block)
        server.close()
        return nil
      end

      #
      # Creates a new UDPServer listening on a given host and port,
      # accepting messages from clients in a loop.
      #
      # @param [Integer] port (nil)
      #   The port the UDPServer will listen on.
      #
      # @param [String] host (nil)
      #   The optional host the UDPServer will bind to.
      #
      # @yield [server, (client_host, client_port), mesg]
      #   The given block will be passed the client host/port and the received
      #   message.
      #
      # @yieldparam [UDPServer] server
      #   The UDPServer.
      #
      # @yieldparam [String] client_host
      #   The source host of the message.
      #
      # @yieldparam [Integer] client_port
      #   The source port of the message.
      #
      # @yieldparam [String] mesg
      #   The received message.
      #
      # @return [nil]
      #
      # @example
      #   udp_server_loop(1337) do |server,(host,port),mesg|
      #     server.send('hello',host,port)
      #   end
      #
      # @api public
      #
      # @since 0.5.0
      #
      def udp_server_loop(port=nil,host=nil)
        udp_server_session(port,host) do |server|
          loop do
            mesg, addrinfo = server.recvfrom(4096)

            yield server, [addrinfo[3], addrinfo[1]], mesg if block_given?
          end
        end
      end

      #
      # Creates a new UDPServer listening on a given host and port,
      # accepts only one message from a client.
      #
      # @param [Integer] port (nil)
      #   The port the UDPServer will listen on.
      #
      # @param [String] host (nil)
      #   The optional host the UDPServer will bind to.
      #
      # @yield [server, (client_host, client_port), mesg]
      #   The given block will be passed the client host/port and the received
      #   message.
      #
      # @yieldparam [UDPServer] server
      #   The UDPServer.
      #
      # @yieldparam [String] client_host
      #   The source host of the message.
      #
      # @yieldparam [Integer] client_port
      #   The source port of the message.
      #
      # @yieldparam [String] mesg
      #   The received message.
      #
      # @return [nil]
      #
      # @example
      #   udp_recv(1337) do |server,(host,port),mesg|
      #     server.send('hello',host,port)
      #   end
      #
      # @api public
      #
      # @since 0.5.0
      #
      def udp_recv(port=nil,host=nil)
        udp_server_session(port,host) do |server|
          mesg, addrinfo = server.recvfrom(4096)

          yield server, [addrinfo[3], addrinfo[1]], mesg if block_given?
        end
      end

      #
      # @deprecated
      #   Deprecated as of 0.5.0. Use {#udp_recv} instead.
      #
      def udp_single_server(port=nil,host=nil)
        udp_recv(port,host)
      end
    end
  end
end
