# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/host'

module Ronin
  module Support
    module Network
      class Host
        #
        # Represents a wildcard hostname.
        #
        # ## Examples
        #
        #     wildcard = Network::Host::Wildcard.new('*.example.com')
        #     wildcard % 'www'
        #     # => #<Ronin::Support::Network::Host: www.example.com>
        #
        # @api public
        #
        # @since 1.1.0
        #
        class Wildcard

          # The wildcard template for the hostname.
          #
          # @return [String]
          attr_reader :template

          #
          # Initializes the wildcard hostname.
          #
          # @param [String] template
          #   The wildcard hostname template.
          #
          # @example
          #   wildcard = Network::Host::Wildcard.new('*.example.com')
          #
          def initialize(template)
            @template = template
          end

          #
          # Replaces the `*` in the wildcard hostname with the given name.
          #
          # @param [String] name
          #   The name to replace the `*` wildcard with.
          #
          # @return [Host]
          #   The new hostname.
          #
          # @example
          #   wildcard = Network::Host::Wildcard.new('*.example.com')
          #   wildcard % 'www'
          #   # => #<Ronin::Support::Network::Host: www.example.com>
          #
          def %(name)
            Host.new(@template.sub('*',name))
          end

          #
          # Converts the wildcard hostname to a String.
          #
          # @return [String]
          #   The string value of the wildcard hostname.
          #
          def to_s
            @template
          end

        end
      end
    end
  end
end
