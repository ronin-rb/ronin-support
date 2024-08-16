require 'spec_helper'
require 'ronin/support/encoding/php/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it { expect(subject).to respond_to(:php_escape) }
  it { expect(subject).to respond_to(:php_encode) }

  describe "#php_escape" do
    Ronin::Support::Encoding::PHP::ESCAPE_BYTES.each do |byte,escaped_char|
      context "when called on #{byte}" do
        subject { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.php_escape).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      subject { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.php_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.php_escape).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0x10ffff" do
      subject { 0xFFFF }

      it "must return the lowercase '\\u{XXXX}' hex escaped String" do
        expect(subject.php_escape).to eq('\u{ffff}')
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.php_escape
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end

  describe "#php_encode" do
    let(:php_formatted) { '\x26' }

    it "must return the '\\xXX' form of the byte" do
      expect(subject.php_encode).to eq(php_formatted)
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.php_encode).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0x10ffff" do
      subject { 0xFFFF }

      it "must return the lowercase '\\u{XXXX}' hex escaped String" do
        expect(subject.php_encode).to eq('\u{ffff}')
      end
    end

    context "when called on a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.php_encode
        }.to raise_error(RangeError,"#{subject} out of char range")
      end
    end
  end
end
