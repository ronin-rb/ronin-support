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

require 'ronin/support/text/random'

module Ronin
  module Support
    module Text
      module Random
        #
        # A mixin for generating random text.
        #
        # @since 1.0.0
        #
        module Mixin
          #
          # Generates a random String of numeric characters.
          #
          # @param [Integer] n
          #   The desired length of the String.
          #
          # @return [String]
          #   A random decimal-digit string.
          #
          # @example
          #   random_numeric
          #   # => "7"
          #   random_numeric(10)
          #   # => "9972255528"
          #
          # @see Text::Random.numeric
          #
          # @api public
          #
          def random_numeric(n=1)
            Text::Random.numeric(n)
          end

          alias random_digits random_numeric

          #
          # A random octal-digit string.
          #
          # @param [Integer] n
          #   The desired length of the String.
          #
          # @return [String]
          #   A random octal-digit string.
          #
          # @example
          #   random_octal
          #   # => "7"
          #   random_octal(10)
          #   # => "3126172075"
          #
          # @see Text::Random.octal
          #
          # @api public
          #
          def random_octal(n=1)
            Text::Random.octal(n)
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
          # @example
          #   random_uppercase_hex
          #   # => "E"
          #   random_uppercase_hex(10)
          #   # => "2477973C18"
          #
          # @see Text::Random.uppercase_hex
          #
          # @api public
          #
          def random_uppercase_hex(n=1)
            Text::Random.uppercase_hex(n)
          end

          alias random_upper_hex random_uppercase_hex

          #
          # The lower-case hexadecimal character set.
          #
          # @param [Integer] n
          #   The desired length of the String.
          #
          # @return [String]
          #   The lower-case hexadecimal character set.
          #
          # @example
          #   random_lowercase_hex
          #   # => "e"
          #   random_lowercase_hex(10)
          #   # => "cfac752fcf"
          #
          # @see Text::Random.lowercase_hex
          #
          # @api public
          #
          def random_lowercase_hex(n=1)
            Text::Random.lowercase_hex(n)
          end

          alias random_lower_hex random_lowercase_hex

          #
          # A random hexadecimal string.
          #
          # @param [Integer] n
          #   The desired length of the String.
          #
          # @return [String]
          #   A random hexadecimal string.
          #
          # @example
          #   random_hex
          #   # => "d"
          #   random_hex(10)
          #   # => "fc8C3BB96f"
          #
          # @see Text::Random.hex
          #
          # @api public
          #
          def random_hex(n=1)
            Text::Random.hex(n)
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
          # @example
          #   random_uppercase_alpha
          #   # => "R"
          #   random_uppercase_alpha(10)
          #   # => "VMRVCQUMCM"
          #
          # @see Text::Random.uppercase_alpha
          #
          # @api public
          #
          def random_uppercase_alpha(n=1)
            Text::Random.uppercase_alpha(n)
          end

          alias random_upper_alpha random_uppercase_alpha

          #
          # The lower-case alphabetic character set.
          #
          # @param [Integer] n
          #   The desired length of the String.
          #
          # @return [String]
          #   The lower-case alphabetic character set.
          #
          # @example
          #   random_lowercase_alpha
          #   # => "r"
          #   random_lowercase_alpha(10)
          #   # => "bqbouadkvb"
          #
          # @see Text::Random.lowercase_alpha
          #
          # @api public
          #
          def random_lowercase_alpha(n=1)
            Text::Random.lowercase_alpha(n)
          end

          alias random_lower_alpha random_lowercase_alpha

          #
          # A random alphabetic string.
          #
          # @param [Integer] n
          #   The desired length of the String.
          #
          # @return [String]
          #   A random alphabetic string.
          #
          # @example
          #   random_alpha
          #   # => "L"
          #   random_alpha(10)
          #   # => "trrwRUvpwo"
          #
          # @see Text::Random.alpha
          #
          # @api public
          #
          def random_alpha(n=1)
            Text::Random.alpha(n)
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
          # @example
          #   random_alpha_numeric
          #   # => "2"
          #   random_alpha_numeric
          #   # => "3zWNgkzUY5"
          #
          # @see Text::Random.alpha_numeric
          #
          # @api public
          #
          def random_alpha_numeric(n=1)
            Text::Random.alpha_numeric(n)
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
          # @example
          #   random_punctuation
          #   # => ")"
          #   random_punctuation(10)
          #   # => ":;[,;'`\"?)"
          #
          # @see Text::Random.punctuation
          #
          # @api public
          #
          def random_punctuation(n=1)
            Text::Random.punctuation(n)
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
          # @example
          #   random_symbols
          #   # => "["
          #   random_symbols
          #   # => ".\\=_.`>;*)"
          #
          # @see Text::Random.symbols
          #
          # @api public
          #
          def random_symbols(n=1)
            Text::Random.symbols(n)
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
          # @example
          #   random_whitespace
          #   # => "\n"
          #   random_whitespace(10)
          #   # => "\v\v\t \r\f\n\f\v\f"
          #
          # @see Text::Random.whitespace
          #
          # @api public
          #
          def random_whitespace(n=1)
            Text::Random.whitespace(n)
          end

          alias random_space random_whitespace

          #
          # The set of printable characters, not including spaces.
          #
          # @param [Integer] n
          #   The desired length of the String.
          #
          # @return [String]
          #   A random visible string.
          #
          # @example
          #   random_visible
          #   # => "L"
          #   random_visible
          #   # => "Z)zG+[$vN_"
          #
          # @see Text::Random.visible
          #
          # @api public
          #
          def random_visible(n=1)
            Text::Random.visible(n)
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
          # @example
          #   random_printable
          #   # => "B"
          #   random_printable(10)
          #   # => "bCz&%ZV30v"
          #
          # @see Text::Random.printable
          #
          # @api public
          #
          def random_printable(n=1)
            Text::Random.printable(n)
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
          # @example
          #   random_control
          #   # => "\u0010"
          #   random_control(10)
          #   # => "\r\u0013\u0018\u0013\u007F\u0001\u000E\u001C\u0012\u000F"
          #
          # @see Text::Random.control
          #
          # @api public
          #
          def random_control(n=1)
            Text::Random.control(n)
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
          # @example
          #   random_signed_ascii
          #   # => "d"
          #   random_signed_ascii(10)
          #   # => "\u00006'\u00030%i\u001Dih"
          #
          # @see Text::Random.signed_ascii
          #
          # @api public
          #
          def random_signed_ascii(n=1)
            Text::Random.signed_ascii(n)
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
          # @example
          #   random_ascii
          #   # => "f"
          #   random_ascii(10)
          #   # => "¹ý0\u0095É\u001Eðºã,"
          #
          # @see Text::Random.ascii
          #
          # @api public
          #
          def random_ascii(n=1)
            Text::Random.ascii(n)
          end
        end
      end
    end
  end
end
