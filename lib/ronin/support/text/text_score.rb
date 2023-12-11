# frozen_string_literal: true

require 'ronin/support/text/text_score/n_glyphs'

module Ronin
  module Support
    module Text
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
          # @param [Proc<Element>] metric
          #   The metric, as a block or Proc
          #   that scores the elements
          def initialize(&metric)
            raise ArgumentError, "Must provide metric as a block or Proc" if metric.nil?

            @metric          = metric
            @dataset         = []
            @scores          = {}
          end

          #
          # add elements to process
          #
          # @param [Array<Element>] elements
          #   opaque array to pass elements
          #   to the user defined score function
          #
          def add_elements(elements)
            @dataset = (@dataset + elements).uniq
          end

          #
          # perform calculation
          #
          # @return [self]
          def score
            @dataset.each { |element| @scores[element] = metric(element) }
          end

          #
          # get the best performing element
          #
          # @return [Float, Element]
          def best
            best_element = @scores.max_by { |k, v| v }
            [@scores[best_element], best_element]
          end

          #
          # get the worst performing element
          #
          # @return [Float, Element]
          def worst
            worst_element = @scores.min_by { |k, v| v }
            [@scores[worst_element], worst_element]
          end

          #
          # get the top N results
          #
          # @return [Array<Float, Element>]
          def top(n)
            @scores.sort_by { |k, v| v }.top(n)
          end
        end
      end
    end
  end
end
