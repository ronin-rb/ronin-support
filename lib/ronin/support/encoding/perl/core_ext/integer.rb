# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/perl'

class Integer

  #
  # Escapes the Integer as a Perl character.
  #
  # @return [String]
  #   The escaped Perl character.
  #
  # @example
  #   0x41.perl_escape
  #   # => "A"
  #   0x22.perl_escape
  #   # => "\\\""
  #   0x7f.perl_escape
  #   # => "\\x7F"
  #
  # @see Ronin::Support::Encoding::Perl.escape_byte
  # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
  #
  # @since 1.2.0
  #
  # @api public
  #
  def perl_escape
    Ronin::Support::Encoding::Perl.escape_byte(self)
  end

  #
  # Encodes the Integer as a Perl character.
  #
  # @return [String]
  #   The encoded Perl character.
  #
  # @example
  #   0x41.perl_encode
  #   # => "\\x41"
  #
  # @see Ronin::Support::Encoding::Perl.encode_byte
  # @see https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators
  #
  # @since 1.2.0
  #
  # @api public
  #
  def perl_encode
    Ronin::Support::Encoding::Perl.encode_byte(self)
  end

end
