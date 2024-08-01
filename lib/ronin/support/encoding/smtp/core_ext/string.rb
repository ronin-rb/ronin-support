# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/smtp'

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
  #   '<a href="https://example.com/">link</a>'.smtp_escape
  #   # => "<a href=3D\"https://example.com/\">link</a>=\n"
  #
  # @api public
  #
  # @since 1.2.0
  #
  # @see #quoted_printable_escape
  #
  def smtp_escape
    Ronin::Support::Encoding::SMTP.escape(self)
  end

  alias smtp_encode smtp_escape

  #
  # Unescapes a [Quoted-Printable] encoded String.
  #
  # [Quoted-Printable]: https://en.wikipedia.org/wiki/Quoted-printable
  #
  # @return [String]
  #   The unescaped String.
  #
  # @example
  #   "<a href=3D\"https://example.com/\">link</a>=\n".smtp_unescape
  #   # => "<a href=\"https://example.com/\">link</a>"
  #
  # @api public
  #
  # @since 1.2.0
  #
  # @see #quoted_printable_unescape
  #
  def smtp_unescape
    Ronin::Support::Encoding::SMTP.unescape(self)
  end

  alias smtp_decode smtp_unescape

end
