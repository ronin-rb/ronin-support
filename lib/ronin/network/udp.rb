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

require 'socket'

module Ronin
  module Network
    #
    # Provides helper methods for using the UDP protocol.
    #
    module UDP
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
      #   udp_connect('www.wired.com',80) do |sock|
      #     puts sock.readlines
      #   end
      #
      # @api public
      #
      def udp_connect(host,port,local_host=nil,local_port=nil)
        host = host.to_s
        local_host = if local_host
                       local_host.to_s
                     end

        socket = UDPSocket.new
        socket.bind(local_host,local_port) if (local_host && local_port)
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
        sock = udp_connect(host,port,local_host,local_port)
        sock.write(data)

        yield sock if block_given?
        return sock
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
        sock = udp_connect(host,port,local_host,local_port)

        yield sock if block_given?

        sock.close
        return nil
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

        udp_session(host,port,local_host,local_port) do |sock|
          banner = sock.readline
        end

        yield banner if block_given?
        return banner
      end

      #
      # Creates a new UDPServer listening on a given host and port.
      #
      # @param [Integer] port
      #   The local port to listen on.
      #
      # @param [String] host ('0.0.0.0')
      #   The host to bind to.
      #
      # @return [UDPServer]
      #   The new UDP server.
      #
      # @example
      #   udp_server(1337)
      #
      # @api public
      #
      def udp_server(port,host='0.0.0.0')
        host   = host.to_s
        server = UDPSocket.new

        server.bind(host,port)

        yield server if block_given?
        return server
      end

      #
      # Creates a new temporary UDPServer listening on a given host and port.
      #
      # @param [Integer] port
      #   The local port to bind to.
      #
      # @param [String] host ('0.0.0.0')
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
      def udp_server_session(port,host='0.0.0.0',&block)
        server = udp_server(port,host,&block)

        server.close()
        return nil
      end
    end
  end
end
