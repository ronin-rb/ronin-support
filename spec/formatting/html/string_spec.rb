require 'spec_helper'
require 'ronin/formatting/core_ext/html/string'

describe String do
  subject { "one & two" }

  it "should provide String#html_escape" do
    expect(subject).to respond_to(:html_escape)
  end

  it "should provide String#html_unescape" do
    expect(subject).to respond_to(:html_unescape)
  end

  it "should provide String#format_html" do
    expect(subject).to respond_to(:format_html)
  end

  it "should provide String#js_escape" do
    expect(subject).to respond_to(:js_escape)
  end

  it "should provide String#js_unescape" do
    expect(subject).to respond_to(:js_unescape)
  end

  it "should provide String#format_js" do
    expect(subject).to respond_to(:format_js)
  end

  describe "#html_escape" do
    subject { "one &amp; two" }

    it "should behave like #xml_escape" do
      expect(subject.html_escape).to eq(subject.xml_escape)
    end
  end

  describe "#html_unescape" do
    subject { "one &amp; two" }

    it "should behave like #xml_unescape" do
      expect(subject.html_unescape).to eq(subject.xml_unescape)
    end
  end

  describe "#format_html" do
    it "should behave like #format_xml" do
      expect(subject.format_html).to eq(subject.format_xml)
    end
  end

  describe "#js_escape" do
    let(:special_chars) { "\t\n\r" }
    let(:escaped_special_chars) { '\t\n\r' }

    let(:normal_chars) { "abc" }

    it "should escape special JavaScript characters" do
      expect(special_chars.js_escape).to eq(escaped_special_chars)
    end

    it "should ignore normal characters" do
      expect(normal_chars.js_escape).to eq(normal_chars)
    end
  end

  describe "#js_unescape" do
    let(:js_unicode) do
      "%u006F%u006E%u0065%u0020%u0026%u0020%u0074%u0077%u006F"
    end
    let(:js_hex) { "%6F%6E%65%20%26%20%74%77%6F" }
    let(:js_mixed) { "%u6F%u6E%u65 %26 two" }

    it "should unescape JavaScript unicode characters" do
      expect(js_unicode.js_unescape).to eq(subject)
    end

    it "should unescape JavaScript hex characters" do
      expect(js_hex.js_unescape).to eq(subject)
    end

    it "should unescape backslash-escaped characters" do
      expect("\\b\\t\\n\\f\\r\\\"\\\\".js_unescape).to eq("\b\t\n\f\r\"\\")
    end

    it "should ignore non-escaped characters" do
      expect(js_mixed.js_unescape).to eq(subject)
    end
  end

  describe "#format_js" do
    let(:js_formatted) { '\x6F\x6E\x65\x20\x26\x20\x74\x77\x6F' }

    it "should JavaScript escape all characters" do
      expect(subject.format_js).to eq(js_formatted)
    end
  end
end
