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
require 'set'

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
  # @param [Hash{Regexp,String,Integer,Enumerable => #each}] mutations
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
  def fuzz(mutations={})
    return enum_for(:fuzz,mutations) unless block_given?

    mutations.each do |pattern,substitution|
      pattern = case pattern
                when Regexp
                  pattern
                when String
                  Regexp.new(Regexp.escape(pattern))
                when Integer
                  Regexp.new(pattern.chr)
                when Enumerable
                  Regexp.union(pattern.map { |s| Regexp.escape(s.to_s) })
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

  #
  # Creates a new String by formatting each byte.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [#include?] :include (0x00..0xff)
  #   The bytes to format.
  #
  # @option options [#include?] :exclude
  #   The bytes not to format.
  #
  # @yield [byte]
  #   The block which will return the formatted version of each byte
  #   within the String.
  #
  # @yieldparam [Integer] byte
  #   The byte to format.
  #
  # @return [String]
  #   The formatted version of the String.
  #
  # @example
  #   "hello".format_bytes { |b| "%x" % b }
  #   # => "68656c6c6f"
  #
  # @api public
  #
  def format_bytes(options={})
    included  = (options[:include] || (0x00..0xff))
    excluded  = (options[:exclude] || Set[])
    formatted = ''

    each_byte do |b|
      formatted << if (included.include?(b) && !excluded.include?(b))
                     yield(b)
                   else
                     b
                   end
    end

    return formatted
  end

  #
  # Creates a new String by formatting each character.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [#include?, Regexp] :include (/./m)
  #   The bytes to format.
  #
  # @option options [#include?, Regexp] :exclude
  #   The bytes not to format.
  #
  # @yield [char]
  #   The block which will return the formatted version of each character
  #   within the String.
  #
  # @yieldparam [String] char
  #   The character to format.
  #
  # @return [String]
  #   The formatted version of the String.
  #
  # @example
  #   "hello".format_chars { |c| c * 3 }
  #   # => "hhheeellllllooo"
  #
  # @api public
  #
  def format_chars(options={})
    included  = (options[:include] || /./m)
    excluded  = (options[:exclude] || Set[])
    formatted = ''

    matches = lambda { |filter,c|
      if filter.respond_to?(:include?)
        filter.include?(c)
      elsif filter.kind_of?(Regexp)
        c =~ filter
      end
    }

    each_char do |c|
      formatted << if (matches[included,c] && !matches[excluded,c])
                     yield(c)
                   else
                     c
                   end
    end

    return formatted
  end

  #
  # Creates a new String by randomizing the case of each character in the
  # String.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Array, Range] :include (0x00..0xff)
  #   The bytes to format.
  #
  # @option options [Array, Range] :exclude
  #   The bytes not to format.
  #
  # @option options [Float] :probability (0.5)
  #   The probability that a character will have it's case changed.
  #
  # @example
  #   "get out your checkbook".random_case
  #   # => "gEt Out YOur CHEckbook"
  #
  # @api public
  #
  def random_case(options={})
    prob = (options[:probability] || 0.5)

    format_chars(options) do |c|
      if rand <= prob
        c.swapcase 
      else
        c
      end
    end
  end

  #
  # Inserts data before the occurrence of a pattern.
  #
  # @param [String, Regexp] pattern
  #   The pattern to search for.
  #
  # @param [String] data
  #   The data to insert before the pattern.
  #
  # @return [String]
  #   The new modified String.
  #
  # @api public
  #
  def insert_before(pattern,data)
    string = dup
    index  = string.index(pattern)

    string.insert(index,data) if index
    return string
  end

  #
  # Inserts data after the occurrence of a pattern.
  #
  # @param [String, Regexp] pattern
  #   The pattern to search for.
  #
  # @param [String] data
  #   The data to insert after the pattern.
  #
  # @return [String]
  #   The new modified String.
  #
  # @api public
  #
  def insert_after(pattern,data)
    string = dup
    match  = string.match(pattern)

    if match
      index = match.end(match.length - 1)

      string.insert(index,data)
    end

    return string
  end

  #
  # Creates a new String by padding the String with repeating text,
  # out to a specified length.
  #
  # @param [String] padding
  #   The text to pad the new String with.
  #
  # @param [String] max_length
  #   The maximum length to pad the new String out to.
  #
  # @return [String]
  #   The padded version of the String.
  #
  # @example
  #   "hello".pad('A',50)
  #   # => "helloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  #
  # @api public
  #
  def pad(padding,max_length=length)
    padding = padding.to_s

    if max_length > length
      max_length -= length
    else
      max_length = 0
    end

    padded = self + (padding * (max_length / padding.length))

    unless (remaining = (max_length % padding.length)) == 0
      padded << padding[0,remaining]
    end

    return padded
  end

end
