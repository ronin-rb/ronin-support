require 'spec_helper'
require 'ronin/support/encoding/c/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it { expect(subject).to respond_to(:c_escape) }
  it { expect(subject).to respond_to(:c_encode) }

  describe "#c_escape" do
    described_class::C_ESCAPE_BYTES.each do |byte,escaped_char|
      context "when called on #{byte}" do
        subject { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.c_escape).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      subject { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.c_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.c_escape).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      subject { 0xFFFF }

      it "must return the lowercase '\\uXXXX' hex escaped String" do
        expect(subject.c_escape).to eq('\uffff')
      end
    end

    context "when called on an Integer greater than 0xffff" do
      subject { 0x10000}

      it "must return the lowercase '\\uXXXXXXXX' hex escaped String" do
        expect(subject.c_escape).to eq('\u00010000')
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.c_escape
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end

  describe "#c_encode" do
    let(:c_formatted) { '\x26' }

    it "must return the '\\xXX' form of the byte" do
      expect(subject.c_encode).to eq(c_formatted)
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.c_encode).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      subject { 0xFFFF }

      it "must return the lowercase '\\uXXXX' hex escaped String" do
        expect(subject.c_encode).to eq('\uffff')
      end
    end

    context "when called on an Integer greater than 0xffff" do
      subject { 0x10000}

      it "must return the lowercase '\\uXXXXXXXX' hex escaped String" do
        expect(subject.c_encode).to eq('\u00010000')
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.c_encode
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end
end
