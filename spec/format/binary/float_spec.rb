# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/format/core_ext/binary/float'

describe Float do
  subject { 0.42 }

  it "must provide Float#pack" do
    expect(subject).to respond_to(:pack)
  end

  describe "#pack" do
    let(:packed) { "\xE1z\x14\xAEG\xE1\xDA?" }

    context "when only given a String" do
      it "must unpack Strings using String#unpack template Strings" do
        expect(subject.pack('E')).to eq(packed)
      end
    end

    context "when given a Binary::Template Float type" do
      it "must unpack Strings using Binary::Template" do
        expect(subject.pack(:double_le)).to eq(packed)
      end
    end

    context "when given non-Float Binary::Template types" do
      it "must raise an ArgumentError" do
        expect {
          subject.pack(:int)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
