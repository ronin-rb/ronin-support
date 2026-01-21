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

module Ronin
  module Support
    module Text
      module Distance
        #
        # Methods for calculating Levenshtein Distance
        #
        module Levenshtein
          #
          # Calculates Levenshtein Distance between two strings.
          #
          # @param [String] string1
          #   First string to compare.
          #
          # @param [String] string2
          #   Second string to compare.
          #
          # @return [Integer]
          #   The calculated distance.
          #
          def levenshtein_distance(string1,string2)
            m = string1.size
            n = string2.size

            previous_row = (0..n).to_a

            1.upto(m) do |i|
              current_value  = i

              1.upto(n) do |j|
                diagonal            = previous_row[j - 1]
                previous_row[j - 1] = current_value

                current_value = if string1[i - 1] == string2[j - 1]
                                  diagonal
                                else
                                  1 + [current_value, previous_row[j], diagonal].min
                                end
              end

              previous_row[n] = current_value
            end

            previous_row[n]
          end
        end
      end
    end
  end
end
