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

require 'ronin/network/mixins/mixin'
require 'ronin/network/tcp'

module Ronin
  module Network
    module Mixins
      #
      # Adds TCP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - TCP host.
      # * `port` (`Integer`) - TCP port.
      # * `local_host` (`String`) - TCP local host.
      # * `local_port` (`Integer`) - TCP local port.
      # * `server_host` (`String`) - TCP server host.
      # * `server_port` (`Integer`) - TCP server port.
      #
      module TCP
        include Mixin, Network::TCP

        # TCP host
        parameter :host, type:        String,
                         description: 'TCP host'

        # TCP port
        parameter :port, type:        Integer,
                         description: 'TCP port'

        # TCP local host
        parameter :local_host, type:        String,
                               description: 'TCP local host'

        # TCP local port
        parameter :local_port, type:        Integer,
                               description: 'TCP local port'

        # TCP server host
        parameter :server_host, type:        String,
                                default:     '0.0.0.0',
                                description: 'TCP server host'

        # TCP server port
        parameter :server_port, type:        Integer,
                                description: 'TCP server port'

        #
        # Tests whether the TCP port is open.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Integer] port
        #   The port to connect to. Defaults to {#port}.
        #
        # @param [String] local_host
        #   The local host to bind to. Defaults to {#local_host}.
        #
        # @param [Integer] local_port
        #   The local port to bind to. Defaults to {#local_port}.
        #
        # @param [Integer] timeout
        #   The maximum time to attempt connecting.
        #
        # @return [Boolean, nil]
        #   Specifies whether the remote TCP port is open.
        #   If the connection was not accepted, `nil` will be returned.
        #
        # @see Network::TCP#tcp_open?
        #
        # @api public
        #
        # @since 0.5.0
        #
        def tcp_open?(host=nil,port=nil,local_host=nil,local_port=nil,timeout=nil)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_info "Testing if #{host}:#{port} is open ..."

          return super(host,port,local_host,local_port,timeout)
        end

        #
        # Creates a new TCP socket connected to a given host and port.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Integer] port
        #   The port to connect to. Defaults to {#port}.
        #
        # @param [String] local_host
        #   The local host to bind to. Defaults to {#local_host}.
        #
        # @param [Integer] local_port
        #   The local port to bind to. Defaults to {#local_port}.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #
        # @yieldparam [TCPsocket] socket
        #   The newly created TCP socket.
        #
        # @return [TCPSocket]
        #   The newly created TCP socket.
        #
        # @example
        #   tcp_connect # => TCPSocket
        #
        # @example
        #   tcp_connect do |socket|
        #     socket.write("GET / HTTP/1.1\n\r\n\r")
        #
        #     puts socket.readlines
        #     socket.close
        #   end
        #
        # @see Network::TCP#tcp_connect
        #
        # @api public
        #
        def tcp_connect(host=nil,port=nil,local_host=nil,local_port=nil,&block)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_info "Connecting to #{host}:#{port} ..."

          return super(host,port,self.local_host,self.local_port,&block)
        end

        #
        # Creates a new TCP socket, connected to a given host and port.
        # The given data will then be written to the newly created socket.
        #
        # @param [String] data
        #   The data to send through the connection.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Integer] port
        #   The port to connect to. Defaults to {#port}.
        #
        # @param [String] local_host
        #   The local host to bind to. Defaults to {#local_host}.
        #
        # @param [Integer] local_port
        #   The local port to bind to. Defaults to {#local_port}.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #
        # @yieldparam [TCPsocket] socket
        #   The newly created TCP socket.
        #
        # @return [TCPSocket]
        #   The newly created TCP socket.
        #
        # @see Network::TCP#tcp_connect_and_send
        #
        # @api public
        #
        def tcp_connect_and_send(data,host=nil,port=nil,local_host=nil,local_port=nil,&block)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_debug "Sending data: #{data.inspect} ..."

          return super(data,host,port,local_host,local_port,&block)
        end

        #
        # Creates a new temporary TCP socket, connected to the given host
        # and port.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Integer] port
        #   The port to connect to. Defaults to {#port}.
        #
        # @param [String] local_host
        #   The local host to bind to. Defaults to {#local_host}.
        #
        # @param [Integer] local_port
        #   The local port to bind to. Defaults to {#local_port}.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #   After the block has returned, the socket will be closed.
        #
        # @yieldparam [TCPsocket] socket
        #   The newly created TCP socket.
        #
        # @return [nil]
        #
        # @see Network::TCP#tcp_session
        #
        # @api public
        #
        def tcp_session(host=nil,port=nil,local_host=nil,local_port=nil,&block)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          super(host,port,local_host,local_port,&block)

          print_info "Disconnected from #{host}:#{port}"
          return nil
        end

        #
        # Reads the banner from the service running on the given host and port.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Integer] port
        #   The port to connect to. Defaults to {#port}.
        #
        # @param [String] local_host
        #   The local host to bind to. Defaults to {#local_host}.
        #
        # @param [Integer] local_port
        #   The local port to bind to. Defaults to {#local_port}.
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
        #   tcp_banner
        #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
        #
        # @see Network::TCP#tcp_banner
        #
        # @api public
        #
        def tcp_banner(host=nil,port=nil,local_host=nil,local_port=nil,&block)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_debug "Grabbing banner from #{host}:#{port}"

          return super(host,port,local_host,local_port,&block)
        end

        #
        # Connects to a specified host and port, sends the given data and then
        # closes the connection.
        #
        # @param [String] data
        #   The data to send through the connection.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Integer] port
        #   The port to connect to. Defaults to {#port}.
        #
        # @param [String] local_host
        #   The local host to bind to. Defaults to {#local_host}.
        #
        # @param [Integer] local_port
        #   The local port to bind to. Defaults to {#local_port}.
        #
        # @return [true]
        #   The data was successfully sent.
        #
        # @example
        #   buffer = "GET /#{'A' * 4096}\n\r"
        #   tcp_send(buffer)
        #   # => true
        #
        # @see Network::TCP#tcp_send
        #
        # @api public
        #
        def tcp_send(data,host=nil,port=nil,local_host=nil,local_port=nil)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_debug "Sending data: #{data.inspect}"

          return super(data,host,port,local_host,local_port)
        end

        #
        # Creates a new TCP socket listening on a given host and port.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @param [Integer] backlog
        #   The maximum backlog of pending connections.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #
        # @yieldparam [TCPServer] server
        #   The newly created server.
        #
        # @return [TCPServer]
        #   The newly created server.
        #
        # @example
        #   tcp_server
        #
        # @see Network::TCP#tcp_server
        #
        # @api public
        #
        def tcp_server(port=nil,host=nil,backlog=5,&block)
          port ||= self.server_port
          host ||= self.server_host

          print_info "Listening on #{host}:#{port} ..."

          return super(server_port,server_host,&block)
        end

        #
        # Creates a new temporary TCP socket listening on a host and port.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @param [Integer] backlog
        #   The maximum backlog of pending connections.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #   When the block has finished, the server will be closed.
        #
        # @yieldparam [TCPServer] server
        #   The newly created server.
        #
        # @return [nil]
        #
        # @example
        #   tcp_server_session do |server|
        #     client1 = server.accept
        #     client2 = server.accept
        #
        #     client2.write(server.read_line)
        #
        #     client1.close
        #     client2.close
        #   end
        #
        # @see Network::TCP#tcp_server_session
        #
        # @api public
        #
        def tcp_server_session(port=nil,host=nil,backlog=5,&block)
          port ||= self.server_port
          host ||= self.server_host

          super(self.server_port,self.server_host,&block)

          print_info "Closed #{host}:#{port}"
          return nil
        end

        #
        # Creates a new TCP socket listening on a given host and port,
        # accepting clients in a loop.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @param [Integer] backlog
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
        #   tcp_server_loop do |client|
        #     client.puts 'lol'
        #   end
        #
        # @see Network::TCP#tcp_server_loop
        #
        # @api public
        #
        # @since 0.6.0
        #
        def tcp_server_loop(port=nil,host=nil,backlog=5,&block)
          port ||= self.server_port
          host ||= self.server_host

          return super(self.server_port,self.server_host) do |client|
            print_info "Client connected #{tcp_client_address(client)}"

            yield client if block_given?

            print_info "Disconnected client #{tcp_client_address(client)}"
          end
        end

        #
        # Creates a new TCP socket listening on a given host and port,
        # accepts only one client and then stops listening.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @yield [client]
        #   The given block will be passed the newly connected client.
        #   When the block has finished, the newly connected client and
        #   the server will be closed.
        #
        # @yieldparam [TCPSocket] client
        #   The newly connected client.
        #
        # @return [nil]
        #
        # @example
        #   tcp_accept do |client|
        #     client.puts 'lol'
        #   end
        #
        # @see Network::TCP#tcp_accept
        #
        # @api public
        #
        # @since 0.5.0
        #
        def tcp_accept(port=nil,host=nil,&block)
          port ||= self.server_port
          host ||= self.server_host

          return super(port,host) do |client|
            print_info "Client connected #{tcp_client_address(client)}"

            yield client if block_given?

            print_info "Disconnected client #{tcp_client_address(client)}"
          end
        end

        protected

        #
        # The host/port of a client.
        #
        # @param [TCPSocket] client
        #   The client socket.
        #
        # @return [String]
        #   The host/port of the client socket.
        #
        # @api private
        #
        # @since 0.6.0
        #
        def tcp_client_address(client)
          client_addr = client.peeraddr
          client_host = (client_addr[2] || client_addr[3])
          client_port = client_addr[1]

          return "#{client_host}:#{client_port}"
        end
      end
    end
  end
end
