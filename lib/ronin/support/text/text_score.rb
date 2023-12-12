# frozen_string_literal: true

require 'ronin/support/text/text_score/engine'

module Ronin
  module Support
    module Text
      #
      # Scoring provides basic text scoring capibilites for
      # english. Can be extended to other languages or formats
      # using provided generator script in
      # `ronin/support/text/text_score/`
      #
      # You'll need to modifiy the erb template to specify language
      # if you plan to do this later. @todo: shellspawn
      #
      module Scoring
        #
        # @api public
        #
        # @param [Array<String>] data_set
        #   the array of english text canidates
        #
        # @return [<String>, Score] or Array[[<String>, Score]]
        #   Score is the result of the provided metric applied to
        #   the string. This function returns the one that looks
        #   most like english, or the top_n number of scores
        #
        def self.find_english_text(data_set, top_n=1)
          # this could be made a bit nicer by passing a symbol to the
          # constructor, but this suffices TODO
          tse = TextScoringEngine.new { |e| english_n_glyph_metric e }

          tse.add_elements data_set

          if top_n > 1
            return tse.score.top top_n
          else
            return tse.score.best
          end
        end
      end
    end
  end
end
