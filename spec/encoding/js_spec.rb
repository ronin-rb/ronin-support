require 'spec_helper'
require 'ronin/support/encoding/js'

describe Ronin::Support::Encoding::JS do
  describe ".escape_byte" do
    context "when given a byte that maps to a special character" do
      let(:special_byte)         { 0x0a }
      let(:escaped_special_byte) { '\n' }

      it "must escape special JavaScript characters" do
        expect(subject.escape_byte(special_byte)).to eq(escaped_special_byte)
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      let(:normal_byte) { 0x41 }
      let(:normal_char) { 'A' }

      it "must ignore normal characters" do
        expect(subject.escape_byte(normal_byte)).to eq(normal_char)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      let(:byte)         { 0xFF   }
      let(:escaped_byte) { '\xFF' }

      it "must escape special JavaScript characters" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      let(:byte)         { 0xFFFF   }
      let(:escaped_byte) { '\uFFFF' }

      it "must return the lowercase '\\uXXXX' escaped JavaScript character" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end
  end

  describe ".encode_byte" do
    context "when given a ASCII byte" do
      let(:byte)       { 0x26   }
      let(:js_escaped) { '\x26' }

      it "must JavaScript format ascii bytes" do
        expect(subject.encode_byte(byte)).to eq(js_escaped)
      end
    end

    context "when given a unicode byte" do
      let(:byte)                 { 0xd556   }
      let(:escaped_unicode_byte) { '\uD556' }

      it "must JavaScript format unicode bytes" do
        expect(byte.js_encode).to eq(escaped_unicode_byte)
      end
    end
  end

  describe ".escape" do
    let(:special_chars) { "\t\n\r" }
    let(:escaped_special_chars) { '\t\n\r' }

    let(:normal_chars) { "abc" }

    it "must escape special JavaScript characters" do
      expect(subject.escape(special_chars)).to eq(escaped_special_chars)
    end

    it "must ignore normal characters" do
      expect(subject.escape(normal_chars)).to eq(normal_chars)
    end

    context "when the String contains invalid byte sequences" do
      let(:invalid_string) { "hello\xfe\xff" }
      let(:escaped_string) { "hello\\xFE\\xFF" }

      it "must JavaScript escape each byte in the String" do
        expect(subject.escape(invalid_string)).to eq(escaped_string)
      end
    end
  end

  let(:data) { "one & two" }

  describe ".unescape" do
    let(:js_unicode) do
      "%u006F%u006E%u0065%u0020%u0026%u0020%u0074%u0077%u006F"
    end
    let(:js_hex) { "%6F%6E%65%20%26%20%74%77%6F" }
    let(:js_mixed) { "%u6F%u6E%u65 %26 two" }

    it "must unescape JavaScript unicode characters" do
      expect(subject.unescape(js_unicode)).to eq(data)
    end

    it "must unescape JavaScript hex characters" do
      expect(subject.unescape(js_hex)).to eq(data)
    end

    it "must unescape backslash-escaped characters" do
      expect(subject.unescape("\\b\\t\\n\\f\\r\\\"\\'\\\\")).to eq("\b\t\n\f\r\"'\\")
    end

    it "must ignore non-escaped characters" do
      expect(subject.unescape(js_mixed)).to eq(data)
    end
  end

  describe ".encode" do
    let(:js_encoded) { '\x6F\x6E\x65\x20\x26\x20\x74\x77\x6F' }

    it "must JavaScript escape all characters" do
      expect(subject.encode(data)).to eq(js_encoded)
    end

    context "when the String contains invalid byte sequences" do
      let(:invalid_string) { "hello\xfe\xff" }
      let(:encoded_string) { '\x68\x65\x6C\x6C\x6F\xFE\xFF' }

      it "must JavaScript encode each byte in the String" do
        expect(subject.encode(invalid_string)).to eq(encoded_string)
      end
    end
  end

  describe ".quote" do
    let(:data)      { "hello\nworld"      }
    let(:js_string) { "\"hello\\nworld\"" }

    it "must return a double quoted JavaScript string" do
      expect(subject.quote(data)).to eq(js_string)
    end
  end

  describe ".unquote" do
    context "when the String is double-quoted" do
      let(:data)      { "\"hello\\nworld\"" }
      let(:unescaped) { "hello\nworld"      }

      it "must remove double-quotes and unescape the JavaScript string" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      let(:data)      { "'hello\\'world'" }
      let(:unescaped) { "hello'world"     }

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
