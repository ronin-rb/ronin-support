# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/ssl'

module Ronin
  module Support
    module Network
      module SSL
        #
        # Provides helper methods for communicating with SSL-enabled services.
        #
        module Mixin
          #
          # @!macro context_kwargs
          #   @option kwargs [1, 1.1, 1.2, 1.3, Symbol, nil] :version
          #     The SSL version to use.
          #
          #   @option kwargs [Symbol, Boolean] :verify
          #     Specifies whether to verify the SSL certificate.
          #     May be one of the following:
          #
          #     * `:none`
          #     * `:peer`
          #     * `:fail_if_no_peer_cert`
          #     * `:client_once`
          #
          #   @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #     The RSA key to use for the SSL context.
          #
          #   @option kwargs [String] :key_file
          #     The path to the SSL `.key` file.
          #
          #   @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #     The X509 certificate to use for the SSL context.
          #
          #   @option kwargs [String] :cert_file
          #     The path to the SSL `.crt` file.
          #
          #   @option kwargs [String] :ca_bundle
          #     Path to the CA certificate file or directory.
          #

          #
          # Creates a new SSL Context.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @!macro context_kwargs
          #
          # @return [OpenSSL::SSL::SSLContext]
          #   The newly created SSL Context.
          #
          # @api semipublic
          #
          # @see SSL.context
          #
          # @since 0.6.0
          #
          def ssl_context(**kwargs)
            SSL.context(**kwargs)
          end

          #
          # Initiates an SSL session with an existing TCP socket.
          #
          # @param [TCPSocket] socket
          #   The existing TCP socket.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_context}.
          #
          # @!macro context_kwargs
          #
          # @return [OpenSSL::SSL::SSLSocket]
          #   The new SSL Socket.
          #
          # @api public
          #
          # @see SSL.socket
          #
          # @since 0.6.0
          #
          def ssl_socket(socket,**kwargs)
            SSL.socket(socket,**kwargs)
          end

          #
          # @!macro connect_kwargs
          #   @option kwargs [String] :bind_host
          #     The local host to bind to.
          #
          #   @option kwargs [Integer] :bind_port
          #     The local port to bind to.
          #
          #   @!macro context_kwargs
          #

          #
          # Tests whether a remote SSLed TCP port is open.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @!macro connect_kwargs
          #
          # @option kwargs [Integer] :timeout (5)
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
          # @see SSL.open?
          #
          # @since 0.6.0
          #
          def ssl_open?(host,port,**kwargs)
            SSL.open?(host,port,**kwargs)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_socket}.
          #
          # @!macro connect_kwargs
          #
          # @yield [ssl_socket]
          #   The given block will be passed the new SSL socket. Once the block
          #   returns the SSL socket will be closed.
          #
          # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
          #   The new SSL Socket.
          #
          # @return [OpenSSL::SSL::SSLSocket, nil]
          #   The new SSL Socket. If a block is given, then `nil` will be
          #   returned.
          #
          # @example
          #   socket = ssl_connect('twitter.com',443)
          #
          # @example
          #   ssl_connect('twitter.com',443) do |sock|
          #     sock.write("GET / HTTP/1.1\n\r\n\r")
          #
          #     sock.each_line { |line| puts line }
          #   end
          #
          # @see http://rubydoc.info/stdlib/openssl/OpenSSL/SSL/SSLSocket
          # @see SSL.connect
          #
          # @api public
          #
          def ssl_connect(host,port,**kwargs,&block)
            SSL.connect(host,port,**kwargs,&block)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @!macro connect_kwargs
          #
          # @yield [ssl_socket]
          #   The given block will be passed the newly created SSL Socket.
          #
          # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
          #   The newly created SSL Socket.
          #
          # @api public
          #
          # @see SSL.connect_and_send
          #
          # @since 0.6.0
          #
          def ssl_connect_and_send(data,host,port,**kwargs,&block)
            SSL.connect_and_send(data,host,port,**kwargs,&block)
          end

          #
          # Connects to the host and port and returns the server's certificate.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments {#ssl_connect}.
          #
          # @!macro connect_kwargs
          #
          # @return [Crypto::Cert]
          #   The server's certificate.
          #
          # @see SSL.get_cert
          #
          def ssl_cert(host,port,**kwargs)
            SSL.get_cert(host,port,**kwargs)
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
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @!macro connect_kwargs
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
          # @see SSL.banner
          #
          # @since 0.6.0
          #
          def ssl_banner(host,port,**kwargs,&block)
            SSL.banner(host,port,**kwargs,&block)
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
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @!macro connect_kwargs
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
          # @see SSL.send
          #
          # @since 0.6.0
          #
          def ssl_send(data,host,port,**kwargs)
            SSL.send(data,host,port,**kwargs)
          end

          #
          # @!macro server_context_kwargs
          #   @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key (SSL.key)
          #     The RSA key to use for the SSL context.
          #
          #   @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert (SSL.cert)
          #     The X509 certificate to use for the SSL context.
          #
          #   @!macro context_kwargs
          #

          #
          # Accepts an SSL session from an existing TCP socket.
          #
          # @param [TCPSocket] socket
          #   The existing TCP socket.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_socket}.
          #
          # @!macro server_context_kwargs
          #
          # @return [OpenSSL::SSL::SSLSocket]
          #   The new SSL Socket.
          #
          # @api public
          #
          # @see SSL.server_socket
          #
          # @since 0.6.0
          #
          def ssl_server_socket(socket,**kwargs)
            SSL.server_socket(socket,**kwargs)
          end

          #
          # @!macro server_kwargs
          #   @option kwargs [Integer] :port (0)
          #     The local port to listen on.
          #
          #   @option kwargs [String, nil] :host
          #     The host to bind to.
          #
          #   @option kwargs [Integer] :backlog (5)
          #     The maximum backlog of pending connections.
          #
          #   @!macro server_context_kwargs
          #

          #
          # Creates a new SSL server listening on a given host and port.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_context}.
          #
          # @!macro server_kwargs
          #
          # @yield [server]
          #   The given block will be passed the newly created SSL server.
          #
          # @yieldparam [OpenSSL::SSL::SSLServer] server
          #   The newly created SSL server.
          #
          # @return [OpenSSL::SSL::SSLServer]
          #   The newly created SSL server.
          #
          # @api public
          #
          # @since 1.1.0
          #
          def ssl_server(**kwargs,&block)
            SSL.server(**kwargs,&block)
          end

          #
          # Creates a new temporary SSL server listening on a given host and
          # port.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_context}.
          #
          # @!macro server_kwargs
          #
          # @yield [server]
          #   The given block will be passed the newly created SSL server.
          #   Once the block has finished, the server will be closed.
          #
          # @yieldparam [OpenSSL::SSL::SSLServer] server
          #   The newly created SSL server.
          #
          # @return [OpenSSL::SSL::SSLServer]
          #   The newly created SSL server.
          #
          # @api public
          #
          # @since 1.1.0
          #
          def ssl_server_session(**kwargs,&block)
            SSL.server_session(**kwargs,&block)
          end

          #
          # Creates a new SSL socket listening on a given host and port,
          # accepting clients in a loop.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_context}.
          #
          # @!macro server_kwargs
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
          # @see SSL.server_loop
          #
          # @since 0.6.0
          #
          def ssl_server_loop(**kwargs,&block)
            SSL.server_loop(**kwargs,&block)
          end

          #
          # Creates a new SSL socket listening on a given host and port,
          # accepts only one client and then stops listening.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_context}.
          #
          # @!macro server_kwargs
          #
          # @yield [client]
          #   The given block will be passed the newly connected client.
          #   After the block has finished, both the client and the server will
          #   be closed.
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
          # @example Using a self-signed certificate:
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
          # @see SSL.accept
          #
          # @since 0.6.0
          #
          def ssl_accept(**kwargs,&block)
            SSL.accept(**kwargs,&block)
          end
        end
      end
    end
  end
end
