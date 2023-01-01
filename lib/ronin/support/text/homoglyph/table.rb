# frozen_string_literal: true
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

require 'ronin/support/text/homoglyph/exceptions'

module Ronin
  module Support
    module Text
      module Homoglyph
        #
        # Loads a table of characters and their homoglyph characters.
        #
        # @since 1.0.0
        #
        # @api private
        #
        class Table

          # The list of all homoglyph characters in the table.
          #
          # @return [Array<String>]
          attr_reader :homoglyphs

          # The table of ASCII characters and their homoglyph counterparts.
          #
          # @return [Hash{String => Array<String>}]
          attr_reader :table

          #
          # Initializes an empty homoglyph table.
          #
          def initialize
            @homoglyphs = []
            @table      = {}
          end

          #
          # Loads a table of homoglyphs from the `.txt` file.
          #
          # @param [String] path
          #   The path to the `.txt` file.
          #
          # @return [Table]
          #   The newly loaded homoglyph table.
          #
          # @api private
          #
          def self.load_file(path)
            table = new()

            File.open(path) do |file|
              file.each_line(chomp: true) do |line|
                char, substitute = line.split(' ',2)

                table[char] = substitute
              end
            end

            return table
          end

          #
          # Looks up the substitute characters for the given original character.
          #
          # @param [String] char
          #   The ASCII character to lookup in the table.
          #
          # @return [Array<String>, nil]
          #   The homoglyphic equivalent characters for the given ASCII
          #   character.
          #
          # @api public
          #
          def [](char)
            @table[char]
          end

          #
          # Adds a homoglyph character for the character.
          #
          # @param [String] char
          #   The ASCII character.
          #
          # @param [String] substitute
          #   The ASCII character's homoglyph counterpart.
          #
          # @return [Array<String>]
          #   All previously added homoglyph substitution characters.
          #
          # @api private
          #
          def []=(char,substitute)
            @homoglyphs << substitute
            (@table[char] ||= []) << substitute
          end

          #
          # Enumerates over all characters and their substitutions in the table.
          #
          # @yield [char,substitutions]
          #   If a block is given, it will be passed each ASCII character and a
          #   homoglyphic equivalent character from the table.
          #
          # @yieldparam [String] char
          #   An ASCII character.
          #
          # @yieldparam [String] substitution
          #   A homoglyphic equivalent for the character.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator will be returned.
          #
          def each(&block)
            return enum_for(__method__) unless block

            @table.each do |char,substitutions|
              substitutions.each do |substitute_char|
                yield char, substitute_char
              end
            end
          end

          #
          # Combines the table with another table.
          #
          # @param [Table] other_table
          #   The other table to merge together.
          #
          # @return [Table]
          #   The new merged table.
          #
          def merge(other_table)
            new_table = self.class.new

            each do |char,substitute|
              new_table[char] = substitute
            end

            other_table.each do |char,other_substitute|
              new_table[char] = other_substitute
            end

            return new_table
          end

          alias + merge

          #
          # Performs a random homoglyphic substitution on the given String.
          #
          # @param [String] string
          #   The given String.
          #
          # @return [String]
          #   The random homoglyph string derived from the given String.
          #
          # @raise [NotViable]
          #   No homoglyph replaceable characters were found in the String.
          #
          def substitute(string)
            replaceable_chars = string.chars & @table.keys

            if replaceable_chars.empty?
              raise(NotViable,"no homoglyph replaceable characters found in String (#{string.inspect})")
            end

            replaceable_char = replaceable_chars.sample
            substitute_char  = @table[replaceable_char].sample

            return string.sub(replaceable_char,substitute_char)
          end

          #
          # Enumerates over every possible homoglyphic substitution of the
          # given String.
          #
          # @param [String] string
          #   The original to perform substitutions on.
          #
          # @yield [homoglyph]
          #   If a block is given, it will be passed each homoglyphic
          #   substitution of the given String.
          #
          # @yieldparam [String] homoglyph
          #   A copy of the given String with one character replaced with it's
          #   homoglyph equivalent from the table.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator will be returned.
          #
          def each_substitution(string)
            return enum_for(__method__,string) unless block_given?

            (string.chars & @table.keys).each do |replaceable_char|
              @table[replaceable_char].each do |substitute_char|
                offset = 0

                while (index = string.index(replaceable_char,offset))
                  homoglyph = string.dup
                  homoglyph[index] = substitute_char

                  yield homoglyph
                  offset = index+1
                end
              end
            end
          end

        end
      end
    end
  end
end
