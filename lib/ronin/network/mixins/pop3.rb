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
require 'ronin/network/pop3'

module Ronin
  module Network
    module Mixins
      #
      # Adds POP3 convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - POP3 host.
      # * `port` (`Integer`) - POP3 port.
      # * `pop3_user` (`String`) - POP3 user to login as.
      # * `pop3_password` (`String`) - POP3 password to login with.
      # * `ssl` (`Boolean`) - Enables SSL.
      # * `ssl_verify` (`Boolean`) - SSL verify mode.
      # * `ssl_cert` (`String`) - Path to the `.crt` file.
      #
      module POP3
        include Mixin, Network::POP3

        # POP3 host
        parameter :host, type:        String,
                         description: 'POP3 host'

        # POP3 port
        parameter :port, type:        Integer,
                         default:     Network::POP3.default_port,
                         description: 'POP3 port'

        # POP3 user
        parameter :pop3_user, type:        String,
                              description: 'POP3 user to login as'

        # POP3 password
        parameter :pop3_password, type:        String,
                                  description: 'POP3 password to login with'

        # Enables SSL support
        parameter :ssl, type:        true,
                        description: 'Enables SSL support'

        # SSL verify mode
        parameter :ssl_verify, type:        true,
                               description: 'Verifies the SSL certificate'

        # SSL cert file
        parameter :ssl_cert, type:        String,
                             description: 'SSL cert file'

        #
        # Creates a connection to the POP3 server.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port
        #   The port the POP3 server is running on. Defaults to {#port}.
        #
        # @option options [Boolean, Hash] :ssl
        #   Additional SSL options. Enabled if {#ssl} is set.
        #
        # @option :ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #   Defaults to {#ssl_verify}.
        #
        # @option :ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #   Defaults to {#ssl_cert}.
        #
        # @option options [String] :user
        #   The user to authenticate with when connecting to the POP3
        #   server. Defaults to {#pop3_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the POP3
        #   server. Defaults to {#pop3_password}.
        #
        # @yield [pop3]
        #   If a block is given, it will be passed the newly created
        #   POP3 session.
        #
        # @yieldparam [Net::POP3] pop3
        #   The newly created POP3 session.
        #
        # @return [Net::POP3]
        #   The newly created POP3 session.
        #
        # @see Network::POP3#pop3_connect
        #
        # @api public
        #
        def pop3_connect(host=nil,options={},&block)
          host  ||= self.host
          options = pop3_merge_options(options)

          print_info "Connecting to #{host}:#{options[:port]} ..."

          return super(host,options,&block)
        end

        #
        # Starts a session with the POP3 server.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port
        #   The port the POP3 server is running on. Defaults to {#port}.
        #
        # @option options [Boolean, Hash] :ssl
        #   Additional SSL options. Enabled if {#ssl} is set.
        #
        # @option :ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #   Defaults to {#ssl_verify}.
        #
        # @option :ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #   Defaults to {#ssl_cert}.
        #
        # @option options [String] :user
        #   The user to authenticate with when connecting to the POP3
        #   server. Defaults to {#pop3_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the POP3
        #   server. Defaults to {#pop3_password}.
        #
        # @yield [pop3]
        #   If a block is given, it will be passed the newly created
        #   POP3 session. After the block has returned, the session
        #   will be closed.
        #
        # @yieldparam [Net::POP3] pop3
        #   The newly created POP3 session.
        #
        # @return [nil]
        #
        # @see Network::POP3#pop3_session
        #
        # @api public
        #
        def pop3_session(host=nil,options={})
          host  ||= self.host
          options = pop3_merge_options(options)

          super(host,options) do |sess|
            yield sess if block_given?

            print_info "Logging out ..."
          end

          print_info "Disconnected to #{host}:#{options[:port]}"
          return nil
        end

        private

        #
        # Merges the POP3 parameters into the options for {Network::POP3}
        # methods.
        #
        # @param [Hash] options
        #   The original options.
        #
        # @return [Hash]
        #   The merged options.
        #
        # @since 0.4.0
        #
        # @api private
        #   
        def pop3_merge_options(options={})
          options[:port]     ||= self.port
          options[:user]     ||= self.pop3_user
          options[:password] ||= self.pop3_password

          if self.ssl?
            options[:ssl] = options.fetch(:ssl) do
              {verify: self.ssl_verify?, certs:  self.ssl_cert}
            end
          end

          return options
        end
      end
    end
  end
end
