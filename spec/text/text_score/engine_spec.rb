require 'spec_helper'
require 'ronin/support/encoding/base64'

describe Ronin::Support::Text::Scoring do
  describe ".english_n_glyph_metric" do
    context "when providing english text" do
      it "must return a positive numeric score" do
        expect(subject.english_n_glyph_metric("eeeeeeeeeee")).to be_a_kind_of(Numeric)
        expect(subject.english_n_glyph_metric("eeeeeeeeeee")).to be > 0
      end
    end
    context "when providing non-ascii text" do
      it "must return a zero" do
        expect(subject.english_n_glyph_metric("\xff\xff\xff\xff")).to be_a_kind_of(Numeric)
        expect(subject.english_n_glyph_metric("\xff\xff\xff\xff")).to be == 0
      end
    end
  end
  describe "TextScoringEngine" do
    context "when used with english strings" do
      let(:tse) {
        Ronin::Support::Text::Scoring::TextScoringEngine.new { | e |
          Ronin::Support::Text::Scoring.english_n_glyph_metric e
        }
      }


      it "must return an array of type [Opaque, score]" do
        tse.add_elements ["eeeeeeee","eeee\x90\x90\x90\x90","\x90\x90\x90\x90\x90\x90\x90\x90"]
        expect(tse.score.best).to be_an_instance_of(Array)
        # the element returned by best [Opaque, score] is not tested here
        expect(tse.score.best[1]).to be_a_kind_of(Numeric)
        expect(tse.score.best.length).to be == 2
      end
      it "must return highest scored result when best is called" do
        tse.add_elements ["eeeeeeee","eeee\x90\x90\x90\x90","\x90\x90\x90\x90\x90\x90\x90\x90"]
        expect(tse.score.best[1]).to be > 0.5
        expect(tse.score.worst[1]).to be == 0
        # ugly access to middle element
        expect(tse.score.top(3)[1][1]).to be < 0.5
        expect(tse.score.top(3)[1][1]).to be > 0
      end
    end
  end
end 
