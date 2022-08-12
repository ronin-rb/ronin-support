require 'spec_helper'
require 'ronin/support/encoding/text/core_ext/array'

describe Array do
  subject { [] }

  let(:byte_array) { [0x41, 0x41, 0x20] }
  let(:char_array) { ['A', 'A', ' '] }
  let(:mixed_array) { ['AA', 0x20] }
  let(:string) { 'AA ' }

  it "must provide Array#bytes" do
    expect(subject).to respond_to(:bytes)
  end

  it "must provide Array#chars" do
    expect(subject).to respond_to(:chars)
  end

  it "must provide Array#char_string" do
    expect(subject).to respond_to(:char_string)
  end

  it "must provide Array#hex_chars" do
    expect(subject).to respond_to(:hex_chars)
  end

  it "must provide Array#hex_integers" do
    expect(subject).to respond_to(:hex_integers)
  end

  describe "#bytes" do
    it "must convert an Array of bytes to an Array of bytes" do
      expect(byte_array.bytes).to eq(byte_array)
    end

    it "must convert an Array of chars to an Array of bytes" do
      expect(char_array.bytes).to eq(byte_array)
    end

    it "must safely handle mixed byte/char/string Arrays" do
      expect(mixed_array.bytes).to eq(byte_array)
    end
  end

  describe "#chars" do
    it "must convert an Array of bytes to an Array of chars" do
      expect(byte_array.chars).to eq(char_array)
    end

    it "must safely convert an Array of chars to an Array of chars" do
      expect(char_array.chars).to eq(char_array)
    end

    it "must safely handle mixed byte/char/string Arrays" do
      expect(mixed_array.chars).to eq(char_array)
    end
  end

  describe "#char_string" do
    it "must convert an Array of bytes to a String" do
      expect(byte_array.char_string).to eq(string)
    end

    it "must convert an Array of chars to a String" do
      expect(char_array.char_string).to eq(string)
    end

    it "must safely handle mixed byte/char/string Arrays" do
      expect(mixed_array.char_string).to eq(string)
    end
  end

  describe "#hex_chars" do
    let(:hex_chars) { ['\x41', '\x41', '\x20'] }

    it "must convert an Array of bytes into hexadecimal chars" do
      expect(byte_array.hex_chars).to eq(hex_chars)
    end

    it "must convert an Array of chars into hexadecimal chars" do
      expect(char_array.hex_chars).to eq(hex_chars)
    end

    it "must safely handle mixed byte/char/string Arrays" do
      expect(mixed_array.hex_chars).to eq(hex_chars)
    end
  end

  describe "#hex_integers" do
    let(:hex_integers) { ['0x41', '0x41', '0x20'] }

    it "must convert an Array of bytes into hexadecimal integers" do
      expect(byte_array.hex_integers).to eq(hex_integers)
    end

    it "must convert an Array of chars into hexadecimal integers" do
      expect(char_array.hex_integers).to eq(hex_integers)
    end

    it "must safely handle mixed byte/char/string Arrays" do
      expect(mixed_array.hex_integers).to eq(hex_integers)
    end
  end
end
