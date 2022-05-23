require 'spec_helper'
require 'ronin/support/format/html/core_ext/string'

describe String do
  subject { "one & two" }

  it "must provide String#html_escape" do
    expect(subject).to respond_to(:html_escape)
  end

  it "must provide String#html_unescape" do
    expect(subject).to respond_to(:html_unescape)
  end

  it "must provide String#format_html" do
    expect(subject).to respond_to(:format_html)
  end

  it "must provide String#js_escape" do
    expect(subject).to respond_to(:js_escape)
  end

  it "must provide String#js_unescape" do
    expect(subject).to respond_to(:js_unescape)
  end

  it "must provide String#format_js" do
    expect(subject).to respond_to(:format_js)
  end

  describe "#html_escape" do
    subject { "one &amp; two" }

    it "must behave like #xml_escape" do
      expect(subject.html_escape).to eq(subject.xml_escape)
    end
  end

  describe "#html_unescape" do
    subject { "one &amp; two" }

    it "must behave like #xml_unescape" do
      expect(subject.html_unescape).to eq(subject.xml_unescape)
    end
  end

  describe "#format_html" do
    it "must behave like #format_xml" do
      expect(subject.format_html).to eq(subject.format_xml)
    end
  end

  describe "#html_encode" do
    subject { "ABC" }

    it "must encode each character in the String" do
      expect(subject.html_encode).to eq("&#65;&#66;&#67;")
    end
  end
end
