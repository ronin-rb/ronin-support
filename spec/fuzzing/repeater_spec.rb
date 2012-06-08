require 'spec_helper'
require 'ronin/fuzzing/repeater'

describe Fuzzing::Repeater do
  let(:repeatable) { 'A' }

  describe "#initialize" do
    subject { described_class }

    context "when lengths is an Integer" do
      it "should coerce lengths to an Enumerable" do
        repeator = subject.new(repeatable,10)

        repeator.lengths.should be_kind_of(Enumerable)
      end
    end

    context "when lengths is not Enumerable or an Integer" do
      it "should raise a TypeError" do
        lambda {
          subject.new(repeatable,Object.new)
        }.should raise_error(TypeError)
      end
    end
  end

  describe "#each" do
    context "when lengths was an Integer" do
      let(:length) { 10 }

      subject { described_class.new(repeatable,length) }

      it "should yield one repeated value" do
        values = subject.each.to_a
        
        values.should == [repeatable * length]
      end
    end

    context "when lengths was Enumerable" do
      let(:lengths) { (1..4) }

      subject { described_class.new(repeatable,lengths) }

      it "should yield repeated values for each length" do
        values = subject.each.to_a.should

        values.should == [
          repeatable * 1,
          repeatable * 2,
          repeatable * 3,
          repeatable * 4
        ]
      end
    end
  end
end
