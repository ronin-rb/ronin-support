#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/fuzzing'
require 'ronin/extensions/regexp'

require 'combinatorics/list_comprehension'
require 'combinatorics/power_set'
require 'combinatorics/generator'
require 'strscan'
require 'set'

module Ronin
  module Fuzzing
    #
    # Fuzzer class that permutates over every mutation of a String, given
    # mutation rules.
    #
    # @api semipublic
    #
    # @since 0.5.0
    #
    class Mutator

      # Mutation rules
      attr_reader :rules

      #
      # Initialize the Mutator.
      #
      # @param [Hash{Regexp,String,Symbol => Symbol,Enumerable}] rules
      #   The patterns and substitutions to mutate the String with.
      #
      # @raise [TypeError]
      #   A mutation pattern was not a Regexp, String or Symbol.
      #   A mutation substitution was not a Symbol or Enumerable.
      #
      def initialize(rules)
        @rules = {}
        
        rules.each do |pattern,mutation|
          pattern = case pattern
                    when Regexp
                      pattern
                    when String
                      Regexp.new(Regexp.escape(pattern))
                    when Symbol
                      Regexp.const_get(pattern.upcase)
                    else
                      raise(TypeError,"cannot convert #{pattern.inspect} to a Regexp")
                    end

          mutation = case mutation
                     when Enumerable
                       mutation
                     when Symbol
                       Ronin::Fuzzing[mutation]
                     else
                       raise(TypeError,"mutation #{mutation.inspect} must be a Symbol or Enumerable")
                     end

          @rules[pattern] = mutation
        end
      end

      #
      # Permutes over every possible mutation of the String.
      #
      # @param [String] string
      #   The String to be mutated.
      #
      # @yield [mutant]
      #   The given block will be yielded every possible mutant String.
      #
      # @yieldparam [String] mutant
      #   A mutated String.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator will be returned.
      #
      def each(string)
        return enum_for(__method__,string) unless block_given?

        matches = Set[]

        @rules.each do |pattern,mutation|
          scanner = StringScanner.new(string)

          while scanner.scan_until(pattern)
            length   = scanner.matched_size
            index    = scanner.pos - length
            original = scanner.matched

            mutator = Combinatorics::Generator.new do |g|
              mutation.each do |mutate|
                g.yield case mutate
                        when Proc
                          mutate.call(original)
                        when Integer
                          mutate.chr
                        else
                          mutate.to_s
                        end
              end
            end

            matches << [index, length, mutator]
          end
        end

        matches.powerset do |submatches|
          # ignore the empty Set
          next if submatches.empty?

          # sort the submatches by index
          submatches = submatches.sort_by { |index,length,mutator| index }
          sets       = []
          prev_index = 0

          submatches.each do |index,length,mutator|
            # add the previous substring to the set of Strings
            if index > prev_index
              sets << [string[prev_index,index - prev_index]]
            end

            # add the mutator to the set of Strings
            sets << mutator

            prev_index = index + length
          end

          # add the remaining substring to the set of Strings
          if prev_index < string.length
            sets << [string[prev_index..-1]]
          end

          sets.comprehension { |strings| yield strings.join }
        end

        return nil
      end

    end
  end
end
