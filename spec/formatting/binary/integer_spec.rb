require 'spec_helper'
require 'ronin/formatting/extensions/binary/integer'

require 'ostruct'

describe Integer do
  subject { 0x41 }

  it "should provide Integer#bytes" do
    expect(subject).to respond_to(:bytes)
  end

  it "should provide Integer#pack" do
    expect(subject).to respond_to(:pack)
  end

  it "should provide Integer#hex_encode" do
    should respond_to(:hex_encode)
  end

  it "should provide Integer#hex_escape" do
    expect(subject).to respond_to(:hex_escape)
  end

  it "should alias char to the #chr method" do
    expect(subject.char).to eq(subject.chr)
  end

  describe "#hex_encode" do
    subject { 42 }

    it "should hex encode an Integer" do
      expect(subject.hex_encode).to eq("2a")
    end
  end

  describe "#hex_escape" do
    subject { 42 }

    it "should hex escape an Integer" do
      expect(subject.hex_escape).to eq("\\x2a")
    end
  end

  describe "#bytes" do
    let(:little_endian_char)  { [0x37] }
    let(:little_endian_short) { [0x37, 0x13] }
    let(:little_endian_long)  { [0x37, 0x13, 0x0, 0x0] }
    let(:little_endian_quad)  { [0x37, 0x13, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0] }

    let(:big_endian_char)  { [0x37] }
    let(:big_endian_short) { [0x13, 0x37] }
    let(:big_endian_long)  { [0, 0, 0x13, 0x37] }
    let(:big_endian_quad)  { [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x13, 0x37] }

    subject { 0x1337 }

    it "should return the bytes in little endian ordering by default" do
      expect(subject.bytes(4)).to eq(little_endian_long)
    end

    it "should return the bytes for a char in little endian ordering" do
      expect(subject.bytes(1, :little)).to eq(little_endian_char)
    end

    it "should return the bytes for a short in little endian ordering" do
      expect(subject.bytes(2, :little)).to eq(little_endian_short)
    end

    it "should return the bytes for a long in little endian ordering" do
      expect(subject.bytes(4, :little)).to eq(little_endian_long)
    end

    it "should return the bytes for a quad in little endian ordering" do
      expect(subject.bytes(8, :little)).to eq(little_endian_quad)
    end

    it "should return the bytes for a char in big endian ordering" do
      expect(subject.bytes(1, :big)).to eq(big_endian_char)
    end

    it "should return the bytes for a short in big endian ordering" do
      expect(subject.bytes(2, :big)).to eq(big_endian_short)
    end

    it "should return the bytes for a long in big endian ordering" do
      expect(subject.bytes(4, :big)).to eq(big_endian_long)
    end

    it "should return the bytes for a quad in big endian ordering" do
      expect(subject.bytes(8, :big)).to eq(big_endian_quad)
    end
  end

  describe "#pack" do
    subject { 0x1337 }

    let(:packed) { "7\023\000\000" }

    context "when only given a String" do
      it "should pack Integers using Array#pack codes" do
        expect(subject.pack('V')).to eq(packed)
      end
    end

    context "when given a Binary::Template Integer type" do
      it "should pack Integers using Binary::Template" do
        expect(subject.pack(:uint32_le)).to eq(packed)
      end
    end

    context "when given non-Integer Binary::Template types" do
      it "should raise an ArgumentError" do
        expect {
          subject.pack(:float)
        }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 or 2 arguments" do
      it "should raise an ArgumentError" do
        expect {
          subject.pack(1,2,3)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
