# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/c'

class String

  #
  # Escapes a String for C.
  #
  # @return [String]
  #   The C escaped String.
  #
  # @example
  #   "hello\nworld\n".c_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::C.escape
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_escape
    Ronin::Support::Encoding::C.escape(self)
  end

  #
  # Unescapes a C escaped String.
  #
  # @return [String]
  #   The unescaped C String.
  #
  # @example
  #   "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64".c_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::C.unescape
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_unescape
    Ronin::Support::Encoding::C.unescape(self)
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
  # @see Ronin::Support::Encoding::C.encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def c_encode
    Ronin::Support::Encoding::C.encode(self)
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
  # @see Ronin::Support::Encoding::C.quote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_string
    Ronin::Support::Encoding::C.quote(self)
  end

  #
  # Removes the quotes an unescapes a C string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".c_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::C.unquote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def c_unquote
    Ronin::Support::Encoding::C.unquote(self)
  end

end
