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


require 'ronin/support/network/tls/proxy'
require 'ronin/support/network/ssl'

module Ronin
  module Support
    module Network
      #
      # @since 1.0.0
      #
      module TLS
        include SSL

        #
        # Creates a new SSL Context.
        #
        # @param [1, 1.1, 1.2, String, Symbol, nil] version
        #   The SSL version to use.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {SSL.context}.
        #
        # @return [OpenSSL::SSL::SSLContext]
        #   The newly created SSL Context.
        #
        # @api semipublic
        #
        def self.context(version: 1.2, **kwargs)
          SSL.context(version: version, **kwargs)
        end

      end
    end
  end
end
