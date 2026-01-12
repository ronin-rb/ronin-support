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

module Ronin
  module Support
    module Network
      module PublicSuffix
        #
        # Represents a suffix from the public suffix list.
        #
        # @api private
        #
        class Suffix

          # The suffix name.
          #
          # @return [String]
          attr_reader :name

          # The suffix type.
          #
          # @return [:icann, :private]
          attr_reader :type

          #
          # Initializes the suffix.
          #
          # @param [String] name
          #
          # @param [:icann, :private] type
          #   Indictages whether the suffix is an official ICANN domain or a
          #   private domain suffix.
          #
          def initialize(name, type: :icann)
            @name = name
            @type = type
          end

          #
          # Indicates whether the suffix is an ICANN domain.
          #
          # @return [Boolean]
          #
          def icann?
            @type == :icann
          end

          #
          # Indicates whether the suffix is a private domain.
          #
          # @return [Boolean]
          #
          def private?
            @type == :private
          end

          #
          # Determines if the suffix contians a `*` wildcard.
          #
          # @return [Boolean]
          #
          def wildcard?
            @name.include?('*')
          end

          #
          # Determines if the suffix does not contain a `*` wildcard.
          #
          # @return [Boolean]
          #
          def non_wildcard?
            !wildcard?
          end

          #
          # Compares the suffix to another object.
          #
          # @param [Object] other
          #   The other object to compare to.
          #
          # @return [Boolean]
          #
          def ==(other)
            self.class == other.class &&
              @name == other.name &&
              @type == other.type
          end

          #
          # Converts the suffix to a String.
          #
          # @return [String]
          #   The suffix name.
          #
          def to_s
            @name
          end

        end
      end
    end
  end
end
