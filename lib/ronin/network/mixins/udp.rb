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
        parameter :host, :type => String,
                         :description => 'UDP host'

        # UDP port
        parameter :port, :type => Integer,
                         :description => 'UDP port'

        # UDP local host
        parameter :local_host, :type => String,
                               :description => 'UDP local host'

        # UDP local port
        parameter :local_port, :type => Integer,
                               :description => 'UDP local port'

        # UDP server host
        parameter :server_host, :type => String,
                                :description => 'UDP server host'

        # UDP server port
        parameter :server_port, :type => Integer,
                                :description => 'UDP server port'

        protected

        #
        # Opens a UDP connection to the host and port specified by the
        # `host` and `port` parameters. If the `local_host` and
        # `local_port` parameters are set, they will be used for
        # the local host and port of the UDP connection.
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
        #   udp_connect
        #   # => UDPSocket
        #
        # @example
        #   udp_connect do |socket|
        #     puts socket.readlines
        #   end
        #
        # @api public
        #
        def udp_connect(&block)
          print_info "Connecting to #{host_port} ..."

          return super(self.host,self.port,self.local_host,self.local_port,&block)
        end

        #
        # Connects to the host and port specified by the `host` and `port`
        # parameters, then sends the given data. If the `local_host` and
        # `local_port` instance methods are set, they will be used for the
        # local host and port of the UDP connection.
        #
        # @param [String] data
        #   The data to send through the connection.
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
        def udp_connect_and_send(data,&block)
          print_info "Connecting to #{host_port} ..."
          print_debug "Sending data: #{data.inspect}"

          return super(data,self.host,self.port,self.local_host,self.local_port,&block)
        end

        #
        # Creates a UDP session to the host and port specified by the
        # `host` and `port` parameters. If the `local_host` and `local_port`
        # parameters are set, they will be used for the local host and port
        # of the UDP connection.
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
        def udp_session(&block)
          print_info "Connecting to #{host_port} ..."

          super(self.host,self.port,self.local_host,self.local_port,&block)

          print_info "Disconnected from #{host_port}"
          return nil
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
        #   Net.udp_send(buffer)
        #   # => true
        #
        # @api public
        #
        # @since 0.4.0
        #
        def udp_send(data)
          print_info "Connecting to #{host_port} ..."
          print_debug "Sending data: #{data.inspect}"

          super(data,self.host,self.port,self.local_host,self.local_port)

          print_info "Disconnected from #{host_port}"
          return true
        end

        #
        # Creates a new UDPServer object listening on `server_host` and
        # `server_port` parameters.
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
        # @api public
        #
        def udp_server(&block)
          print_info "Listening on #{server_host_port} ..."

          return super(self.server_port,self.server_host,&block)
        end

        #
        # Creates a new temporary UDPServer object listening on the
        # `server_host` and `server_port` parameters.
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
        # @api public
        #
        def udp_server_session(&block)
          print_info "Listening on #{self.server_host_port} ..."

          super(self.server_port,self.server_host,&block)

          print_info "Closed #{self.server_host_port}"
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
