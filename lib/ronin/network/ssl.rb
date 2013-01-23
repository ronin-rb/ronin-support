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

require 'ronin/network/tcp'

begin
  require 'openssl'
rescue ::LoadError
  $stderr.puts "WARNING: Ruby was not compiled with OpenSSL support"
end

module Ronin
  module Network
    #
    # Provides helper methods for communicating with SSL-enabled services.
    #
    module SSL
      include TCP

      # SSL verify modes
      VERIFY = {
        :client_once => OpenSSL::SSL::VERIFY_CLIENT_ONCE,
        :fail_if_no_peer_cert => OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT,
        :none => OpenSSL::SSL::VERIFY_NONE,
        :peer => OpenSSL::SSL::VERIFY_PEER
      }

      #
      # Tests whether a remote SSLed TCP port is open.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:client_once`
      #   * `:fail_if_no_peer_cert`
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @option options [Integer] :timeout (5)
      #   The maximum time to attempt connecting.
      #
      # @return [Boolean, nil]
      #   Specifies whether the remote SSLed TCP port is open.
      #   If the connection was not accepted, `nil` will be returned.
      #
      # @example
      #   ssl_open?('www.bankofamerica.com',443)
      #
      # @example Using a timeout:
      #   ssl_open?('example.com',80,:timeout => 5)
      #   # => nil
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_open?(host,port,options={})
        timeout = options.fetch(:timeout,5)

        begin
          Timeout.timeout(timeout) do
            ssl_session(host,port,options)
          end

          return true
        rescue Timeout::Error
          return nil
        rescue SocketError, SystemCallError
          return false
        end
      end

      #
      # Establishes a SSL connection.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:client_once`
      #   * `:fail_if_no_peer_cert`
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [ssl_socket]
      #   The given block will be passed the new SSL Socket.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
      #   The new SSL Socket.
      #
      # @return [OpenSSL::SSL::SSLSocket]
      #   the new SSL Socket.
      #
      # @example
      #   socket = ssl_connect('twitter.com',443)
      #
      # @see http://rubydoc.info/stdlib/openssl/OpenSSL/SSL/SSLSocket
      #
      # @api public
      #
      def ssl_connect(host,port,options={})
        local_host = options[:local_host]
        local_port = options[:local_port]

        verify = options.fetch(:verify,:none)
        cert   = options[:cert]
        key    = options[:key]

        unless SSL::VERIFY.has_key?(verify)
          raise("unknown verify mode #{verify}")
        end

        socket = tcp_connect(host,port,local_host,local_port)

        ssl_context = OpenSSL::SSL::SSLContext.new()
        ssl_context.verify_mode = SSL::VERIFY[verify]

        if cert
          ssl_context.cert = OpenSSL::X509::Certificate.new(File.new(cert))
        end

        if key
          ssl_context.key = OpenSSL::PKey::RSA.new(File.new(key))
        end

        ssl_socket = OpenSSL::SSL::SSLSocket.new(socket,ssl_context)
        ssl_socket.sync_close = true
        ssl_socket.connect

        yield ssl_socket if block_given?
        return ssl_socket
      end

      #
      # Creates a new temporary SSL connection.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [ssl_socket]
      #   The given block will be passed the temporary SSL Socket.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
      #   The temporary SSL Socket.
      #
      # @return [nil]
      #
      # @example
      #   ssl_session('twitter.com',443) do |sock|
      #     sock.write("GET / HTTP/1.1\n\r\n\r")
      #
      #     sock.each_line { |line| puts line }
      #   end
      #
      # @see http://rubydoc.info/stdlib/openssl/OpenSSL/SSL/SSLSocket
      #
      # @api public
      #
      def ssl_session(host,port,options={},&block)
        ssl_socket = ssl_connect(host,port,options,&block)
        ssl_socket.close
        return nil
      end

      #
      # Creates a new SSL connection and sends the given data.
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
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [ssl_socket]
      #   The given block will be passed the newly created SSL Socket.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
      #   The newly created SSL Socket.
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_connect_and_send(data,host,port,options={})
        ssl_socket = ssl_connect(host,port,options)
        ssl_socket.write(data)

        yield ssl_socket if block_given?
        return ssl_socket
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
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
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
      #   ssl_banner('smtp.gmail.com',465)
      #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_banner(host,port,options={})
        banner = nil

        ssl_session(host,port,options) do |ssl_socket|
          banner = ssl_socket.readline.strip
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
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @return [true]
      #   The data was successfully sent.
      #
      # @example
      #   buffer = "GET /" + ('A' * 4096) + "\n\r"
      #   ssl_send(buffer,'victim.com',443)
      #   # => true
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_send(data,host,port,options={})
        ssl_session(host,port,options) do |ssl_socket|
          ssl_socket.write(data)
        end

        return true
      end

      #
      # Creates a new SSL socket listening on a given host and port.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :port
      #   The local port to listen on.
      #
      # @option options [String] :host ('0.0.0.0')
      #   The host to bind to.
      #
      # @option options [Integer] :backlog (5)
      #   The maximum backlog of pending connections.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [server]
      #   The block which will be called after the server has been created.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] server
      #   The newly created SSL server.
      #
      # @return [OpenSSL::SSL::SSLSocket]
      #   The new SSL server.
      #
      # @example
      #   ssl_server(1337)
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_server(options={})
        port    = options[:port]
        host    = options[:host]
        backlog = options.fetch(:backlog,5)
        verify  = options.fetch(:verify,:none)
        cert    = options[:cert]
        key     = options[:key]

        unless SSL::VERIFY.has_key?(verify)
          raise("unknown verify mode #{verify}")
        end

        ssl_context = OpenSSL::SSL::SSLContext.new()
        ssl_context.verify_mode = SSL::VERIFY[verify]

        if cert
          ssl_context.cert = OpenSSL::X509::Certificate.new(File.new(cert))
        end

        if key
          ssl_context.key = OpenSSL::PKey::RSA.new(File.new(key))
        end

        server = tcp_server(port,host,backlog)
        ssl_server = OpenSSL::SSL::SSLSocket.new(server,ssl_context)

        yield ssl_server if block_given?
        return ssl_server
      end

      #
      # Creates a new temporary SSL socket listening on a host and port.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :port
      #   The local port to listen on.
      #
      # @option options [String] :host ('0.0.0.0')
      #   The host to bind to.
      #
      # @option options [Integer] :backlog (5)
      #   The maximum backlog of pending connections.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [server]
      #   The block which will be called after the server has been created.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] server
      #   The newly created SSL server.
      #
      # @return [nil]
      #
      # @example
      #   ssl_server_session(1337) do |server|
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
      # @since 0.6.0
      #
      def ssl_server_session(options={},&block)
        server = ssl_server(options,&block)
        server.close()
        return nil
      end

      #
      # Creates a new SSL socket listening on a given host and port,
      # accepting clients in a loop.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :port
      #   The local port to listen on.
      #
      # @option options [String] :host ('0.0.0.0')
      #   The host to bind to.
      #
      # @option options [Integer] :backlog (5)
      #   The maximum backlog of pending connections.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [client]
      #   The given block will be passed the newly connected client.
      #   After the block has finished, the client will be closed.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] client
      #   A newly connected client.
      #
      # @return [nil]
      #
      # @example
      #   tcp_server_loop(1337) do |client|
      #     client.puts 'lol'
      #   end
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_server_loop(options={})
        ssl_server_session(options) do |server|
          loop do
            client = server.accept

            yield client if block_given?
            client.close
          end
        end
      end

      #
      # Creates a new SSL socket listening on a given host and port,
      # accepts only one client and then stops listening.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :port
      #   The local port to listen on.
      #
      # @option options [String] :host ('0.0.0.0')
      #   The host to bind to.
      #
      # @option options [Integer] :backlog (5)
      #   The maximum backlog of pending connections.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @example
      #   ssl_accept(1337) do |client|
      #     client.puts 'lol'
      #   end
      #
      # @yield [client]
      #   The given block will be passed the newly connected client.
      #   After the block has finished, both the client and the server will be
      #   closed.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] client
      #   The newly connected client.
      #
      # @return [nil]
      #
      # @example
      #   ssl_accept(1337) do |client|
      #     client.puts 'lol'
      #   end
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_accept(options={})
        ssl_server_session(options.merge(:backlog => 1)) do |server|
          client = server.accept

          yield client if block_given?
          client.close
        end
      end
    end
  end
end
