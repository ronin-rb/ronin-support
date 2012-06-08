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
    subject { 'GET /one/two/three' }

    context "matching" do
      it "should allow Regexps" do
        fuzzed = subject.fuzz(/GET/ => ['get']).to_a

        fuzzed.should == ['get /one/two/three']
      end

      it "should allow Strings" do
        fuzzed = subject.fuzz('GET' => ['get']).to_a

        fuzzed.should == ['get /one/two/three']
      end

      it "should match Symbols to Regexp constants" do
        fuzzed = subject.fuzz(:absolute_path => ['../../../..']).to_a

        fuzzed.should == ['GET ../../../..']
      end
    end

    context "substitution" do
      it "should allow Procs" do
        fuzzed = subject.fuzz('GET' => [lambda { |s| s.downcase }]).to_a

        fuzzed.should == ['get /one/two/three']
      end

      it "should allow Integers" do
        fuzzed = subject.fuzz(' ' => [0x09]).to_a

        fuzzed.should == ["GET\t/one/two/three"]
      end

      it "should map Symbols to Fuzzing methods" do
        fuzzed = subject.fuzz(/\/.*/ => :format_strings).to_a

        fuzzed.should_not == [subject]
      end

      it "should incrementally replace each occurrence" do
        fuzzed = subject.fuzz('/' => ["\n\r"]).to_a

        fuzzed.should == [
          "GET \n\rone/two/three",
          "GET /one\n\rtwo/three",
          "GET /one/two\n\rthree"
        ]
      end

      it "should replace each occurrence with each substitution" do
        fuzzed = subject.fuzz('GET' => ["\n\rGET", "G\n\rET", "GET\n\r"]).to_a

        fuzzed.should == [
          "\n\rGET /one/two/three",
          "G\n\rET /one/two/three",
          "GET\n\r /one/two/three"
        ]
      end
    end
  end
end
