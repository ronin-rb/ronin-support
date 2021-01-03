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
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/ui/output/helpers'

require 'parameters'

module Ronin
  module Network
    module Mixins
      #
      # @since 0.4.0
      #
      module Mixin
        include Parameters,
                UI::Output::Helpers

        parameter :host, :type => String

        parameter :port, :type => Integer

        protected

        #
        # The host/port parameters.
        #
        # @return [String]
        #   The host/port parameters in String form.
        #
        # @api semipublic
        #
        def host_port
          if self.port
            "#{self.host}:#{self.port}"
          else
            "#{self.host}"
          end
        end
      end
    end
  end
end
