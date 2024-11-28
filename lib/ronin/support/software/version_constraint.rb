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

require_relative 'version'

module Ronin
  module Support
    module Software
      #
      # Represents a version constraint (ex: `>= 1.2.3`).
      #
      # ## Examples
      #
      #     constraint = Software::VersionConstraint.new('>= 1.2.3')
      #     version    = Software::Version.new('1.3.0')
      #     constraint.include?(version)
      #     # => true
      #
      # @api public
      #
      # @since 1.2.0
      #
      class VersionConstraint

        # The version constraint string.
        #
        # @return [String]
        attr_reader :string

        # The version constraint operator.
        #
        # @return [">", ">=", "<", "<=", "="]
        attr_reader :operator

        # The parsed version number.
        #
        # @return [Version]
        attr_reader :version

        #
        # Initializes the version constraint.
        #
        # @param [String] string
        #   The version constraint to parse.
        #
        # @raise [ArgumentError]
        #   Could not parse the version constraint.
        #
        # @example
        #   Software::VersionConstraint.new('>= 1.2.3')
        #   Software::VersionConstraint.new('> 1.2.3')
        #   Software::VersionConstraint.new('<= 1.2.3')
        #   Software::VersionConstraint.new('< 1.2.3')
        #   Software::VersionConstraint.new('= 1.2.3')
        #   Software::VersionConstraint.new('1.2.3')
        #
        def initialize(string)
          @string = string

          if (match = string.match(/\A(?:(?<operator>>=|>|<=|<|=)?\s*)(?<version>\S+)\z/))
            @operator = match[:operator] || '='
            @version  = Version.new(match[:version])
          else
            raise(ArgumentError,"invalid version constraint: #{string.inspect}")
          end
        end

        #
        # Parses the version constraint.
        #
        # @param [String] string
        #   The version constraint to parse.
        #
        # @return [VersionConstraint]
        #   The parsed version constraint.
        #
        def self.parse(string)
          new(string)
        end

        #
        # Compares the version to the version constraint.
        #
        # @param [Version] version
        #   The version number to compare.
        #
        # @return [Boolean]
        #
        # @api public
        #
        def include?(version)
          case @operator
          when '>'  then version >  @version
          when '>=' then version >= @version
          when '<'  then version <  @version
          when '<=' then version <= @version
          when '='  then version == @version
          else
            raise(NotImplementedError,"version operator not supported: #{@operator.inspect}")
          end
        end

        alias === include?

        #
        # Compares the version constraint to another version constraint.
        #
        # @param [VersionConstraint] other
        #   The other version constraint to compare against.
        #
        # @return [Boolean]
        #
        # @api public
        #
        def ==(other)
          self.class == other.class &&
            @operator == other.operator &&
            @version  == other.version
        end

      end
    end
  end
end
