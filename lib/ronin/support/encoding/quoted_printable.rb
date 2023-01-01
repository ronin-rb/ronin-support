# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'strscan'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding Quoted Printable data.
      #
      # @api public
      #
      module QuotedPrintable
        #
        # Escapes the data as [Quoted-Printable].
        #
        # [Quoted-Printable]: https://en.wikipedia.org/wiki/Quoted-printable
        #
        # @param [String] data
        #   The data to escape.
        #
        # @return [String]
        #   The quoted-printable escaped String.
        #
        # @example
        #   Encoding::QuotedPrintable.escape('<a href="https://example.com/">link</a>')
        #   # => "<a href=3D\"https://example.com/\">link</a>=\n"
        #
        def self.escape(data)
          [data].pack('M')
        end

        #
        # Alias for {escape}.
        #
        # @param [String] data
        #   The data to escape.
        #
        # @return [String]
        #   The quoted-printable escaped String.
        #
        # @see escape
        #
        def self.encode(data)
          escape(data)
        end

        #
        # Unescapes a [Quoted-Printable] encoded String.
        #
        # [Quoted-Printable]: https://en.wikipedia.org/wiki/Quoted-printable
        #
        # @param [String] data
        #   The Quoted-Printable String to unescape.
        #
        # @return [String]
        #   The unescaped String.
        #
        # @example
        #   Encoding::QuotedPrintable.unescape("<a href=3D\"https://example.com/\">link</a>=\n")
        #   # => "<a href=\"https://example.com/\">link</a>"
        #
        def self.unescape(data)
          data.unpack1('M')
        end

        #
        # Alias for {unescape}.
        #
        # @param [String] data
        #   The Quoted-Printable String to unescape.
        #
        # @return [String]
        #   The unescaped String.
        #
        # @see unescape
        #
        def self.decode(data)
          unescape(data)
        end
      end
    end
  end
end

require 'ronin/support/encoding/quoted_printable/core_ext'
