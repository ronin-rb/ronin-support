require 'spec_helper'
require 'ronin/formatting/text'

describe String do
  subject { "hello" }

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

  it "should provide String#escape" do
    should respond_to(:escape)
  end

  it "should provide String#unescape" do
    should respond_to(:unescape)
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

  describe "#unescape" do
    it "should not unescape a normal String" do
      "hello".unescape.should == "hello"
    end

    it "should unescape a hex String" do
      "\\x68\\x65\\x6c\\x6c\\x6f\\x4e".unescape.should == "hello\x4e"
    end

    it "should unescape an octal String" do
      "hello\012".unescape.should == "hello\n"
    end

    it "should unescape control characters" do
      "hello\\n".unescape.should == "hello\n"
    end

    it "should unescape normal characters" do
      "hell\\o".unescape.should == "hello"
    end
  end
end
