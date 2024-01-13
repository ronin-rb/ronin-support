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

require 'ronin/support/network/tcp/proxy'
require 'ronin/support/network/ssl'

module Ronin
  module Support
    module Network
      module SSL
        #
        # The SSL Proxy allows for inspecting and manipulating SSL wrapped
        # protocols.
        #
        # ## Example
        #
        #     require 'ronin/support/network/ssl/proxy'
        #     require 'hexdump'
        #
        #     Ronin::Support::Network::SSL::Proxy.start(port: 1337, server: ['www.wired.com', 443]) do |proxy|
        #       address = lambda { |socket|
        #         addrinfo = socket.peeraddr
        #
        #        "#{addrinfo[3]}:#{addrinfo[1]}"
        #       }
        #       hex = Hexdump::Hexdump.new
        #
        #       proxy.on_client_data do |client,server,data|
        #         puts "#{address[client]} -> #{proxy}"
        #         hex.dump(data)
        #       end
        #
        #       proxy.on_client_connect do |client|
        #         puts "#{address[client]} -> #{proxy} [connected]"
        #       end
        #
        #       proxy.on_client_disconnect do |client,server|
        #         puts "#{address[client]} <- #{proxy} [disconnected]"
        #       end
        #
        #       proxy.on_server_data do |client,server,data|
        #         puts "#{address[client]} <- #{proxy}"
        #         hex.dump(data)
        #       end
        #
        #       proxy.on_server_connect do |client,server|
        #         puts "#{address[client]} <- #{proxy} [connected]"
        #       end
        #
        #       proxy.on_server_disconnect do |client,server|
        #         puts "#{address[client]} <- #{proxy} [disconnected]"
        #       end
        #     end
        #
        # ## Callbacks
        #
        # In addition to the events supported by the {Network::Proxy Proxy}
        # base class, the SSL Proxy also supports the following callbacks.
        #
        # ### client_connect
        #
        # When a client connects to the proxy:
        #
        #     on_client_connect do |client|
        #       puts "[connected] #{client.remote_address.ip_address}:#{client.remote_addre
        #     end
        #
        # ### client_disconnect
        #
        # When a client disconnects from the proxy:
        #
        #     on_client_disconnect do |client,server|
        #       puts "[disconnected] #{client.remote_address.ip_address}:#{client.remote_ad
        #     end
        #
        # ### server_connect
        #
        # When the server accepts a connection from the proxy:
        #
        #     on_server_connect do |client,server|
        #       puts "[connected] #{proxy}"
        #     end
        #
        # ### server_disconnect
        #
        # When the server closes a connection from the proxy.
        #
        #     on_server_disconnect do |client,server|
        #       puts "[disconnected] #{proxy}"
        #     end
        #
        # ### connect
        #
        # Alias for {#on_server_connect}.
        #
        # ### disconnect
        #
        # Alias for {#on_client_disconnect}.
        #
        # @since 0.6.0
        #
        class Proxy < TCP::Proxy

          # The SSL version to use.
          #
          # @return [1, 1.1, 1.2, String, Symbol, nil]
          #
          # @since 1.0.0
          attr_reader :version

          # The RSA key to use.
          #
          # @return [Crypto::Key::RSA, OpenSSL::PKey::RSA, nil]
          attr_accessor :key

          # The path to the SSL `.key` file.
          #
          # @return [String, nil]
          attr_accessor :key_file

          # The X509 certificate to use.
          #
          # @return [Crypto::Cert, OpenSSL::X509::Certificate, nil]
          attr_accessor :cert

          # The path to the X509 `.crt` or `.pem` file.
          #
          # @return [String, nil]
          attr_accessor :cert_file

          # The SSL verify mode
          #
          # @return [Symbol, Boolean]
          attr_accessor :verify

          # Path to the CA certificate file or directory.
          #
          # @return [String]
          attr_accessor :ca_bundle

          #
          # Creates a new SSL Proxy.
          #
          # @param [1, 1.1, 1.2, String, Symbol, nil] version
          #   The SSL version to use.
          #
          # @param [Crypto::Key::RSA, OpenSSL::PKey::RSA] key
          #   The SSL key.
          #
          # @param [String] key_file
          #   The path to the SSL `.key` file.
          #
          # @param [Crypto::Cert, OpenSSL::X509::Certificate] cert
          #   The SSL X509 certificate.
          #
          # @param [String] cert_file
          #   The path to the SSL `.crt` file.
          #
          # @param [Symbol, Boolean] verify
          #   The SSL verify mode. Must be one of:
          #
          #   * `:none`
          #   * `:peer`
          #   * `:fail_if_no_peer_cert`
          #   * `:client_once`
          #   * `true` (alias for `:peer`)
          #   * `false` (alias for `:none`)
          #
          # @param [String, nil] ca_bundle
          #   Path to the CA certificate file or directory.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {TCP::Proxy#initialize}.
          #
          # @see Network::Proxy#initialize
          #
          def initialize(version:   nil,
                         key:       SSL.key,
                         key_file:  nil,
                         cert:      SSL.cert,
                         cert_file: nil,
                         verify:    :none,
                         ca_bundle: nil,
                         **kwargs,
                         &block)
            @version   = version
            @key       = key
            @key_file  = key_file
            @cert      = cert
            @cert_file = cert_file
            @verify    = verify
            @ca_bundle = ca_bundle

            super(**kwargs,&block)
          end

          protected

          #
          # Sends data to a connection.
          #
          # @param [OpenSSL::SSL::SSLSocket] connection
          #   A SSL connection to write data to.
          #
          # @param [String] data
          #   The data to write.
          #
          # @api public
          #
          def send(connection,data)
            connection.write(data)
          end

          #
          # Receives data from a connection.
          #
          # @param [OpenSSL::SSL::SSLSocket] connection
          #   The SSL connection to receive data from.
          #
          # @return [String, nil]
          #   The received data.
          #
          # @api public
          #
          def recv(connection)
            connection.readpartial(@buffer_size)
          rescue Errno::ECONNRESET, EOFError
            ''
          end

          #
          # Accepts a client connection from the server socket.
          #
          # @return [OpenSSL::SSL::SSLSocket]
          #   The new SSL connection.
          #
          def accept_client_connection
            client     = super
            context    = SSL.context(version:   @version,
                                     key:       @key,
                                     key_file:  @key_file,
                                     cert:      @cert,
                                     cert_file: @cert_file,
                                     verify:    @verify)
            ssl_socket = OpenSSL::SSL::SSLSocket.new(client,context)

            ssl_socket.sync_close = true

            begin
              ssl_socket.accept
            rescue OpenSSL::SSL::SSLError
              return nil
            end

            return ssl_socket
          end

          #
          # Opens a new connection to the server.
          #
          # @return [OpenSSL::SSL::SSLSocket]
          #   The new server connection.
          #
          def open_server_connection
            server_socket = super
            context       = SSL.context(verify: @verify, ca_bundle: @ca_bundle)
            ssl_socket    = OpenSSL::SSL::SSLSocket.new(server_socket,context)

            ssl_socket.sync_close = true
            ssl_socket.connect

            return ssl_socket
          end

        end
      end
    end
  end
end
