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

require 'ronin/support/inflector'

class String

  unless respond_to?(:underscore)
    #
    # Converts the String from `CamelCase` to `under_scored` case.
    #
    # @return [String]
    #   The underscored version of the String.
    #
    # @example
    #   "FooBar".underscore
    #   # => "foo_bar"
    #
    # @api public
    #
    # @since 1.0.0
    #
    def underscore
      Ronin::Support::Inflector.underscore(self)
    end
  end

  unless respond_to?(:camelcase)
    #
    # Converts the String from `under_scored` to `CamelCase` case.
    #
    # @return [String]
    #   The CamelCased version of the String.
    #
    # @example
    #   "foo_bar".camelcase
    #   # => "FooBar"
    #
    # @api public
    #
    # @since 1.0.0
    #
    def camelcase
      Ronin::Support::Inflector.camelcase(self)
    end

    alias camelize camelcase
  end

end
