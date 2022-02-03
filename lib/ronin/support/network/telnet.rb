#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

begin
  require 'net/telnet'
rescue LoadError => error
  warn "ronin/network/telnet requires the net-telnet gem be installed."
  raise(error)
end

module Ronin
  module Support
    module Network
      #
      # Provides helper methods for communicating with Telnet services.
      #
      # @deprecated Will be removed in 1.0.0.
      #
      module Telnet
        # Default telnet port
        DEFAULT_PORT = 23

        # The default prompt regular expression
        DEFAULT_PROMPT = /[$%#>] \z/n

        # The default timeout
        DEFAULT_TIMEOUT = 10

        #
        # @return [Integer]
        #   The default Ronin Telnet timeout.
        #
        # @api public
        #
        def self.default_timeout
          @default_timeout ||= DEFAULT_TIMEOUT
        end

        #
        # Sets the default Ronin Telnet timeout.
        #
        # @param [Integer] timeout
        #   The new default Ronin Telnet timeout.
        #
        # @api public
        #
        def self.default_timeout=(timeout)
          @default_timeout = timeout
        end

        #
        # @return [Telnet, IO, nil]
        #   The Ronin Telnet proxy.
        #
        # @api public
        #
        def self.proxy
          @proxy ||= nil
        end

        #
        # Sets the Ronin Telnet proxy.
        #
        # @param [Telnet, IO, nil] new_proxy
        #   The new Ronin Telnet proxy.
        #
        # @api public
        #
        def self.proxy=(new_proxy)
          @proxy = new_proxy
        end

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
        #   A regular expression matching the host command-line prompt sequence,
        #   used to determine when a command has finished.
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
        #   A proxy object to used instead of opening a direct connection to the
        #   host.
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
        # @api public
        #
        def telnet_connect(host, # connection options
                                 proxy:     Telnet.proxy,
                                 port:      DEFAULT_PORT,
                                 binmode:   false,
                                 wait_time: 0,
                                 prompt:    DEFAULT_PROMPT,
                                 timeout:   Telnet.default_timeout,
                                 telnet:    nil,
                                 plain:     nil,
                                 # authentication options
                                 user:     nil,
                                 password: nil,
                                 # log options
                                 output_log: nil,
                                 dump_log:   nil)
          telnet_options = {
            'Host'       => host.to_s,
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

          yield telnet if block_given?
          return telnet
        end

        #
        # Starts a new Telnet session.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#telnet_connect}.
        #
        # @yield [telnet]
        #   If a block is given, it will be passed the newly created
        #   Telnet session. After the block has returned, the Telnet session
        #   will be closed.
        #
        # @yieldparam [Net::Telnet] telnet
        #   The newly created Telnet session.
        #
        # @return [nil]
        #
        # @example
        #   telnet_session('towel.blinkenlights.nl') do |movie|
        #     movie.each_line { |line| puts line }
        #   end
        #
        # @see #telnet_connect
        #
        # @api public
        #
        def telnet_session(host,**kwargs)
          telnet = telnet_connect(host,**kwargs)

          yield telnet if block_given?

          telnet.close
          return nil
        end
      end

      module_function

      include Telnet
    end
  end
end
