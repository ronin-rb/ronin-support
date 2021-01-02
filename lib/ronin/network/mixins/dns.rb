#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with ronin-support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/network/mixins/mixin'
require 'ronin/network/dns'

module Ronin
  module Network
    module Mixins
      #
      # Adds DNS convenience methods and parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `nameserver` (`String`) - DNS nameserver to query.
      #
      # @since 0.4.0
      #
      module DNS
        include Mixin, Network::DNS

        parameter :nameserver, :type => String,
                               :description => 'DNS nameserver'

        protected

        #
        # The DNS Resolver to use.
        #
        # @see Network::DNS#dns_resolver
        #
        def dns_resolver(nameserver=self.nameserver)
          super(nameserver)
        end

      end
    end
  end
end
