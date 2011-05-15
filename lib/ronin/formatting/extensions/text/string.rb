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

require 'set'

class String

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
  # @api public
  #
  def format_bytes(options={})
    included = options.fetch(:include,(0x00..0xff))
    excluded = options.fetch(:exclude,Set[])

    formatted = ''

    self.each_byte do |b|
      if (included.include?(b) && !excluded.include?(b))
        formatted << yield(b)
      else
        formatted << b
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
  # @api public
  #
  def format_chars(options={})
    included = options.fetch(:include,/./m)
    excluded = options.fetch(:exclude,Set[])

    formatted = ''

    matches = lambda { |filter,c|
      if filter.respond_to?(:include?)
        filter.include?(c)
      elsif filter.kind_of?(Regexp)
        c =~ filter
      else
        false
      end
    }

    self.each_char do |c|
      if (matches[included,c] && !matches[excluded,c])
        formatted << yield(c)
      else
        formatted << c
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
    string = self.dup
    index = string.index(pattern)

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
    string = self.dup
    match = string.match(pattern)

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
  def pad(padding,max_length=self.length)
    padding = padding.to_s

    if max_length >= self.length
      max_length -= self.length
    else
      max_length = 0
    end

    padded = self + (padding * (max_length / padding.length))

    unless (remaining = max_length % padding.length) == 0
      padded << padding[0...remaining]
    end

    return padded
  end

end
