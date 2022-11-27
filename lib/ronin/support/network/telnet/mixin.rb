#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/telnet'
require 'ronin/support/network/dns/idn'

module Ronin
  module Support
    module Network
      #
      # Provides helper methods for communicating with Telnet services.
      #
      # @deprecated Will be removed in 1.0.0.
      #
      module Telnet
        #
        # Provides helper methods for using the Telnet protocol.
        #
        module Mixin
          #
          # Creates a new Telnet connection.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Boolean] binmode
          #   Indicates that newline substitution shall not be performed.
          #
          # @param [String, nil] output_log
          #   The name of the file to write connection status messages and all
          #   received traffic to.
          #
          # @param [String, nil] dump_log
          #   Similar to the `:output_log` option, but connection output is also
          #   written in hexdump format.
          #
          # @param [Regexp] prompt
          #   A regular expression matching the host command-line prompt
          #   sequence, used to determine when a command has finished.
          #
          # @param [Boolean] telnet
          #   Indicates that the connection shall behave as a telnet connection.
          #
          # @param [Boolean] plain
          #   Indicates that the connection shall behave as a normal TCP
          #   connection.
          #
          # @param [Integer] timeout
          #   The number of seconds to wait before timing out both the initial
          #   attempt to connect to host, and all attempts to read data from the
          #   host.
          #
          # @param [Integer] wait_time
          #   The amount of time to wait after seeing what looks like a prompt.
          #
          # @param [Net::Telnet, IO, nil] proxy
          #   A proxy object to used instead of opening a direct connection to
          #   the host.
          #
          # @param [String, nil] user
          #   The user to login as.
          #
          # @param [String, nil] password
          #   The password to login with.
          #
          # @yield [telnet]
          #   If a block is given, it will be passed the newly created Telnet
          #   session.
          #
          # @yieldparam [Net::Telnet] telnet
          #   The newly created Telnet session.
          #
          # @return [Net::Telnet]
          #   The Telnet session
          #
          # @example
          #   telnet_connect('towel.blinkenlights.nl')
          #   # => #<Net::Telnet: ...>
          #
          # @example
          #   telnet_connect('towel.blinkenlights.nl') do |movie|
          #     movie.each_line { |line| puts line }
          #   end
          #
          # @api public
          #
          def telnet_connect(host, # connection options
                             proxy:     Telnet.proxy,
                             port:      Telnet::DEFAULT_PORT,
                             binmode:   false,
                             wait_time: 0,
                             prompt:    Telnet::DEFAULT_PROMPT,
                             timeout:   Telnet.default_timeout,
                             telnet:    nil,
                             plain:     nil,
                             # authentication options
                             user:     nil,
                             password: nil,
                             # log options
                             output_log: nil,
                             dump_log:   nil)
            host = DNS::IDN.to_ascii(host)

            telnet_options = {
              'Host'       => host,
              'Port'       => port,
              'Binmode'    => binmode,
              'Waittime'   => wait_time,
              'Prompt'     => prompt,
              'Timeout'    => timeout
            }

            telnet_options['Telnetmode'] = true       if (telnet && !plain)
            telnet_options['Output_log'] = output_log if output_log
            telnet_options['Dump_log']   = dump_log   if dump_log
            telnet_options['Proxy']      = proxy      if proxy

            telnet = Net::Telnet.new(telnet_options)
            telnet.login(user,password) if user

            if block_given?
              yield telnet
              telnet.close
            else
              return telnet
            end
          end
        end
      end
    end
  end
end
