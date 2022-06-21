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

require 'ronin/support/format/c/core_ext/integer'
require 'ronin/support/format/text/core_ext/string'

require 'strscan'

class String

  # C characters that must be back-slashed.
  C_BACKSLASHED_CHARS = {
    '0'  => "\0",
    'a'  => "\a",
    'b'  => "\b",
    'e'  => "\e",
    't'  => "\t",
    'n'  => "\n",
    'v'  => "\v",
    'f'  => "\f",
    'r'  => "\r"
  }

  #
  # Escapes a String for C.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_chars}.
  #
  # @return [String]
  #   The C escaped String.
  #
  # @example
  #   "hello\nworld\n".c_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Integer#c_escape
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_escape(**kwargs)
    format_chars(**kwargs) { |c| c.ord.c_escape }
  end

  #
  # Unescapes a C escaped String.
  #
  # @return [String]
  #   The unescaped C String.
  #
  # @example
  #   "\x68\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64".c_unescape
  #   # => "hello world"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_unescape
    unescaped = String.new
    scanner   = StringScanner.new(self)

    until scanner.eos?
      unescaped << case (char = scanner.getch)
                   when "\\" # backslash
                     if (hex_char = scanner.scan(/x[0-9a-fA-F]{1,2}/)) # \xXX
                       hex_char[1..].to_i(16).chr
                     elsif (hex_char = scanner.scan(/u[0-9a-fA-F]{4,8}/)) # \u..
                       hex_char[1..].to_i(16).chr(Encoding::UTF_8)
                     elsif (octal_char = scanner.scan(/[0-7]{1,3}/)) # \N, \NN, or \NNN
                       octal_char.to_i(8).chr
                     elsif (special_char = scanner.getch) # \[A-Za-z]
                       C_BACKSLASHED_CHARS.fetch(special_char,special_char)
                     end
                   else
                     char
                   end
    end

    return unescaped
  end

  #
  # Formats a String for C.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_chars}.
  #
  # @return [String]
  #   The C escaped String.
  #
  # @example
  #   "hello".format_c
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  # @see Integer#format_c
  #
  # @since 1.0.0
  #
  # @api public
  #
  def format_c(**kwargs)
    format_chars(**kwargs) { |c| c.ord.format_c }
  end

  #
  # C escapes every character in the String.
  #
  # @return [String]
  #   The C escaped String.
  #
  # @example
  #   "hello".c_encode
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  # @see #format_c
  #
  # @api public
  #
  # @since 1.0.0
  #
  def c_encode
    format_c
  end

  alias c_decode c_unescape

  #
  # Converts the String into a C string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".c_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_string
    "\"#{c_escape}\""
  end

end
