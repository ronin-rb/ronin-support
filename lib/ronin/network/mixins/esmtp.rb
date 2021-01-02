#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
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
# along with ronin-support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/network/mixins/mixin'
require 'ronin/network/esmtp'

module Ronin
  module Network
    module Mixins
      #
      # Adds ESMTP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - ESMTP host.
      # * `port` (`Integer`) - ESMTP port.
      # * `esmtp_login` (`String`) - ESMTP authentication method to use.
      # * `esmtp_user` (`String`) - ESMTP user to login as.
      # * `esmtp_password` (`String`) - ESMTP password to login with.
      #
      module ESMTP
        include Mixin, Network::ESMTP

        # ESMTP host
        parameter :host, :type => String,
                         :description => 'ESMTP host'

        # ESMTP port
        parameter :port, :type => Integer,
                         :description => 'ESMTP port'

        # ESMTP authentication method to use
        parameter :esmtp_login, :type => String,
                                :description => 'ESMTP authentication method to use'

        # ESMTP user to login as
        parameter :esmtp_user, :type => String,
                               :description => 'ESMTP user to login as'

        # ESMTP password to login with
        parameter :esmtp_password, :type => String,
                                   :description => 'ESMTP password to login with'

        protected

        #
        # Creates a connection to the ESMTP server. The `host`, `port`,
        # `esmtp_login`, `esmtp_user` and `esmtp_password` parameters
        # will also be used to connect to the ESMTP server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (Ronin::Network::SMTP.default_port)
        #  The port to connect to.
        #
        # @option options [String] :helo
        #   The HELO domain.
        #
        # @option options [Symbol] :auth
        #   The type of authentication to use.
        #   Can be either `:login`, `:plain`, or `:cram_md5`.
        #
        # @option options [String] :user
        #   The user-name to authenticate with.
        #
        # @option options [String] :password
        #   The password to authenticate with.
        #
        # @yield [session]
        #   If a block is given, it will be passed an ESMTP enabled
        #   session object.
        #
        # @yieldparam [Net::SMTP] session
        #   The ESMTP session.
        #
        # @return [Net::SMTP]
        #   The ESMTP enabled session.
        #
        # @see Network::ESMTP#esmtp_connect
        #
        # @api public
        #
        def esmtp_connect(options={},&block)
          print_info "Connecting to #{host_port} ..."

          return super(self.host,esmtp_merge_options(options),&block)
        end

        #
        # Starts a session with the ESMTP server. The `host`, `port`,
        # `esmtp_login`, `esmtp_user` and `esmtp_password` parameters
        # will also be used to connect to the ESMTP server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @yield [session]
        #   If a block is given, it will be passed an ESMTP enabled
        #   session object. After the block has returned, the session
        #   will be closed.
        #
        # @yieldparam [Net::SMTP] session
        #   The ESMTP session.
        #
        # @see Network::ESMTP#esmtp_session
        #
        # @api public
        #
        def esmtp_session(options={})
          super(esmtp_merge_options(options)) do |sess|
            yield sess if block_given?

            print_info "Logging out ..."
          end

          print_info "Disconnected from #{host_port}"
          return nil
        end

        private

        #
        # Merges the ESMTP parameters into the options for {Network::ESMTP}
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
        def esmtp_merge_options(options={})
          options[:port]     ||= self.port
          options[:login]    ||= self.esmtp_login
          options[:user]     ||= self.esmtp_user
          options[:password] ||= self.esmtp_password

          return options
        end
      end
    end
  end
end
