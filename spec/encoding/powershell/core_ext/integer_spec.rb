require 'spec_helper'
require 'ronin/support/encoding/powershell/core_ext/integer'

describe Integer do
  subject { 0x41 }

  it { expect(subject).to respond_to(:powershell_encode) }
  it { expect(subject).to respond_to(:psh_encode) }

  it { expect(subject).to respond_to(:powershell_escape) }
  it { expect(subject).to respond_to(:psh_escape) }

  describe "#powershell_escape" do
    Ronin::Support::Encoding::PowerShell::ESCAPE_BYTES.each do |byte,escaped_char|
      context "when called on #{byte}" do
        subject { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.powershell_escape).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      subject { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.powershell_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase $([char]0xXX) hex escaped character" do
        expect(subject.powershell_escape).to eq("$([char]0xff)")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      subject { 0xFFFF }

      it "must return the lowercase $([char]0xXXXX) hex escaped character" do
        expect(subject.powershell_escape).to eq("$([char]0xffff)")
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.powershell_escape
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end

  describe "#powershell_encode" do
    context "when called on an Integer between 0x00 and 0xff" do
      subject { 0x41 }

      it "must return the lowercase $([char]0xXX) hex escaped character" do
        expect(subject.powershell_encode).to eq("$([char]0x41)")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      subject { 0xFFFF }

      it "must return the lowercase $([char]0xXXXX) hex escaped String" do
        expect(subject.powershell_encode).to eq("$([char]0xffff)")
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.powershell_encode
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end
end
