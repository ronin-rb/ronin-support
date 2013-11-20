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

require 'strscan'

module Ronin
  module Fuzzing
    #
    # Fuzzing class that incrementally fuzzes a String, given substitution
    # rules.
    #
    # @api semipublic
    #
    # @since 0.5.0
    #
    class Fuzzer

      # Patterns and their substitutions
      attr_reader :rules

      #
      # Initializes a new Fuzzer.
      #
      # @param [Hash{Regexp,String,Symbol => Enumerable,Symbol}] rules
      #   Patterns and their substitutions.
      #
      def initialize(rules)
        @rules = {}
        
        rules.each do |pattern,substitution|
          pattern = case pattern
                    when Regexp then pattern
                    when String then Regexp.new(Regexp.escape(pattern))
                    when Symbol then Regexp.const_get(pattern.upcase)
                    else
                      raise(TypeError,"cannot convert #{pattern.inspect} to a Regexp")
                    end

          substitution = case substitution
                         when Enumerable then substitution
                         when Symbol     then Fuzzing[substitution]
                         else
                           raise(TypeError,"substitutions must be Enumerable or a Symbol")
                         end

          @rules[pattern] = substitution
        end
      end

      #
      # Incrementally fuzzes the String.
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
      def each(string)
        return enum_for(__method__,string) unless block_given?

        @rules.each do |pattern,substitution|
          scanner = StringScanner.new(string)
          indices = []

          while scanner.scan_until(pattern)
            indices << [scanner.pos - scanner.matched_size, scanner.matched_size]
          end

          indices.each do |index,length|
            substitution.each do |substitute|
              substitute = case substitute
                           when Proc    then substitute[string[index,length]]
                           when Integer then substitute.chr
                           else              substitute.to_s
                           end

              fuzzed = string.dup
              fuzzed[index,length] = substitute
              yield fuzzed
            end
          end
        end
      end

    end
  end
end
