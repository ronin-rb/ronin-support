#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
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
  def bytes
    self.inject([]) do |accum,elem|
      if elem.kind_of?(Integer)
        accum << elem
      else
        elem.to_s.each_byte { |b| accum << b }
      end

      accum
    end
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
  def chars
    self.bytes.map { |b| b.chr }
  end

  #
  # @return [String]
  #   The String created from the characters within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].char_string
  #   # => "AA "
  #
  def char_string
    chars.join
  end

  #
  # Decodes the bytes contained with the Array, and escapes them as
  # hexadecimal characters.
  #
  # @return [Array<String>]
  #   The hexidecimal characters contained within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].bytes
  #   # => ['\x41', '\x41', '\x20']
  #
  # @example
  #   ['A', 'BB', 0x90].bytes
  #   # => ['\x41', '\x42', '\x42', '\x90']
  #
  def hex_chars
    self.bytes.map { |b| '\x%x' % b }
  end

  #
  # Decodes the bytes contained with the Array, and escapes them as
  # hexadecimal integers.
  #
  # @return [Array<String>]
  #   The hexidecimal integers contained within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].bytes
  #   # => ['0x41', '0x41', '0x20']
  #
  # @example
  #   ['A', 'BB', 0x90].bytes
  #   # => ['0x41', '0x42', '0x42', '0x90']
  #
  def hex_integers
    self.bytes.map { |b| '0x%x' % b }
  end

end
