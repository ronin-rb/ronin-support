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

require 'ronin/support/binary/unhexdump/parser'
require 'ronin/support/binary/unhexdump/core_ext'

module Ronin
  module Support
    module Binary
      #
      # Methods for parsing hexdumps back into raw data.
      #
      # ## Core-Ext Methods
      #
      # * {File.unhexdump}
      # * {String#unhexdump}
      #
      module Unhexdump
      end
    end
  end
end
