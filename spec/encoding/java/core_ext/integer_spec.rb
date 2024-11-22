require 'spec_helper'
require 'ronin/support/encoding/java/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it { expect(subject).to respond_to(:java_escape) }
  it { expect(subject).to respond_to(:java_encode) }

  describe "#java_escape" do
    {
      0x00 => '\0',
      0x08 => '\b',
      0x09 => '\t',
      0x0a => '\n',
      0x0b => '\v',
      0x0c => '\f',
      0x0d => '\r',
      0x22 => '\"',
      0x27 => '\\\'',
      0x5c => '\\\\'
    }.each do |byte,escaped_char|
      context "when called on #{byte}" do
        subject { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.java_escape).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      subject { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.java_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the uppercase '\\u00XX' hex escaped String" do
        expect(subject.java_escape).to eq('\u00FF')
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      subject { 0xFFFF }

      it "must return the uppercase '\\uXXXX' hex escaped String" do
        expect(subject.java_escape).to eq('\uFFFF')
      end
    end

    context "when called on an Integer between 0x10000 and 0x10ffff" do
      subject { 0x10000 }

      it do
        expect {
          subject.java_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.java_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end

  describe "#java_encode" do
    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the uppercase '\\u00XX' hex escaped String" do
        expect(subject.java_encode).to eq('\u00FF')
      end
    end

    context "when called on an Integer between 0x100 and 0x10ffff" do
      subject { 0xFFFF }

      it "must return the uppercase '\\uXXXX' hex escaped String" do
        expect(subject.java_encode).to eq('\uFFFF')
      end
    end

    context "when called on an Integer between 0x10000 and 0x10ffff" do
      subject { 0x10000 }

      it do
        expect {
          subject.java_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.java_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end
end
