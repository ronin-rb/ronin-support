require 'spec_helper'
require 'ronin/fuzzing/fuzzer'

describe Fuzzing::Fuzzer do
  let(:string) { 'GET /one/two/three' }

  describe "#initialize" do
    subject { described_class }

    context "patterns" do
      let(:substitutions) { ['bar'] }

      it "should accept Regexps" do
        fuzzer = subject.new(/foo/ => substitutions)

        fuzzer.rules.should have_key(/foo/)
      end

      context "when given Strings" do
        subject { described_class.new('foo' => substitutions) }

        it "should convert to Regexp" do
          subject.rules.should have_key(/foo/)
        end
      end

      context "when given Symbols" do
        subject { described_class.new(:word => substitutions) }

        it "should lookup the Regexp constant" do
          subject.rules.should have_key(Regexp::WORD)
        end
      end

      context "otherwise" do
        it "should raise a TypeError" do
          lambda {
            subject.new(Object.new => substitutions)
          }.should raise_error(TypeError)
        end
      end
    end

    context "substitutions" do
      let(:pattern) { /foo/ }

      it "should accept Enumerable values" do
        fuzzer = subject.new(pattern => ['bar'])

        fuzzer.rules[pattern].should == ['bar']
      end

      context "when given Symbols" do
        subject { described_class.new(pattern => :bad_strings) }

        it "should map to an Enumerator for a Fuzzing method" do
          subject.rules[pattern].should be_kind_of(Enumerable)
        end
      end

      context "otherwise" do
        it "should raise a TypeError" do
          lambda {
            subject.new(pattern => Object.new)
          }.should raise_error(TypeError)
        end
      end
    end
  end

  describe "#each" do
    let(:string) { "hello old dog" }

    subject { described_class.new(/o/ => ['O', '0'], /e/ => ['E', '3']) }

    it "should apply each fuzzing rule individually" do
      subject.each(string).to_a.should =~ [
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
