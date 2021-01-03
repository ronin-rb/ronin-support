#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
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

require 'chars'
require 'combinatorics/generator'
require 'combinatorics/list_comprehension'

module Ronin
  module Fuzzing
    #
    # Fuzzing class that generates Strings based on a template.
    #
    # @api semipublic
    #
    # @since 0.5.0
    #
    class Template

      include Enumerable

      #
      # Initializes a new Fuzzing template.
      #
      # @param [Array(<String,Symbol,Enumerable>, <Integer,Array,Range>)] fields
      #   The fields which defines the string or character sets which will
      #   make up parts of the String.
      #
      # @raise [ArgumentError]
      #   A given character set name was unknown.
      #
      # @raise [TypeError]
      #   A given string set was not a String, Symbol or Enumerable.
      #   A given string set length was not an Integer or Enumerable.
      #
      def initialize(fields)
        @enumerators = []

        fields.each do |(set,length)|
          enum = case set
                 when String
                   [set].each
                 when Enumerable
                   set.each
                 when Symbol
                   name = set.to_s.upcase

                   unless Chars.const_defined?(name)
                     raise(ArgumentError,"unknown charset #{set.inspect}")
                   end

                   Chars.const_get(name).each_char
                 else
                   raise(TypeError,"set must be a String, Symbol or Enumerable")
                 end

          case length
          when Integer
            length.times { @enumerators << enum.dup }
          when Array, Range
            @enumerators << Combinatorics::Generator.new do |g|
              length.each do |sublength|
                superset = Array.new(sublength) { enum.dup }

                superset.comprehension { |strings| g.yield strings.join }
              end
            end
          when nil
            @enumerators << enum
          else
            raise(TypeError,"length must be an Integer, Range or Array")
          end
        end
      end

      #
      # @see #initialize
      #
      def self.[](*fields)
        new(fields)
      end

      #
      # Generate permutations of Strings from a format template.
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
      def each
        return enum_for(__method__) unless block_given?

        @enumerators.comprehension do |fields|
          string = ''

          fields.each do |field|
            string << case field
                      when Integer
                        field.chr
                      else
                        field.to_s
                      end
          end

          yield string
        end

        return nil
      end

    end
  end
end
