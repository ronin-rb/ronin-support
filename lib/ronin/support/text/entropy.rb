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
      #
      # Implements the [Shanno Entropy] algorithm.
      #
      # [Shannon Entropy]: https://en.wikipedia.org/wiki/Entropy_(information_theory)
      #
      # @since 1.0.0
      #
      # @api public
      #
      module Entropy
        #
        # Calculates the entropy for the given string.
        #
        # @param [String] string
        #   The given string to calculate the entropy for.
        #
        # @param [Integer] base
        #   The base to calculate the entropy for.
        #
        # @return [Float]
        #   The entropy for the string.
        #
        def self.calculate(string, base: 2)
          char_counts = Hash.new(0)

          string.each_char do |char|
            char_counts[char] += 1
          end

          length  = string.length.to_f
          entropy = 0.0

          char_counts.each do |char,count|
            freq     = count / length
            entropy -= freq * Math.log(freq,base)
          end

          return entropy
        end
      end
    end
  end
end

require 'ronin/support/text/entropy/core_ext'
