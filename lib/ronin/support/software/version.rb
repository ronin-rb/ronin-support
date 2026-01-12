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
    module Software
      #
      # Represents a software version number.
      #
      # ## Examples
      #
      # Supports parsing a variety of version formats:
      #
      #     42
      #     1.2
      #     1.2.3
      #     1.2.3a
      #     1.2.3.4
      #     1.2.3-4
      #     1.2.3_4
      #     1.2.3.pre
      #     1.2.3-pre
      #     1.2.3_pre
      #     1.2.3.pre1
      #     1.2.3-pre1
      #     1.2.3_pre1
      #     1.2.3.alpha
      #     1.2.3-alpha
      #     1.2.3_alpha
      #     1.2.3.alpha1
      #     1.2.3-alpha1
      #     1.2.3_alpha1
      #     1.2.3.beta
      #     1.2.3-beta
      #     1.2.3_beta
      #     1.2.3.beta1
      #     1.2.3-beta1
      #     1.2.3_beta1
      #     1.2.3.rc
      #     1.2.3-rc
      #     1.2.3_rc
      #     1.2.3.rc1
      #     1.2.3-rc1
      #     1.2.3_rc1
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

        include Comparable

        # The version string.
        #
        # @return [String]
        attr_reader :string

        # The individual parsed version numbers.
        #
        # @return [Array<Integer, :pre, :alpha, :beta, :rc, String>]
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
          @string = string
          @parts  = []

          parse!
        end

        private

        #
        # Internal method which parses the {#string} instance variable and
        # populates {#parts}.
        #
        # @note
        #   This method mainly exists in case you want to sub-class {Version}
        #   and define your own custom version string parsing logic.
        #
        # @api private
        #
        def parse!
          # ignore everything after the '+' symbol, then split by '.', '-', '_'.
          @string.sub(/\+.+\z/,'').split(/[._-]/).each do |part|
            if part =~ /\A\d+\z/
              # append the version number
              @parts << part.to_i
            elsif (match = part.match(/\A(pre|alpha|beta|rc)(\d+)?\z/))
              # append the pre|alpha|beta|rc as a separate Symbol element
              @parts << match[1].to_sym

              if (number = match[2])
                # append the number as a separate Integer element
                @parts << number.to_i
              end
            elsif (match = part.match(/\Ap(\d+)\z/)) # -pN / .pN
              # omit the 'p' prefix and append the number
              @parts << match[1].to_i
            else
              # append everything else as a String
              @parts << part
            end
          end
        end

        public

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

        # Explicit order of pre-release version tags.
        #
        # @api private
        PRERELEASE_ORDER = [
          :pre,
          :alpha,
          :beta,
          :rc
        ]

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
          # quickly return if the version strings are identical
          return 0 if @string == other.string

          max_length = [@parts.length, other.parts.length].max
          index      = 0

          while index < max_length
            # missing version parts will be filled in with 0s
            #
            #   1.2 <=> 1.2.3 ---> 1.2.0 <=> 1.2.3
            #
            part       = @parts.fetch(index,0)
            other_part = other.parts.fetch(index,0)

            # must increment index before calling next
            index += 1

            case part
            when Integer
              case other_part
              when Integer
                # Comparison between two version numbers.
                #
                # Examples:
                #   1.2.3 == 1.2.3
                #   1.2.0 < 1.2.3
                #   1.2.3 > 1.2.0
                if part == other_part
                  next # keep going
                else
                  return part <=> other_part # tie breaker
                end
              when Symbol
                # Comparison between a version number and a version modifier.
                #
                # Examples:
                #   1.2.0.1 > 1.2.0.alpha
                #   1.2.0.1 > 1.2.0-a1b2c3
                return 1
              when String
                # Comparison between a version number and an unrecognized
                # version tag / build-info string.
                #
                # Examples:
                #   1.2.3 < 1.2.3a
                #   1.2.30 > 1.2.3a
                return part.to_s <=> other_part
              end
            when Symbol
              case other_part
              when Integer
                # Comparison between a recognized version modifier and a
                # version number.
                #
                # Examples:
                #   1.2.0.alpha < 1.2.0.1
                return -1
              when Symbol
                # Comparison between two recognized version modifiers.
                #
                # Examples:
                #   1.2.0.pre   < 1.2.0.alpha
                #   1.2.0.alpha < 1.2.0.beta
                #   1.2.3.beta  < 1.2.0.rc
                if part == other_part
                  next # keep going
                else
                  # tie breaker
                  return PRERELEASE_ORDER.index(part) <=>
                         PRERELEASE_ORDER.index(other_part)
                end
              when String
                # Comparison between a recognized version modifier (ex: alpha)
                # and an unrecognized version tag or build-info.
                #
                # Examples:
                #   1.2.0.alpha > 1.2.0.1a
                return 1
              end
            when String
              case other_part
              when Integer
                # Comparison between an unrecognized version tag or build-info
                # string and an Integer.
                #
                # Examples:
                #   1.2.3a > 1.2.3
                #   1.2.3a < 1.2.30
                return part <=> other_part.to_s
              when Symbol
                # Comparison between an unrecognized version tag or build-info
                # string and a recognized version modifier.
                #
                # Examples:
                #   1.2.0.1a > 1.2.0.pre1
                return 1
              when String
                # Comparison between two unrecognized version tags or build-info
                # strings.
                #
                # Examples:
                #   1.2.3a < 1.2.3b
                #   1.2.3b < 1.2.3c
                return part <=> other_part
              end
            end
          end

          # All version elements are equal, even though the version strings may
          # be slightly different.
          #
          # Examples:
          #   1.2.3.alpha1 == 1.2.3.alpha.1
          #   1.2.3.alpha1 == 1.2.3-alpha1
          #   1.2.3.alpha1 == 1.2.3-alpha-1
          return 0
        end

        alias to_s string

      end
    end
  end
end
