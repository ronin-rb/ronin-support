# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/ruby'

class String

  #
  # Escapes a String for Ruby.
  #
  # @return [String]
  #   The Ruby escaped String.
  #
  # @example
  #   "hello\nworld\n".ruby_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::Ruby.escape
  #
  # @since 1.0.0
  #
  # @api public
  #
  def ruby_escape
    Ronin::Support::Encoding::Ruby.escape(self)
  end

  alias escape ruby_escape

  #
  # Unescapes a Ruby escaped String.
  #
  # @return [String]
  #   The unescaped Ruby String.
  #
  # @example
  #   "\x68\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64".ruby_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::Ruby.unescape
  #
  # @since 1.0.0
  #
  # @api public
  #
  def ruby_unescape
    Ronin::Support::Encoding::Ruby.unescape(self)
  end

  alias unescape ruby_unescape

  #
  # Ruby escapes every character in the String.
  #
  # @return [String]
  #   The Ruby escaped String.
  #
  # @example
  #   "hello".ruby_encode
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  # @see Ronin::Support::Encoding::Ruby.encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def ruby_encode
    Ronin::Support::Encoding::Ruby.encode(self)
  end

  alias ruby_decode ruby_unescape

  #
  # Rubyonverts the String into a Ruby string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".ruby_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @see Ronin::Support::Encoding::Ruby.quote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def ruby_string
    Ronin::Support::Encoding::Ruby.quote(self)
  end

  #
  # Removes the quotes an unescapes a Ruby string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".ruby_unquote
  #   # => "hello\nworld"
  #
  # @see Ronin::Support::Encoding::Ruby.unquote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def ruby_unquote
    Ronin::Support::Encoding::Ruby.unquote(self)
  end

end
