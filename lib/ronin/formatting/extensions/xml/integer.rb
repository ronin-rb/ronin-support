#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
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

require 'cgi'

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
  # @since 0.2.0
  #
  # @api public
  #
  def xml_escape
    CGI.escapeHTML(chr)
  end

  #
  # Formats the Integer as a XML String.
  #
  # @return [String]
  #   The XML String.
  #
  # @example
  #   0x41.format_xml
  #   # => "&#65;"
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_xml
    "&#%d;" % self
  end

end
