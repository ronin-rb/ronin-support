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

class String

  #
  # Creates a new ASCII encoding string.
  #
  # @param [String] string
  #   The string to convert to ASCII.
  #
  # @return [String]
  #   The new ASCII encoded string.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.ascii(string)
    string.encode(Encoding::ASCII_8BIT)
  end

  #
  # Converts the string into an ASCII encoded string.
  #
  # @return [String]
  #   The new ASCII string.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_ascii
    encode(Encoding::ASCII_8BIT)
  end

  #
  # Converts the string into an UTF-8 encoded string.
  #
  # @return [String]
  #   The new UTF-8 string.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def to_utf8
    encode(Encoding::UTF_8)
  end

  #
  # Enumerates over every sub-string within the string.
  #
  # @param [Integer] min
  #   Minimum length of each sub-string.
  #
  # @yield [substring,(index)]
  #   The given block will receive every sub-string contained within the
  #   string. If the block accepts two arguments, then the index of
  #   the sub-string will also be passed in.
  #
  # @yieldparam [String] substring
  #   A sub-string from the string.
  #
  # @yieldparam [Integer] index
  #   The optional index of the sub-string.
  #
  # @return [String]
  #   The original string
  #
  # @example
  #   "hello".each_substring(3).to_a
  #   # => ["hel", "hell", "hello", "ell", "ello", "llo"]
  #
  # @api public
  #
  def each_substring(min=1,&block)
    return enum_for(__method__,min) unless block

    (0..(length - min)).each do |i|
      ((i + min)..length).each do |j|
        sub_string = self[i...j]

        if block.arity == 2
          block.call(sub_string,i)
        else
          block.call(sub_string)
        end
      end
    end

    return self
  end

  #
  # Enumerates over the unique sub-strings contained in the string.
  #
  # @param [Integer] min
  #   Minimum length of each unique sub-string.
  #
  # @yield [substring,(index)]
  #   The given block will receive every unique sub-string contained
  #   within the string. If the block accepts two arguments, then the
  #   index of the unique sub-string will also be passed in.
  #
  # @yieldparam [String] substring
  #   A unique sub-string from the string.
  #
  # @yieldparam [Integer] index
  #   The optional index of the unique sub-string.
  #
  # @return [String]
  #   The original string
  #
  # @example
  #   "xoxo".each_unique_substring(2).to_a
  #   # => ["xo", "xox", "xoxo", "ox", "oxo"]
  #
  # @see each_substring
  #
  # @api public
  #
  def each_unique_substring(min=1,&block)
    return enum_for(__method__,min) unless block

    unique_strings = {}

    each_substring(min) do |sub_string,index|
      unless unique_strings.has_key?(sub_string)
        unique_strings[sub_string] = index

        if block.arity == 2
          block.call(sub_string,index)
        else
          block.call(sub_string)
        end
      end
    end

    return self
  end

  #
  # The common prefix of the string and the specified other string.
  #
  # @param [String] other
  #   The other String to compare against.
  #
  # @return [String]
  #   The common prefix between the two Strings.
  #
  # @api public
  #
  def common_prefix(other)
    min_length = [length, other.length].min

    min_length.times do |i|
      if self[i] != other[i]
        return self[0,i]
      end
    end

    return self[0,min_length]
  end

  #
  # Finds the common suffix of the string and the specified other string.
  #
  # @param [String] other
  #   The other String to compare against.
  #
  # @return [String]
  #   The common suffix of the two Strings.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def common_suffix(other)
    min_length = [length, other.length].min

    (min_length - 1).times do |i|
      index       = (length - i - 1)
      other_index = (other.length - i - 1)

      if self[index] != other[other_index]
        return self[(index + 1)..-1]
      end
    end

    return ''
  end

  #
  # Finds the uncommon sub-string within the specified other string,
  # which does not occur within the string.
  #
  # @param [String] other
  #   The other String to compare against.
  #
  # @return [String]
  #   The uncommon sub-string between the two Strings.
  #
  # @api public
  #
  def uncommon_substring(other)
    prefix  = common_prefix(other)
    postfix = self[prefix.length..-1].common_suffix(other[prefix.length..-1])

    return self[prefix.length...(length - postfix.length)]
  end

  #
  # Creates a new String by randomizing the case of each character in the
  # String.
  #
  # @param [Float] probability
  #   The probability that a character will have it's case changed.
  #
  # @example
  #   "get out your checkbook".random_case
  #   # => "gEt Out YOur CHEckbook"
  #
  # @api public
  #
  def random_case(probability: 0.5)
    new_string = String.new(encoding: encoding)

    each_char.each_with_index do |char|
      new_string << if rand <= probability
                      char.swapcase 
                    else
                      char
                    end
    end

    return new_string
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
  # @param [String] length
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
  def pad(padding,length)
    ljust(length,padding)
  end

end
