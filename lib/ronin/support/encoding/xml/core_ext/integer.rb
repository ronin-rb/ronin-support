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

require 'ronin/support/encoding/xml'

class Integer

  #
  # Escapes the Integer as an XML String.
  #
  # @return [String]
  #   The escaped XML String.
  #
  # @example
  #   0x26.xml_escape
  #   # => "&amp;"
  #
  # @see Ronin::Support::Encoding::XML.escape_byte
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_escape
    Ronin::Support::Encoding::XML.escape_byte(self)
  end

  #
  # Encodes the Integer as a XML String.
  #
  # @return [String]
  #   The XML String.
  #
  # @example
  #   0x41.xml_encode
  #   # => "&#65;"
  #
  # @see Ronin::Support::Encoding::XML.encode_byte
  #
  # @since 0.2.0
  #
  # @api public
  #
  def xml_encode
    Ronin::Support::Encoding::XML.encode_byte(self)
  end

end
