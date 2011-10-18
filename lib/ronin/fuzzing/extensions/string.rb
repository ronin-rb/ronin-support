#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'combinatorics/list_comprehension'
require 'combinatorics/generator'

require 'chars'

class String

  #
  # Generate permutations of Strings from a format template.
  #
  # @param [Array(<String, Symbol, Enumerable>, <Integer, Enumerable>)] template
  #   The template which defines the string or character sets which will
  #   make up parts of the String.
  #
  # @yield [string]
  #   The given block will be passed each unique String.
  #
  # @yieldparam [String] string
  #   A newly generated String.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator will be returned.
  #
  # @raise [ArgumentError]
  #   A given character set name was unknown.
  #
  # @raise [TypeError]
  #   A given string set was not a String, Symbol or Enumerable.
  #   A given string set length was not an Integer or Enumerable.
  #
  # @example Generate Strings with ranges of repeating sub-strings.
  #
  # @example Generate Strings with three alpha chars and one numeric chars.
  #   String.generate([:alpha, 3], :numeric) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings with two to four alpha chars.
  #   String.generate([:alpha, 2..4]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings using alpha and punctuation chars.
  #   String.generate([Chars.alpha + Chars.punctuation, 4]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings from a custom char set.
  #   String.generate([['a', 'b', 'c'], 3], [['1', '2', '3'], 3]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings containing known Strings.
  #   String.generate("rock", [:numeric, 4]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings with ranges of repeating sub-strings.
  #   String.generate(['/AA', (1..100).step(5)]) do |path|
  #     puts path
  #   end
  #
  # @since 0.3.0
  #
  # @api public
  #
  def self.generate(*template)
    return enum_for(:generate,*template) unless block_given?

    sets = []

    template.each do |pattern|
      set, length = pattern
      set = case set
            when String
              [set].each
            when Symbol
              name = set.to_s.upcase

              unless Chars.const_defined?(name)
                raise(ArgumentError,"unknown charset #{set.inspect}")
              end

              Chars.const_get(name).each_char
            when Enumerable
              Chars::CharSet.new(set).each_char
            else
              raise(TypeError,"set must be a String, Symbol or Enumerable")
            end

      case length
      when Integer
        length.times { sets << set.dup }
      when Enumerable
        sets << Combinatorics::Generator.new do |g|
          length.each do |sublength|
            superset = Array.new(sublength) { set.dup }

            superset.comprehension { |strings| g.yield strings.join }
          end
        end
      when nil
        sets << set
      else
        raise(TypeError,"length must be an Integer or Enumerable")
      end
    end

    sets.comprehension { |strings| yield strings.join }
    return nil
  end

  #
  # Incrementally fuzzes the String.
  #
  # @param [Hash{Regexp,String => #each}] substitutions
  #   Patterns and their substitutions.
  #
  # @yield [fuzz]
  #   The given block will be passed every fuzzed String.
  #
  # @yieldparam [String] fuzz
  #   A fuzzed String.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator will be returned.
  #
  # @example Replace every `e`, `i`, `o`, `u` with `(`, 100 `A`s and a `\0`:
  #   "the quick brown fox".fuzz(/[eiou]/ => ['(', ('A' * 100), "\0"]) do |str|
  #     p str
  #   end
  #
  # @example {String.generate} with {String.fuzz}:
  #   "GET /".fuzz('/' => String.generate(['A', 1..100])) do |str|
  #     p str
  #   end
  #
  # @since 0.3.0
  #
  # @api public
  #
  def fuzz(substitutions={})
    return enum_for(:fuzz,substitutions) unless block_given?

    substitutions.each do |pattern,substitution|
      pattern = case pattern
                when Regexp
                  pattern
                when String
                  Regexp.new(Regexp.escape(pattern))
                else
                  raise(TypeError,"cannot convert #{pattern.inspect} to a Regexp")
                end

      scanner = StringScanner.new(self)
      indices = []

      while scanner.scan_until(pattern)
        indices << [scanner.pos - scanner.matched_size, scanner.matched_size]
      end

      indices.each do |index,length|
        substitution.each do |substitute|
          substitute = case substitute
                       when Proc
                         substitute.call(self[index,length])
                       when Integer
                         substitute.chr
                       else
                         substitute.to_s
                       end

          fuzzed = dup
          fuzzed[index,length] = substitute
          yield fuzzed
        end
      end
    end
  end

end
