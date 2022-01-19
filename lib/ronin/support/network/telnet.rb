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
        #   The default Ronin Telnet port.
        #
        # @api public
        #
        def self.default_port
          @default_port ||= DEFAULT_PORT
        end

        #
        # Sets the default Ronin Telnet port.
        #
        # @param [Integer] port
        #   The new default Ronin Telnet port.
        #
        # @api public
        #
        def self.default_port=(port)
          @default_port = port
        end

        #
        # @return [Regexp]
        #   The default Ronin Telnet prompt pattern.
        #
        # @api public
        #
        def self.default_prompt
          @default_prompt ||= DEFAULT_PROMPT
        end

        #
        # Sets the default Ronin Telnet prompt pattern.
        #
        # @param [Regexp] prompt
        #   The new default Ronin Telnet prompt pattern.
        #
        # @api public
        #
        def self.default_prompt=(prompt)
          @default_prompt = prompt
        end

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
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (Telnet.default_port)
        #   The port to connect to.
        #
        # @option options [Boolean] :binmode
        #   Indicates that newline substitution shall not be performed.
        #
        # @option options [String] :output_log
        #   The name of the file to write connection status messages and all
        #   received traffic to.
        #
        # @option options [String] :dump_log
        #   Similar to the `:output_log` option, but connection output is also
        #   written in hexdump format.
        #
        # @option options [Regexp] :prompt (Telnet.default_prompt)
        #   A regular expression matching the host command-line prompt sequence,
        #   used to determine when a command has finished.
        #
        # @option options [Boolean] :telnet (true)
        #   Indicates that the connection shall behave as a telnet connection.
        #
        # @option options [Boolean] :plain
        #   Indicates that the connection shall behave as a normal TCP
        #   connection.
        #
        # @option options [Integer] :timeout (Telnet.default_timeout)
        #   The number of seconds to wait before timing out both the initial
        #   attempt to connect to host, and all attempts to read data from the
        #   host.
        #
        # @option options [Integer] :wait_time
        #   The amount of time to wait after seeing what looks like a prompt.
        #
        # @option options [Net::Telnet, IO] :proxy (Telnet.proxy)
        #   A proxy object to used instead of opening a direct connection to the
        #   host.
        #
        # @option options [String] :user
        #   The user to login as.
        #
        # @option options [String] :password
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
        def telnet_connect(host,options={})
          telnet_options = {
            'Host'       => host.to_s,
            'Port'       => (options[:port]      || Telnet.default_port),
            'Binmode'    => (options[:binmode]   || false),
            'Waittime'   => (options[:wait_time] || 0),
            'Prompt'     => (options[:prompt]    || Telnet.default_prompt),
            'Timeout'    => (options[:timeout]   || Telnet.default_timeout)
          }

          if (options[:telnet] && !options[:plain])
            telnet_options['Telnetmode'] = true
          end

          if options[:output_log]
            telnet_options['Output_log'] = options[:output_log]
          end

          if options[:dump_log]
            telnet_options['Dump_log'] = options[:dump_log]
          end

          if (proxy = (options[:proxy] || Telnet.proxy))
            telnet_options['Proxy'] = proxy
          end

          telnet = Net::Telnet.new(telnet_options)
          telnet.login(options[:user],options[:password]) if options[:user]

          yield telnet if block_given?
          return telnet
        end

        #
        # Starts a new Telnet session.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash] options
        #   Additional options.
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
        def telnet_session(host,options={})
          telnet = telnet_connect(host,options)

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
