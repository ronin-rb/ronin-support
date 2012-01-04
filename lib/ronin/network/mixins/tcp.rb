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
        parameter :host, :type => String,
                         :description => 'TCP host'

        # TCP port
        parameter :port, :type => Integer,
                         :description => 'TCP port'

        # TCP local host
        parameter :local_host, :type => String,
                               :description => 'TCP local host'

        # TCP local port
        parameter :local_port, :type => Integer,
                               :description => 'TCP local port'

        # TCP server host
        parameter :server_host, :type => String,
                                :description => 'TCP server host'

        # TCP server port
        parameter :server_port, :type => Integer,
                                :description => 'TCP server port'

        protected

        #
        # Opens a TCP connection to the host and port specified by the
        # `host` and `port` parameters. If the `local_host` and
        # `local_port` parameters are set, they will be used for
        # the local host and port of the TCP connection.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #
        # @yieldparam [TCPsocket] socket
        #   The newly created TCPSocket object.
        #
        # @return [TCPSocket]
        #   The newly created TCPSocket object.
        #
        # @example
        #   tcp_connect # => TCPSocket
        #
        # @example
        #   tcp_connect do |socket|
        #     socket.write("GET /\n\n")
        #
        #     puts socket.readlines
        #     socket.close
        #   end
        #
        # @api public
        #
        def tcp_connect(&block)
          print_info "Connecting to #{host_port} ..."

          return super(self.host,self.port,self.local_host,self.local_port,&block)
        end

        #
        # Connects to the host and port specified by the `host` and `port`
        # parameters, then sends the given data.
        #
        # @param [String] data
        #   The data to send through the connection.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #
        # @yieldparam [TCPsocket] socket
        #   The newly created TCPSocket object.
        #
        # @return [TCPSocket]
        #   The newly created TCPSocket object.
        #
        # @api public
        #
        def tcp_connect_and_send(data,&block)
          print_info "Connecting to #{host_port} ..."
          print_debug "Sending data: #{data.inspect}"

          return super(data,self.host,self.port,self.local_host,self.local_port,&block)
        end

        #
        # Creates a TCP session to the host and port specified by the
        # `host` and `port` parameters.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #   After the block has returned, the socket will be closed.
        #
        # @yieldparam [TCPsocket] socket
        #   The newly created TCPSocket object.
        #
        # @return [nil]
        #
        # @api public
        #
        def tcp_session(&block)
          print_info "Connecting to #{host_port} ..."

          Net.tcp_session(self.host,self.port,self.local_host,self.local_port,&block)

          print_info "Disconnected from #{host_port}"
          return nil
        end

        #
        # Connects to the host and port specified by the `host` and `port`
        # parameters, reads the banner then closes the connection.
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
        # @api public
        #
        def tcp_banner(&block)
          print_debug "Grabbing banner from #{host_port}"

          return super(self.host,self.port,self.local_host,self.local_port,&block)
        end

        #
        # Connects to the host and port specified by the `host` and `port`
        # parameters, sends the given data and then disconnects.
        #
        # @return [true]
        #   The data was successfully sent.
        #
        # @example
        #   buffer = "GET /" + ('A' * 4096) + "\n\r"
        #   Net.tcp_send(buffer)
        #   # => true
        #
        # @api public
        #
        def tcp_send(data)
          print_info "Connecting to #{host_port} ..."
          print_debug "Sending data: #{data.inspect}"

          super(data,self.host,self.port,self.local_host,self.local_port)

          print_info "Disconnected from #{host_port}"
          return true
        end

        #
        # Creates a new TCPServer object listening on the `server_host`
        # and `server_port` parameters.
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
        # @api public
        #
        def tcp_server(&block)
          print_info "Listening on #{self.server_host_port} ..."

          return super(self.server_port,self.server_host,&block)
        end

        #
        # Creates a new temporary TCPServer object listening on the
        # `server_host` and `server_port` parameters.
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
        # @api public
        #
        def tcp_server_session(&block)
          print_info "Listening on #{server_host_port} ..."

          super(self.server_port,self.server_host,&block)

          print_info "Closed #{server_host_port}"
          return nil
        end

        #
        # Creates a new temporary TCPServer object listening on
        # `server_host` and `server_port` parameters.
        # The TCPServer will accepting one client, pass the newly connected
        # client to a given block, disconnects the client and stops
        # listening.
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
        #   tcp_single_server do |client|
        #     client.puts 'lol'
        #   end
        #
        # @api public
        #
        def tcp_single_server(&block)
          print_info "Listening on #{server_host_port} ..."

          super(self.server_port,self.server_host) do |client|
            client_addr = client.peeraddr
            client_host = (client_addr[2] || client_addr[3])
            client_port = client_addr[1]

            print_info "Client connected #{client_host}:#{client_port}"

            yield client if block_given?

            print_info "Disconnected client #{client_host}:#{client_port}"
          end

          print_info "Closed #{server_host_port}"
          return nil
        end

        private

        #
        # The server host/port parameters.
        #
        # @return [String]
        #   The server host/port parameters in String form.
        #
        # @since 0.4.0
        #
        # @api private
        #
        def server_host_port
          "#{self.server_host}:#{self.server_port}"
        end
      end
    end
  end
end
