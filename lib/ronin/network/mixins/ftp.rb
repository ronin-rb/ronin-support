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
require 'ronin/network/ftp'

module Ronin
  module Network
    module Mixins
      #
      # Adds FTP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - FTP host.
      # * `port` (`Integer`) - FTP port.
      # * `ftp_user` (`String`) - FTP user to login as.
      # * `ftp_password` (`String`) - FTP password to login with.
      # * `ftp_account` (`String`) - FTP account information to send.
      #
      # @since 0.5.0
      #
      module FTP
        include Mixin, Network::FTP

        # FTP host
        parameter :host, type:        String,
                         description: 'FTP host'

        # FTP port
        parameter :port, type:        Integer,
                         description: 'FTP port'

        # FTP user to login as
        parameter :ftp_user, type:        String,
                             description: 'FTP user to login as'

        # FTP password to login with
        parameter :ftp_password, type:        String,
                                 description: 'FTP password to login with'

        # FTP account information to send
        parameter :ftp_account, type:        String,
                                description: 'FTP account information'

        #
        # Creates a connection to the FTP server. The `host`, `port`,
        # `ftp_user`, `ftp_password` and `ftp_account` parameters
        # will also be used to connect to the server.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (port)
        #   The port to connect to.
        #
        # @option options [String] :user (ftp_user)
        #   The username to authenticate with.
        #
        # @option options [String] :password (ftp_password)
        #   The password to authenticate with.
        #
        # @option options [String] :account (ftp_account)
        #   The account information to send via the FTP `ACCT` command.
        #
        # @yield [session]
        #   If a block is given, it will be passed an FTP session object.
        #
        # @yieldparam [Net::FTP] session
        #   The FTP session.
        #
        # @return [Net::FTP]
        #   The FTP session.
        #
        # @see Network::FTP#ftp_connect
        #
        # @api public
        #
        def ftp_connect(host=nil,options={},&block)
          host  ||= self.host
          options = ftp_merge_options(options)

          print_info "Connecting to #{host}:#{options[:port]} ..."

          return super(host,options,&block)
        end

        #
        # Starts a session with the FTP server. The `host`, `port`,
        # `ftp_login`, `ftp_user` and `ftp_password` parameters
        # will also be used to connect to the server.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (FTP.default_port)
        #   The port to connect to.
        #
        # @option options [String] :user (DEFAULT_USER)
        #   The user to authenticate with.
        #
        # @option options [String] :password
        #   The password to authenticate with.
        #
        # @option options [String] :account
        #   The FTP account information to send via the `ACCT` command.
        #
        # @option options [Boolean] :passive (true)
        #   Specifies whether the FTP session should use passive mode.
        #
        # @yield [session]
        #   If a block is given, it will be passed an FTP session object.
        #   After the block has returned, the session will be closed.
        #
        # @yieldparam [Net::FTP] session
        #   The FTP session.
        #
        # @see Network::FTP#ftp_session
        #
        # @api public
        #
        def ftp_session(host=nil,options={},&block)
          host  ||= self.host
          options = ftp_merge_options(options)

          super(host,options) do |sess|
            yield sess if block_given?

            print_info "Logging out ..."
          end

          print_info "Disconnected to #{host}:#{options[:port]}"
          return nil
        end

        private

        #
        # Merges the FTP parameters into the options for {Network::FTP}
        # methods.
        #
        # @param [Hash] options
        #   The original options.
        #
        # @return [Hash]
        #   The merged options.
        #
        # @api private
        #   
        def ftp_merge_options(options={})
          options[:port]     ||= self.port
          options[:user]     ||= self.ftp_user
          options[:password] ||= self.ftp_password
          options[:account]  ||= self.ftp_account

          return options
        end
      end
    end
  end
end
