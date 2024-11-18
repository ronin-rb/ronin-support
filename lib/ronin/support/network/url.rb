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

require 'ronin/support/network/http'
require 'ronin/support/network/defang'

require 'addressable/uri'
require 'uri/query_params/core_ext/addressable/uri'

module Ronin
  module Support
    module Network
      #
      # Represents a URL.
      #
      # ## Features
      #
      # * Supports parsing URLs with IDN domains.
      #
      # @api public
      #
      # @since 1.2.0
      #
      class URL < Addressable::URI

        #
        # Defangs the URL.
        #
        # @return [String]
        #   The defanged URL.
        #
        # @example
        #   url = URL.new("https://www.example.com:8080/foo?q=1")
        #   url.defang
        #   # => "hxxps[://]www[.]example[.]com[:]8080/foo?q=1"
        #
        def defang
          Defang.defang_url(self)
        end

        #
        # Returns the Status Code of the HTTP Response for the URL.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {HTTP.response_status}.
        #
        # @return [Integer]
        #   The HTTP Response Status.
        #
        # @example
        #   url = Network::URL.parse('http://github.com/')
        #   url.status
        #   # => 301
        #
        # @see HTTP.response_status
        #
        def status(**kwargs)
          HTTP.response_status(self,**kwargs)
        end

        #
        # Checks if the HTTP response for the URL has an HTTP `OK` status code.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {HTTP.ok?}.
        #
        # @return [Boolean]
        #   Specifies whether the response had an HTTP OK status code or not.
        #
        # @example
        #   url = Network::URL.parse('https://example.com/')
        #   url.ok?
        #   # => true
        #
        # @see HTTP.ok?
        #
        def ok?(**kwargs)
          HTTP.ok?(self,**kwargs)
        end

      end
    end
  end
end
