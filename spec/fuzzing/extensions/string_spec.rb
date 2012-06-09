require 'spec_helper'
require 'ronin/fuzzing/extensions/string'

describe String do
  it "should provide String.generate" do
    described_class.should respond_to(:generate)
  end

  it "should provide String#repeating" do
    subject.should respond_to(:repeating)
  end

  it "should provide String#fuzz" do
    subject.should respond_to(:fuzz)
  end

  it "should provide String#mutate" do
    subject.should respond_to(:mutate)
  end

  describe "generate" do
    subject { described_class }

    it "should generate Strings from a template" do
      strings = subject.generate([:numeric, 2]).to_a

      strings.grep(/^[0-9]{2}$/).should == strings
    end
  end

  describe "#repeating" do
    subject { 'A' }

    context "when n is an Integer" do
      let(:n) { 100 }

      it "should multiply the String by n" do
        subject.repeating(n).should == (subject * n)
      end
    end

    context "when n is Enumerable" do
      let(:n) { [128, 512, 1024] }

      it "should repeat the String by each length" do
        strings = subject.repeating(n).to_a

        strings.should == n.map { |length| subject * length }
      end
    end
  end

  describe "#fuzz" do
    subject { "hello old dog" }

    it "should apply each fuzzing rule individually" do
      strings = subject.fuzz(/o/ => ['O', '0'], /e/ => ['E', '3']).to_a
      
      strings.should =~ [
        "hellO old dog",
        "hell0 old dog",
        "hello Old dog",
        "hello 0ld dog",
        "hello old dOg",
        "hello old d0g",
        "hEllo old dog",
        "h3llo old dog"
      ]
    end
  end
end
