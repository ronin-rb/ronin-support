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

require 'ronin/support/text/typo'

class String

  #
  # Returns a random typo substitution for the String.
  #
  # @param [Hash{Symbol => Boolean}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [Boolean] omit
  #   Enables/disables omission of repeated characters.
  #
  # @option kwargs [Boolean] repeat
  #   Enables/disables repeatition of single characters.
  #
  # @option kwargs [Boolean] swap
  #   Enables/disables swapping of certain common character pairs.
  #
  # @option kwargs [Boolean] suffix
  #   Enables/disables changing the suffixes of words.
  #
  # @return [String]
  #   A random typo of the String.
  #
  # @example
  #   "microsoft".typo
  #   # => "microssoft"
  #
  # @see Ronin::Support::Text::Typo.substitute
  #
  # @api public
  #
  # @since 1.0.0
  #
  def typo(**kwargs)
    Ronin::Support::Text::Typo.substitute(self,**kwargs)
  end

  #
  # Enumerates over every typo mistake for the String.
  #
  # @param [Hash{Symbol => Boolean}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [Boolean] omit
  #   Enables/disables omission of repeated characters.
  #
  # @option kwargs [Boolean] repeat
  #   Enables/disables repeatition of single characters.
  #
  # @option kwargs [Boolean] swap
  #   Enables/disables swapping of certain common character pairs.
  #
  # @option kwargs [Boolean] suffix
  #   Enables/disables changing the suffixes of words.
  #
  # @yield [typoed]
  #   If a block is given, it will be passed each possible typo of the
  #   original String.
  #
  # @yieldparam [String]
  #   A modified version of the original String.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator will be returned.
  #
  # @example
  #   "consciousness".each_typo do |typo|
  #     # ...
  #   end
  #
  # @see Ronin::Support::Text::Typo.each_substitution
  #
  # @api public
  #
  # @since 1.0.0
  #
  def each_typo(**kwargs,&block)
    Ronin::Support::Text::Typo.each_substitution(self,**kwargs,&block)
  end

  #
  # Returns every typo for the String.
  #
  # @param [Hash{Symbol => Boolean}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [Boolean] omit
  #   Enables/disables omission of repeated characters.
  #
  # @option kwargs [Boolean] repeat
  #   Enables/disables repeatition of single characters.
  #
  # @option kwargs [Boolean] swap
  #   Enables/disables swapping of certain common character pairs.
  #
  # @option kwargs [Boolean] suffix
  #   Enables/disables changing the suffixes of words.
  #
  # @return [Array<String>]
  #   Every typo variation of the String.
  #
  # @example
  #   "consciousness".typos
  #   # =>
  #   # ["consciusness",
  #   #  "consciosness",
  #   #  "conscuosness",
  #   #  "consciosness",
  #   #  "coonsciousness",
  #   #  "conscioousness",
  #   #  "conssciousness",
  #   #  "conscioussness",
  #   #  "consciousnesss",
  #   #  "consciuosness",
  #   #  "consciousnes"]
  #
  # @see Ronin::Support::Text::Typo.each_substitution
  #
  # @api public
  #
  # @since 1.0.0
  #
  def typos(**kwargs)
    Ronin::Support::Text::Typo.each_substitution(self,**kwargs).to_a
  end

end
