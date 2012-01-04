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

require 'ronin/network/mixins/mixin'
require 'ronin/network/ssl'

module Ronin
  module Network
    module Mixins
      #
      # Adds SSL convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - SSL host.
      # * `port` (`Integer`) - SSL port.
      # * `local_host` (`String`) - SSL local host.
      # * `local_port` (`Integer`) - SSL local port.
      #
      module TCP
        include Mixin, Network::SSL

        # SSL host
        parameter :host, :type => String,
                         :description => 'SSL host'

        # SSL port
        parameter :port, :type => Integer,
                         :description => 'SSL port'

        # SSL local host
        parameter :local_host, :type => String,
                               :description => 'SSL local host'

        # SSL local port
        parameter :local_port, :type => Integer,
                               :description => 'SSL local port'

        protected

        #
        # Establishes a SSL connection.
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
        #   socket = ssl_connect
        #
        # @api public
        #
        def ssl_connect(host,port,options={},&block)
          options = options.merge(
            :local_host => self.local_host,
            :local_port => self.local_port
          )

          super(self.host,self.port,options,&block)
        end

        #
        # Creates a new temporary SSL connection.
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
        #   ssl_session do |socket|
        #     socket.write("GET /\n\n")
        #
        #     socket.each_line { |line| puts line }
        #   end
        #
        # @api public
        #
        def ssl_session(options={},&block)
          super(self.host,self.port,options,&block)
        end
      end
    end
  end
end
