require 'spec_helper'
require 'ronin/formatting/text'

describe Array do
  subject { [] }

  let(:byte_array) { [0x41, 0x41, 0x20] }
  let(:char_array) { ['A', 'A', ' '] }
  let(:mixed_array) { ['AA', 0x20] }
  let(:string) { 'AA ' }

  it "should provide Array#bytes" do
    should respond_to(:bytes)
  end

  it "should provide Array#chars" do
    should respond_to(:chars)
  end

  it "should provide Array#char_string" do
    should respond_to(:char_string)
  end

  it "should provide Array#hex_chars" do
    should respond_to(:hex_chars)
  end

  it "should provide Array#hex_integers" do
    should respond_to(:hex_integers)
  end

  describe "#bytes" do
    it "should convert an Array of bytes to an Array of bytes" do
      byte_array.bytes.should == byte_array
    end

    it "should convert an Array of chars to an Array of bytes" do
      char_array.bytes.should == byte_array
    end

    it "should safely handle mixed byte/char/string Arrays" do
      mixed_array.bytes.should == byte_array
    end
  end

  describe "#chars" do
    it "should convert an Array of bytes to an Array of chars" do
      byte_array.chars.should == char_array
    end

    it "should safely convert an Array of chars to an Array of chars" do
      char_array.chars.should == char_array
    end

    it "should safely handle mixed byte/char/string Arrays" do
      mixed_array.chars.should == char_array
    end
  end

  describe "#char_string" do
    it "should convert an Array of bytes to a String" do
      byte_array.char_string.should == string
    end

    it "should convert an Array of chars to a String" do
      char_array.char_string.should == string
    end

    it "should safely handle mixed byte/char/string Arrays" do
      mixed_array.char_string.should == string
    end
  end

  describe "#hex_chars" do
    let(:hex_chars) { ['\x41', '\x41', '\x20'] }

    it "should convert an Array of bytes into hexadecimal chars" do
      byte_array.hex_chars.should == hex_chars
    end

    it "should convert an Array of chars into hexadecimal chars" do
      char_array.hex_chars.should == hex_chars
    end

    it "should safely handle mixed byte/char/string Arrays" do
      mixed_array.hex_chars.should == hex_chars
    end
  end

  describe "#hex_integers" do
    let(:hex_integers) { ['0x41', '0x41', '0x20'] }

    it "should convert an Array of bytes into hexadecimal integers" do
      byte_array.hex_integers.should == hex_integers
    end

    it "should convert an Array of chars into hexadecimal integers" do
      char_array.hex_integers.should == hex_integers
    end

    it "should safely handle mixed byte/char/string Arrays" do
      mixed_array.hex_integers.should == hex_integers
    end
  end
end
