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

module Ronin
  module Fuzzing
    #
    # Fuzzing class that generates repeated data.
    #
    # @api semipublic
    #
    # @since 0.5.0
    #
    class Repeater

      # The lengths to repeat the data by
      attr_reader :lengths

      #
      # Initializes a new Repeater.
      #
      # @param [Enumerable, Integer] lengths
      #   The lengths to repeat the data by.
      #
      # @raise [TypeError]
      #   `lengths` must either be Enumerable or an Integer.
      #
      def initialize(lengths)
        @lengths = case lengths
                   when Integer
                     [lengths]
                   when Enumerable
                     lengths
                   else
                     raise(TypeError,"argument must be Enumerable or an Integer")
                   end
      end

      #
      # Enumerates through each length of repeated data.
      #
      # @param [#*] repeatable
      #   The repeatable data.
      #
      # @yield [repeated]
      #   The given block will be passed every repeated String.
      #
      # @yieldparam [String] repeated
      #   A repeated version of the String.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator will be returned.
      #
      def each(repeatable)
        return enum_for(__method__,repeatable) unless block_given?

        @lengths.each do |length|
          yield(repeatable * length)
        end

        return nil
      end

    end
  end
end
