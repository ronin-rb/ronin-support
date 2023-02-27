# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/network/tcp/mixin'
require 'ronin/support/crypto/cert'

module Ronin
  module Support
    module Network
      module SSL
        #
        # Provides helper methods for communicating with SSL-enabled services.
        #
        module Mixin
          include TCP::Mixin

          #
          # Creates a new SSL Context.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version
          #   The SSL version to use.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
          #
          # @return [OpenSSL::SSL::SSLContext]
          #   The newly created SSL Context.
          #
          # @api semipublic
          #
          # @since 0.6.0
          #
          def ssl_context(**kwargs)
            Network::SSL.context(**kwargs)
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
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
          #
          # @return [OpenSSL::SSL::SSLSocket]
          #   the new SSL Socket.
          #
          # @api public
          #
          # @since 0.6.0
          #
          def ssl_socket(socket,**kwargs)
            ssl_socket = OpenSSL::SSL::SSLSocket.new(socket,ssl_context(**kwargs))

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
          # @param [String] bind_host
          #   The local host to bind to.
          #
          # @param [Integer] bind_port
          #   The local port to bind to.
          #
          # @param [Integer] timeout (5)
          #   The maximum time to attempt connecting.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @option options [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
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
          def ssl_open?(host,port, bind_host: nil, bind_port: nil, timeout: 5,
                                                                   **kwargs)
            Timeout.timeout(timeout) do
              ssl_connect(host,port, bind_host: bind_host,
                                     bind_port: bind_port,
                                     **kwargs)
            end

            return true
          rescue Timeout::Error
            return nil
          rescue SocketError, SystemCallError
            return false
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
          # @param [String] bind_host
          #   The local host to bind to.
          #
          # @param [Integer] bind_port
          #   The local port to bind to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_socket}.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
          #
          # @yield [ssl_socket]
          #   The given block will be passed the new SSL socket. Once the block
          #   returns the SSL socket will be closed.
          #
          # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
          #   The new SSL Socket.
          #
          # @return [OpenSSL::SSL::SSLSocket, nil]
          #   the new SSL Socket. If a block is given, then `nil` will be
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
          #
          # @api public
          #
          def ssl_connect(host,port, bind_host: nil, bind_port: nil, **kwargs)
            socket     = tcp_connect(host,port,bind_host: bind_host,
                                               bind_port: bind_port)
            ssl_socket = ssl_socket(socket,**kwargs)
            ssl_socket.connect

            if block_given?
              yield ssl_socket
              ssl_socket.close
            else
              return ssl_socket
            end
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
          # @param [String] bind_host
          #   The local host to bind to.
          #
          # @param [Integer] bind_port
          #   The local port to bind to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
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
          def ssl_connect_and_send(data,host,port, bind_host: nil,
                                                   bind_port: nil,
                                                   **kwargs)
            socket = ssl_connect(host,port, bind_host: bind_host,
                                            bind_port: bind_port,
                                            **kwargs)
            socket.write(data)

            yield socket if block_given?
            return socket
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
          #   Additional keyword arguments.
          #
          # @option kwargs [String] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer] :bind_port
          #   The local port to bind to.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
          #
          # @return [Crypto::Cert]
          #   The server's certificate.
          #
          def ssl_cert(host,port,**kwargs)
            socket = ssl_connect(host,port,**kwargs)
            cert   = Crypto::Cert(socket.peer_cert)

            socket.close
            return cert
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
          # @param [String] bind_host
          #   The local host to bind to.
          #
          # @param [Integer] bind_port
          #   The local port to bind to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
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
          def ssl_banner(host,port, bind_host: nil, bind_port: nil, **kwargs)
            banner = nil

            ssl_connect(host,port, bind_host: bind_host,
                                   bind_port: bind_port,
                                   **kwargs) do |ssl_socket|
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
          # @param [String] bind_host
          #   The local host to bind to.
          #
          # @param [Integer] bind_port
          #   The local port to bind to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
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
          def ssl_send(data,host,port, bind_host: nil, bind_port: nil,**kwargs)
            ssl_connect(host,port, bind_host: bind_host,
                                   bind_port: bind_port,**kwargs) do |socket|
              socket.write(data)
            end

            return true
          end

          #
          # Accepts an SSL session from an existing TCP socket.
          #
          # @param [TCPSocket] socket
          #   The existing TCP socket.
          #
          # @param [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] key
          #   The RSA key to use for the SSL context.
          #
          # @param [Crypto::Cert, OpenSSL::X509::Certificate, nil] cert
          #   The X509 certificate to use for the SSL context.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_socket}.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
          #
          # @return [OpenSSL::SSL::SSLSocket]
          #   the new SSL Socket.
          #
          # @api public
          #
          # @since 0.6.0
          #
          def ssl_server_socket(socket, key:  Network::SSL.key,
                                        cert: Network::SSL.cert,
                                        **kwargs)
            return ssl_socket(socket, cert: cert, key: key, **kwargs)
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
          # @param [Integer] backlog (5)
          #   The maximum backlog of pending connections.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_server_socket}.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key (Network::SSL.key)
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert (Network::SSL.cert)
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
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
          def ssl_server_loop(port: nil, host: nil, backlog: 5, **kwargs)
            return tcp_server_session(port: port, host: host, backlog: backlog) do |server|
              loop do
                client     = server.accept
                ssl_client = ssl_server_socket(client,**kwargs)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_server_socket}.
          #
          # @option kwargs [Symbol, Boolean] :verify
          #   Specifies whether to verify the SSL certificate.
          #   May be one of the following:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #
          # @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key (Network::SSL.key)
          #   The RSA key to use for the SSL context.
          #
          # @option kwargs [String] :key_file
          #   The path to the SSL `.key` file.
          #
          # @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert (Network::SSL.cert)
          #   The X509 certificate to use for the SSL context.
          #
          # @option kwargs [String] :cert_file
          #   The path to the SSL `.crt` file.
          #
          # @option kwargs [String] :ca_bundle
          #   Path to the CA certificate file or directory.
          #
          # @example
          #   ssl_accept(1337) do |client|
          #     client.puts 'lol'
          #   end
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
          def ssl_accept(port: nil, host: nil,**kwargs)
            tcp_server_session(port: port, host: host, backlog: 1) do |server|
              client     = server.accept
              ssl_client = ssl_server_socket(client,options)
              ssl_client.accept

              yield ssl_client if block_given?
              ssl_client.close
            end
          end
        end
      end
    end
  end
end
