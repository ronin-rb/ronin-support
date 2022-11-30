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

module Ronin
  module Support
    module Text
      module Random
        #
        # Creates a new String by randomizing the case of each character in the
        # string.
        #
        # @param [String] string
        #   The string to randomize the case of.
        #
        # @return [String]
        #   The new String with randomized case.
        #
        # @example
        #   Text::Random.swapcase("a")
        #   # => "A"
        #   Text::Random.swapcase("ab")
        #   # => "aB"
        #   Text::Random.swapcase("foo")
        #   # => "FoO"
        #   Text::Random.swapcase("The quick brown fox jumps over 13 lazy dogs.")
        #   # => "the quIcK broWn fox Jumps oveR 13 lazY Dogs."
        #
        # @api public
        #
        def self.swapcase(string)
          candidates = []

          string.each_char.each_with_index do |char,index|
            if char =~ /\p{L}/
              candidates << index
            end
          end

          new_string = string.dup

          # ensure that at least one character is swap-cased, but not all
          num_swaps = rand(candidates.length-1)+1

          candidates.sample(num_swaps).each do |index|
            new_string[index] = new_string[index].swapcase
          end

          return new_string
        end
      end
    end
  end
end
