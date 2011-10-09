require 'spec_helper'
require 'ronin/formatting/text'

describe String do
  subject { "hello" }

  it "should provide String.generate" do
    described_class.should respond_to(:generate)
  end

  it "should provide String#format_chars" do
    should respond_to(:format_chars)
  end

  it "should provide String#format_bytes" do
    should respond_to(:format_bytes)
  end

  it "should provide String#random_case" do
    should respond_to(:random_case)
  end

  it "should provide String#insert_before" do
    should respond_to(:insert_before)
  end

  it "should provide String#insert_after" do
    should respond_to(:insert_after)
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

  describe "#format_bytes" do
    it "should format each byte in the String" do
      subject.format_bytes { |b|
        sprintf("%%%x",b)
      }.should == "%68%65%6c%6c%6f"
    end

    it "should format specific bytes in a String" do
      subject.format_bytes(:include => [104, 108]) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      subject.format_bytes(:exclude => [101, 111]) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should format ranges of bytes in a String" do
      subject.format_bytes(:include => (104..108)) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format ranges of bytes in a String" do
      subject.format_bytes(:exclude => (104..108)) { |b|
        b - 32
      }.should == 'hEllO'
    end
  end

  describe "#format_chars" do
    it "should format each character in the String" do
      subject.format_chars { |c|
        "#{c}."
      }.should == "h.e.l.l.o."
    end

    it "should format specific chars in a String" do
      subject.format_chars(:include => ['h', 'l']) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format specific chars in a String" do
      subject.format_chars(:exclude => ['h', 'l']) { |c|
        c.upcase
      }.should == 'hEllO'
    end

    it "should format ranges of chars in a String" do
      subject.format_chars(:include => /[h-l]/) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format ranges of chars in a String" do
      subject.format_chars(:exclude => /[h-l]/) { |c|
        c.upcase
      }.should == 'hEllO'
    end
  end

  describe "#random_case" do
    it "should capitalize each character when :probability is 1.0" do
      new_string = subject.random_case(:probability => 1.0)

      subject.upcase.should == new_string
    end

    it "should not capitalize any characters when :probability is 0.0" do
      new_string = subject.random_case(:probability => 0.0)

      subject.should == new_string
    end
  end

  describe "#insert_before" do
    it "should inject data before a matched String" do
      subject.insert_before('ll','x').should == "hexllo"
    end

    it "should inject data before a matched Regexp" do
      subject.insert_before(/l+/,'x').should == "hexllo"
    end

    it "should not inject data if no matches are found" do
      subject.insert_before(/x/,'x').should == subject
    end
  end

  describe "#insert_after" do
    it "should inject data after a matched String" do
      subject.insert_after('ll','x').should == "hellxo"
    end

    it "should inject data after a matched Regexp" do
      subject.insert_after(/l+/,'x').should == "hellxo"
    end

    it "should not inject data if no matches are found" do
      subject.insert_after(/x/,'x').should == subject
    end
  end
end
