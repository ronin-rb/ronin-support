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

require 'ronin/support/text/typo/exceptions'

module Ronin
  module Support
    module Text
      module Typo
        #
        # Geneerates one or more typos based on a series of substitution rules.
        #
        # @api public
        #
        # @since 1.0.0
        #
        class Generator

          # The typo substitution rules.
          #
          # @return [Array<(Regexp, String)>]
          attr_reader :rules

          #
          # Initializes the typo substitution rules.
          #
          # @param [Array<(Regexp, String)>] rules
          #   The typo pattern patterns and substition strings for the
          #   generator.
          #
          def initialize(rules)
            @rules = rules
          end

          #
          # Creates a new generator.
          #
          # @param [Array<(Regexp, String)>] rules
          #   The typo pattern patterns and substition strings for the
          #   generator.
          #
          # @return [Generator]
          #   The newly created typo generator.
          #
          # @example
          #   Text::Typo::Generator[
          #     [/(?<=\w)o(?=\w)/, 'oo'],
          #     [/(?<=\w)l(?=\w)/, 'll'],
          #     [/(?<=\w)s(?=\w)/, 'ss']
          #   ]
          #
          def self.[](*rules)
            new(rules)
          end

          #
          # Combines the typo generator's rules with another typo generator's
          # rules.
          #
          # @param [Generator] other
          #   The other typo generator.
          #
          # @return [Generator]
          #   The new typo generator object.
          #
          def +(other)
            Generator.new(@rules + other.rules)
          end

          #
          # Performs a random typo substitution of the given word.
          #
          # @param [String] word
          #   The original word.
          #
          # @return [String]
          #   The random typoed version of the original word.
          #
          # @raise [NoTypoPossible]
          #   No possible typo substitutions were found in the word.
          #
          def substitute(word)
            matching_rules = @rules.select do |regexp,replace|
              word =~ regexp
            end

            if matching_rules.empty?
              raise(NoTypoPossible,"no possible typo substitution found in word: #{word.inspect}")
            end

            regexp, replace = matching_rules.sample

            return word.sub(regexp,replace)
          end

          #
          # Enumerates over every possible typo substition for the given word.
          #
          # @param [String] word
          #   The original word to typo.
          #
          # @yield [typo_word]
          #   If a block is given, it will be passed each typo variation of the
          #   original word.
          #
          # @yieldparam [String] typo_word
          #   One of the typoed variations of the original word.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumrator object will be returned.
          #
          def each_substitution(word)
            return enum_for(__method__,word) unless block_given?

            @rules.each do |regexp,replace|
              offset = 0

              while (match = word.match(regexp,offset))
                start, stop = match.offset(0)
                new_string  = word.dup

                new_string[start...stop] = replace
                yield new_string

                offset = stop
              end
            end

            return nil
          end

          #
          # Converts the generator into the Array of substitution rules.
          #
          # @return [Array<(Regexp, String)>]
          #   The Array of patterns and substitution strings.
          #
          def to_a
            @rules
          end

        end
      end
    end
  end
end
