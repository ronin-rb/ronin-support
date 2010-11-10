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

  it "should provide String#inject_before" do
    should respond_to(:inject_before)
  end

  it "should provide String#inject_after" do
    should respond_to(:inject_after)
  end

  it "should provide String#inject_with" do
    should respond_to(:inject_with)
  end

  describe "format_chars" do
    it "should format each character in the String" do
      subject.format_chars { |c|
        "_#{c}"
      }.should == "_h_e_l_l_o"
    end

    it "should format specific bytes in a String" do
      subject.format_chars(:include => [104, 108]) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      subject.format_chars(:exclude => [101, 111]) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should format ranges of bytes in a String" do
      subject.format_chars(:include => (104..108)) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format ranges of bytes in a String" do
      subject.format_chars(:exclude => (104..108)) { |c|
        c.upcase
      }.should == 'hEllO'
    end

    it "should format specific chars in a String" do
      subject.format_chars(:include => ['h', 'l']) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      subject.format_chars(:exclude => ['e', 'o']) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should format ranges of chars in a String" do
      subject.format_chars(:include => ('h'..'l')) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format ranges of chars in a String" do
      subject.format_chars(:exclude => ('h'..'l')) { |c|
        c.upcase
      }.should == 'hEllO'
    end
  end

  describe "format_bytes" do
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

    it "should format specific chars in a String" do
      subject.format_bytes(:include => ['h', 'l']) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      subject.format_bytes(:exclude => ['e', 'o']) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should format ranges of chars in a String" do
      subject.format_bytes(:include => ('h'..'l')) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format ranges of chars in a String" do
      subject.format_bytes(:exclude => ('h'..'l')) { |b|
        b - 32
      }.should == 'hEllO'
    end
  end

  describe "random_case" do
    it "should capitalize each character when :probability is 1.0" do
      new_string = subject.random_case(:probability => 1.0)

      subject.upcase.should == new_string
    end

    it "should not capitalize any characters when :probability is 0.0" do
      new_string = subject.random_case(:probability => 0.0)

      subject.should == new_string
    end
  end

  describe "inject_before" do
    it "should inject data before a matched String" do
      subject.inject_before('ll','x').should == "hexllo"
    end

    it "should inject data before a matched Regexp" do
      subject.inject_before(/l+/,'x').should == "hexllo"
    end

    it "should not inject data if no matches are found" do
      subject.inject_before(/x/,'x').should == subject
    end
  end

  describe "inject_after" do
    it "should inject data after a matched String" do
      subject.inject_after('ll','x').should == "hellxo"
    end

    it "should inject data after a matched Regexp" do
      subject.inject_after(/l+/,'x').should == "hellxo"
    end

    it "should not inject data if no matches are found" do
      subject.inject_after(/x/,'x').should == subject
    end
  end

  describe "inject_with" do
    it "should replace the data when given a String" do
      subject.inject_with('foo').should == 'foo'
    end

    it "should append data" do
      subject.inject_with(:append => 'x').should == "#{subject}x"
    end

    it "should prepend data" do
      subject.inject_with(:prepend => 'x').should == "x#{subject}"
    end

    it "should randomly insert data" do
      new_string = subject.inject_with(:insert => 'x')

      new_string[0,1].should_not == 'x'
      new_string[-2..-1].should_not == 'x'
      new_string.should include('x')
    end

    it "should insert data before appending or prepending data" do
      new_string = subject.inject_with(
        :append => 'xxx',
        :prepend => 'yyy',
        :insert => 'z'
      )

      new_string[0,3].should_not include('z')
      new_string[-4..-1].should_not include('z')
      new_string.should include('z')
    end
  end
end
