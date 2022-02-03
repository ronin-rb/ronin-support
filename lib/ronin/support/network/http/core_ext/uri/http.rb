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

require 'ronin/support/network/http'

require 'uri/http'

module URI
  class HTTP < Generic

    include Ronin::Support::Network::HTTP

    #
    # Returns the Status Code of the HTTP Response for the URI.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for
    #   {Ronin::Support::Network::HTTP#http_status}.
    #
    # @return [Integer]
    #   The HTTP Response Status.
    #
    # @see Ronin::Support::Network::HTTP#http_status
    #
    # @since 0.3.0
    #
    def status(**kwargs)
      http_status(url: self)
    end

    #
    # Checks if the HTTP response for the URI has an HTTP `OK` status code.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for
    #   {Ronin::Support::Network::HTTP#http_status}.
    #
    # @return [Boolean]
    #   Specifies whether the response had an HTTP OK status code or not.
    #
    # @see Ronin::Support::Network::HTTP#http_ok?
    #
    # @since 0.3.0
    #
    def ok?(**kwargs)
      http_ok?(url: self)
    end

  end
end
