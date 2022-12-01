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

require 'chars'

module Ronin
  module Support
    module Text
      module Random
        #
        # Creates a new String by randomizing the case of each character in the
        # string.
        #
        # @param [String] string
        #   The string to randomize the case of.
        #
        # @return [String]
        #   The new String with randomized case.
        #
        # @example
        #   Text::Random.swapcase("a")
        #   # => "A"
        #   Text::Random.swapcase("ab")
        #   # => "aB"
        #   Text::Random.swapcase("foo")
        #   # => "FoO"
        #   Text::Random.swapcase("The quick brown fox jumps over 13 lazy dogs.")
        #   # => "the quIcK broWn fox Jumps oveR 13 lazY Dogs."
        #
        # @api public
        #
        def self.swapcase(string)
          candidates = []

          string.each_char.each_with_index do |char,index|
            if char =~ /\p{L}/
              candidates << index
            end
          end

          new_string = string.dup

          # ensure that at least one character is swap-cased, but not all
          num_swaps = rand(candidates.length-1)+1

          candidates.sample(num_swaps).each do |index|
            new_string[index] = new_string[index].swapcase
          end

          return new_string
        end

        #
        # Generates a random String of numeric characters.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random decimal-digit string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#NUMERIC-constant
        #
        def self.numeric(n=1)
          Chars::NUMERIC.random_string(n)
        end

        #
        # Alias for {numeric}.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random decimal-digit string.
        #
        # @see random_numeric
        #
        def self.digits(n=1)
          numeric(n)
        end

        #
        # A random octal-digit string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random octal-digit string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#OCTAL-constant
        #
        def self.octal(n=1)
          Chars::OCTAL.random_string(n)
        end

        #
        # The upper-case hexadecimal character set.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The upper-case hexadecimal character set.
        #
        # @see https://rubydoc.info/gems/chars/Chars#UPPERCASE_HEXADECIMAL#constant
        #
        def self.uppercase_hex(n=1)
          Chars::UPPERCASE_HEXADECIMAL.random_string(n)
        end

        #
        # Alias for {uppercase_hexadecimal}.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The upper-case hexadecimal character set.
        #
        # @see uppercase_hexadecimal
        #
        def self.upper_hex(n=1)
          uppercase_hex(n)
        end

        #
        # The lower-case hexadecimal character set.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The lower-case hexadecimal character set.
        #
        # @see https://rubydoc.info/gems/chars/Chars#LOWERCASE_HEXADECIMAL-constant
        #
        def self.lowercase_hex(n=1)
          Chars::LOWERCASE_HEXADECIMAL.random_string(n)
        end

        #
        # Alias for {lowercase_hexadecimal}.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The lower-case hexadecimal character set.
        #
        # @see lowercase_hexadecimal
        #
        def self.lower_hex(n=1)
          lowercase_hex(n)
        end

        #
        # A random hexadecimal string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random hexadecimal string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#HEXADECIMAL-constant
        #
        def self.hex(n=1)
          Chars::HEXADECIMAL.random_string(n)
        end

        #
        # The upper-case alphabetic character set.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The upper-case alphabetic character set.
        #
        # @see https://rubydoc.info/gems/chars/Chars#UPPERCASE_ALPHA-constant
        #
        def self.uppercase_alpha(n=1)
          Chars::UPPERCASE_ALPHA.random_string(n)
        end

        #
        # Alias for {uppercase_alpha}.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The upper-case alphabetic character set.
        #
        # @see uppercase_alpha
        #
        def self.upper_alpha(n=1)
          uppercase_alpha(n)
        end

        #
        # The lower-case alphabetic character set.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The lower-case alphabetic character set.
        #
        # @see https://rubydoc.info/gems/chars/Chars#LOWERCASE_ALPHA-constant
        #
        def self.lowercase_alpha(n=1)
          Chars::LOWERCASE_ALPHA.random_string(n)
        end

        #
        # Alias for {lowercase_alpha}.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The lower-case alphabetic character set.
        #
        # @see lowercase_alpha
        #
        def self.lower_alpha(n=1)
          lowercase_alpha(n)
        end

        #
        # A random alphabetic string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random alphabetic string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#ALPHA-constant
        #
        def self.alpha(n=1)
          Chars::ALPHA.random_string(n)
        end

        #
        # A random alpha-numeric string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random alpha-numeric string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#ALPHA_NUMERIC-constant
        #
        def self.alpha_numeric(n=1)
          Chars::ALPHA_NUMERIC.random_string(n)
        end

        #
        # A random punctuation string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random punctuation string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#PUNCTUATION-constant
        #
        def self.punctuation(n=1)
          Chars::PUNCTUATION.random_string(n)
        end

        #
        # A random symbolic string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random symbolic string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#SYMBOLS-constant
        #
        def self.symbols(n=1)
          Chars::SYMBOLS.random_string(n)
        end

        #
        # A random whitespace string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random whitespace string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#WHITESPACE-constant
        #
        def self.whitespace(n=1)
          Chars::WHITESPACE.random_string(n)
        end

        #
        # A random whitespace string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #
        # @see whitespace
        #
        def self.space(n=1)
          whitespace(n)
        end

        #
        # The set of printable characters, not including spaces.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random visible string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#VISIBLE-constant
        #
        def self.visible(n=1)
          Chars::VISIBLE.random_string(n)
        end

        #
        # The set of printable characters, including spaces.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random printable string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#PRINTABLE-constant
        #
        def self.printable(n=1)
          Chars::PRINTABLE.random_string(n)
        end

        #
        # A random control-character string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random control-character string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#CONTROL-constant
        #
        def self.control(n=1)
          Chars::CONTROL.random_string(n)
        end

        #
        # The signed ASCII character set.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   The signed ASCII character set.
        #
        # @see https://rubydoc.info/gems/chars/Chars#SIGNED_ASCII-constant
        #
        def self.signed_ascii(n=1)
          Chars::SIGNED_ASCII.random_string(n)
        end

        #
        # A random ASCII string.
        #
        # @param [Integer] n
        #   The desired length of the String.
        #
        # @return [String]
        #   A random ASCII string.
        #
        # @see https://rubydoc.info/gems/chars/Chars#ASCII-constant
        #
        def self.ascii(n=1)
          Chars::ASCII.random_string(n)
        end
      end
    end
  end
end
