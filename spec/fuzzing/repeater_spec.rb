require 'spec_helper'
require 'ronin/fuzzing/repeater'

describe Fuzzing::Repeater do
  describe "#initialize" do
    subject { described_class }

    context "when lengths is an Integer" do
      it "should coerce lengths to an Enumerable" do
        repeator = subject.new(10)

        expect(repeator.lengths).to be_kind_of(Enumerable)
      end
    end

    context "when lengths is not Enumerable or an Integer" do
      it "should raise a TypeError" do
        expect {
          subject.new(Object.new)
        }.to raise_error(TypeError)
      end
    end
  end

  describe "#each" do
    let(:repeatable) { 'A' }

    context "when lengths was an Integer" do
      let(:length) { 10 }

      subject { described_class.new(length) }

      it "should yield one repeated value" do
        values = subject.each(repeatable).to_a
        
        expect(values).to eq([repeatable * length])
      end
    end

    context "when lengths was Enumerable" do
      let(:lengths) { (1..4) }

      subject { described_class.new(lengths) }

      it "should yield repeated values for each length" do
        values = subject.each(repeatable).to_a

        expect(values).to eq([
          repeatable * 1,
          repeatable * 2,
          repeatable * 3,
          repeatable * 4
        ])
      end
    end
  end
end
