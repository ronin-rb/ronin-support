#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as publishe by
# the Free Software Foundation, either version 3 of the License, or
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

require 'ronin/network/extensions/pop3'

module Ronin
  module Network
    module POP3
      # Default pop3 port
      DEFAULT_PORT = 110

      #
      # @return [Integer]
      #   The default Ronin POP3 port.
      #
      def POP3.default_port
        @default_port ||= DEFAULT_PORT
      end

      #
      # Sets the default Ronin POP3 port.
      #
      # @param [Integer] port
      #   The new default Ronin POP3 port.
      #
      def POP3.default_port=(port)
        @default_port = port
      end
    end
  end
end
