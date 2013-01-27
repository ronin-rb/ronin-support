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
require 'ronin/network/imap'

module Ronin
  module Network
    module Mixins
      #
      # Adds IMAP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - IMAP host.
      # * `port` (`Integer`) - IMAP port.
      # * `imap_auth` (`String`) - IMAP authentication method.
      # * `imap_user` (`String`) - IMAP user to login as.
      # * `imap_password` (`String`) - IMAP password to login with.
      #
      module IMAP
        include Mixin, Network::IMAP

        # IMAP host
        parameter :host, type:        String,
                         description: 'IMAP host'

        # IMAP port
        parameter :port, type:        Integer,
                         description: 'IMAP port'

        # IMAP auth
        parameter :imap_auth, type:        String,
                              description: 'IMAP authentication method'

        # IMAP user to login as
        parameter :imap_user, type:        String,
                              description: 'IMAP user to login as'

        # IMAP password to login with
        parameter :imap_password, type:        String,
                                  description: 'IMAP password to login with'

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
        # Creates a connection to the IMAP server.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port
        #   The port the IMAP server is running on. Defaults to {#port}.
        #
        # @option options [Boolean, Hash] :ssl
        #   Additional SSL options. Enabled when {#ssl} is set.
        #
        # @option :ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #   Defaults to {#ssl_verify}.
        #
        # @option :ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #   Defaults to {#ssl_cert}.
        #
        # @option options [Symbol] :auth
        #   The type of authentication to perform when connecting to the
        #   server. Defaults to {#imap_auth}.
        #
        # @option options [String] :user
        #   The user to authenticate as when connecting to the server.
        #   Defaults to {#imap_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the
        #   server. Defaults to {#imap_password}.
        #
        # @option options [Boolean]
        #   Indicates wether or not to use SSL when connecting to the
        #   server.
        #
        # @yield [imap]
        #   If a block is given, it will be passed the newly created IMAP
        #   session.
        #
        # @yieldparam [Net::IMAP] imap
        #   The newly created IMAP session object.
        #
        # @return [Net::IMAP]
        #   The newly created IMAP session object.
        #
        # @see Network::IMAP#imap_connect
        #
        # @api public
        #
        def imap_connect(host=nil,options={},&block)
          host  ||= self.host
          options = imap_merge_options(options)

          print_info "Connecting to #{host}:#{options[:port]} ..."

          return super(host,options,&block)
        end

        #
        # Starts a session with the IMAP server.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port
        #   The port the IMAP server is running on. Defaults to {#port}.
        #
        # @option options [Boolean, Hash] :ssl
        #   Additional SSL options.
        #
        # @option :ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #
        # @option :ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #
        # @option options [Symbol] :auth
        #   The type of authentication to perform when connecting to the
        #   server. Defaults to {#imap_auth}.
        #
        # @option options [String] :user
        #   The user to authenticate as when connecting to the server.
        #   Defaults to {#imap_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the
        #   server. Defaults to {#imap_password}.
        #
        # @option options [Boolean]
        #   Indicates wether or not to use SSL when connecting to the
        #   server.
        #
        # @yield [imap]
        #   If a block is given, it will be passed the newly created
        #   IMAP session. After the block has returned, the session will
        #   be closed.
        #
        # @yieldparam [Net::IMAP] imap
        #   The newly created IMAP session object.
        #
        # @return [nil]
        #
        # @see Network::IMAP#imap_session
        #
        # @api public
        #
        def imap_session(host=nil,options={})
          host  ||= self.host
          options = imap_merge_options(options)

          super(host,options) do |sess|
            yield sess if block_given?

            print_info "Logging out ..."
          end

          print_info "Disconnected from #{host}:#{options[:port]}"
          return nil
        end

        private

        #
        # Merges the IMAP parameters into the options for {Network::IMAP}
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
        def imap_merge_options(options={})
          options[:port]     ||= self.port
          options[:auth]     ||= self.imap_auth
          options[:user]     ||= self.imap_user
          options[:password] ||= self.imap_password

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
