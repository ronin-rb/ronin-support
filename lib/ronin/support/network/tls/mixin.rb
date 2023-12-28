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

require 'ronin/support/network/tls'
require 'ronin/support/network/ssl/mixin'

module Ronin
  module Support
    module Network
      module TLS
        #
        # Provides helper methods for communicating with TLS-enabled services.
        #
        module Mixin
          include SSL::Mixin

          #
          # Creates a new TLS Context.
          #
          # @param [1, 1.1, 1.2, String, Symbol, nil] version
          #   The TLS version to use.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {SSL.context}.
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
          def tls_context(version: 1.2, **kwargs)
            TLS.context(version: version, **kwargs)
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
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
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
          # @option kwargs [String, nil] :hostname (host)
          #   Sets the hostname used for SNI.
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
          #   The new SSL Socket.
          #
          # @api public
          #
          def tls_socket(socket,**kwargs)
            TLS.socket(socket,**kwargs)
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
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#ssl_connect}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
          #
          # @option kwargs [String] :bind_host
          #   The local host to bind to.
          #
          # @option kwargs [Integer] :bind_port
          #   The local port to bind to.
          #
          # @option kwargs [Integer] :timeout (5)
          #   The maximum time to attempt connecting.
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
          # @option kwargs [String, nil] :hostname (host)
          #   Sets the hostname used for SNI.
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
          #   tls_open?('www.bankofamerica.com',443)
          #
          # @example Using a timeout:
          #   tls_open?('example.com',80, timeout: 5)
          #   # => nil
          #
          # @api public
          #
          # @see TLS.open?
          #
          def tls_open?(host,port,**kwargs)
            TLS.open?(host,port,**kwargs)
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
          #   Additional keyword arguments for {#tls_socket}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
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
          # @option kwargs [String, nil] :hostname (host)
          #   Sets the hostname used for SNI.
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
          # @yield [tls_socket]
          #   The given block will be passed the new SSL socket. Once the block
          #   returns the SSL socket will be closed.
          #
          # @yieldparam [OpenSSL::SSL::SSLSocket] tls_socket
          #   The new SSL Socket.
          #
          # @return [OpenSSL::SSL::SSLSocket, nil]
          #   The new SSL Socket. If a block is given, then `nil` will be
          #   returned.
          #
          # @example
          #   socket = tls_connect('twitter.com',443)
          #
          # @example
          #   tls_connect('twitter.com',443) do |sock|
          #     sock.write("GET / HTTP/1.1\n\r\n\r")
          #
          #     sock.each_line { |line| puts line }
          #   end
          #
          # @see http://rubydoc.info/stdlib/openssl/OpenSSL/SSL/SSLSocket
          #
          # @api public
          #
          # @see TLS.connect
          #
          def tls_connect(host,port,**kwargs, &block)
            TLS.connect(host,port,**kwargs, &block)
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
          #   Additional keyword arguments for {#tls_connect}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
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
          # @option kwargs [String, nil] :hostname (host)
          #   Sets the hostname used for SNI.
          #
          # @yield [tls_socket]
          #   The given block will be passed the newly created SSL Socket.
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
          # @yieldparam [OpenSSL::SSL::SSLSocket] tls_socket
          #   The newly created SSL Socket.
          #
          # @api public
          #
          # @see TLS.connect_and_send
          #
          def tls_connect_and_send(data,host,port,**kwargs, &block)
            TLS.connect_and_send(data,host,port,**kwargs, &block)
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
          #   Additional keyword arguments for {#tls_connect}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
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
          # @option kwargs [String, nil] :hostname (host)
          #   Sets the hostname used for SNI.
          #
          # @yield [tls_socket]
          #   The given block will be passed the newly created SSL Socket.
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
          # @return [OpenSSL::X509::Certificate]
          #   The server's certificate.
          #
          # @see TLS.get_cert
          #
          def tls_cert(host,port,**kwargs)
            TLS.get_cert(host,port,**kwargs)
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
          #   Additional keyword arguments for {#tls_connect}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
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
          # @option kwargs [String, nil] :hostname (host)
          #   Sets the hostname used for SNI.
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
          #   tls_banner('smtp.gmail.com',465)
          #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
          #
          # @api public
          #
          # @see TLS.banner
          #
          def tls_banner(host,port,**kwargs, &block)
            TLS.banner(host,port,**kwargs, &block)
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
          #   Additional keyword arguments for {#tls_connect}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
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
          # @option kwargs [String, nil] :hostname (host)
          #   Sets the hostname used for SNI.
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
          #   tls_send(buffer,'victim.com',443)
          #   # => true
          #
          # @api public
          #
          # @see TLS.send
          #
          def tls_send(data,host,port,**kwargs)
            TLS.send(data,host,port,**kwargs)
          end

          #
          # Accepts an SSL session from an existing TCP socket.
          #
          # @param [TCPSocket] socket
          #   The existing TCP socket.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#tls_socket}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
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
          # @return [OpenSSL::SSL::SSLSocket]
          #   The new SSL Socket.
          #
          # @api public
          #
          # @see TLS.server_socket
          #
          def tls_server_socket(socket,**kwargs)
            TLS.server_socket(socket,**kwargs)
          end

          #
          # Creates a new SSL socket listening on a given host and port,
          # accepting clients in a loop.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#tls_server_socket}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
          #
          # @option kwargs [Integer] :port
          #   The local port to listen on.
          #
          # @option kwargs [String] :host
          #   The host to bind to.
          #
          # @option kwargs [Integer] :backlog (5)
          #   The maximum backlog of pending connections.
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
          #   tls_server_loop(port: 1337, cert: 'ssl.crt', key: 'ssl.key') do |sock|
          #     sock.puts 'lol'
          #   end
          #
          # @api public
          #
          # @see TLS.server_loop
          #
          def tls_server_loop(**kwargs,&block)
            TLS.server_loop(**kwargs,&block)
          end

          #
          # Creates a new SSL socket listening on a given host and port,
          # accepts only one client and then stops listening.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#tls_server_socket}.
          #
          # @option kwargs [1, 1.1, 1.2, String, Symbol, nil] :version (1.2)
          #   The TLS version to use.
          #
          # @option kwargs [Integer] :port
          #   The local port to listen on.
          #
          # @option kwargs [String] :host
          #   The host to bind to.
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
          #   tls_accept(1337) do |client|
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
          #   tls_accept(port: 1337, cert: 'ssl.crt', key: 'ssl.key') do |client|
          #     client.puts 'lol'
          #   end
          #
          # @api public
          #
          # @see TLS.accept
          #
          def tls_accept(**kwargs, &block)
            TLS.accept(**kwargs, &block)
          end
        end
      end
    end
  end
end
