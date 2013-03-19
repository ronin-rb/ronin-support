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
      class Proxy < TCP::Proxy

        attr_accessor :cert

        attr_accessor :key

        attr_accessor :verify

        def initialize(options={},&block)
          @cert   = options.fetch(:cert,SSL::DEFAULT_CERT_FILE)
          @key    = options.fetch(:key,SSL::DEFAULT_KEY_FILE)
          @verify = options.fetch(:verify,:none)
          @certs  = options[:certs]

          super(options,&block)
        end

        protected

        #
        # @return [OpenSSL::SSL::SSLSocket]
        #   The new SSL connection.
        #
        def accept_client_connection
          client = super

          context = OpenSSL::SSL::SSLContext.new()
          context.verify_mode = SSL::VERIFY[@verify]

          context.cert = OpenSSL::X509::Certificate.new(File.new(@cert))
          context.key = OpenSSL::PKey::RSA.new(File.new(@key))

          ssl_socket = OpenSSL::SSL::SSLSocket.new(client,context)
          ssl_socket.sync_close = true
          return ssl_socket
        end

        def open_server_connection
          server = super

          context = OpenSSL::SSL::SSLContext.new()
          context.verify_mode = SSL::VERIFY[@verify]

          if @certs
            if File.file?(@certs)         then context.ca_file = @certs
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
