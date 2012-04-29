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
require 'timeout'

module Ronin
  module Network
    #
    # Provides helper methods for communicating with UNIX sockets.
    #
    # @since 0.5.0
    #
    module UNIX
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
      # @since 0.5.0
      #
      def unix_open?(path,timeout=nil)
        timeout ||= 5

        begin
          Timeout.timeout(timeout) { unix_session(path) }
          return true
        rescue Timeout::Error
          return nil
        rescue SocketError, SystemCallError
          return false
        end
      end

      #
      # Connects to a UNIX socket.
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
      #   unix_connect('/tmp/haproxy.stats.socket')
      #
      # @see http://rubydoc.info/stdlib/socket/UNIXSocket
      #
      # @api public
      #
      def unix_connect(path)
        socket = UNIXSocket.new(path)

        yield socket if block_given?
        return socket
      end

      #
      # Creates a new UNIXSocket object, connected to the given path.
      # The given data will then be written to the newly created UNIXSocket.
      #
      # @param [String] data
      #   The data to send to the socket.
      #
      # @param [String] path
      #   The path to the socket.
      #
      # @yield [socket]
      #   If a block is given, it will be passed the newly created socket.
      #
      # @yieldparam [UNIXSocket] socket
      #   The newly created UNIXSocket object.
      #
      # @api public
      #
      def unix_connect_and_send(data,path)
        socket = unix_connect(path)
        socket.write(data)

        yield socket if block_given?
        return socket
      end

      #
      # Connects temporarily to a UNIX socket.
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
      #   unix_session('/tmp/haproxy.stats.socket') do |socket|
      #     # ...
      #   end
      #
      # @api public
      #
      def unix_session(path)
        socket = unix_connect(path)

        yield socket if block_given?
        socket.close
        return nil
      end

      #
      # Connects to a UNIX socket, sends the given data and then closes the
      # socket.
      #
      # @param [String] data
      #   The data to send to the UNIX socket.
      #
      # @param [String] path
      #   The UNIX socket to connect to.
      #
      # @return [true]
      #   The data was successfully sent.
      #
      # @example
      #   buffer = "GET /" + ('A' * 4096) + "\n\r"
      #   unix_send(buffer,'/tmp/thin.socket')
      #   # => true
      #
      # @api public
      #
      def unix_send(data,path)
        unix_session(path) do |socket|
          socket.write(data)
        end

        return true
      end

      #
      # Opens a UNIX socket.
      #
      # @param [String] path
      #   The path for the new UNIX socket.
      #
      # @yield [server]
      #   If a block is given, it will be passed an UNIX socket object.
      #
      # @yieldparam [UNIXServer] server
      #   The new UNIX socket.
      #
      # @return [UNIXServer]
      #   The new UNIX socket.
      #
      # @example
      #   unix_server('/tmp/test.socket')
      #
      # @see http://rubydoc.info/stdlib/socket/UNIXServer
      #
      # @api public
      #
      def unix_server(path)
        socket = UNIXServer.new(path)

        yield socket if block_given?
        return socket
      end

      #
      # Opens a UNIX socket temporarily.
      #
      # @param [String] path
      #   The path for the new UNIX socket.
      #
      # @yield [server]
      #   If a block is given, it will be passed an UNIX socket object.
      #
      # @yieldparam [UNIXServer] server
      #   The new UNIX socket.
      #
      # @example
      #   unix_server_session('/tmp/test.socket') do |server|
      #     # ...
      #   end
      #
      # @api public
      #
      def unix_server_session(path,&block)
        socket = unix_server(path,&block)
        socket.close
        return nil
      end

      #
      # Opens a UNIX socket, accepts a connection, then closes the socket.
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
      #   unix_single_server('/tmp/test.socket') do |client|
      #     # ...
      #   end
      #
      # @api public
      #
      def unix_single_server(path)
        unix_server_session(path) do |server|
          client = server.accept

          yield client if block_given?
          client.close
        end
      end

      #
      # Opens a UNIX socket, accepts connections in a loop.
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
      #   unix_server_loop('/tmp/test.socket') do |client|
      #     # ...
      #   end
      #
      # @api public
      #
      def unix_server_loop(path)
        unix_server_session(path) do |server|
          loop do
            client = server.accept

            yield client if block_given?
            client.close
          end
        end
      end
    end
  end
end
