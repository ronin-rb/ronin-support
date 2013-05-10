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

require 'chars/char_set'

class String

  #
  # Creates a new String by formatting each byte.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Enumerable<Integer, String>] :include (0x00..0xff)
  #   The bytes to format.
  #
  # @option options [Enumerable<Integer, String>] :exclude
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
    included  = (Chars::CharSet.new(*options[:include]) if options[:include])
    excluded  = (Chars::CharSet.new(*options[:exclude]) if options[:exclude])
    formatted = ''

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
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Enumerable<Integer, String>] :include
  #   The bytes to format.
  #
  # @option options [Enumerable<Integer, String>] :exclude
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
    included  = (Chars::CharSet.new(*options[:include]) if options[:include])
    excluded  = (Chars::CharSet.new(*options[:exclude]) if options[:exclude])
    formatted = ''

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

  #
  # Creates a new String by randomizing the case of each character in the
  # String.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Float] :probability (0.5)
  #   The probability that a character will have it's case changed.
  #
  # @example
  #   "get out your checkbook".random_case
  #   # => "gEt Out YOur CHEckbook"
  #
  # @see #format_chars
  #
  # @api public
  #
  def random_case(options={})
    prob = (options[:probability] || 0.5)

    format_chars(options) do |c|
      if rand <= prob then c.swapcase 
      else                 c
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

  alias escape dump

  # Common escaped characters.
  UNESCAPE_CHARS = Hash.new do |hash,char|
    if char[0,1] == '\\'
      char[1,1]
    else
      char
    end
  end
  UNESCAPE_CHARS['\0'] = "\0"
  UNESCAPE_CHARS['\a'] = "\a"
  UNESCAPE_CHARS['\b'] = "\b"
  UNESCAPE_CHARS['\t'] = "\t"
  UNESCAPE_CHARS['\n'] = "\n"
  UNESCAPE_CHARS['\v'] = "\v"
  UNESCAPE_CHARS['\f'] = "\f"
  UNESCAPE_CHARS['\r'] = "\r"

  #
  # Unescapes the escaped String.
  #
  # @return [String]
  #   The unescaped version of the hex escaped String.
  #
  # @example
  #   "\\x68\\x65\\x6c\\x6c\\x6f".unescape
  #   # => "hello"
  #
  # @api public
  #
  # @since 0.5.0
  #
  def unescape
    buffer     = ''.force_encoding(Encoding::ASCII)
    hex_index  = 0
    hex_length = length

    while (hex_index < hex_length)
      hex_substring = self[hex_index..-1]

      if hex_substring =~ /^\\[0-7]{3}/
        buffer    << hex_substring[0,4].to_i(8)
        hex_index += 3
      elsif hex_substring =~ /^\\x[0-9a-fA-F]{1,2}/
        hex_substring[2..-1].scan(/^[0-9a-fA-F]{1,2}/) do |hex_byte|
          buffer    << hex_byte.to_i(16)
          hex_index += (2 + hex_byte.length)
        end
      elsif hex_substring =~ /^\\./
        buffer    << UNESCAPE_CHARS[hex_substring[0,2]]
        hex_index += 2
      else
        buffer    << hex_substring[0,1]
        hex_index += 1
      end
    end

    return buffer.force_encoding(__ENCODING__)
  end

end
