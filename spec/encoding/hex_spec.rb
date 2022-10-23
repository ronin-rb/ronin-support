require 'spec_helper'
require 'ronin/support/encoding/hex'

describe Ronin::Support::Encoding::Hex do
  describe ".encode_byte" do
    let(:byte) { 41 }

    it "must hex encode the byte" do
      expect(subject.encode_byte(byte)).to eq("29")
    end
  end

  describe ".escape_byte" do
    context "when called on the byte between 0x20 and 0x7e" do
      let(:byte) { 41 }

      it "must return the ASCII character for the byte" do
        expect(subject.escape_byte(byte)).to eq(byte.chr)
      end
    end

    context "when called on the byte that does not map to an ASCII char" do
      let(:byte) { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.escape_byte(byte)).to eq("\\xff")
      end
    end

    context "when called on the byte is greater than 0xff" do
      let(:byte) { 0xFFFF }

      it "must return the lowercase '\\xXXXX' hex escaped String" do
        expect(subject.escape_byte(byte)).to eq("\\xffff")
      end
    end

    context "when called on a negative Integer" do
      let(:byte) { -1 }

      it do
        expect {
          subject.escape_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end
  end

  describe ".encode" do
    let(:data) { "hello\x4e" }

    it "must hex encode a String" do
      expect(subject.encode(data)).to eq("68656c6c6f4e")
    end

    context "when the String contains invalid byte sequences" do
      let(:data) { "hello\xfe\xff" }

      it "must hex encode each byte in the String" do
        expect(subject.encode(data)).to eq("68656c6c6ffeff")
      end
    end
  end

  describe ".decode" do
    let(:data) { "68656c6c6f4e" }

    it "must hex decode a String" do
      expect(subject.decode(data)).to eq("hello\x4e")
    end
  end

  describe ".escape" do
    let(:data) { "hello\x00" }

    it "must hex escape a String" do
      expect(subject.escape(data)).to eq("hello\\x00")
    end

    context "when the String contains invalid byte sequences" do
      let(:data) { "hello\xfe\xff" }

      it "must hex escape each byte in the String" do
        expect(subject.escape(data)).to eq("hello\\xfe\\xff")
      end
    end
  end

  describe ".unescape" do
    context "when the given String contains escaped hexadecimal characters" do
      let(:data) do
        "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64"
      end
      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the given String contains escaped multi-byte characters" do
      let(:data)      { "\\x00D8\\x2070E" }
      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the given String contains escaped special characters" do
      let(:data)      { "hello\\0world\\n" }
      let(:unescaped) { "hello\0world\n"   }

      it "must unescape C special characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the given String does not contain escaped characters" do
      let(:data) { "hello world" }

      it "must return the given String" do
        expect(subject.unescape(data)).to eq(data)
      end
    end
  end

  describe ".quote" do
    let(:data) { "hello\nworld" }

    it "must return a double-quoted hex escaped String" do
      expect(subject.quote(data)).to eq("\"hello\\x0aworld\"")
    end
  end

  describe ".unquote" do
    context "when the String is double-quoted" do
      let(:data)      { "\"hello\\nworld\"" }
      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the JavaScript string" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      let(:data)      { "'hello\\'world'" }
      let(:unescaped) { "hello'world" }

      it "must remove the single-quotes and unescape the JavaScript string" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      let(:data) { "hello world" }

      it "must return the same String" do
        expect(subject.unquote(data)).to be(data)
      end
    end
  end
end
