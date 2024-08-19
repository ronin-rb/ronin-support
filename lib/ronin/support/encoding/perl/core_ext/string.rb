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

require 'ronin/support/encoding/perl'

class String

  #
  # Escapes a String for Perl.
  #
  # @return [String]
  #   The Perl escaped String.
  #
  # @example
  #   "hello\nworld\n".perl_escape
  #   # => "hello\\nworld\\n"
  #
  # @see Ronin::Support::Encoding::Perl.escape
  # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
  #
  # @since 1.2.0
  #
  # @api public
  #
  def perl_escape
    Ronin::Support::Encoding::Perl.escape(self)
  end

  #
  # Unescapes a Perl escaped String.
  #
  # @return [String]
  #   The unescaped Perl String.
  #
  # @raise [NotImplementedError]
  #   Decoding Perl Unicode Named Characters is currently not supported
  #   (ex: `\N{GREEK CAPITAL LETTER SIGMA}`).
  #
  # @example
  #   "\x68\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64".perl_unescape
  #   # => "hello world"
  #
  # @see Ronin::Support::Encoding::Perl.unescape
  # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
  #
  # @since 1.2.0
  #
  # @api public
  #
  def perl_unescape
    Ronin::Support::Encoding::Perl.unescape(self)
  end

  #
  # Perl escapes every character in the String.
  #
  # @return [String]
  #   The Perl escaped String.
  #
  # @example
  #   "hello".perl_encode
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  # @see Ronin::Support::Encoding::Perl.encode
  # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
  #
  # @api public
  #
  # @since 1.2.0
  #
  def perl_encode
    Ronin::Support::Encoding::Perl.encode(self)
  end

  alias perl_decode perl_unescape

  #
  # Converts the String into a Perl string.
  #
  # @return [String]
  #
  # @example
  #   "hello\nworld\n".perl_string
  #   # => "\"hello\\nworld\\n\""
  #
  # @see Ronin::Support::Encoding::Perl.quote
  # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
  #
  # @since 1.2.0
  #
  # @api public
  #
  def perl_string
    Ronin::Support::Encoding::Perl.quote(self)
  end

  #
  # Removes the quotes an unescapes a Perl string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello\\nworld\"".perl_unquote
  #   # => "hello\nworld"
  #   "qq{hello\\'world}".perl_unquote
  #   # => "hello'world"
  #   "'hello\\'world'".perl_unquote
  #   # => "hello'world"
  #   "q{hello\\'world}".perl_unquote
  #   # => "hello\\'world"
  #
  # @see Ronin::Support::Encoding::Perl.unquote
  # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
  #
  # @since 1.2.0
  #
  # @api public
  #
  def perl_unquote
    Ronin::Support::Encoding::Perl.unquote(self)
  end

end
