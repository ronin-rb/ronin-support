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
  # Escapes the String as [Quoted-Printable].
  #
  # [Quoted-Printable]: https://en.wikipedia.org/wiki/Quoted-printable
  #
  # @return [String]
  #   The quoted-printable escaped String.
  #
  # @example
  #   '<a href="https://example.com/">link</a>'.quoted_printable_escape
  #   # => "<a href=3D\"https://example.com/\">link</a>=\n"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def quoted_printable_escape
    [self].pack('M')
  end

  alias quoted_printable_encode quoted_printable_escape
  alias qp_escape quoted_printable_escape
  alias qp_encode quoted_printable_escape

  #
  # Unescapes a [Quoted-Printable] encoded String.
  #
  # [Quoted-Printable]: https://en.wikipedia.org/wiki/Quoted-printable
  #
  # @return [String]
  #   The unescaped String.
  #
  # @example
  #   "<a href=3D\"https://example.com/\">link</a>=\n".quoted_printable_unescape
  #   # => "<a href=\"https://example.com/\">link</a>"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def quoted_printable_unescape
    unpack1('M')
  end

  alias quoted_printable_decode quoted_printable_unescape
  alias qp_decode quoted_printable_unescape
  alias qp_unescape quoted_printable_unescape

end
