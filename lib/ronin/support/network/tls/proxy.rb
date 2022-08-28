#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/ssl/proxy'

module Ronin
  module Support
    module Network
      module TLS
        #
        # The TLS Proxy allows for inspecting and manipulating TLS wrapped
        # protocols.
        #
        # ## Example
        # 
        #     require 'ronin/support/network/tls/proxy'
        #     require 'hexdump'
        #
        #     Ronin::Support::Network::TLS::Proxy.start(port: 1337, server: ['www.wired.com', 443]) do |proxy|
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
        # base class, the TLS Proxy also supports the following callbacks.
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
        # @since 1.0.0
        #
        class Proxy < SSL::Proxy

          #
          # Creates a new TLS Proxy.
          #
          # @param [1, 1.1, 1.2, String, Symbol, nil] version
          #   The TLS version to use.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {SSL::Proxy#initialize}.
          #
          def initialize(version: 1.2, **kwargs)
            super(version: version, **kwargs)
          end

        end
      end
    end
  end
end
