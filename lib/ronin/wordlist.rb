#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/fuzzing'

module Ronin
  #
  # An Enumerable class for iterating over wordlist files or lists of words.
  #
  # @since 0.4.0
  #
  class Wordlist

    include Enumerable

    # Mutation rules to apply to every word in the list
    attr_reader :mutations

    #
    # Initializes the wordlist.
    #
    # @param [String, Enumerable] list
    #   The path of the wordlist or list of words.
    #
    # @param [Hash{Regexp,String,Symbol => Symbol,#each}] mutations
    #   Additional mutation rules to perform on each word in the list.
    #
    # @example Use a file wordlist
    #   wordlist = Wordlist.new('passwords.txt')
    #
    # @example Use a range of Strings
    #   wordlist = Wordlist.new('aaaa'..'zzzz')
    #
    # @example Specify mutation rules
    #   wordlist = Wordlist.new('passwords.txt', /e/ => ['E', '3'])
    #
    # @see String#mutate
    #
    # @api public
    #
    def initialize(list,mutations={})
      @list = case list
              when String
                File.new(list)
              when Enumerable
                list
              else
                raise(TypeError,"list must be a path or Enumerable")
              end

      @mutations = {}
      @mutations.merge!(mutations)
    end

    #
    # Iterates over each word from the list.
    #
    # @yield [word]
    #   The given block will be passed each word.
    #
    # @yieldparam [String] word
    #   A word from the list.
    #
    # @return [Enumerator]
    #   If no block is given, an Enumerator will be returned.
    #
    # @api public
    #
    def each(&block)
      return enum_for(:each) unless block

      @list.rewind if @list.respond_to?(:rewind)

      @list.each do |line|
        line = line.chomp

        yield line

        unless @mutations.empty?
          # perform additional mutations
          line.mutate(@mutations,&block)
        end
      end
    end

    #
    # Iterates over every n words.
    #
    # @param [Integer, Range, Array] n
    #   The number of words to combine.
    #
    # @yield [words]
    #   The given block will be passed every combination of `n` words.
    #
    # @yieldparam [String]
    #    The combination of `n` words.
    #
    # @return [Enumerator]
    #   If no block is given, an Enumerator will be returned.
    #
    # @api public
    #
    def each_n_words(n,&block)
      String.generate([each, n],&block)
    end

  end
end
