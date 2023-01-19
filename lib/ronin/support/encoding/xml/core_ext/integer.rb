# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/xml'

class Integer

  #
  # Escapes the Integer as an XML String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase XML special
  #   characters. Defaults to lowercase hexadecimal.
  #
  # @return [String]
  #   The escaped XML String.
  #
  # @example
  #   0x26.xml_escape
  #   # => "&amp;"
  #
  # @example Uppercase encoding:
  #   0x26.xml_escape(case: :upper)
  #   # => "&AMP;"
  #
  # @see Ronin::Support::Encoding::XML.escape_byte
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_escape(**kwargs)
    Ronin::Support::Encoding::XML.escape_byte(self,**kwargs)
  end

  #
  # Encodes the Integer as a XML String.
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
  #   The XML String.
  #
  # @example
  #   0x41.xml_encode
  #   # => "&#65;"
  #
  # @example Zero-padding:
  #   0x41.xml_encode(zero_pad: true)
  #   # => "&#0000065;"
  #
  # @example Hexadecimal escaped characters:
  #   0x41.xml_encode(format: :hex)
  #   # => "&#x41;"
  #
  # @example Uppercase hexadecimal escaped characters:
  #   0xff.xml_encode(format: :hex, case: :upper)
  #   # => "&#XFF;"
  #
  # @see Ronin::Support::Encoding::XML.encode_byte
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_encode(**kwargs)
    Ronin::Support::Encoding::XML.encode_byte(self,**kwargs)
  end

end
