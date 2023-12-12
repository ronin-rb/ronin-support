require 'spec_helper'
require 'ronin/support/text/text_score'

describe Ronin::Support::Text::Scoring do
  describe ".find_english_text" do
    context "when provided with a text corpus" do
      let(:data) { ["the english language"] }

      it "must return an array of the format [String, float]" do
        expect(subject.find_english_text(data)).to be_an_instance_of(Array)
        expect(subject.find_english_text(data)[0]).to be_an_instance_of(String)
        expect(subject.find_english_text(data)[1]).to be_a_kind_of(Numeric)
        expect(subject.find_english_text(data).length).to eq(2)
      end

      it "must score the data with a positive floating point number" do
        expect(subject.find_english_text(data)[1]).to be > 0
      end
    end
  end
end
