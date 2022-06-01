require 'spec_helper'
require 'ronin/support/format/shell/core_ext/integer'

describe Integer do
  subject { 0x41 }

  it { expect(subject).to respond_to(:shell_encode) }
  it { expect(subject).to respond_to(:sh_encode) }
  it { expect(subject).to respond_to(:bash_encode) }

  it { expect(subject).to respond_to(:shell_escape) }
  it { expect(subject).to respond_to(:sh_escape) }
  it { expect(subject).to respond_to(:bash_escape) }

  describe "#shell_escape" do
    described_class::SHELL_ESCAPE_BYTES.each do |byte,escaped_char|
      context "when called on #{byte}" do
        subject { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.shell_escape).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      subject { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.shell_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase \\xXX hex escaped String" do
        expect(subject.shell_escape).to eq("\\xff")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      subject { 0xFFFF }

      it "must return the lowercase \\uXXXX hex escaped String" do
        expect(subject.shell_escape).to eq("\\uffff")
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

  describe "#shell_encode" do
    context "when called on an Integer between 0x00 and 0xff" do
      subject { 0x41 }

      it "must encode the Integer as a shell hex character" do
        expect(subject.shell_encode).to eq("\\x41")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      subject { 0xFFFF }

      it "must return the lowercase \\uXXXX hex escaped String" do
        expect(subject.shell_encode).to eq("\\uffff")
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.shell_encode
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end
end
