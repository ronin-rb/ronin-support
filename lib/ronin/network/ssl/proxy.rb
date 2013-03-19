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

require 'ronin/network/proxy'
require 'ronin/network/ssl/ssl'

module Ronin
  module Network
    module SSL
      #
      # The SSL Proxy allows for inspecting and manipulating SSL wrapped
      # protocols.
      #
      # ## Example
      # 
      #     require 'ronin/network/ssl/proxy'
      #     require 'hexdump'
      #
      #     Ronin::Network::SSL::Proxy.start(port: 1337, server: ['www.wired.com', 443]) do |proxy|
      #       address = lambda { |socket|
      #         addrinfo = socket.peeraddr
      #
      #        "#{addrinfo[3]}:#{addrinfo[1]}"
      #       }
      #       hex = Hexdump::Dumper.new
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

        # The path to the SSL `.crt` file.
        #
        # @return [String]
        attr_accessor :cert

        # The path to the SSL `.key` file.
        #
        # @return [String]
        attr_accessor :key

        # The SSL verify mode
        #
        # @return [Symbol, Boolean]
        attr_accessor :verify

        # Path to the CA certificate file or directory.
        #
        # @return [String]
        attr_accessor :certs

        #
        # Creates a new SSL Proxy.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :cert (SSL::DEFAULT_CERT_FILE)
        #   The path to the SSL `.crt` file.
        #
        # @option options [String] :key (SSL::DEFAULT_KEY_FILE)
        #   The path to the SSL `.key` file.
        #
        # @option options [Symbol, Boolean] :verify (:none)
        #   The SSL verify mode. Must be one of:
        #
        #   * `:none`
        #   * `:peer`
        #   * `:fail_if_no_peer_cert`
        #   * `:client_once`
        #   * `true` (alias for `:peer`)
        #   * `false` (alias for `:none`)
        #
        # @option options [String] :certs
        #   Path to the CA certificate file or directory.
        #
        # @see Network::Proxy#initialize
        #
        def initialize(options={},&block)
          @cert   = options.fetch(:cert,SSL::DEFAULT_CERT_FILE)
          @key    = options.fetch(:key,SSL::DEFAULT_KEY_FILE)
          @verify = options.fetch(:verify,:none)
          @certs  = options[:certs]

          super(options,&block)
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
        end

        #
        # @return [OpenSSL::SSL::SSLSocket]
        #   The new SSL connection.
        #
        def accept_client_connection
          client = super

          context = OpenSSL::SSL::SSLContext.new()
          context.verify_mode = SSL::VERIFY[@verify]

          context.cert = OpenSSL::X509::Certificate.new(File.new(@cert))
          context.key  = OpenSSL::PKey::RSA.new(File.new(@key))

          ssl_socket = OpenSSL::SSL::SSLSocket.new(client,context)
          ssl_socket.sync_close = true
          ssl_socket.accept
          return ssl_socket
        end

        #
        # Opens a new connection to the server.
        #
        # @return [OpenSSL::SSL::SSLSocket]
        #   The new server connection.
        #
        def open_server_connection
          server = super

          context = OpenSSL::SSL::SSLContext.new()
          context.verify_mode = SSL::VERIFY[@verify]

          if @certs
            if    File.file?(@certs)      then context.ca_file = @certs
            elsif File.directory?(@certs) then context.ca_path = @certs
            end
          end

          ssl_socket = OpenSSL::SSL::SSLSocket.new(server,context)
          ssl_socket.sync_close = true
          return ssl_socket
        end

      end
    end
  end
end
