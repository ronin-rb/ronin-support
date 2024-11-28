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

module Ronin
  module Support
    #
    # Represents a software version number.
    #
    # ## Examples
    #
    # Supports parsing a variety of version formats:
    #
    #     Software::Version.new('42')
    #     Software::Version.new('1.2')
    #     Software::Version.new('1.2.3')
    #     Software::Version.new('1.2.3.4')
    #     Software::Version.new('1.2.3.rc1')
    #     Software::Version.new('1.2.3-rc1')
    #     Software::Version.new('1.2.a')
    #     Software::Version.new('1.2.abc')
    #
    # Supports comparing version numbers:
    #
    #     version1 = Software::Version.new('1.2.0')
    #     version2 = Software::Version.new('1.2.3.1')
    #     version2 >= version1
    #     # => true
    #
    # @api public
    #
    # @since 1.2.0
    #
    class Version

      include Compareable

      # The version string.
      #
      # @return [String]
      attr_reader :string

      # The parsed version numbers.
      #
      # @return [Array<Integer, String>]
      attr_reader :parts

      #
      # Initializes the version number.
      #
      # @param [String] string
      #   The version string to parse.
      #
      # @example
      #   Software::Version.new('42')
      #   Software::Version.new('1.2')
      #   Software::Version.new('1.2.3')
      #   Software::Version.new('1.2.3.rc1')
      #   Software::Version.new('1.2.3-rc1')
      #   Software::Version.new('1.2.a')
      #   Software::Version.new('1.2.abc')
      #
      def initialize(string)
        @string  = string
        @parts   = string.split(/[.-]/).map do |part|
          if part =~ /\A\d+\z/ then part.to_i
          else                      part
          end
        end
      end

      #
      # Parses the version string.
      #
      # @param [String] string
      #   The version string to parse.
      #
      # @return [Version]
      #   The parsed version string.
      #
      # @see #initialize
      #
      def self.parse(string)
        new(string)
      end

      #
      # Compares the version to another version.
      #
      # @param [Version] other
      #   The other version to compare with.
      #
      # @return [-1, 0, 1]
      #   Returns `-1`, `0`, `1`, if the version is less than, equal to, or
      #   greater than the other version, respectively.
      #
      def <=>(other)
        @parts <=> other.parts
      end

      alias to_s string

    end
  end
end
