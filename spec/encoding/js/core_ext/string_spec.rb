require 'spec_helper'
require 'ronin/support/encoding/js/core_ext/string'

describe String do
  subject { "one & two" }

  it { expect(subject).to respond_to(:js_escape)   }
  it { expect(subject).to respond_to(:js_unescape) }
  it { expect(subject).to respond_to(:js_encode)   }

  describe "#js_escape" do
    let(:special_chars) { "\t\n\r" }
    let(:escaped_special_chars) { '\t\n\r' }

    let(:normal_chars) { "abc" }

    it "must escape special JavaScript characters" do
      expect(special_chars.js_escape).to eq(escaped_special_chars)
    end

    it "must ignore normal characters" do
      expect(normal_chars.js_escape).to eq(normal_chars)
    end
  end

  describe "#js_unescape" do
    let(:js_unicode) do
      "%u006F%u006E%u0065%u0020%u0026%u0020%u0074%u0077%u006F"
    end
    let(:js_hex) { "%6F%6E%65%20%26%20%74%77%6F" }
    let(:js_mixed) { "%u6F%u6E%u65 %26 two" }

    it "must unescape JavaScript unicode characters" do
      expect(js_unicode.js_unescape).to eq(subject)
    end

    it "must unescape JavaScript hex characters" do
      expect(js_hex.js_unescape).to eq(subject)
    end

    it "must unescape backslash-escaped characters" do
      expect("\\b\\t\\n\\f\\r\\\"\\\'\\\\".js_unescape).to eq("\b\t\n\f\r\"'\\")
    end

    it "must ignore non-escaped characters" do
      expect(js_mixed.js_unescape).to eq(subject)
    end
  end

  describe "#js_encode" do
    let(:js_formatted) { '\x6F\x6E\x65\x20\x26\x20\x74\x77\x6F' }

    it "must JavaScript escape all characters" do
      expect(subject.js_encode).to eq(js_formatted)
    end
  end

  describe "#js_encode" do
    subject { "ABC" }

    let(:js_encoded) { "\\x41\\x42\\x43" }

    it "must JavaScript encode each character in the string" do
      expect(subject.js_encode).to eq(js_encoded)
    end
  end

  describe "#js_string" do
    subject { "hello\nworld" }

    let(:js_string) { "\"hello\\nworld\"" }

    it "must return a double quoted JavaScript string" do
      expect(subject.js_string).to eq(js_string)
    end
  end

  describe "#js_unquote" do
    context "when the String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the JavaScript string" do
        expect(subject.js_unquote).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      subject { "'hello\\'world'" }

      let(:unescaped) { "hello'world" }

      it "must remove the single-quotes and unescape the JavaScript string" do
        expect(subject.js_unquote).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.js_unquote).to be(subject)
      end
    end
  end
end
