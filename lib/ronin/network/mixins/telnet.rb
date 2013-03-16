#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/network/telnet'

module Ronin
  module Network
    module Mixins
      #
      # Adds Telnet convenience methods and connection parameters to a
      # class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - Telnet host.
      # * `port` (`Integer`) - Telnet port.
      # * `telnet_user` (`String`) - Telnet user to login as.
      # * `telnet_password` (`String`) - Telnet password to login with.
      # * `telnet_proxy` (`String`) - Telnet proxy.
      # * `telnet_ssl` (`Boolean`) - Enable Telnet over SSL. Defaults to `true`.
      #
      module Telnet
        include Mixin, Network::Telnet

        # Telnet host
        parameter :host, :type => String,
                         :description => 'Telnet host'

        # Telnet port
        parameter :port, :type => Integer,
                         :description => 'Telnet port'

        # Telnet user
        parameter :telnet_user, :type => String,
                                :description => 'Telnet user to login as'

        # Telnet password
        parameter :telnet_password, :type => String,
                                    :description => 'Telnet password to login with'

        # Telnet proxy
        parameter :telnet_proxy, :description => 'Telnet proxy'

        # Enable Telnet SSL
        parameter :telnet_ssl, :type => true,
                               :description => 'Enable Telnet over SSL'

        protected

        #
        # Creates a connection to a Telnet server. The `host`, `port`,
        # `telnet_user`, `telnet_password`, `telnet_proxy` and
        # `telnet_ssl` parameters will also be used to connect to the
        # Telnet server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (Network::Telnet.default_port)
        #   The port to connect to.
        #
        # @option options [Boolean] :binmode
        #   Indicates that newline substitution shall not be performed.
        #
        # @option options [String] :output_log
        #   The name of the file to write connection status messages
        #   and all received traffic to.
        #
        # @option options [String] :dump_log
        #   Similar to the `:output_log` option, but connection output
        #   is also written in hexdump format.
        #
        # @option options [Regexp] :prompt (Network::Telnet.default_prompt)
        #   A regular expression matching the host command-line prompt
        #   sequence, used to determine when a command has finished.
        #
        # @option options [Boolean] :telnet (true)
        #   Indicates that the connection shall behave as a telnet
        #   connection.
        #
        # @option options [Boolean] :plain
        #   Indicates that the connection shall behave as a normal TCP
        #   connection.
        #
        # @option options [Integer] :timeout (Network::Telnet.default_timeout)
        #   The number of seconds to wait before timing out both the
        #   initial attempt to connect to host, and all attempts to read
        #   data from the host.
        #
        # @option options [Integer] :wait_time
        #   The amount of time to wait after seeing what looks like
        #   a prompt.
        #
        # @option options [Net::Telnet, IO] :proxy (Network::Telnet.proxy)
        #   A proxy object to used instead of opening a direct connection
        #   to the host.
        #
        # @option options [String] :user
        #   The user to login as.
        #
        # @option options [String] :password
        #   The password to login with.
        #
        # @yield [connection]
        #   If a block is given, it will be passed the newly created
        #   Telnet connection.
        #
        # @yieldparam [Net::Telnet] connection
        #   The newly created Telnet connection.
        #
        # @return [Net::Telnet]
        #   The Telnet session
        #
        # @example
        #   telnet_connect
        #   # => Net::Telnet
        #
        # @see Network::Telnet#telnet_connect
        #
        # @api public
        #
        def telnet_connect(options={},&block)
          print_info "Connecting to #{host_port} ..."

          return super(self.host,telnet_merge_options(options),&block)
        end

        #
        # Starts a session with a Telnet server. The `host`, `port`,
        # `telnet_user`, `telnet_password`, `telnet_proxy` and
        # `telnet_ssl` parameters will also be used to connect to the
        # Telnet server.
        #
        # @yield [session]
        #   If a block is given, it will be passed the newly created
        #   Telnet session. After the block has returned, the Telnet
        #   session will be closed.
        #
        # @yieldparam [Net::Telnet] session
        #   The newly created Telnet session.
        #
        # @example
        #   telnet_session do |movie|
        #     movie.each_line { |line| puts line }
        #   end
        #
        # @see Network::Telnet#telnet_session
        #
        # @api public
        #
        def telnet_session(options={},&block)
          super(telnet_merge_options(options)) do |sess|
            yield sess if block_given?

            print "Logging out ..."
          end

          print_info "Disconnected to #{host_port}"
          return nil
        end

        private

        #
        # Merges the Telnet parameters into the options for {Network::Telnet}
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
        def telnet_merge_options(options={})
          options[:port]     ||= self.port
          options[:user]     ||= self.telnet_user
          options[:password] ||= self.telnet_password

          options[:proxy] ||= self.telnet_proxy
          options[:ssl]   ||= self.telnet_ssl

          return options
        end
      end
    end
  end
end
