require 'spec_helper'
require 'ronin/formatting/fuzz'

describe String do
  it "should provide String.generate" do
    described_class.should respond_to(:generate)
  end

  describe "generate" do
    subject { described_class }

    it "should generate Strings from CharSets" do
      strings = subject.generate(:lowercase_hexadecimal, :numeric).to_a

      strings.grep(/^[0-9a-f][0-9]$/).should == strings
    end

    it "should generate Strings from lengths of CharSets" do
      strings = subject.generate([:numeric, 2]).to_a

      strings.grep(/^[0-9]{2}$/).should == strings
    end

    it "should generate Strings from varying lengths of CharSets" do
      strings = subject.generate([:numeric, 1..2]).to_a

      strings.grep(/^[0-9]{1,2}$/).should == strings
    end

    it "should generate Strings from custom CharSets" do
      strings = subject.generate([%w[a b c], 2]).to_a

      strings.grep(/^[abc]{2}$/).should == strings
    end

    it "should generate Strings containing known Strings" do
      strings = subject.generate('foo', [%w[a b c], 2]).to_a

      strings.grep(/^foo[abc]{2}$/).should == strings
    end

    it "should raise a TypeError for non String, Symbol, Enumerable CharSets" do
      lambda {
        subject.generate([Object.new, 2]).to_a
      }.should raise_error(TypeError)
    end

    it "should raise an ArgumentError for unknown CharSets" do
      lambda {
        subject.generate([:foo_bar, 2]).to_a
      }.should raise_error(ArgumentError)
    end

    it "should raise a TypeError for non Integer,Array,Range lengths" do
      lambda {
        subject.generate([:numeric, 'foo']).to_a
      }.should raise_error(TypeError)
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
