#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with ronin-support.  If not, see <http://www.gnu.org/licenses/>.
#

class String

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
  # @deprecated
  #   Deprecates as of 0.2.0, and will be removed in 1.0.0.
  #   Please use {#common_suffix} instead.
  #
  def common_postfix(other)
    warn 'DEPRECATED: String#common_postfix was deprecated in 0.2.0.'
    warn 'DEPRECATED: Please use String#common_suffix instead.'

    common_suffix(other)
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

  if RUBY_VERSION < '1.9.'
    # Special ASCII bytes and their escaped character forms
    ESCAPE_BYTES = Hash.new do |escape,byte|
      escape[byte] = if (byte >= 0x20 && byte <= 0x7e)
                       byte.chr
                     else
                       "\\x%.2X" % byte
                     end
    end

    ESCAPE_BYTES[0x00] = '\0'
    ESCAPE_BYTES[0x07] = '\a'
    ESCAPE_BYTES[0x08] = '\b'
    ESCAPE_BYTES[0x09] = '\t'
    ESCAPE_BYTES[0x0a] = '\n'
    ESCAPE_BYTES[0x0b] = '\v'
    ESCAPE_BYTES[0x0c] = '\f'
    ESCAPE_BYTES[0x0d] = '\r'

    #
    # Dumps the string as a C-style string.
    #
    # @return [String]
    #   The C-style encoded version of the String.
    #
    # @example
    #   "hello\x00\073\x90\r\n".dump
    #   # => "hello\0;\x90\r\n"
    #
    # @note
    #   This method is only defined on Ruby 1.8.x.
    #
    # @api public
    #
    def dump
      dumped_string = ''

      each_byte { |b| dumped_string << ESCAPE_BYTES[b] }
      return "\"#{dumped_string}\""
    end

    alias inspect dump
  end

end
