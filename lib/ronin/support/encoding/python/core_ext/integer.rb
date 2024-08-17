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

require 'ronin/support/encoding/python'

class Integer

  #
  # Escapes the Integer as a Python character.
  #
  # @return [String]
  #   The escaped Python character.
  #
  # @example
  #   0x41.python_escape
  #   # => "A"
  #   0x22.python_escape
  #   # => "\\\""
  #   0x7f.python_escape
  #   # => "\\x7f"
  #
  # @see Ronin::Support::Encoding::Python.escape_byte
  # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
  #
  # @since 1.2.0
  #
  # @api public
  #
  def python_escape
    Ronin::Support::Encoding::Python.escape_byte(self)
  end

  #
  # Encodes the Integer as a Python character.
  #
  # @return [String]
  #   The encoded Python character.
  #
  # @example
  #   0x41.python_encode
  #   # => "\\x41"
  #
  # @see Ronin::Support::Encoding::Python.encode_byte
  # @see https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences
  #
  # @since 1.2.0
  #
  # @api public
  #
  def python_encode
    Ronin::Support::Encoding::Python.encode_byte(self)
  end

end
