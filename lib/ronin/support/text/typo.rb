# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/text/typo/generator'

module Ronin
  module Support
    module Text
      #
      # Generates typos in words.
      #
      # ## Core-Ext Methods
      #
      # * {String#each_typo}
      # * {String#typo}
      # * {String#typos}
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Typo
        # Typo generator that repeats characters.
        OMIT_CHARS = Generator[
          [/(?<=\w)ae(?=\w)/, 'e'],
          [/(?<=\w)dd(?=\w)/, 'd'],
          [/(?<=\w)rr(?=\w)/, 'r'],
          [/(?<=\w)ll(?=\w)/, 'l'],
          [/(?<=\w)mm(?=\w)/, 'm'],
          [/(?<=\w)ss(?=\w)/, 's'],
          [/(?<=\w)oo(?=\w)/, 'o'],
          [/(?<=\w)ous/,  'us'],
          [/(?<=\w)ous/,  'os'],
          [/(?<=\w)ious/, 'uos'],
          [/(?<=\w)ious/, 'ios'],
          [/[_-]/, '']
        ]

        # Typo generator that repeats characters.
        REPEAT_CHARS = Generator[
          [/(?<=\w)o(?=\w)/, 'oo'],
          [/(?<=\w)l(?=\w)/, 'll'],
          [/(?<=\w)s(?=\w)/, 'ss']
        ]

        # Typo generator that swaps neighboring characters.
        SWAP_CHARS = Generator[
          [/(?<=\w)au(?=\w)/, 'ua'],
          [/(?<=\w)ua(?=\w)/, 'au'],
          [/(?<=\w)ie(?=\w)/, 'ei'],
          [/(?<=\w)ei(?=\w)/, 'ie'],
          [/(?<=\w)th(?=\w)/, 'ht'],
          [/(?<=\w)ht(?=\w)/, 'th'],
          [/(?<=\w)il(?=\w)/, 'li'],
          [/(?<=\w)ou(?=\w)/, 'uo']
        ]

        # Typo generator that swaps different symbols.
        SWAP_SYMBOLS = Generator[
          [/_/, '-'],
          [/-/, '_']
        ]

        # Typo generator that changes the suffix of words.
        CHANGE_SUFFIX = Generator[
          [/er$/,   'ar'],
          [/ar$/,   'er'],
          [/el$/,   'le'],
          [/al$/,   'al'],
          [/es$/,   's'],
          [/s$/,    ''],
          [/ent$/,  'ant'],
          [/ant$/,  'ent'],
          [/able$/, 'ible'],
          [/ible$/, 'able'],
          [/ence$/, 'ense'],
          [/ense$/, 'ence'],
          [/ance$/, 'anse'],
          [/anse$/, 'ance'],
          [/ier$/,  'er'],
          [/ion$/,  'on']
        ]

        # Default typo generator.
        #
        # @note Does not include the {SWAP_SYMBOLS} typo rules.
        DEFAULT = Generator.new(
          OMIT_CHARS.rules + REPEAT_CHARS.rules + SWAP_CHARS.rules +
          CHANGE_SUFFIX.rules
        )

        #
        # Typo generator that repeats characters.
        #
        # @return [Generator]
        #
        # @see OMIT_CHARS
        #
        def self.omit_chars
          OMIT_CHARS
        end

        #
        # Typo generator that repeats characters.
        #
        # @return [Generator]
        #
        # @see REPEAT_CHARS
        #
        def self.repeat_chars
          REPEAT_CHARS
        end

        #
        # Typo generator that swaps neighboring characters.
        #
        # @return [Generator]
        #
        # @see SWAP_CHARS
        #
        def self.swap_chars
          SWAP_CHARS
        end

        #
        # Typo generator that swaps different symbols.
        #
        # @return [Generator]
        #
        # @see SWAP_SYMBOLS
        #
        def self.swap_symbols
          SWAP_SYMBOLS
        end

        #
        # Typo generator that changes the suffix of words.
        #
        # @return [Generator]
        #
        # @see CHANGE_SUFFIX
        #
        def self.change_suffix
          CHANGE_SUFFIX
        end

        #
        # Builds a set of typo substitution rules.
        #
        # @param [Hash{Symbol => Boolean}] kwargs
        #   Additional typo options.
        #
        # @option kwargs [Boolean] :omit_chars
        #   Whether to enable/disable omission of repeated characters.
        #
        # @option kwargs [Boolean] :repeat_chars
        #   Whether to enable/disable repeatition of single characters.
        #
        # @option kwargs [Boolean] :swap_chars
        #   Whether to enable/disable swapping of certain common character
        #   pairs.
        #
        # @option kwargs [Boolean] :change_suffix
        #   Whether to enable/disable changing the suffixes of words.
        #
        # @return [Generator]
        #   The typo generator.
        #
        def self.generator(**kwargs)
          if kwargs.empty?
            DEFAULT
          else
            rules = []
            rules.concat(OMIT_CHARS.rules)    if kwargs[:omit_chars]
            rules.concat(REPEAT_CHARS.rules)  if kwargs[:repeat_chars]
            rules.concat(SWAP_CHARS.rules)    if kwargs[:swap_chars]
            rules.concat(SWAP_SYMBOLS.rules)  if kwargs[:swap_symbols]
            rules.concat(CHANGE_SUFFIX.rules) if kwargs[:change_suffix]

            Generator.new(rules)
          end
        end

        #
        # Returns a random typo substitution for the given word.
        #
        # @param [String] word
        #   The given String.
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
        #   A random typo of the given word.
        #
        # @see String#typo
        #
        def self.substitute(word,**kwargs)
          generator(**kwargs).substitute(word)
        end

        #
        # Enumerates over every typo mistake for the given word.
        #
        # @param [String] word
        #   The given String.
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
        # @see String#each_typo
        # @see String#typos
        #
        def self.each_substitution(word,**kwargs,&block)
          generator(**kwargs).each_substitution(word,&block)
        end
      end
    end
  end
end

require 'ronin/support/text/typo/core_ext'
