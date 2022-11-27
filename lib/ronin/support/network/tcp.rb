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

require 'ronin/support/network/tcp/proxy'
require 'ronin/support/network/dns/idn'

require 'socket'
require 'timeout'

module Ronin
  module Support
    module Network
      #
      # @since 1.0.0
      #
      module TCP
        #
        # Tests whether a remote TCP port is open.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Integer] port
        #   The port to connect to.
        #
        # @param [Integer] timeout (5)
        #   The maximum time to attempt connecting.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {connect}.
        #
        # @option kwargs [String, nil] bind_host
        #   The local host to bind to.
        #
        # @option kwargs [Integer, nil] bind_port
        #   The local port to bind to.
        #
        # @return [Boolean, nil]
        #   Specifies whether the remote TCP port is open.
        #   If the connection was not accepted, `nil` will be returned.
        #
        # @example
        #   open?('example.com',80)
        #   # => true
        #
        # @example Using a timeout:
        #   TCP.open?('example.com',1111, timeout: 5)
        #   # => nil
        #
        # @api public
        #
        # @since 0.5.0
        #
        def self.open?(host,port, timeout: 5, **kwargs)
          begin
            Timeout.timeout(timeout) do
              socket = connect(host,port,**kwargs)
              socket.close
            end

            return true
          rescue Timeout::Error
            return nil
          rescue SocketError, SystemCallError
            return false
          end
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
        # @param [String, nil] bind_host
        #   The local host to bind to.
        #
        # @param [Integer, nil] bind_port
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
        #   TCP.connect('www.example.com',80)
        #   # => #<TCPSocket:fd 5, AF_INET, 192.168.122.165, 40364>
        #
        # @example
        #   TCP.connect('www.wired.com',80) do |socket|
        #     socket.write("GET /\n\n")
        #
        #     puts socket.readlines
        #   end
        #
        # @see https://rubydoc.info/stdlib/socket/TCPSocket
        #
        # @api public
        #
        def self.connect(host,port, bind_host: nil, bind_port: nil)
          host = DNS::IDN.to_ascii(host)
          port = port.to_i

          socket = if bind_host || bind_port
                     TCPSocket.new(host,port,bind_host.to_s,bind_port.to_i)
                   else
                     TCPSocket.new(host,port)
                   end

          if block_given?
            yield socket
            socket.close
          else
            return socket
          end
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
        #   Additional keyword arguments for {connect}.
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
        def self.connect_and_send(data,host,port,**kwargs)
          socket = connect(host,port,**kwargs)
          socket.write(data)

          yield socket if block_given?
          return socket
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
        #   Additional keyword arguments for {connect}.
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
        #   TCP.banner('pop.gmail.com',25)
        #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
        #
        # @api public
        #
        def self.banner(host,port,**kwargs)
          banner = nil

          connect(host,port,**kwargs) do |socket|
            banner = socket.readline.strip
          end

          yield banner if block_given?
          return banner
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
        #   Additional keyword arguments for {connect}.
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
        #   TCP.send(buffer,'victim.com',80)
        #   # => true
        #
        # @api public
        #
        def self.send(data,host,port,**kwargs)
          connect(host,port,**kwargs) do |socket|
            socket.write(data)
          end

          return true
        end

        #
        # Creates a new TCPServer listening on a given host and port.
        #
        # @param [Integer, nil] port
        #   The local port to listen on.
        #
        # @param [String, nil] host
        #   The host to bind to.
        #
        # @param [Integer] backlog
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
        #   server = TCP.server(port: 1337)
        #
        # @see https://rubydoc.info/stdlib/socket/TCPServer
        #
        # @api public
        #
        def self.server(port: 0, host: nil, backlog: 5)
          server = if host
                     TCPServer.new(host.to_s,port.to_i)
                   else
                     TCPServer.new(port.to_i)
                   end
          server.listen(backlog)

          yield server if block_given?
          return server
        end

        #
        # Creates a new temporary TCPServer listening on a host and port.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {server}.
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
        #   TCP.server_session(port: 1337) do |server|
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
        def self.server_session(**kwargs,&block)
          server = server(**kwargs,&block)
          server.close()
          return nil
        end

        #
        # Creates a new TCPServer listening on a given host and port,
        # accepting clients in a loop.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {server}.
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
        #   TCP.server_loop(port: 1337) do |client|
        #     client.puts 'lol'
        #   end
        #
        # @api public
        #
        # @since 0.5.0
        #
        def self.server_loop(**kwargs)
          server_session(**kwargs) do |server|
            loop do
              client = server.accept

              yield client if block_given?
              client.close
            end
          end
        end

        #
        # Creates a new TCPServer listening on a given host and port,
        # accepts only one client and then stops listening.
        #
        # @param [Integer] backlog
        #   The maximum backlog of pending connections.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {server}.
        #
        # @option kwargs [Integer, nil] :port
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
        #   TCP.accept(port: 1337) do |client|
        #     client.puts 'lol'
        #   end
        #
        # @api public
        #
        # @since 0.5.0
        #
        def self.accept(backlog: 1, **kwargs)
          server_session(backlog: backlog, **kwargs) do |server|
            client = server.accept

            yield client if block_given?
            client.close
          end
        end
      end
    end
  end
end
