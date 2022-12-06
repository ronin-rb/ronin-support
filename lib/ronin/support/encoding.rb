# frozen_string_literal: true
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

require 'ronin/support/encoding/base16'
require 'ronin/support/encoding/base32'
require 'ronin/support/encoding/base64'
require 'ronin/support/encoding/hex'
require 'ronin/support/encoding/c'
require 'ronin/support/encoding/shell'
require 'ronin/support/encoding/powershell'
require 'ronin/support/encoding/http'
require 'ronin/support/encoding/xml'
require 'ronin/support/encoding/html'
require 'ronin/support/encoding/js'
require 'ronin/support/encoding/sql'
require 'ronin/support/encoding/quoted_printable'
require 'ronin/support/encoding/ruby'
require 'ronin/support/encoding/uri'
require 'ronin/support/encoding/punycode'

module Ronin
  module Support
    #
    # Contains additional encoding/decoding modules.
    #
    # @since 1.0.0
    #
    class Encoding < ::Encoding
    end
  end
end
