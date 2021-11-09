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

require 'ronin/network/mixins/mixin'
require 'ronin/network/udp'

module Ronin
  module Network
    module Mixins
      #
      # Adds UDP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - UDP host.
      # * `port` (`Integer`) - UDP port.
      # * `local_host` (`String`) - UDP local host.
      # * `local_port` (`Integer`) - UDP local port.
      # * `server_host` (`String`) - UDP server host.
      # * `server_port` (`Integer`) - UDP server port.
      #
      module UDP
        include Mixin, Network::UDP

        # UDP host
        parameter :host, type:        String,
                         description: 'UDP host'

        # UDP port
        parameter :port, type:        Integer,
                         description: 'UDP port'

        # UDP local host
        parameter :local_host, type:        String,
                               description: 'UDP local host'

        # UDP local port
        parameter :local_port, type:        Integer,
                               description: 'UDP local port'

        # UDP server host
        parameter :server_host, type:        String,
                                default:     '0.0.0.0',
                                description: 'UDP server host'

        # UDP server port
        parameter :server_port, type:        Integer,
                                description: 'UDP server port'

        #
        # Tests whether a remote UDP port is open.
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
        #   Specifies whether the remote UDP port is open.
        #   If no data or ICMP error were received, `nil` will be returned.
        #
        # @api public
        #
        # @since 0.5.0
        #
        def udp_open?(host=nil,port=nil,local_host=nil,local_port=nil,timeout=nil)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_info "Testing if #{host}:#{port} is open ..."

          return super(self.host,self.port,self.local_host,self.local_port,timeout)
        end

        #
        # Creates a new UDP sockeet connected to a given host and port.
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
        # @yieldparam [UDPsocket] socket
        #   The newly created UDP socket.
        #
        # @return [UDPSocket]
        #   The newly created UDP socket.
        #
        # @example
        #   udp_connect
        #   # => UDPSocket
        #
        # @example
        #   udp_connect do |socket|
        #     puts socket.readlines
        #   end
        #
        # @see Network::UDP#udp_connect
        #
        # @api public
        #
        def udp_connect(host=nil,port=nil,local_host=nil,local_port=nil,&block)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_info "Connecting to #{host}:#{port} ..."

          return super(host,port,local_host,local_port,&block)
        end

        #
        # Creates a new UDP socket, connected to a given host and port.
        # The given data will then be written to the newly created UDPSocket.
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
        # @yieldparam [UDPsocket] socket
        #   The newly created UDP socket.
        #
        # @return [UDPSocket]
        #   The newly created UDP socket.
        #
        # @see Network::UDP#udp_connect_and_send
        #
        # @api public
        #
        def udp_connect_and_send(data,host=nil,port=nil,local_host=nil,local_port=nil,&block)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_info "Connecting to #{host}:#{port} ..."
          print_debug "Sending data: #{data.inspect}"

          return super(data,host,port,local_host,local_port,&block)
        end

        #
        # Creates a new temporary UDP socket, connected to the given host
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
        #   After the block has returned, the socket will then be closed.
        #
        # @yieldparam [UDPsocket] socket
        #   The newly created UDP socket.
        #
        # @return [nil]
        #
        # @see Network::UDP#udp_session
        #
        # @api public
        #
        def udp_session(host=nil,port=nil,local_host=nil,local_port=nil,&block)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          super(host,port,local_host,local_port,&block)

          print_info "Disconnected from #{host}:#{port}"
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
        #   udp_send(buffer)
        #   # => true
        #
        # @see Network::UDP#udp_send
        #
        # @api public
        #
        # @since 0.4.0
        #
        def udp_send(data,host=nil,port=nil,local_host=nil,local_port=nil)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_debug "Sending data: #{data.inspect}"

          return super(data,host,port,local_host,local_port)
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
        # @param [String] local_host
        #   The local host to bind to.
        #
        # @param [Integer] local_port
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
        # @since 0.6.0
        #
        def udp_banner(host=nil,port=nil,local_host=nil,local_port=nil)
          host       ||= self.host
          port       ||= self.port
          local_host ||= self.local_host
          local_port ||= self.local_port

          print_debug "Grabbing banner from #{host}:#{port}"

          return super(data,host,port,local_host,local_port)
        end

        #
        # Creates a new UDP server listening on a given host and port.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #
        # @yieldparam [UDPServer] server
        #   The newly created server.
        #
        # @return [UDPServer]
        #   The newly created server.
        #
        # @example
        #   udp_server
        #
        # @see Network::UDP#udp_server
        #
        # @api public
        #
        def udp_server(port=nil,host=nil,&block)
          port ||= self.server_port
          host ||= self.server_host

          print_info "Listening on #{host}:#{port} ..."

          return super(port,host,&block)
        end

        #
        # Creates a new temporary UDP server listening on a given host and port.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #   When the block has finished, the server will be closed.
        #
        # @yieldparam [UDPServer] server
        #   The newly created server.
        #
        # @return [nil]
        #
        # @example
        #   udp_server_session do |server|
        #     data, sender = server.recvfrom(1024)
        #   end
        #
        # @see Network::UDP#udp_server_session
        #
        # @api public
        #
        def udp_server_session(port=nil,host=nil,&block)
          port ||= self.server_port
          host ||= self.server_host

          super(port,host,&block)

          print_info "Closed #{host}:#{port}"
          return nil
        end

        #
        # Creates a new UDP server listening on a given host and port,
        # accepting messages from clients in a loop.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @yield [server, (client_host, client_port), mesg]
        #   The given block will be passed the client host/port and the received
        #   message.
        #
        # @yieldparam [UDPServer] server
        #   The UDPServer.
        #
        # @yieldparam [String] client_host
        #   The source host of the mesg.
        #
        # @yieldparam [Integer] client_port
        #   The source port of the mesg.
        #
        # @yieldparam [String] mesg
        #   The received message.
        #
        # @return [nil]
        #
        # @example
        #   udp_server_loop do |server,(host,port),mesg|
        #     server.send('hello',host,port)
        #   end
        #
        # @see Network::UDP#udp_server_loop
        #
        # @api public
        #
        # @since 0.5.0
        #
        def udp_server_loop(port=nil,host=nil,&block)
          port ||= self.server_port
          host ||= self.server_host

          return super(port,host,&block)
        end

        #
        # Creates a new UDP server listening on a given host and port,
        # accepts only one message from a client.
        #
        # @param [Integer] port
        #   The local port to listen on. Defaults to {#server_port}.
        #
        # @param [String] host
        #   The host to bind to. Defaults to {#server_host}.
        #
        # @yield [server, (client_host, client_port), mesg]
        #   The given block will be passed the client host/port and the received
        #   message.
        #
        # @yieldparam [UDPServer] server
        #   The UDPServer.
        #
        # @yieldparam [String] client_host
        #   The source host of the mesg.
        #
        # @yieldparam [Integer] client_port
        #   The source port of the mesg.
        #
        # @yieldparam [String] mesg
        #   The received message.
        #
        # @return [nil]
        #
        # @example
        #   udp_recv do |server,(host,port),mesg|
        #     server.send('hello',host,port)
        #   end
        #
        # @see Network::UDP#udp_recv
        #
        # @api public
        #
        # @since 0.5.0
        #
        def udp_recv(port=nil,host=nil,&block)
          port ||= self.server_port
          host ||= self.server_host

          return super(port,host) do |server,(host,port),mesg|
            print_info "Received message from #{host}:#{port}"
            print_debug mesg

            yield server, [host, port], mesg if block_given?
          end
        end
      end
    end
  end
end
