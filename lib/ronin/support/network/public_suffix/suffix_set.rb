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

module Ronin
  module Support
    module Network
      module PublicSuffix
        class SuffixSet

          include Enumerable

          # The suffixes in the suffix set.
          #
          # @return [Array<Suffix>, Enumerator::Lazy<Suffix>]
          attr_reader :suffixes

          #
          # Initializes the suffix-set.
          #
          # @param [Enumerator::Lazy<Suffix>] suffixes
          #   The optional suffixes to initialize the suffix set with.
          #
          # @api private
          #
          def initialize(suffixes=[])
            @suffixes = suffixes
          end

          #
          # Adds a public suffix to the suffix-set.
          #
          # @param [Suffix] suffix
          #   The suffix String to add.
          #
          # @return [self]
          #
          # @api private
          #
          def <<(suffix)
            @suffixes << suffix
            return self
          end

          #
          # Enumerates over each suffix within the suffix-set.
          #
          # @yield [suffix]
          #   If a block is given, it will be passed each suffix in the list.
          #
          # @yieldparam [Suffix] suffix
          #   A domain suffix in the list.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator object will be returned.
          #
          def each(&block)
            @suffixes.each(&block)
          end

          #
          # Selects all suffixes with the matching type.
          #
          # @param [:icann, :private] type
          #   The type to filter by.
          #
          # @return [SuffixSet]
          #   The new sub-set of suffixes.
          #
          def type(type)
            SuffixSet.new(lazy.select { |suffix| suffix.type == type })
          end

          #
          # Selects all ICANN suffixes.
          #
          # @return [SuffixSet]
          #   The new sub-set of suffixes.
          #
          def icann
            SuffixSet.new(lazy.select(&:icann?))
          end

          #
          # Selects all private suffixes.
          #
          # @return [SuffixSet]
          #   The new sub-set of suffixes.
          #
          def private
            SuffixSet.new(lazy.select(&:private?))
          end

          #
          # Selects all wildcard suffixes.
          #
          # @return [SuffixSet]
          #   The new sub-set of suffixes.
          #
          def wildcards
            SuffixSet.new(lazy.select(&:wildcard?))
          end

          #
          # Selects all non-wildcard suffixes.
          #
          # @return [SuffixSet]
          #   The new sub-set of suffixes.
          #
          def non_wildcards
            SuffixSet.new(lazy.select(&:non_wildcard?))
          end

          #
          # The number of suffixes within the suffix-set.
          #
          # @return [Integer]
          #
          def length
            @suffixes.length
          end

          #
          # Converts the suffix-set to an Array of suffixes.
          #
          # @return [Array<Suffix>]
          #
          def to_a
            @suffixes.to_a
          end

        end
      end
    end
  end
end
