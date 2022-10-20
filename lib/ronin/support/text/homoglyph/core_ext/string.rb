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

require 'ronin/support/text/homoglyph'

class String

  #
  # Returns a random homoglyph substitution of the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:ascii, :greek, :cyrillic, :punctuation, :latin_numbers,
  #                 :full_width, nil] char_set
  #   The character set to use.
  #
  # @return [String]
  #   A random homoglyphic variation of the String.
  #
  # @raise [ArgumentError]
  #   Could not find any matching characters to replace in the String.
  #
  # @raise [Ronin::Support::Text::Homoglyph::NotViable]
  #   No homoglyph replaceable characters were found in the String.
  #
  # @see Ronin::Support::Text::Homoglyph.substitute
  #
  # @api public
  #
  # @since 1.0.0
  #
  def homoglyph(**kwargs)
    Ronin::Support::Text::Homoglyph.substitute(self,**kwargs)
  end

  #
  # Enumerates over every homoglyph variation of the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:ascii, :greek, :cyrillic, :punctuation, :latin_numbers,
  #                 :full_width, nil] char_set
  #   The character set to use.
  #
  # @yield [homoglyph]
  #   The given block will be passed each homoglyph variation of the String.
  #
  # @yieldparam [String] homoglyph
  #   A variation of the String.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator object will be returned.
  #
  # @see Ronin::Support::Text::Homoglyph.each_substitution
  #
  # @api public
  #
  # @since 1.0.0
  #
  def each_homoglyph(**kwargs,&block)
    Ronin::Support::Text::Homoglyph.each_substitution(self,**kwargs,&block)
  end

  #
  # Returns every homoglyph variation of the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:ascii, :greek, :cyrillic, :punctuation, :latin_numbers,
  #                 :full_width, nil] char_set
  #   The character set to use.
  #
  # @yield [homoglyph]
  #   The given block will be passed each homoglyph variation of the given
  #   word.
  #
  # @return [Array<String>]
  #   All variation of the given String.
  #
  # @see Ronin::Support::Text::Homoglyph.each_substitution
  #
  # @api public
  #
  # @since 1.0.0
  #
  def homoglyphs(**kwargs)
    Ronin::Support::Text::Homoglyph.each_substitution(self,**kwargs).to_a
  end

end
