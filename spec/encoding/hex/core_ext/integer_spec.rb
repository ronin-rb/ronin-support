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
    context "when given the byte 0x22" do
      subject { 0x22 }

      it "must return '\\\"'" do
        expect(subject.hex_escape).to eq("\\\"")
      end
    end

    context "when given the byte 0x5d" do
      subject { 0x5d }

      it "must return '\\\\'" do
        expect(subject.hex_escape).to eq("\\\\")
      end
    end

    [*(0x20..0x21), *(0x23..0x5c), *(0x5e..0x7e)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:char) { byte.chr }

        it "must return the ASCII character for the byte" do
          expect(subject.hex_escape).to eq(char)
        end
      end
    end

    [*(0x00..0x1f), *(0x7f..0xff)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:escaped_char) { "\\x%.2x" % byte }

        it "must return the lowercase '\\xXX' hex escaped String" do
          expect(subject.hex_escape).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer is greater than 0xff" do
      subject { 0x100 }

      let(:escaped_char) { "\\x100" }

      it "must return the lowercase '\\xXXXX' hex escaped String" do
        expect(subject.hex_escape).to eq(escaped_char)
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.hex_escape
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
