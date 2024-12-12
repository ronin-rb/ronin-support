# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
        # @group Software Version Patterns
        #

        # Regular expression for finding version numbers in text.
        #
        # @since 1.0.0
        VERSION_NUMBER = /\d+\.\d+(?:(?!\.(?:tar|tgz|tbz|zip|rar|txt|htm|xml))[._-][A-Za-z0-9]+)*/

        # Regular expression for finding version constraints in text.
        #
        # @since 1.2.0
        VERSION_CONSTRAINT = /(?:>=|>|<=|<|=)\s*#{VERSION_NUMBER}/

        # Regular expression for finding version ranges in text.
        #
        # @since 1.2.0
        VERSION_RANGE = /#{VERSION_CONSTRAINT}(?:(?:,\s*|\s+)#{VERSION_CONSTRAINT})?/
      end
    end
  end
end
