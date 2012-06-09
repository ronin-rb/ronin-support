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
    subject { "foo bar" }

    it "should apply each fuzzing rule individually" do
      strings = subject.fuzz(/o/ => ['O', '0'], /a/ => ['A', '@']).to_a
      
      strings.should =~ [
        "fOo bar",
        "f0o bar",
        "foO bar",
        "fo0 bar",
        "foo bAr",
        "foo b@r"
      ]
    end
  end

  describe "#mutate" do
    subject { "foo bar" }

    it "should apply every combination of mutation rules" do
      strings = subject.mutate(/o/ => ['0'], /a/ => ['@']).to_a

      strings.should =~ [
        "f0o bar",
        "fo0 bar",
        "f00 bar",
        "foo b@r",
        "f0o b@r",
        "fo0 b@r",
        "f00 b@r"
      ]
    end
  end
end
