# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      end
    end
  end
end
