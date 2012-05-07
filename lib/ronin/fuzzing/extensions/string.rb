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

require 'ronin/extensions/regexp'
require 'ronin/fuzzing/fuzzing'

require 'combinatorics/generator'
require 'combinatorics/list_comprehension'
require 'combinatorics/power_set'
require 'chars'

class String

  #
  # Generate permutations of Strings from a format template.
  #
  # @param [Array(<String,Symbol,Enumerable>, <Integer,Array,Range>)] template
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
  # @example Generate Strings with ranges of repeating sub-strings:
  #
  # @example Generate Strings with three alpha chars and one numeric chars:
  #   String.generate([:alpha, 3], :numeric) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings with two to four alpha chars:
  #   String.generate([:alpha, 2..4]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings using alpha and punctuation chars:
  #   String.generate([Chars.alpha + Chars.punctuation, 4]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings from a custom char set:
  #   String.generate([['a', 'b', 'c'], 3], [['1', '2', '3'], 3]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings containing known Strings:
  #   String.generate("rock", [:numeric, 4]) do |password|
  #     puts password
  #   end
  #
  # @example Generate Strings with ranges of repeating sub-strings:
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
              set
            else
              raise(TypeError,"set must be a String, Symbol or Enumerable")
            end

      case length
      when Integer
        length.times { sets << set.dup }
      when Array, Range
        sets << Combinatorics::Generator.new do |g|
          length.each do |sublength|
            superset = Array.new(sublength) { set.dup }

            superset.comprehension { |strings| g.yield strings.join }
          end
        end
      when nil
        sets << set
      else
        raise(TypeError,"length must be an Integer, Range or Array")
      end
    end

    sets.comprehension do |strings|
      new_string = ''

      strings.each do |string|
        new_string << case string
                      when Integer
                        string.chr
                      else
                        string.to_s
                      end
      end

      yield new_string
    end
    return nil
  end

  #
  # Repeats the String.
  #
  # @param [Enumerable, Integer] n
  #   The number of times to repeat the String.
  #
  # @yield [repeated]
  #   The given block will be passed every repeated String.
  #
  # @yieldparam [String] repeated
  #   A repeated version of the String.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator will be returned.
  #
  # @raise [TypeError]
  #   `n` must either be Enumerable or an Integer.
  #
  # @example
  #   'A'.repeating(100)
  #   # => "AAAAAAAAAAAAA..."
  #
  # @example Generates 100 upto 700 `A`s, increasing by 100 at a time:
  #   'A'.repeating((100..700).step(100)) do |str|
  #     # ...
  #   end
  #
  # @example Generates 128, 1024, 65536 `A`s:
  #   'A'.repeating([128, 1024, 65536]) do |str|
  #     # ...
  #   end
  #
  # @api public
  #
  # @since 0.4.0
  #
  def repeating(n)
    if n.kind_of?(Integer)
      # if n is an Integer, simply multiply the String and return
      repeated = (self * n)

      yield repeated if block_given?
      return repeated
    end

    return enum_for(:repeating,n) unless block_given?

    unless n.kind_of?(Enumerable)
      raise(TypeError,"argument must be Enumerable or an Integer")
    end

    n.each do |length|
      yield(self * length)
    end

    return self
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
  # @example {String.generate} with {String#fuzz}:
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
                when Symbol
                  Regexp.const_get(pattern.to_s.upcase)
                else
                  raise(TypeError,"cannot convert #{pattern.inspect} to a Regexp")
                end

      substitution = case substitution
                      when Enumerable
                        substitution
                      when Symbol
                        Ronin::Fuzzing[substitution]
                      else
                        raise(TypeError,"substitutions must be Enumerable or a Symbol")
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

  #
  # Permutes over every possible mutation of the String.
  #
  # @param [Hash{Regexp,String,Symbol => Symbol,Enumerable}] mutations
  #   The patterns and substitutions to mutate the String with.
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
  # @raise [TypeError]
  #   A mutation pattern was not a Regexp, String or Symbol.
  #   A mutation substitution was not a Symbol or Enumerable.
  #
  # @example
  #   "hello old dog".mutate('e' => ['3'], 'l' => ['1'], 'o' => ['0']) do |str|
  #     puts str
  #   end
  #
  # @since 0.4.0
  #
  # @api public
  #
  def mutate(mutations={})
    return enum_for(:mutate,mutations) unless block_given?

    matches = Set[]

    mutations.each do |pattern,mutation|
      pattern = case pattern
                when Regexp
                  pattern
                when String
                  Regexp.new(Regexp.escape(pattern))
                when Symbol
                  Regexp.const_get(pattern.to_s.upcase)
                else
                  raise(TypeError,"cannot convert #{pattern.inspect} to a Regexp")
                end

      mutation = case mutation
                 when Symbol
                   Ronin::Fuzzing[mutation]
                 when Enumerable
                   mutation
                 else
                   raise(TypeError,"mutation #{mutation.inspect} must be a Symbol or Enumerable")
                 end

      scanner = StringScanner.new(self)

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
          sets << [self[prev_index,index - prev_index]]
        end

        # add the mutator to the set of Strings
        sets << mutator

        prev_index = index + length
      end

      # add the remaining substring to the set of Strings
      if prev_index < self.length
        sets << [self[prev_index..-1]]
      end

      sets.comprehension { |strings| yield strings.join }
    end
  end

end
