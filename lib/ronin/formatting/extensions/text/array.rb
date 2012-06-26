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

class Array

  #
  # Decodes the bytes contained within the Array. The Array may contain
  # both Integer and String objects.
  #
  # @return [Array]
  #   The bytes contained within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].bytes
  #   # => [0x41, 0x41, 0x20]
  #
  # @example
  #   ['A', 'BB', 0x90].bytes
  #   # => [0x41, 0x42, 0x42, 0x90]
  #
  # @api public
  #
  def bytes
    bytes = []

    each do |element|
      case element
      when Integer then bytes << element
      else
        element.to_s.each_byte do |b|
          bytes << b
        end
      end
    end

    return bytes
  end

  #
  # Decodes the characters contained within the Array. The Array may contain
  # either Integer or String objects.
  #
  # @return [Array]
  #   The characters generated from the array.
  #
  # @example
  #   [0x41, 0x41, 0x20].chars
  #   # => ["A", "A", " "]
  #
  # @api public
  #
  def chars
    array_bytes = bytes
    array_bytes.map! { |b| b.chr }

    return array_bytes
  end

  #
  # @return [String]
  #   The String created from the characters within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].char_string
  #   # => "AA "
  #
  # @api public
  #
  def char_string
    chars.join
  end

  #
  # Decodes the bytes contained with the Array, and escapes them as
  # hexadecimal characters.
  #
  # @return [Array<String>]
  #   The hexadecimal characters contained within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].bytes
  #   # => ['\x41', '\x41', '\x20']
  #
  # @example
  #   ['A', 'BB', 0x90].bytes
  #   # => ['\x41', '\x42', '\x42', '\x90']
  #
  # @api public
  #
  def hex_chars
    array_bytes = bytes
    array_bytes.map! { |b| '\x%x' % b }

    return array_bytes
  end

  #
  # Decodes the bytes contained with the Array, and escapes them as
  # hexadecimal integers.
  #
  # @return [Array<String>]
  #   The hexadecimal integers contained within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].bytes
  #   # => ['0x41', '0x41', '0x20']
  #
  # @example
  #   ['A', 'BB', 0x90].bytes
  #   # => ['0x41', '0x42', '0x42', '0x90']
  #
  # @api public
  #
  def hex_integers
    array_bytes = bytes
    array_bytes.map! { |b| '0x%x' % b }

    return array_bytes
  end

end
