require 'spec_helper'
require 'ronin/support/format/core_ext/js/string'

describe String do
  subject { "one & two" }

  it "must provide String#js_escape" do
    should respond_to(:js_escape)
  end

  it "must provide String#js_unescape" do
    should respond_to(:js_unescape)
  end

  it "must provide String#format_js" do
    should respond_to(:format_js)
  end

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
      expect("\\b\\t\\n\\f\\r\\\"\\\\".js_unescape).to eq("\b\t\n\f\r\"\\")
    end

    it "must ignore non-escaped characters" do
      expect(js_mixed.js_unescape).to eq(subject)
    end
  end

  describe "#format_js" do
    let(:js_formatted) { '\x6F\x6E\x65\x20\x26\x20\x74\x77\x6F' }

    it "must JavaScript escape all characters" do
      expect(subject.format_js).to eq(js_formatted)
    end
  end
end
