require 'spec_helper'
require 'ronin/support/encoding/c'

describe Ronin::Support::Encoding::C do
  let(:data) { "hello world" }

  describe ".escape_byte" do
    described_class::ESCAPE_BYTES.each do |byte,escaped_char|
      context "when called on #{byte}" do
        let(:byte) { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.escape_byte(byte)).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      let(:byte) { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.escape_byte(byte)).to eq(byte.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      let(:byte) { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.escape_byte(byte)).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      let(:byte) { 0xFFFF }

      it "must return the lowercase '\\uXXXX' hex escaped String" do
        expect(subject.escape_byte(byte)).to eq('\uffff')
      end
    end

    context "when called on an Integer greater than 0xffff" do
      let(:byte) { 0x10000 }

      it "must return the lowercase '\\UXXXXXXXX' hex escaped String" do
        expect(subject.escape_byte(byte)).to eq('\U00010000')
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

  describe ".encode_byte" do
    let(:byte)         { 0x26   }
    let(:encoded_byte) { '\x26' }

    it "must return the '\\xXX' form of the byte" do
      expect(subject.encode_byte(byte)).to eq(encoded_byte)
    end

    context "when called on an Integer that does not map to an ASCII char" do
      let(:byte) { 0xFF }

      it "must return the lowercase '\\xXX' hex escaped String" do
        expect(subject.encode_byte(byte)).to eq('\xff')
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      let(:byte) { 0xFFFF }

      it "must return the lowercase '\\uXXXX' hex escaped String" do
        expect(subject.encode_byte(byte)).to eq('\uffff')
      end
    end

    context "when called on an Integer greater than 0xffff" do
      let(:byte) { 0x10000 }

      it "must return the lowercase '\\UXXXXXXXX' hex escaped String" do
        expect(subject.encode_byte(byte)).to eq('\U00010000')
      end
    end

    context "when called on a negative Integer" do
      let(:byte) { -1 }

      it do
        expect {
          subject.encode_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end
  end

  describe ".escape" do
    context "when the given String does not contain special characters" do
      let(:data) { "abc" }

      it "must return the given String" do
        expect(subject.escape(data)).to eq(data)
      end
    end

    context "when the given String contains back-slashed escaped characters" do
      let(:data)           { "\0\a\b\e\t\n\v\f\r\\\"" }
      let(:escaped_string) { "\\0\\a\\b\\e\\t\\n\\v\\f\\r\\\\\\\"" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.escape(data)).to eq(escaped_string)
      end
    end

    context "when the given String contains non-printable characters" do
      let(:data)           { "hello\x01world"  }
      let(:escaped_string) { "hello\\x01world" }

      it "must escape non-printable characters with an extra back-slash" do
        expect(subject.escape(data)).to eq(escaped_string)
      end
    end

    context "when the given String contains unicode characters" do
      let(:data)           { "hello\u1001world" }
      let(:escaped_string) { "hello\\u1001world" }

      it "must escape the unicode characters with a \\u" do
        expect(subject.escape(data)).to eq(escaped_string)
      end
    end

    context "when the String contains invalid byte sequences" do
      let(:data)           { "hello\xfe\xff"   }
      let(:escaped_string) { "hello\\xfe\\xff" }

      it "must C escape each byte in the String" do
        expect(subject.escape(data)).to eq(escaped_string)
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

    context "when the given String contains escaped unicode characters" do
      let(:data)      { "\\u00D8\\U0002070E" }
      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the given String contains single character escaped octal characters" do
      let(:data)      { "\\0\\1\\2\\3\\4\\5\\6\\7" }
      let(:unescaped) { "\0\1\2\3\4\5\6\7" }

      it "must unescape the octal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the given String contains two character escaped octal characters" do
      let(:data)      { "\\10\\11\\12\\13\\14\\15\\16\\17\\20" }
      let(:unescaped) { "\10\11\12\13\14\15\16\17\20" }

      it "must unescape the octal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the given String contains three character escaped octal characters" do
      let(:data) do
        "\\150\\145\\154\\154\\157\\040\\167\\157\\162\\154\\144"
      end
      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
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

    it "must set the String encoding to Encoding::UTF_8" do
      expect(subject.unescape(data).encoding).to be(Encoding::UTF_8)
    end
  end

  describe ".encode" do
    let(:data)    { "ABC" }
    let(:encoded) { '\x41\x42\x43' }

    it "must C encode each character in the string" do
      expect(subject.encode(data)).to eq(encoded)
    end

    context "when the String contains invalid byte sequences" do
      let(:data)    { "ABC\xfe\xff" }
      let(:encoded) { '\x41\x42\x43\xfe\xff' }

      it "must C escape each byte in the String" do
        expect(subject.encode(data)).to eq(encoded)
      end
    end
  end

  describe ".quote" do
    let(:data)   { "hello\nworld" }
    let(:quoted) { '"hello\nworld"' }

    it "must return a double quoted C string" do
      expect(subject.quote(data)).to eq(quoted)
    end
  end

  describe ".unquote" do
    context "when the given String is double-quoted" do
      let(:data)      { "\"hello\\nworld\"" }
      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the C string" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the given String is a single-quoted character" do
      let(:data)      { "'\\n'" }
      let(:unescaped) { "\n" }

      it "must remove single-quotes and unescape the C character" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the given String is not quoted" do
      let(:data) { "hello world" }

      it "must return the same String" do
        expect(subject.unquote(data)).to be(data)
      end
    end
  end
end
