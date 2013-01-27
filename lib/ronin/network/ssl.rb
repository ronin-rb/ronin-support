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
  warn "WARNING: Ruby was not compiled with OpenSSL support"
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
        none:                 OpenSSL::SSL::VERIFY_NONE,
        peer:                 OpenSSL::SSL::VERIFY_PEER,
        fail_if_no_peer_cert: OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT,
        client_once:          OpenSSL::SSL::VERIFY_CLIENT_ONCE
      }

      #
      # Creates a new SSL Context.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify (:none)
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
      #
      # @return [OpenSSL::SSL::SSLContext]
      #   The newly created SSL Context.
      #
      # @api semipublic
      #
      # @since 0.6.0
      #
      def self.context(options={})
        context = OpenSSL::SSL::SSLContext.new()
        context.verify_mode = SSL::VERIFY[options.fetch(:verify,:none)]

        if options[:cert]
          file = File.new(options[:cert])
          context.cert = OpenSSL::X509::Certificate.new(file)
        end

        if options[:key]
          file = File.new(options[:key])
          context.key = OpenSSL::PKey::RSA.new(file)
        end

        return context
      end

      #
      # Initiates an SSL session with an existing TCP socket.
      #
      # @param [TCPSocket] socket
      #   The existing TCP socket.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
      #
      # @return [OpenSSL::SSL::SSLSocket]
      #   the new SSL Socket.
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_socket(socket,options={})
        verify = options.fetch(:verify,:none)
        cert   = options[:cert]
        key    = options[:key]

        unless SSL::VERIFY.has_key?(verify)
          raise("unknown verify mode #{verify}")
        end

        ssl_socket = OpenSSL::SSL::SSLSocket.new(socket,SSL.context(options))
        ssl_socket.sync_close = true
        return ssl_socket
      end

      #
      # Tests whether a remote SSLed TCP port is open.
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
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
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
      #   ssl_open?('example.com',80, timeout: 5)
      #   # => nil
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_open?(host,port,local_host=nil,local_port=nil,options={})
        timeout = options.fetch(:timeout,5)

        begin
          Timeout.timeout(timeout) do
            ssl_session(host,port,local_host,local_port,options)
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
      # @param [String] local_host
      #   The local host to bind to.
      #
      # @param [Integer] local_port
      #   The local port to bind to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
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
      def ssl_connect(host,port,local_host=nil,local_port=nil,options={})
        socket     = tcp_connect(host,port,local_host,local_port)
        ssl_socket = ssl_socket(socket,options)
        ssl_socket.connect

        yield ssl_socket if block_given?
        return ssl_socket
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
      # @param [String] local_host
      #   The local host to bind to.
      #
      # @param [Integer] local_port
      #   The local port to bind to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
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
      def ssl_connect_and_send(data,host,port,local_host=nil,local_port=nil,options={})
        socket = ssl_connect(host,port,local_host,local_port,options)
        socket.write(data)

        yield socket if block_given?
        return socket
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
      # @param [String] local_host
      #   The local host to bind to.
      #
      # @param [Integer] local_port
      #   The local port to bind to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
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
      def ssl_session(host,port,local_host=nil,local_port=nil,options={},&block)
        socket = ssl_connect(host,port,local_host,local_port,options,&block)
        socket.close
        return nil
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
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
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
      def ssl_banner(host,port,local_host=nil,local_port=nil,options={})
        banner = nil

        ssl_session(host,port,local_host,local_port,options) do |ssl_socket|
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
      # @param [String] local_host
      #   The local host to bind to.
      #
      # @param [Integer] local_port
      #   The local port to bind to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
      #
      # @return [true]
      #   The data was successfully sent.
      #
      # @example
      #   buffer = "GET /#{'A' * 4096}\n\r"
      #   ssl_send(buffer,'victim.com',443)
      #   # => true
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_send(data,host,port,local_host=nil,local_port=nil,options={})
        ssl_session(host,port,local_host,local_port,options) do |socket|
          socket.write(data)
        end

        return true
      end

      #
      # Creates a new SSL socket listening on a given host and port,
      # accepting clients in a loop.
      #
      # @param [Integer] port
      #   The local port to listen on.
      #
      # @param [String] host
      #   The host to bind to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :backlog (5)
      #   The maximum backlog of pending connections.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
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
      #   # $ openssl genrsa -out ssl.key 1024
      #   # $ openssl req -new -key ssl.key -x509 -days 3653 -out ssl.crt
      #   # $ cat ssl.key ssl.crt > ssl.pem
      #   # $ chmod 600 ssl.key ssl.pem
      #   ssl_server_loop(port: 1337, cert: 'ssl.crt', key: 'ssl.key') do |sock|
      #     sock.puts 'lol'
      #   end
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_server_loop(port=nil,host=nil,options={})
        backlog = options[:backlog]

        return tcp_server_session(port,host,backlog) do |server|
          loop do
            client     = server.accept
            ssl_client = ssl_socket(client,options)
            ssl_client.accept

            yield ssl_client if block_given?
            ssl_client.close
          end
        end
      end

      #
      # Creates a new SSL socket listening on a given host and port,
      # accepts only one client and then stops listening.
      #
      # @param [Integer] port
      #   The local port to listen on.
      #
      # @param [String] host
      #   The host to bind to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :backlog (5)
      #   The maximum backlog of pending connections.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:fail_if_no_peer_cert`
      #   * `:client_once`
      #
      # @option options [String] :cert
      #   The path to the SSL `.crt` file.
      #
      # @option options [String] :key
      #   The path to the SSL `.key` file.
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
      #   # $ openssl genrsa -out ssl.key 1024
      #   # $ openssl req -new -key ssl.key -x509 -days 3653 -out ssl.crt
      #   # $ cat ssl.key ssl.crt > ssl.pem
      #   # $ chmod 600 ssl.key ssl.pem
      #   ssl_accept(port: 1337, cert: 'ssl.crt', key: 'ssl.key') do |client|
      #     client.puts 'lol'
      #   end
      #
      # @api public
      #
      # @since 0.6.0
      #
      def ssl_accept(port=nil,host=nil,options={})
        tcp_server_session(port,host,1) do |server|
          client     = server.accept
          ssl_client = ssl_socket(client,options)
          ssl_client.accept

          yield ssl_client if block_given?
          ssl_client.close
        end
      end
    end
  end
end
