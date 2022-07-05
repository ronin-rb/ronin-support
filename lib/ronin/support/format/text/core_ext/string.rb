#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'chars/char_set'
require 'strscan'

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
  #   "hello".format_bytes { |b| "%x" % b }
  #   # => "68656c6c6f"
  #
  # @api public
  #
  def format_bytes(include: nil, exclude: nil)
    included  = (Chars::CharSet.new(*include) if include)
    excluded  = (Chars::CharSet.new(*exclude) if exclude)
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
  #   "hello".format_chars { |c| c * 3 }
  #   # => "hhheeellllllooo"
  #
  # @api public
  #
  def format_chars(include: nil, exclude: nil)
    included  = (Chars::CharSet.new(*include) if include)
    excluded  = (Chars::CharSet.new(*exclude) if exclude)
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
  # @param [Float] probability
  #   The probability that a character will have it's case changed.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_chars].
  #
  # @example
  #   "get out your checkbook".random_case
  #   # => "gEt Out YOur CHEckbook"
  #
  # @see #format_chars
  #
  # @api public
  #
  def random_case(probability: 0.5, **kwargs)
    format_chars(**kwargs) do |c|
      if rand <= probability then c.swapcase 
      else                        c
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
    if char[0] == '\\' then char[1]
    else                    char
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
    buffer  = String.new(encoding: Encoding::ASCII)
    scanner = StringScanner.new(self)

    until scanner.eos?
      if (unicode_escape = scanner.scan(/\\(?:[0-7]{1,3}|[0-7])/))
        buffer << unicode_escape[1,3].to_i(8).chr
      elsif (hex_escape = scanner.scan(/\\u[0-9a-fA-F]{4,8}/))
        buffer << hex_escape[2..-1].to_i(16).chr(Encoding::UTF_8)
      elsif (hex_escape = scanner.scan(/\\x[0-9a-fA-F]{1,2}/))
        buffer << hex_escape[2..-1].to_i(16).chr
      elsif (escape = scanner.scan(/\\./))
        buffer << UNESCAPE_CHARS[escape]
      else
        buffer << scanner.getch
      end
    end

    return buffer.force_encoding(__ENCODING__)
  end

  #
  # Removes the quotes an unescapes a quoted string.
  #
  # @return [String]
  #
  # @example
  #   "\"hello\\nworld\"".unquote
  #   # => "hello\nworld"
  #   "'hello\\'world'".unquote
  #   # => "hello'world"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def unquote
    if (self[0] == '"' && self[-1] == '"')
      self[1..-2].unescape
    elsif (self[0] == "'" && self[-1] == "'")
      self[1..-2].gsub("\\'","'")
    else
      self
    end
  end

end
