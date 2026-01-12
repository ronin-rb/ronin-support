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

require_relative 'version_constraint'

module Ronin
  module Support
    module Software
      #
      # Represents a version range (ex: `>= 1.2.3, < 2.0.0`).
      #
      # ## Examples
      #
      #     version_range = Software::VersionRange.new('>= 1.2.3, < 2.0.0')
      #     version       = Software::Version.new('1.2.8')
      #     version_range.include?(version)
      #     # => true
      #
      # @api public
      #
      # @since 1.2.0
      #
      class VersionRange

        # The version range string.
        #
        # @return [String]
        attr_reader :string

        # The individual version constraints.
        #
        # @return [Array<VersionConstraint>]
        attr_reader :constraints

        #
        # Initializes the version range.
        #
        # @param [String] string
        #   The version range string to parse.
        #
        # @example
        #   version_range = Software::VersionRange.new('>= 1.2.3, < 2.0.0')
        #   version       = Software::Version.new('1.2.8')
        #   version_range.include?(version)
        #   # => true
        #
        def initialize(string)
          @string = string

          @constraints = string.split(/,\s*/).map do |constraint|
            VersionConstraint.new(constraint)
          end
        end

        #
        # Parses a version range.
        #
        # @param [String] string
        #   The version range string to parse.
        #
        # @return [VersionRange]
        #   The parsed version range.
        #
        def self.parse(string)
          new(string)
        end

        #
        # Compares the version number against the version range.
        #
        # @param [Version] version
        #   The version number to compare.
        #
        # @return [Boolean]
        #   Indicates whether the version number satisfies all of the version
        #   constraints in the version range.
        #
        def include?(version)
          @constraints.all? { |constraint| constraint.include?(version) }
        end

        alias === include?

        #
        # Compares the version range to another version range.
        #
        # @param [VersionRange] other
        #   The other version range.
        #
        # @return [Boolean]
        #
        def ==(other)
          self.class == other.class && @constraints == other.constraints
        end

        alias to_s string

      end
    end
  end
end
