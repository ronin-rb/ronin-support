#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/fuzzing/template'
require 'ronin/fuzzing/mutator'
require 'ronin/extensions/regexp'

require 'set'

module Ronin
  #
  # An Enumerable class for iterating over wordlist files or lists of words.
  #
  # @since 0.4.0
  #
  class Wordlist

    include Enumerable

    # The path to the wordlist file
    #
    # @since 0.5.0
    attr_reader :path

    # The words for the list
    #
    # @since 0.5.0
    attr_reader :words

    # Mutation rules to apply to every word in the list
    attr_reader :mutations

    #
    # Initializes the wordlist.
    #
    # @param [String, Enumerable] wordlist
    #   The path of the wordlist or list of words.
    #
    # @param [Hash{Regexp,String,Symbol => Symbol,#each}] mutations
    #   Additional mutation rules to perform on each word in the list.
    #
    # @yield [wordlist]
    #   The given block will be passed the new wordlist.
    #
    # @yieldparam [Wordlist] wordlist
    #   The new wordlist object.
    #
    # @raise [TypeError]
    #   The list was not a path to a wordlist file, nor a list of words.
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
    def initialize(wordlist,mutations={})
      case wordlist
      when String
        @path  = wordlist
        @words = nil
      when Enumerable
        @path  = nil
        @words = wordlist
      else
        raise(TypeError,"wordlist must be a path or Enumerable")
      end

      @mutations = mutations

      yield self if block_given?
    end

    #
    # Parses the text into a unique Set of words.
    #
    # @param [#each_line] text
    #   The text to parse.
    #
    # @yield [word]
    #   If a block is given, it will be passed every unique word,
    #   the first time it is seen.
    #
    # @yieldparam [String] word
    #   A unique word from the text.
    #
    # @return [Set]
    #   The unique set of words from the text.
    #
    def self.parse(text)
      words_seen = Set[]

      text.each_line do |line|
        line.scan(Regexp::WORD) do |word|
          if block_given?
            yield word unless words_seen.include?(word)
          end

          words_seen << word
        end
      end

      return words_seen
    end

    #
    # Builds a new wordlist from the text.
    #
    # @param [#each_line] text
    #   The text to parse.
    #
    # @param [Hash{Regexp,String,Symbol => Symbol,#each}] mutations
    #   Additional mutations for the wordlist.
    #
    # @return [Wordlist]
    #   The newly build wordlist.
    #
    def self.build(text,mutations={})
      new(parse(text),mutations)
    end

    #
    # Creates a new wordlist file.
    #
    # @param [String] path
    #   The path to the wordlist file.
    #
    # @param [String] text
    #   The text to parse.
    #
    # @param [Hash{Regexp,String,Symbol => Symbol,#each}] mutations
    #   Additional mutations for the wordlist.
    #
    # @return [Wordlist]
    #   The newly built wordlist.
    #
    # @since 0.5.0
    #
    def self.create(path,text,mutations={})
      wordlist = build(text,mutations)

      return wordlist.save(path)
    end

    #
    # The wordlist file or list of words.
    #
    # @return [String, Enumerable]
    #   The path to the wordlist file or list of words.
    #
    # @api semipublic
    #
    def list
      @path || @words
    end

    #
    # Iterates over each word in the list.
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
    # @raise [RuntimeError]
    #   {#path} or {#words} must be set.
    #
    # @api public
    #
    def each_word(&block)
      return enum_for(__method__) unless block

      if @path
        File.open(@path) do |file|
          file.each_line do |line|
            yield line.chomp
          end
        end
      elsif @words
        @words.each(&block)
      end
    end

    #
    # Iterates over each word, and each mutation, from the list.
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
      return enum_for(__method__) unless block

      mutator = unless @mutations.empty?
                  Fuzzing::Mutator.new(@mutations)
                end

      each_word do |word|
        yield word

        if mutator
          # perform additional mutations
          mutator.each(word,&block)
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
      Fuzzing::Template[[each, n]].each(&block)
    end

    #
    # Saves the words to a new file.
    #
    # @param [String] path
    #   The path to the new wordlist file.
    #
    # @return [Wordlist]
    #   The wordlist object.
    #
    # @see #each
    #
    # @since 0.5.0
    #
    # @api public
    #
    def save(path)
      File.open(path,'w') do |file|
        each { |word| file.puts word }
      end

      return self
    end

  end
end
