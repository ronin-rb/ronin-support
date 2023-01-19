# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/tcp'

module Ronin
  module Support
    module Network
      module TCP
        #
        # Provides helper methods for using the TCP protocol.
        #
        module Mixin
          #
          # Tests whether a remote TCP port is open.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#tcp_connect}.
          #
          # @option kwargs [String, nil] bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer, nil] bind_port
          #   The local port to bind to.
          #
          # @option kwargs [Integer] :timeout (5)
          #   The maximum time to attempt connecting.
          #
          # @return [Boolean, nil]
          #   Specifies whether the remote TCP port is open.
          #   If the connection was not accepted, `nil` will be returned.
          #
          # @example
          #   tcp_open?('example.com',80)
          #   # => true
          #
          # @example Using a timeout:
          #   tcp_open?('example.com',1111, timeout: 5)
          #   # => nil
          #
          # @api public
          #
          # @see TCP.open?
          #
          # @since 0.5.0
          #
          def tcp_open?(host,port,**kwargs)
            TCP.open?(host,port,**kwargs)
          end

          #
          # Creates a new TCP socket connected to a given host and port.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {TCP.connect}.
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
          # @yieldparam [TCPsocket] socket
          #   The newly created TCP socket.
          #
          # @return [TCPSocket, nil]
          #   The newly created TCPSocket object. If a block is given a `nil`
          #   will be returned.
          #
          # @example
          #   tcp_connect('www.example.com',80)
          #   # => #<TCPSocket:fd 5, AF_INET, 192.168.122.165, 40364>
          #
          # @example
          #   tcp_connect('www.wired.com',80) do |socket|
          #     socket.write("GET /\n\n")
          #
          #     puts socket.readlines
          #   end
          #
          # @see TCP.connect
          # @see https://rubydoc.info/stdlib/socket/TCPSocket
          #
          # @api public
          #
          def tcp_connect(host,port,**kwargs,&block)
            TCP.connect(host,port,**kwargs,&block)
          end

          #
          # Creates a new TCPSocket object, connected to a given host and port.
          # The given data will then be written to the newly created TCPSocket.
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
          #   Additional keyword arguments for {#tcp_connect}.
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
          # @yieldparam [TCPSocket] socket
          #   The newly created TCPSocket object.
          #
          # @return [TCPSocket]
          #   The newly created TCPSocket object.
          #
          # @api public
          #
          def tcp_connect_and_send(data,host,port,**kwargs,&block)
            TCP.connect_and_send(data,host,port,**kwargs,&block)
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
          #   Additional keyword arguments for {#tcp_connect}.
          #
          # @option kwargs [String] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer] :bind_port
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
          # @example
          #   tcp_banner('pop.gmail.com',25)
          #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
          #
          # @see TCP.banner
          #
          # @api public
          #
          def tcp_banner(host,port,**kwargs,&block)
            TCP.banner(host,port,**kwargs,&block)
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
          #   Additional keyword arguments for {#tcp_connect}.
          #
          # @option kwargs [String] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer] :bind_port
          #   The local port to bind to.
          #
          # @return [true]
          #   The data was successfully sent.
          #
          # @example
          #   buffer = "GET /" + ('A' * 4096) + "\n\r"
          #   tcp_send(buffer,'victim.com',80)
          #   # => true
          #
          # @api public
          #
          # @see TCP.send
          #
          def tcp_send(data,host,port,**kwargs)
            TCP.send(data,host,port,**kwargs)
          end

          #
          # Creates a new TCPServer listening on a given host and port.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {TCP.server}.
          #
          # @option kwargs [Integer, nil] :port (0)
          #   The local port to listen on.
          #
          # @option kwargs [String, nil] :host
          #   The host to bind to.
          #
          # @option kwargs [Integer] :backlog (5)
          #   The maximum backlog of pending connections.
          #
          # @yield [server]
          #   The block which will be called after the server has been created.
          #
          # @yieldparam [TCPServer] server
          #   The newly created TCP server.
          #
          # @return [TCPServer]
          #   The new TCP server.
          #
          # @example
          #   tcp_server(port: 1337)
          #
          # @see https://rubydoc.info/stdlib/socket/TCPServer
          #
          # @api public
          #
          # @see TCP.server
          #
          def tcp_server(**kwargs,&block)
            TCP.server(**kwargs,&block)
          end

          #
          # Creates a new temporary TCPServer listening on a host and port.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {TCP.server_session}.
          #
          # @option kwargs [Integer, nil] :port (0)
          #   The local port to bind to.
          #
          # @option kwargs [String, nil] :host
          #   The host to bind to.
          #
          # @option kwargs [Integer] :backlog (5)
          #   The maximum backlog of pending connections.
          #
          # @yield [server]
          #   The block which will be called after the server has been created.
          #   After the block has finished, the server will be closed.
          #
          # @yieldparam [TCPServer] server
          #   The newly created TCP server.
          #
          # @return [nil]
          #
          # @example
          #   tcp_server_session(port: 1337) do |server|
          #     client1 = server.accept
          #     client2 = server.accept
          #
          #     client2.write(server.read_line)
          #
          #     client1.close
          #     client2.close
          #   end
          #
          # @api public
          #
          # @see TCP.server_session
          #
          def tcp_server_session(**kwargs,&block)
            TCP.server_session(**kwargs,&block)
          end

          #
          # Creates a new TCPServer listening on a given host and port,
          # accepting clients in a loop.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {TCP.server_loop}.
          #
          # @option kwargs [Integer, nil] :port (0)
          #   The local port to bind to.
          #
          # @option kwargs [String, nil] :host
          #   The host to bind to.
          #
          # @option kwargs [Integer] :backlog (5)
          #   The maximum backlog of pending connections.
          #
          # @yield [client]
          #   The given block will be passed the newly connected client.
          #   After the block has finished, the client will be closed.
          #
          # @yieldparam [TCPSocket] client
          #   A newly connected client.
          #
          # @return [nil]
          #
          # @example
          #   tcp_server_loop(port: 1337) do |client|
          #     client.puts 'lol'
          #   end
          #
          # @api public
          #
          # @see TCP.server_loop
          #
          # @since 0.5.0
          #
          def tcp_server_loop(**kwargs,&block)
            TCP.server_loop(**kwargs,&block)
          end

          #
          # Creates a new TCPServer listening on a given host and port,
          # accepts only one client and then stops listening.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {TCP.accept}.
          #
          # @option kwargs [Integer] :backlog (1)
          #   The maximum backlog of pending connections.
          #
          # @option kwargs [Integer, nil] :port (0)
          #   The local port to bind to.
          #
          # @option kwargs [String, nil] :host
          #   The host to bind to.
          #
          # @yield [client]
          #   The given block will be passed the newly connected client.
          #   After the block has finished, both the client and the server
          #   will be closed.
          #
          # @yieldparam [TCPSocket] client
          #   The newly connected client.
          #
          # @return [nil]
          #
          # @example
          #   tcp_accept(port: 1337) do |client|
          #     client.puts 'lol'
          #   end
          #
          # @api public
          #
          # @see TCP.accept
          #
          # @since 0.5.0
          #
          def tcp_accept(**kwargs,&block)
            TCP.accept(**kwargs,&block)
          end
        end
      end
    end
  end
end
