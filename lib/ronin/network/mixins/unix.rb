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
      # * `path` (`String`) - UNIX Socket path.
      #
      # @since 0.5.0
      #
      module UNIX
        include Mixin, Network::UNIX

        # UNIX path
        parameter :path, type:        String,
                         description: 'UNIX Socket path'

        #
        # Tests whether a UNIX socket is open.
        #
        # @param [String] path
        #   The path to the socket.
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
        def unix_open?(path=nil,timeout=nil)
          path ||= self.path

          print_info "Testing if #{path} is open ..."

          return super(path,timeout)
        end

        #
        # Connects to a UNIX socket specified by the `path` parameter.
        #
        # @param [String] path
        #   The path to the UNIX socket.
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
        def unix_connect(path=nil,&block)
          path ||= self.path

          print_info "Connecting to #{path} ..."

          return super(path,&block)
        end

        #
        # Creates a new UNIXSocket object, connected to the `path` parameter.
        # The given data will then be written to the newly created UNIXSocket.
        #
        # @param [String] data
        #   The data to send to the socket.
        #
        # @param [String] path
        #   The path to the UNIX socket.
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
        def unix_connect_and_send(data,path=nil,&block)
          path ||= self.path

          print_debug "Sending data: #{data.inspect}"

          return super(data,path,&block)
        end

        #
        # Creates a UNIX session to the host and port specified by the
        # `host` and `port` parameters. If the `local_host` and `local_port`
        # parameters are set, they will be used for the local host and port
        # of the UNIX connection.
        #
        # @param [String] path
        #   The path to the UNIX socket.
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
        def unix_session(path=nil,&block)
          path ||= self.path

          super(path,&block)

          print_info "Disconnected from #{path}"
          return nil
        end

        #
        # Connects to the UNIX socket, specified by the `path` parameter,
        # sends the given data and then disconnects.
        #
        # @param [String] data
        #   The data to send to the UNIX socket.
        #
        # @param [String] path
        #   The path to the UNIX socket.
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
        def unix_send(data,path=nil)
          path ||= self.path

          print_debug "Sending data: #{data.inspect}"

          return super(data,path,&block)
        end

        #
        # Opens a UNIX socket, listening on the `path` parameter.
        #
        # @param [String] path
        #   The path for the new UNIX socket.
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
        def unix_server(path=nil,&block)
          path ||= self.path

          print_info "Listening on #{path} ..."

          return super(path,&block)
        end

        #
        # Opens a UNIX socket temporarily, listening on the `path` parameter.
        #
        # @param [String] path
        #   The path for the new UNIX socket.
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
          path ||= self.path

          super(path,&block)

          print_info "Closed #{path}"
          return nil
        end

        #
        # Opens a UNIX socket specified by the `path` parameter,
        # accepts a connection, then closes the socket.
        #
        # @param [String] path
        #   The path for the new UNIX socket.
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
        def unix_accept(path=nil)
          path ||= self.path

          print_info "Listening on #{path} ..."

          super(path) do |client|
            print_info "Client connected to #{path}"

            yield client if block_given?

            print_info "Client disconnecting from #{path} ..."
          end

          print_info "Closed #{path}"
          return nil
        end

        #
        # Opens a UNIX socket specified by the `path` parameter,
        # accepts connections in a loop.
        #
        # @param [String] path
        #   The path for the new UNIX socket.
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
        def unix_server_loop(path=nil)
          path ||= self.path

          print_info "Listening on #{path} ..."

          super(path) do |client|
            print_info "Client connected: #{path}"

            yield client if block_given?

            print_info "Client disconnecting: #{path} ..."
          end

          print_info "Closed #{path}"
          return nil
        end
      end
    end
  end
end
