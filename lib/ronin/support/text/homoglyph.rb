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

require 'ronin/support/text/homoglyph/table'

module Ronin
  module Support
    module Text
      #
      # Generates [homoglyph](http://homoglyphs.net/) typos.
      #
      # @since 1.0.0
      #
      # @api public
      #
      module Homoglyph
        # Path to the `data/text/homoglyphs/` directory.
        DATA_DIR = File.expand_path(File.join(__dir__,'..','..','..','..','data','text','homoglyphs'))

        # ASCII only homoglyph rules.
        ASCII = Table.load_file(File.join(DATA_DIR,'ascii.txt'))

        # Greek homoglyph rules.
        GREEK = Table.load_file(File.join(DATA_DIR,'greek.txt'))

        # Cyrillic homoglyph rules.
        CYRILLIC = Table.load_file(File.join(DATA_DIR,'cyrillic.txt'))

        # Punctuation/symbol homoglyph rules.
        PUNCTUATION = Table.load_file(File.join(DATA_DIR,'punctuation.txt'))

        # Latin numeral homoglyph rules.
        LATIN_NUMBERS = Table.load_file(File.join(DATA_DIR,'latin_numbers.txt'))

        # Full-width homoglyph rules.
        FULL_WIDTH = Table.load_file(File.join(DATA_DIR,'full_width.txt'))

        # All homoglyph rules combined.
        DEFAULT = GREEK + CYRILLIC + PUNCTUATION + LATIN_NUMBERS + FULL_WIDTH

        # Homoglyph rules grouped by character set.
        CHAR_SETS = {
          ascii:         ASCII,
          greek:         GREEK,
          cyrillic:      CYRILLIC,
          punctuation:   PUNCTUATION,
          latin_numbers: LATIN_NUMBERS,
          full_width:    FULL_WIDTH
        }

        #
        # Looks up a homoglyph character set.
        #
        # @param [:ascii, :greek, :cyrillic, :punctuation, :latin_numbers,
        #         :full_width, nil] char_set
        #   The character set name.
        #
        # @return [Table]
        #   The specific homoglyph character set or {DEFAULT} if no name was
        #   given.
        #
        def self.table(char_set=nil)
          if char_set
            CHAR_SETS.fetch(char_set) do
              raise(ArgumentError,"unknown homoglyph character set (#{char_set.inspect}), must be #{CHAR_SETS.keys.map(&:inspect).join(', ')}")
            end
          else
            DEFAULT
          end
        end

        #
        # Returns a random homoglyph substitution of the given word.
        #
        # @param [String] word
        #   The given word to mutate.
        #
        # @param [:ascii, :greek, :cyrillic, :punctuation, :latin_numbers,
        #         :full_width, nil] char_set
        #   The character set to use.
        #
        # @return [String]
        #   A random homoglyphic variation of the given word.
        #
        # @raise [ArgumentError]
        #   Could not find any matching characters to replace in the given text.
        #
        # @raise [NotViable]
        #   No homoglyph replaceable characters were found in the String.
        #
        # @see Table#substitute
        #
        def self.substitute(word, char_set: nil)
          self.table(char_set).substitute(word)
        end

        #
        # Enumerates over every homoglyph variation of the given word.
        #
        # @param [String] word
        #   The given word to mutate.
        #
        # @param [:ascii, :greek, :cyrillic, :punctuation, :latin_numbers,
        #         :full_width, nil] char_set
        #   The character set to use.
        #
        # @yield [homoglyph]
        #   The given block will be passed each homoglyph variation of the given
        #   word.
        #
        # @yieldparam [String] homoglyph
        #   A variation of the given word.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator object will be returned.
        #
        # @see Table#each_substitution
        #
        def self.each_substitution(word, char_set: nil, &block)
          self.table(char_set).each_substitution(word,&block)
        end
      end
    end
  end
end

require 'ronin/support/text/homoglyph/core_ext'
