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
        # @group File System Patterns
        #

        # Regular expression to find File extensions in text
        #
        # @since 0.4.0
        FILE_EXT = /(?:\.[A-Za-z0-9]+)+/

        # Regular expression to find file names in text
        #
        # @since 0.4.0
        FILE_NAME = %r{(?:[^/\\\. ]|\\[/\\ ])+(?:#{FILE_EXT})?}

        # Regular expression to find Directory names in text
        #
        # @since 1.0.0
        DIR_NAME = /(?:\.\.|\.|#{FILE_NAME})/

        # Regular expression to find local UNIX Paths in text
        #
        # @since 0.4.0
        RELATIVE_UNIX_PATH = %r{(?:#{DIR_NAME}/)+#{DIR_NAME}/?}

        # Regular expression to find absolute UNIX Paths in text
        #
        # @since 0.4.0
        ABSOLUTE_UNIX_PATH = %r{(?:/#{FILE_NAME})+/?}

        # Regular expression to find UNIX Paths in text
        #
        # @since 0.4.0
        UNIX_PATH = /#{ABSOLUTE_UNIX_PATH}|#{RELATIVE_UNIX_PATH}/

        # Regular expression to find local Windows Paths in text
        #
        # @since 0.4.0
        RELATIVE_WINDOWS_PATH = /(?:#{DIR_NAME}\\)+#{DIR_NAME}\\?/

        # Regular expression to find absolute Windows Paths in text
        #
        # @since 0.4.0
        ABSOLUTE_WINDOWS_PATH = /[A-Za-z]:(?:\\#{FILE_NAME})+\\?/

        # Regular expression to find Windows Paths in text
        #
        # @since 0.4.0
        WINDOWS_PATH = /#{ABSOLUTE_WINDOWS_PATH}|#{RELATIVE_WINDOWS_PATH}/

        # Regular expression to find local Paths in text
        #
        # @since 0.4.0
        RELATIVE_PATH = /#{RELATIVE_UNIX_PATH}|#{RELATIVE_WINDOWS_PATH}/

        # Regular expression to find absolute Paths in text
        #
        # @since 0.4.0
        ABSOLUTE_PATH = /#{ABSOLUTE_UNIX_PATH}|#{ABSOLUTE_WINDOWS_PATH}/

        # Regular expression to find Paths in text
        #
        # @since 0.4.0
        PATH = /#{UNIX_PATH}|#{WINDOWS_PATH}/
      end
    end
  end
end
