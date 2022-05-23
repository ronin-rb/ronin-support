require 'spec_helper'
require 'ronin/support/format/binary/core_ext/integer'

require 'ostruct'

describe Integer do
  subject { 0x41 }

  it "must provide Integer#pack" do
    expect(subject).to respond_to(:pack)
  end

  it "must provide Integer#hex_encode" do
    should respond_to(:hex_encode)
  end

  it "must provide Integer#hex_escape" do
    expect(subject).to respond_to(:hex_escape)
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

  describe "#pack" do
    subject { 0x1337 }

    let(:packed) { "7\023\000\000" }

    context "when only given a String" do
      it "must pack Integers using Array#pack codes" do
        expect(subject.pack('V')).to eq(packed)
      end
    end

    context "when given a Ronin::Support::Binary::CTypes type name" do
      it "must pack Integers using the Ronin::Support::Binary::CTypes type" do
        expect(subject.pack(:uint32_le)).to eq(packed)
      end
    end

    context "when given more than 1 or 2 arguments" do
      it "must raise an ArgumentError" do
        expect {
          subject.pack(1,2,3)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
