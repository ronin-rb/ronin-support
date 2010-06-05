require 'spec_helper'
require 'ronin/formatting/text'

describe String do
  before(:all) do
    @string = "hello"
  end

  it "should provide String#format_chars" do
    String.method_defined?(:format_chars).should == true
  end

  it "should provide String#format_bytes" do
    String.method_defined?(:format_bytes).should == true
  end

  it "should provide String#random_case" do
    String.method_defined?(:random_case).should == true
  end

  describe "format_chars" do
    it "should format each character in the String" do
      @string.format_chars { |c|
        "_#{c}"
      }.should == "_h_e_l_l_o"
    end

    it "should format specific bytes in a String" do
      @string.format_chars(:include => [104, 108]) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      @string.format_chars(:exclude => [101, 111]) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should format ranges of bytes in a String" do
      @string.format_chars(:include => (104..108)) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format ranges of bytes in a String" do
      @string.format_chars(:exclude => (104..108)) { |c|
        c.upcase
      }.should == 'hEllO'
    end

    it "should format specific chars in a String" do
      @string.format_chars(:include => ['h', 'l']) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      @string.format_chars(:exclude => ['e', 'o']) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should format ranges of chars in a String" do
      @string.format_chars(:include => ('h'..'l')) { |c|
        c.upcase
      }.should == 'HeLLo'
    end

    it "should not format ranges of chars in a String" do
      @string.format_chars(:exclude => ('h'..'l')) { |c|
        c.upcase
      }.should == 'hEllO'
    end
  end

  describe "format_bytes" do
    it "should format each byte in the String" do
      @string.format_bytes { |b|
        sprintf("%%%x",b)
      }.should == "%68%65%6c%6c%6f"
    end

    it "should format specific bytes in a String" do
      @string.format_bytes(:include => [104, 108]) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      @string.format_bytes(:exclude => [101, 111]) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should format ranges of bytes in a String" do
      @string.format_bytes(:include => (104..108)) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format ranges of bytes in a String" do
      @string.format_bytes(:exclude => (104..108)) { |b|
        b - 32
      }.should == 'hEllO'
    end

    it "should format specific chars in a String" do
      @string.format_bytes(:include => ['h', 'l']) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format specific bytes in a String" do
      @string.format_bytes(:exclude => ['e', 'o']) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should format ranges of chars in a String" do
      @string.format_bytes(:include => ('h'..'l')) { |b|
        b - 32
      }.should == 'HeLLo'
    end

    it "should not format ranges of chars in a String" do
      @string.format_bytes(:exclude => ('h'..'l')) { |b|
        b - 32
      }.should == 'hEllO'
    end
  end

  describe "random_case" do
    it "should capitalize each character when :probability is 1.0" do
      new_string = @string.random_case(:probability => 1.0)

      @string.upcase.should == new_string
    end

    it "should not capitalize any characters when :probability is 0.0" do
      new_string = @string.random_case(:probability => 0.0)

      @string.should == new_string
    end
  end
end
