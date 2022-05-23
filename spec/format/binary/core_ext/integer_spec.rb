require 'spec_helper'
require 'ronin/support/format/binary/core_ext/integer'

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

  it "must alias char to the #chr method" do
    expect(subject.char).to eq(subject.chr)
  end

  describe "#hex_encode" do
    subject { 42 }

    it "must hex encode an Integer" do
      expect(subject.hex_encode).to eq("2a")
    end
  end

  describe "#hex_escape" do
    subject { 42 }

    it "must hex escape an Integer" do
      expect(subject.hex_escape).to eq("\\x2a")
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
