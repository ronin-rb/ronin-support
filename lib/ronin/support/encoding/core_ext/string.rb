# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'chars/char_set'

class String

  #
  # Creates a new String by formatting each byte.
  #
  # @param [Enumerable<Integer, String>] include
  #   The bytes to format.
  #
  # @param [Enumerable<Integer, String>] exclude
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
  #   "hello".encode_bytes { |b| "%x" % b }
  #   # => "68656c6c6f"
  #
  # @api public
  #
  def encode_bytes(include: nil, exclude: nil)
    included  = (Chars::CharSet.new(*include) if include)
    excluded  = (Chars::CharSet.new(*exclude) if exclude)
    formatted = String.new(encoding: ::Encoding::UTF_8)

    each_byte do |b|
      formatted << if (included.nil? || included.include_byte?(b)) &&
                      (excluded.nil? || !excluded.include_byte?(b))
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
  # @param [Enumerable<Integer, String>] include
  #   The bytes to format.
  #
  # @param [Enumerable<Integer, String>] exclude
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
  #   "hello".encode_chars { |c| c * 3 }
  #   # => "hhheeellllllooo"
  #
  # @api public
  #
  def encode_chars(include: nil, exclude: nil)
    included  = (Chars::CharSet.new(*include) if include)
    excluded  = (Chars::CharSet.new(*exclude) if exclude)
    formatted = String.new(encoding: ::Encoding::UTF_8)

    each_char do |c|
      formatted << if (included.nil? || included.include_char?(c)) &&
                      (excluded.nil? || !excluded.include_char?(c))
                     yield(c)
                   else
                     c
                   end
    end

    return formatted
  end

end
