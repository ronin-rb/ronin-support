# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Support
    module Text
      #
      # @since 0.3.0
      #
      module Patterns
        #
        # @group Numeric Patterns
        #

        # Regular expression for finding all numbers in text.
        #
        # @since 1.0.0
        NUMBER = /[0-9]+/

        # Regular expression for finding a decimal octet (0 - 255)
        #
        # @since 0.4.0
        DECIMAL_OCTET = /(?<=[^\d]|^)(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])(?=[^\d]|$)/

        # Regular expression for finding all hexadecimal numbers in text.
        #
        # @since 1.0.0
        HEX_NUMBER = /(?:0x)?[0-9a-fA-F]+/

        # Regular expression for finding version numbers in text.
        #
        # @since 1.0.0
        VERSION_NUMBER = /\d+\.\d+(?:(?!\.(?:tar|tgz|tbz|zip|rar|txt|htm|xml))[._-][A-Za-z0-9]+)*/
      end
    end
  end
end
