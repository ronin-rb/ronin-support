require 'spec_helper'
require 'ronin/support/encoding/python/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it { expect(subject).to respond_to(:python_escape) }
  it { expect(subject).to respond_to(:python_encode) }

  describe "#python_escape" do
    {
      0x00 => '\x00',
      0x07 => '\a',
      0x08 => '\b',
      0x09 => '\t',
      0x0a => '\n',
      0x0b => '\v',
      0x0c => '\f',
      0x0d => '\r',
      0x22 => '\"',
      0x5c => '\\\\'
    }.each do |byte,escaped_char|
      context "when called on #{byte}" do
        subject { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.python_escape).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      subject { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.python_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.python_escape).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      subject { 0xFFFF }

      it "must return the lowercase '\\uXXXX' hex escaped String" do
        expect(subject.python_escape).to eq('\uffff')
      end
    end

    context "when called on an Integer between 0x10000 and 0x10ffff" do
      subject { 0x10000 }

      it "must return the lowercase '\\UXXXXXXXX' hex escaped String" do
        expect(subject.python_escape).to eq('\U00010000')
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.python_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end

  describe "#python_encode" do
    subject { 0x26 }

    let(:encoded_byte) { '\x26' }

    it "must return the '\\xXX' form of the byte" do
      expect(subject.python_encode).to eq(encoded_byte)
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.python_encode).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0x10ffff" do
      subject { 0xFFFF }

      it "must return the lowercase '\\uXXXX' hex escaped String" do
        expect(subject.python_encode).to eq('\uffff')
      end
    end

    context "when called on an Integer between 0x10000 and 0x10ffff" do
      subject { 0x10000 }

      it "must return the lowercase '\\UXXXXXXXX' hex escaped String" do
        expect(subject.python_escape).to eq('\U00010000')
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.python_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end
end
