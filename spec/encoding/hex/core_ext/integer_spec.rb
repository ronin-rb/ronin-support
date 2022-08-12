require 'spec_helper'
require 'ronin/support/encoding/hex/core_ext/integer'

describe Integer do
  subject { 0x41 }

  it "must provide Integer#hex_encode" do
    should respond_to(:hex_encode)
  end

  it "must provide Integer#hex_escape" do
    expect(subject).to respond_to(:hex_escape)
  end

  it "must provide Integer#hex_int" do
    expect(subject).to respond_to(:hex_int)
  end

  describe "#hex_encode" do
    subject { 41 }

    it "must hex encode an Integer" do
      expect(subject.hex_encode).to eq("29")
    end
  end

  describe "#hex_escape" do
    context "when called on an Integer between 0x20 and 0x7e" do
      subject { 41 }

      it "must return the ASCII character for the byte" do
        expect(subject.hex_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.hex_escape).to eq("\\xff")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      subject { 0xFFFF }

      it "must return the lowercase '\\xXXXX' hex escaped String" do
        expect(subject.hex_escape).to eq("\\xffff")
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.shell_escape
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end

  describe "#hex_int" do
    subject { 4919 }

    it "must encode the Integer as a '0xXX...' String" do
      expect(subject.hex_int).to eq("0x1337")
    end

    context "when the integer is below 255" do
      subject { 0xf }

      it "must zero pad the hex int to ensure there's at least two digits" do
        expect(subject.hex_int).to eq("0x0f")
      end
    end
  end
end
