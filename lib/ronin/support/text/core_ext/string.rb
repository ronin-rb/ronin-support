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

require 'ronin/support/text/random'

class String

  #
  # Creates a new String by randomizing the case of each character in the
  # String.
  #
  # @return [String]
  #   The new String with randomized case.
  #
  # @example
  #   "a".random_case
  #   # => "A"
  #   "ab".random_case
  #   # => "aB"
  #   "foo".random_case
  #   # => "FoO"
  #   "The quick brown fox jumps over 13 lazy dogs.".random_case
  #   # => "the quIcK broWn fox Jumps oveR 13 lazY Dogs."
  #
  # @api public
  #
  def random_case
    Ronin::Support::Text::Random.swapcase(self)
  end

end
