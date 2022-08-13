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

require 'ronin/support/encoding/js'

class Integer

  #
  # Escapes the Integer as a JavaScript character.
  #
  # @return [String]
  #   The escaped JavaScript character.
  #
  # @example 
  #   0x41.js_escape
  #   # => "A"
  #   0x22.js_escape
  #   # => "\\\""
  #   0x7f.js_escape
  #   # => "\x7F"
  #
  # @see Ronin::Support::Encoding::JS.escape_byte
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_escape
    Ronin::Support::Encoding::JS.escape_byte(self)
  end

  #
  # Encodes the Integer as a JavaScript character.
  #
  # @return [String]
  #   The encoded JavaScript character.
  #
  # @example
  #   0x41.js_encode
  #   # => "%41"
  #
  # @see Ronin::Support::Encoding::JS.encode_byte
  #
  # @since 1.0.0
  #
  # @api public
  #
  def js_encode
    Ronin::Support::Encoding::JS.encode_byte(self)
  end

end
