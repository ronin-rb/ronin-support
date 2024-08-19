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

require 'strscan'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding Quoted Printable data.
      #
      # ## Core-Ext Methods
      #
      # * {String#quoted_printable_escape}
      # * {String#quoted_printable_unescape}
      #
      # @see https://en.wikipedia.org/wiki/Quoted-printable
      #
      # @api public
      #
      module QuotedPrintable
        #
        # Escapes the data as Quoted Printable.
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
        # @see https://en.wikipedia.org/wiki/Quoted-printable
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
        # Unescapes a Quoted Printable encoded String.
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
        # @see https://en.wikipedia.org/wiki/Quoted-printable
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
