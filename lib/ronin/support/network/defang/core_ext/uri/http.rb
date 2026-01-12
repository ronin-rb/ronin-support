# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/defang'

require 'uri/http'

module URI
  class HTTP < Generic

    #
    # Defangs a URL.
    #
    # @return [String]
    #   The defanged URL.
    #
    # @example
    #   uri = URI("https://www.example.com:8080/foo?q=1")
    #   uri.defang
    #   # => "hxxps[://]www[.]example[.]com[:]8080/foo?q=1"
    #
    # @api public
    #
    # @since 1.2.0
    #
    def defang
      Ronin::Support::Network::Defang.defang_url(self)
    end

  end
end
