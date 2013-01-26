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
require 'ronin/network/unix'

module Ronin
  module Network
    module Mixins
      #
      # Adds UNIX Socket convenience methods and connection parameters to a
      # class.
      #
      # Defines the following parameters:
      #
      # * `socket` (`String`) - UNIX Socket socket.
      #
      # @since 0.5.0
      #
      module UNIX
        include Mixin, Network::UNIX

        # UNIX socket
        #
        # @since 0.6.0
        parameter :socket, type:        String,
                           description: 'UNIX Socket path'

        # UNIX Server socket
        #
        # @since 0.6.0
        parameter :server_socket, type:        String,
                                  description: 'UNIX Server socket path'

        #
        # @deprecated
        #   Use `socket` instead.
        #
        def path
          warn "DEPRECATED: #{UNIX}#path is depcreated. Use #socket instead."

          return socket
        end

        #
        # @deprecated
        #   Use `socket=` instead.
        #
        def path=(new_path)
          warn "DEPRECATED: #{UNIX}#path= is depcreated. Use #socket= instead."

          self.socket = new_path
        end

        #
        # Tests whether a UNIX socket is open.
        #
        # @param [String] socket
        #   The socket to the socket.
        #
        # @param [Integer] timeout (5)
        #   The maximum time to attempt connecting.
        #
        # @return [Boolean, nil]
        #   Specifies whether the UNIX socket is open.
        #   If the connection was not accepted, `nil` will be returned.
        #
        # @api public
        #
        # @since 0.6.0
        #
        def unix_open?(socket=nil,timeout=nil)
          socket ||= self.socket

          print_info "Testing if #{socket} is open ..."

          return super(socket,timeout)
        end

        #
        # Connects to a UNIX socket specified by the `socket` parameter.
        #
        # @param [String] socket
        #   The socket to the UNIX socket.
        #
        # @yield [socket]
        #   If a block is given, it will be passed an UNIX socket object.
        #
        # @yieldparam [UNIXSocket] socket
        #   The UNIX socket.
        #
        # @return [UNIXSocket]
        #   The UNIX socket.
        #
        # @example
        #   socket = unix_connect
        #
        # @see Network::UNIX#unix_connect
        #
        # @api public
        #
        def unix_connect(socket=nil,&block)
          socket ||= self.socket

          print_info "Connecting to #{socket} ..."

          return super(socket,&block)
        end

        #
        # Creates a new UNIXSocket object, connected to the `socket` parameter.
        # The given data will then be written to the newly created UNIXSocket.
        #
        # @param [String] data
        #   The data to send to the socket.
        #
        # @param [String] socket
        #   The socket to the UNIX socket.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #
        # @yieldparam [UNIXSocket] socket
        #   The newly created UNIXSocket object.
        #
        # @return [UNIXSocket]
        #   The newly created UNIXSocket object.
        #
        # @see Network::UNIX#unix_connect_and_send
        #
        # @api public
        #
        def unix_connect_and_send(data,socket=nil,&block)
          socket ||= self.socket

          print_debug "Sending data: #{data.inspect}"

          return super(data,socket,&block)
        end

        #
        # Creates a UNIX session to the host and port specified by the
        # `host` and `port` parameters. If the `local_host` and `local_port`
        # parameters are set, they will be used for the local host and port
        # of the UNIX connection.
        #
        # @param [String] socket
        #   The socket to the UNIX socket.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #   After the block has returned, the socket will then be closed.
        #
        # @yieldparam [UNIXsocket] socket
        #   The newly created UNIXSocket object.
        #
        # @see Network::UNIX#unix_session
        #
        # @api public
        #
        def unix_session(socket=nil,&block)
          socket ||= self.socket

          super(socket,&block)

          print_info "Disconnected from #{socket}"
          return nil
        end

        #
        # Connects to the UNIX socket, specified by the `socket` parameter,
        # sends the given data and then disconnects.
        #
        # @param [String] data
        #   The data to send to the UNIX socket.
        #
        # @param [String] socket
        #   The socket to the UNIX socket.
        #
        # @return [true]
        #   The data was successfully sent.
        #
        # @example
        #   buffer = "GET /" + ('A' * 4096) + "\n\r"
        #   unix_send(buffer)
        #   # => true
        #
        # @see Network::UNIX#unix_send
        #
        # @api public
        #
        # @since 0.4.0
        #
        def unix_send(data,socket=nil)
          socket ||= self.socket

          print_debug "Sending data: #{data.inspect}"

          return super(data,socket,&block)
        end

        #
        # Opens a UNIX socket, listening on the `socket` parameter.
        #
        # @param [String] socket
        #   The socket for the new UNIX socket.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #
        # @yieldparam [UNIXServer] server
        #   The newly created server.
        #
        # @return [UNIXServer]
        #   The newly created server.
        #
        # @example
        #   unix_server
        #
        # @see Network::UNIX#unix_server
        #
        # @api public
        #
        def unix_server(socket=nil,&block)
          socket ||= self.server_socket

          print_info "Listening on #{socket} ..."

          return super(socket,&block)
        end

        #
        # Opens a UNIX socket temporarily, listening on the `socket` parameter.
        #
        # @param [String] socket
        #   The socket for the new UNIX socket.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #   When the block has finished, the server will be closed.
        #
        # @yieldparam [UNIXServer] server
        #   The newly created server.
        #
        # @return [nil]
        #
        # @example
        #   unix_server_session do |server|
        #     # ...
        #   end
        #
        # @see Network::UNIX#unix_server_session
        #
        # @api public
        #
        def unix_server_session(&block)
          socket ||= self.server_socket

          super(socket,&block)

          print_info "Closed #{socket}"
          return nil
        end

        #
        # Opens a UNIX socket specified by the `socket` parameter,
        # accepts a connection, then closes the socket.
        #
        # @param [String] socket
        #   The socket for the new UNIX socket.
        #
        # @yield [client]
        #   If a block is given, it will be passed the accepted connection.
        #
        # @yieldparam [UNIXSocket] client
        #   The accepted connection to UNIX socket.
        #
        # @example
        #   unix_accept do |client|
        #     # ...
        #   end
        #
        # @see Network::UNIX#unix_accept
        #
        # @api public
        #
        def unix_accept(socket=nil)
          socket ||= self.server_socket

          print_info "Listening on #{socket} ..."

          super(socket) do |client|
            print_info "Client connected to #{socket}"

            yield client if block_given?

            print_info "Client disconnecting from #{socket} ..."
          end

          print_info "Closed #{socket}"
          return nil
        end

        #
        # Opens a UNIX socket specified by the `socket` parameter,
        # accepts connections in a loop.
        #
        # @param [String] socket
        #   The socket for the new UNIX socket.
        #
        # @yield [client]
        #   If a block is given, it will be passed each accepted connection.
        #
        # @yieldparam [UNIXSocket] client
        #   An accepted connection to UNIX socket.
        #
        # @example
        #   unix_server_loop do |client|
        #     # ...
        #   end
        #
        # @see Network::UNIX#unix_server_loop
        #
        # @api public
        #
        def unix_server_loop(socket=nil)
          socket ||= self.server_socket

          print_info "Listening on #{socket} ..."

          super(socket) do |client|
            print_info "Client connected: #{socket}"

            yield client if block_given?

            print_info "Client disconnecting: #{socket} ..."
          end

          print_info "Closed #{socket}"
          return nil
        end
      end
    end
  end
end
