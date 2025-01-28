# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/html'

class Integer

  #
  # Escapes the Integer as an HTML String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase XML special
  #   characters. Defaults to lowercase hexadecimal.
  #
  # @return [String]
  #   The escaped HTML String.
  #
  # @raise [ArgumentError]
  #   The `case:` keyword argument is invalid.
  #
  # @example
  #   0x26.html_escape
  #   # => "&amp;"
  #
  # @example Uppercase encoding:
  #   0x26.html_escape(case: :upper)
  #   # => "&AMP;"
  #
  # @since 0.2.0
  #
  # @see Ronin::Support::Encoding::HTML.escape_byte
  #
  # @api public
  #
  def html_escape(**kwargs)
    Ronin::Support::Encoding::HTML.escape_byte(self,**kwargs)
  end

  #
  # Encodes the Integer as a HTML String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:decimal, :hex] :format (:decimal)
  #   The numeric format for the escaped characters.
  #
  # @option kwargs [Boolean] :zero_pad
  #   Controls whether the escaped characters will be left-padded with
  #   up to seven `0` characters.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase XML special
  #   characters. Defaults to lowercase hexadecimal.
  #
  # @return [String]
  #   The encoded HTML String.
  #
  # @raise [ArgumentError]
  #   The `format:` or `case:` keyword argument is invalid.
  #
  # @example
  #   0x41.html_encode
  #   # => "&#65;"
  #
  # @example Zero-padding:
  #   0x41.html_encode(zero_pad: true)
  #   # => "&#0000065;"
  #
  # @example Hexadecimal escaped characters:
  #   0x41.html_encode(format: :hex)
  #   # => "&#x41;"
  #
  # @example Uppercase hexadecimal escaped characters:
  #   0xff.html_encode(format: :hex, case: :upper)
  #   # => "&#XFF;"
  #
  # @since 0.2.0
  #
  # @see Ronin::Support::Encoding::HTML.encode_byte
  #
  # @api public
  #
  def html_encode(**kwargs)
    Ronin::Support::Encoding::HTML.encode_byte(self,**kwargs)
  end

end
