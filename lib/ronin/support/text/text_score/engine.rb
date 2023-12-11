# frozen_string_literal: true

require 'ronin/support/text/text_score/n_glyphs'

module Ronin
  module Support
    module Text
      # a nice default metric for use with TSE
      def englishNGlyphMetric element
        # sum the sums computed from the original maps maps
        [MONOGLYPH_MAP, DIGLYPH_MAP, TRIGLYPH_MAP].sum do | glyph_map |
          # compute the occurence of each glyph
          glyph_map.sum do | glyph_and_score |
            glyph, score = *glyph_and_score
            element.scan(/?=#{glyph})/).count * score
          end
        end
      end

      #
      # Implements a basic text scoring enigne.
      #
      # The text scoring engine takes a "metric" and a "dataset" as parameters.
      # It then selects the elements of the dataset that best match the metric.
      #
      # Selected elements are avalible via `best`, `worst`. `top`, and etc
      #
      #
      # @api public
      module Scoring
        #
        # Text Scoring engine implementation
        class TextScoringEngine
          #
          # Initialize an new scoring engine
          #
          # NOTE: the only requirement for
          # the opaque elements used in this
          # engine is hashability
          #
          # @param [Proc<Element>] metric
          #   The metric, as a block or Proc
          #   that scores the elements
          def initialize(&metric)
            raise ArgumentError, "Must provide metric as a block or Proc" if metric.nil?

            @metric          = metric
            @dataset         = []
            @scores          = Hash.new(0)
          end

          #
          # add an element to process
          
          # @param <Element> elements
          #   opaque 'element' that the metric
          #   score function can accept
          #
          def add_element(elements)
            @dataset << [elements]
          end
          
          #
          # add elements to process
          #
          # @param [Array<Element>] elements
          #   array of opaque elements 
          #   (each element still needs to be
          #   compatable with the score function)
          #
          def add_elements(elements)
            @dataset += elements
          end

          #
          # perform calculation
          #
          # @return [self]
          #   this is so we can immediatly call top/best/worse
          def score
            @dataset.each { |element| @scores[element] = @metric.call(element) }
            self
          end

          #
          # get the best performing element
          #
          # @return [Float, Element]
          def best
            @scores.max_by { |k, v| v }
          end

          #
          # get the worst performing element
          #
          # @return [Float, Element]
          def worst
            @scores.min_by { |k, v| v }
          end

          #
          # get the top N results
          #
          # @return [Array<Float, Element>]
          def top(n)
            @scores.sort_by { |k, v| v }.reverse[0..n]
          end
        end
      end
    end
  end
end
