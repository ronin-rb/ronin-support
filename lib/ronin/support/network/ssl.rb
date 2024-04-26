# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/support/crypto/openssl'
require 'ronin/support/crypto/key'
require 'ronin/support/network/ssl/local_key'
require 'ronin/support/network/ssl/local_cert'
require 'ronin/support/network/ssl/proxy'
require 'ronin/support/network/tcp'

module Ronin
  module Support
    module Network
      #
      # Top-level SSL methods.
      #
      module SSL
        # SSL/TLS versions
        VERSIONS = {
          1   => OpenSSL::SSL::TLS1_VERSION,
          1.1 => OpenSSL::SSL::TLS1_1_VERSION,
          1.2 => OpenSSL::SSL::TLS1_2_VERSION,

          # deprecated TLS version symbols
          :TLSv1   => OpenSSL::SSL::TLS1_VERSION,
          :TLSv1_1 => OpenSSL::SSL::TLS1_1_VERSION,
          :TLSv1_2 => OpenSSL::SSL::TLS1_2_VERSION
        }

        # SSL verify modes
        VERIFY = {
          none:                 OpenSSL::SSL::VERIFY_NONE,
          peer:                 OpenSSL::SSL::VERIFY_PEER,
          fail_if_no_peer_cert: OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT,
          client_once:          OpenSSL::SSL::VERIFY_CLIENT_ONCE,
          true               => OpenSSL::SSL::VERIFY_PEER,
          false              => OpenSSL::SSL::VERIFY_NONE
        }

        #
        # The default RSA key used for all SSL server sockets.
        #
        # @return [Crypto::Key::RSA]
        #   The default RSA key.
        #
        def self.key
          @key ||= LocalKey.fetch
        end

        #
        # Overrides the default RSA key.
        #
        # @param [Crypto::Key::RSA, OpenSSL::PKey::RSA] new_key
        #   The new RSA key.
        #
        # @return [Crypto::Key::RSA, OpenSSL::PKey::RSA]
        #   The new default RSA key.
        #
        def self.key=(new_key)
          @key = new_key
        end

        #
        # The default SSL certificate used for all SSL server sockets.
        #
        # @return [Crypto::Cert]
        #   The default SSL certificate.
        #
        def self.cert
          @cert ||= LocalCert.fetch
        end

        #
        # Overrides the default SSL certificate.
        #
        # @param [Crypto::Cert, OpenSSL::X509::Certificate] new_cert
        #   The new SSL certificate.
        #
        # @return [Crypto::Cert, OpenSSL::X509::Certificate]
        #   The new default SSL certificate.
        #
        def self.cert=(new_cert)
          @cert = new_cert
        end

        #
        # Creates a new SSL Context.
        #
        # @param [1, 1.1, 1.2, Symbol, nil] version
        #   The SSL version to use.
        #
        # @param [1, 1.1, 1.2, Symbol, nil] min_version
        #   The minimum SSL version to use.
        #
        # @param [1, 1.1, 1.2, Symbol, nil] max_version
        #   The maximum SSL version to use.
        #
        # @param [Symbol, Boolean] verify
        #   Specifies whether to verify the SSL certificate.
        #   May be one of the following:
        #
        #   * `:none`
        #   * `:peer`
        #   * `:fail_if_no_peer_cert`
        #   * `:client_once`
        #
        # @param [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] key
        #   The RSA key to use for the SSL context.
        #
        # @param [String, nil] key_file
        #   The path to the RSA `.key` file.
        #
        # @param [Crypto::Cert, OpenSSL::X509::Certificate, nil] cert
        #   The X509 certificate to use for the SSL context.
        #
        # @param [String, nil] cert_file
        #   The path to the SSL `.crt` or `.pem` file.
        #
        # @param [String, nil] ca_bundle
        #   Path to the CA bundle file or directory.
        #
        # @return [OpenSSL::SSL::SSLContext]
        #   The newly created SSL Context.
        #
        # @raise [ArgumentError]
        #   `cert_file:` or `cert:` keyword arguments also require a `key_file:`
        #   or `key:` keyword argument.
        #
        # @api semipublic
        #
        # @since 1.0.0
        #
        def self.context(version:     nil,
                         min_version: nil,
                         max_version: nil,
                         verify:      :none,
                         key:         nil,
                         key_file:    nil,
                         cert:        nil,
                         cert_file:   nil,
                         ca_bundle:   nil)
          context = OpenSSL::SSL::SSLContext.new

          if version
            version = VERSIONS.fetch(version,version)

            context.min_version = context.max_version = version
          else min_version || max_version
            if min_version
              context.min_version = VERSIONS.fetch(min_version,min_version)
            end

            if max_version
              context.max_version = VERSIONS.fetch(max_version,max_version)
            end
          end

          context.verify_mode = VERIFY[verify]

          if (key_file || key) && (cert_file || cert)
            context.key  = if key_file then Crypto::Key.load_file(key_file)
                           else             key
                           end

            context.cert = if cert_file then Crypto::Cert.load_file(cert_file)
                           else              cert
                           end
          elsif (key_file || key) || (cert_file || cert)
            raise(ArgumentError,"cert_file: and cert: keyword arguments also require a key_file: or key: keyword argument")
          end

          if ca_bundle
            if File.file?(ca_bundle)
              context.ca_file = ca_bundle
            elsif File.directory?(ca_bundle)
              context.ca_path = ca_bundle
            end
          end

          return context
        end

        #
        # @!macro context_kwargs
        #   @option kwargs [1, 1.1, 1.2, Symbol, nil] :version
        #     The SSL version to use.
        #
        #   @option kwargs [1, 1.1, 1.2, Symbol, nil] :min_version
        #     The minimum SSL version to use.
        #
        #   @option kwargs [1, 1.1, 1.2, Symbol, nil] :max_version
        #     The maximum SSL version to use.
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
        # Initiates an SSL session with an existing TCP socket.
        #
        # @param [TCPSocket] socket
        #   The existing TCP socket.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {context}.
        #
        # @!macro context_kwargs
        #
        # @return [OpenSSL::SSL::SSLSocket]
        #   The new SSL Socket.
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.socket(socket,**kwargs)
          ssl_socket = OpenSSL::SSL::SSLSocket.new(socket,context(**kwargs))

          ssl_socket.sync_close = true
          return ssl_socket
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
        # @param [Integer] timeout (5)
        #   The maximum time to attempt connecting.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {connect}.
        #
        # @!macro connect_kwargs
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
        # @since 1.1.0
        #
        def self.open?(host,port, timeout: 5, **kwargs)
          Timeout.timeout(timeout) do
            connect(host,port,**kwargs)
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
        # @param [String, nil] hostname
        #   Sets the hostname used for SNI.
        #
        # @param [String] bind_host
        #   The local host to bind to.
        #
        # @param [Integer] bind_port
        #   The local port to bind to.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {socket}.
        #
        # @!macro context_kwargs
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
        #
        # @example
        #   socket = SSL.connect('twitter.com',443)
        #
        # @example
        #   SSL.connect('twitter.com',443) do |sock|
        #     sock.write("GET / HTTP/1.1\n\r\n\r")
        #
        #     sock.each_line { |line| puts line }
        #   end
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.connect(host,port, hostname: host,
                                    bind_host: nil,
                                    bind_port: nil,
                                    **kwargs)
          socket     = TCP.connect(host,port,bind_host: bind_host,
                                             bind_port: bind_port)
          ssl_socket = self.socket(socket,**kwargs)

          ssl_socket.hostname = hostname
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {connect}.
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
        # @since 1.1.0
        #
        def self.connect_and_send(data,host,port,**kwargs)
          socket = connect(host,port,**kwargs)
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
        #   Additional keyword arguments for {connect}.
        #
        # @!macro connect_kwargs
        #
        # @return [Crypto::Cert]
        #   The server's certificate.
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.get_cert(host,port,**kwargs)
          socket = connect(host,port,**kwargs)
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {connect}.
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
        #   SSL.banner('smtp.gmail.com',465)
        #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.banner(host,port,**kwargs)
          banner = nil

          connect(host,port,**kwargs) do |ssl_socket|
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
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {connect}.
        #
        # @!macro connect_kwargs
        #
        # @return [true]
        #   The data was successfully sent.
        #
        # @example
        #   buffer = "GET /#{'A' * 4096}\n\r"
        #   SSL.send(buffer,'victim.com',443)
        #   # => true
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.send(data,host,port,**kwargs)
          connect(host,port,**kwargs) do |socket|
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
        #   Additional keyword arguments for {socket}.
        #
        # @!macro context_kwargs
        #
        # @return [OpenSSL::SSL::SSLSocket]
        #   The new SSL Socket.
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.server_socket(socket, key:  Network::SSL.key,
                                       cert: Network::SSL.cert,
                                       **kwargs)
          socket(socket, cert: cert, key: key, **kwargs)
        end

        #
        # Creates a new SSL server listening on a given host and port.
        #
        # @param [Integer] port
        #   The local port to listen on.
        #
        # @param [String, nil] host
        #   The host to bind to.
        #
        # @param [Integer] backlog (5)
        #   The maximum backlog of pending connections.
        #
        # @param [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] key
        #   The RSA key to use for the SSL context.
        #
        # @param [Crypto::Cert, OpenSSL::X509::Certificate, nil] cert
        #   The X509 certificate to use for the SSL context.
        #
        # @!macro context_kwargs
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
        def self.server(port:    0,
                        host:    nil,
                        backlog: 5,
                        key:     Network::SSL.key,
                        cert:    Network::SSL.cert,
                        **kwargs)
          context    = self.context(key: key, cert: cert, **kwargs)
          tcp_server = TCP.server(port: port, host: host, backlog: backlog)
          ssl_server = OpenSSL::SSL::SSLServer.new(tcp_server,context)

          yield ssl_server if block_given?
          return ssl_server
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
        #   @option kwargs [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil] :key (Network::SSL.key)
        #     The RSA key to use for the SSL context.
        #
        #   @option kwargs [Crypto::Cert, OpenSSL::X509::Certificate, nil] :cert (Network::SSL.cert)
        #     The X509 certificate to use for the SSL context.
        #
        #   @!macro context_kwargs
        #

        #
        # Creates a new temporary SSL server listening on a given host and
        # port.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {server}.
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
        def self.server_session(**kwargs,&block)
          ssl_server = self.server(**kwargs,&block)
          ssl_server.close
          return ssl_server
        end

        #
        # Creates a new SSL socket listening on a given host and port,
        # accepting clients in a loop.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {server}.
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
        #   SSL.server_loop(port: 1337, cert: 'ssl.crt', key: 'ssl.key') do |sock|
        #     sock.puts 'lol'
        #   end
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.server_loop(**kwargs)
          server(**kwargs) do |ssl_server|
            loop do
              ssl_client = ssl_server.accept

              yield ssl_client if block_given?
              ssl_client.close
            end
          end
        end

        #
        # Creates a new SSL socket listening on a given host and port,
        # accepts only one client and then stops listening.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {server}.
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
        # @example Using a self-signed certificate:e
        #   # $ openssl genrsa -out ssl.key 1024
        #   # $ openssl req -new -key ssl.key -x509 -days 3653 -out ssl.crt
        #   # $ cat ssl.key ssl.crt > ssl.pem
        #   # $ chmod 600 ssl.key ssl.pem
        #   SSL.accept(port: 1337, cert: 'ssl.crt', key: 'ssl.key') do |client|
        #     client.puts 'lol'
        #   end
        #
        # @api public
        #
        # @since 1.1.0
        #
        def self.accept(**kwargs)
          server_session(**kwargs) do |server|
            ssl_client = server.accept

            yield ssl_client if block_given?
            ssl_client.close
          end
        end
      end
    end
  end
end
