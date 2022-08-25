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

require 'ronin/support/network/udp'

module Ronin
  module Support
    module Network
      module UDP
        #
        # Provides helper methods for using the UDP protocol.
        #
        module Mixin
          #
          # Tests whether a remote UDP port is open.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#udp_connect}.
          #
          # @option kwargs [Integer] :timeout (5)
          #   The maximum time to attempt connecting.
          #
          # @option kwargs [String, nil] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer, nil] :bind_port
          #   The local port to bind to.
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
          #   udp_open?('example.com',1111, timeout: 5)
          #   # => nil
          #
          # @api public
          #
          # @see UDP.open?
          #
          # @since 0.5.0
          #
          def udp_open?(host,port,**kwargs)
            UDP.open?(host,port,**kwargs)
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
          # @option kwargs [String, nil] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer, nil] :bind_port
          #   The local port to bind to.
          #
          # @yield [socket]
          #   If a block is given, it will be passed the newly created socket.
          #   Once the block returns the socket will be closed.
          #
          # @yieldparam [UDPsocket] socket
          #   The newly created UDP socket.
          #
          # @return [UDPSocket, nil]
          #   The newly created UDP socket object. If a block is given a `nil`
          #   will be returned.
          #
          # @example
          #   udp_connect('8.8.8.8',53)
          #   # => #<UDPSocket:fd 5, AF_INET, 192.168.122.165, 48313>
          #
          # @example
          #   udp_connect('8.8.8.8',53) do |socket|
          #     # ...
          #   end
          #
          # @see UDP.connect
          # @see https://rubydoc.info/stdlib/socket/UDPSocket
          #
          # @api public
          #
          def udp_connect(host,port,**kwargs,&block)
            UDP.connect(host,port,**kwargs,&block)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#udp_connect}.
          #
          # @option kwargs [String, nil] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer, nil] :bind_port
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
          # @see UDP.connect_and_send
          #
          def udp_connect_and_send(data,host,port,**kwargs,&block)
            UDP.connect_and_send(data,host,port,**kwargs,&block)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#udp_connect}.
          #
          # @option kwargs [String, nil] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer, nil] :bind_port
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
          # @see UDP.send
          #
          # @since 0.4.0
          #
          def udp_send(data,host,port,**kwargs)
            UDP.send(data,host,port,**kwargs)
          end

          #
          # Reads the banner from the service running on the given host and
          # port.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#udp_connect}.
          #
          # @option kwargs [String, nil] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer, nil] :bind_port
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
          # @see UDP.banner
          #
          def udp_banner(host,port,**kwargs,&block)
            UDP.banner(host,port,**kwargs,&block)
          end

          #
          # Creates a new UDPServer listening on a given host and port.
          #
          # @param [Integer, nil] port
          #   The local port to listen on.
          #
          # @param [String, nil] host
          #   The host to bind to.
          #
          # @return [UDPServer]
          #   The new UDP server.
          #
          # @example
          #   udp_server(port: 1337)
          #
          # @see https://rubydoc.info/stdlib/socket/UDPSocket
          #
          # @api public
          #
          # @see UDP.server
          #
          def udp_server(**kwargs,&block)
            UDP.server(**kwargs,&block)
          end

          #
          # Creates a new temporary UDPServer listening on a given host and
          # port.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional arguments for {#udp_server}.
          #
          # @option kwargs [Integer, nil] :port
          #   The local port to bind to.
          #
          # @option kwargs [String, nil] :host
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
          #   udp_server_session(port: 1337) do |server|
          #     data, sender = server.recvfrom(1024)
          #   end
          #
          # @api public
          #
          # @see UDP.server_session
          #
          def udp_server_session(**kwargs,&block)
            UDP.server_session(**kwargs,&block)
          end

          #
          # Creates a new UDPServer listening on a given host and port,
          # accepting messages from clients in a loop.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional arguments for {#udp_server}.
          #
          # @option kwargs [Integer, nil] :port
          #   The local port to bind to.
          #
          # @option kwargs [String, nil] :host
          #   The host to bind to.
          #
          # @yield [server, (client_host, client_port), mesg]
          #   The given block will be passed the client host/port and the
          #   received message.
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
          #   udp_server_loop(port: 1337) do |server,(host,port),mesg|
          #     server.send('hello',host,port)
          #   end
          #
          # @api public
          #
          # @see UDP.server_loop
          #
          # @since 0.5.0
          #
          def udp_server_loop(**kwargs,&block)
            UDP.server_loop(**kwargs,&block)
          end

          #
          # Creates a new UDPServer listening on a given host and port,
          # accepts only one message from a client.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional arguments for {#udp_server}.
          #
          # @option kwargs [Integer, nil] :port
          #   The local port to bind to.
          #
          # @option kwargs [String, nil] :host
          #   The host to bind to.
          #
          # @yield [server, (client_host, client_port), mesg]
          #   The given block will be passed the client host/port and the
          #   received message.
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
          #   udp_recv(port: 1337) do |server,(host,port),mesg|
          #     server.send('hello',host,port)
          #   end
          #
          # @api public
          #
          # @see UDP.recv
          #
          # @since 0.5.0
          #
          def udp_recv(**kwargs,&block)
            UDP.recv(**kwargs,&block)
          end
        end
      end
    end
  end
end
