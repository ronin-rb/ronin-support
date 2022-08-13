require 'spec_helper'
require 'ronin/support/encoding/hex/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#hex_encode" do
    expect(subject).to respond_to(:hex_encode)
  end

  it "must provide String#hex_decode" do
    expect(subject).to respond_to(:hex_decode)
  end

  it "must provide String#hex_unescape" do
    expect(subject).to respond_to(:hex_unescape)
  end

  describe "#hex_encode" do
    subject { "hello\x4e" }

    it "must hex encode a String" do
      expect(subject.hex_encode).to eq("68656c6c6f4e")
    end
  end

  describe "#hex_decode" do
    subject { "68656c6c6f4e" }

    it "must hex decode a String" do
      expect(subject.hex_decode).to eq("hello\x4e")
    end
  end

  describe "#hex_escape" do
    subject { "hello\xff".force_encoding(Encoding::ASCII_8BIT) }

    it "must hex escape a String" do
      expect(subject.hex_escape).to eq("hello\\xff")
    end
  end

  describe "#hex_unescape" do
    context "when the given String contains escaped hexadecimal characters" do
      subject do
        "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64"
      end
      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.hex_unescape).to eq(unescaped)
      end
    end

    context "when the given String contains escaped multi-byte characters" do
      subject { "\\x00D8\\x2070E" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.hex_unescape).to eq(unescaped)
      end
    end

    context "when the given String contains escaped special characters" do
      subject { "hello\\0world\\n" }

      let(:unescaped) { "hello\0world\n"   }

      it "must unescape C special characters" do
        expect(subject.hex_unescape).to eq(unescaped)
      end
    end

    context "when the given String does not contain escaped characters" do
      it "must return the given String" do
        expect(subject.hex_unescape).to eq(subject)
      end
    end
  end

  describe "#hex_string" do
    subject { "hello\nworld" }

    it "must return a double-quoted hex escaped String" do
      expect(subject.hex_string).to eq("\"hello\\x0aworld\"")
    end
  end

  describe "#hex_unquote" do
    context "when the String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the JavaScript string" do
        expect(subject.hex_unquote).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      subject { "'hello\\'world'" }

      let(:unescaped) { "hello'world" }

      it "must remove the single-quotes and unescape the JavaScript string" do
        expect(subject.hex_unquote).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.hex_unquote).to be(subject)
      end
    end
  end
end
