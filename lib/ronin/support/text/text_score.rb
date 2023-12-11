# frozen_string_literal: true

require 'ronin/support/text/text_score/engine'

module Ronin
  module Support
    module Text
      module Scoring
        def find_english_text(data_set, top_n=1)
          tse = TextScoringEngine.new englishNGlyphMetric
          data_set.each { | datum | tse.add_elements data_set }
          tse.score.top top_n
        end
      end
    end
  end
end

