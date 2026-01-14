require 'spec_helper'
require 'ronin/support/text/distance/levenshtein'

describe Ronin::Support::Text::Distance::Levenshtein do
  class TestTextLevenshtein
    include Ronin::Support::Text::Distance::Levenshtein
  end

  let(:test_class) { TestTextLevenshtein }
  subject { test_class.new }

  it "must provide a #levenshtein_distance method" do
    expect(subject).to respond_to(:levenshtein_distance)
  end

  describe "#levenshtein_distance" do
    context "when given two somewhat similar strings" do
      let(:string1)  { "kitten" }
      let(:string2)  { "sitting" }
      let(:expected_distance) { 3 }

      it "must calculate levenshtein distance between them" do
        expect(subject.levenshtein_distance(string1, string2)).to eq(expected_distance)
      end
    end

    context "when given two empty strings" do
      let(:string1) { "" }
      let(:string2) { "" }
      let(:expected_distance) { 0 }

      it "must returns 0" do
        expect(subject.levenshtein_distance(string1, string2)).to eq(expected_distance)
      end
    end

    context "when given one empty string" do
      let(:string1) { "test" }
      let(:string2) { "" }
      let(:expected_distance) { string1.size }

      it "must return length of given string" do
        expect(subject.levenshtein_distance(string1, string2)).to eq(expected_distance)
      end
    end

    context "when given two identical strings" do
      let(:string1) { "test" }
      let(:string2) { "test" }
      let(:expected_distance) { 0 }

      it "must return 0" do
        expect(subject.levenshtein_distance(string1, string2)).to eq(expected_distance)
      end
    end

    context "when given strings differing by one character" do
      let(:string1) { "cat" }
      let(:string2) { "bat" }
      let(:expected_distance) { 1 }

      it "must returns 1" do
        expect(subject.levenshtein_distance(string1, string2)).to eq(expected_distance)
      end
    end

    context "when given two completely different strings" do
      let(:string1) { "long_foo" }
      let(:string2) { "bar" }
      let(:expected_distance) { string1.size }

      it "must return lenght of the longest one" do
        expect(subject.levenshtein_distance(string1, string2)).to eq(expected_distance)
      end
    end
  end
end
