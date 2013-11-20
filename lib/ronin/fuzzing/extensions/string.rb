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

require 'ronin/fuzzing/template'
require 'ronin/fuzzing/repeater'
require 'ronin/fuzzing/fuzzer'
require 'ronin/fuzzing/mutator'
require 'ronin/fuzzing'
require 'ronin/extensions/regexp'

class String

  #
  # Generate permutations of Strings from a format template.
  #
  # @param [Array(<String,Symbol,Enumerable>, <Integer,Array,Range>)] fields
  #   The fields which defines the string or character sets which will
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
  def self.generate(*fields,&block)
    Ronin::Fuzzing::Template.new(fields).each(&block)
  end

  #
  # Repeats the String.
  #
  # @param [Enumerable<Integer>, Integer] lengths
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
  def repeating(lengths,&block)
    case lengths
    when Integer
      # if lengths is an Integer, simply multiply the String and return
      repeated = (self * lengths)

      yield repeated if block_given?
      return repeated
    else
      return Ronin::Fuzzing::Repeater.new(lengths).each(self,&block)
    end
  end

  #
  # Incrementally fuzzes the String.
  #
  # @param [Hash{Regexp,String,Symbol => Enumerable,Symbol}] substitutions
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
  # @example Replace a {Regexp::UNIX_PATH} with {Ronin::Fuzzing#format_strings}:
  #   "GET /downloads/".fuzz(unix_path: :format_string)
  #
  # @since 0.3.0
  #
  # @api public
  #
  def fuzz(substitutions={},&block)
    Ronin::Fuzzing::Fuzzer.new(substitutions).each(self,&block)
  end

  #
  # Permutes over every possible mutation of the String.
  #
  # @param [Hash{Regexp,String,Symbol => Enumerable,Symbol}] mutations
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
  def mutate(mutations={},&block)
    Ronin::Fuzzing::Mutator.new(mutations).each(self,&block)
  end

end
