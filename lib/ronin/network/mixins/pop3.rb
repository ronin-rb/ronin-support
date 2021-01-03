#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
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
      #
      module POP3
        include Mixin, Network::POP3

        # POP3 host
        parameter :host, :type => String,
                         :description => 'POP3 host'

        # POP3 port
        parameter :port, :type => Integer,
                         :description => 'POP3 port'

        # POP3 user
        parameter :pop3_user, :type => String,
                              :description => 'POP3 user to login as'

        # POP3 password
        parameter :pop3_password, :type => String,
                                  :description => 'POP3 password to login with'

        protected

        #
        # Creates a connection to the POP3 server. The `host}, `port`,
        # `pop3_user` and `pop3_password` parameters will also be used
        # to connect to the server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (Ronin::Network::POP3.default_port)
        #   The port the POP3 server is running on.
        #
        # @option options [String] :user
        #   The user to authenticate with when connecting to the POP3
        #   server.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the POP3
        #   server.
        #
        # @yield [session]
        #   If a block is given, it will be passed the newly created
        #   POP3 session.
        #
        # @yieldparam [Net::POP3] session
        #   The newly created POP3 session.
        #
        # @return [Net::POP3]
        #   The newly created POP3 session.
        #
        # @see Network::POP3#pop3_connect
        #
        # @api public
        #
        def pop3_connect(options={},&block)
          print_info "Connecting to #{host_port} ..."

          return super(self.host,pop3_merge_options(options),&block)
        end

        #
        # Starts a session with the POP3 server. The `host`, `port`,
        # `pop3_user` and `pop3_password` parameters will also be used
        # to connect to the server.
        #
        # @yield [session]
        #   If a block is given, it will be passed the newly created
        #   POP3 session. After the block has returned, the session
        #   will be closed.
        #
        # @yieldparam [Net::POP3] session
        #   The newly created POP3 session.
        #
        # @see Network::POP3#pop3_session
        #
        # @api public
        #
        def pop3_session(options={})
          super(options) do |sess|
            yield sess if block_given?

            print_info "Logging out ..."
          end

          print_info "Disconnected to #{host_port}"
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

          return options
        end
      end
    end
  end
end
