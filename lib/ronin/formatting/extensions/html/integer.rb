#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'cgi/util'

class Integer

  #
  # Escapes the Integer as an HTML String.
  #
  # @return [String]
  #   The escaped HTML String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_escape
    CGI.escapeHTML(self.chr)
  end

  #
  # Formats the Integer as a HTML String.
  #
  # @return [String]
  #   The HTML String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_html
    "&#%d;" % self
  end

  #
  # Escapes the Integer as a JavaScript String.
  #
  # @return [String]
  #   The escaped JavaScript String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_escape
    format_js
  end

  #
  # Formats the Integer as a JavaScript escaped String.
  #
  # @return [String]
  #   The escaped JavaScript String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_js
    if self > 0xff
      "%%u%.2X%.2X" % [(self & 0xff00) >> 8, (self & 0xff)]
    else
      "%%%.2X" % self
    end
  end

end
