require 'spec_helper'
require 'ronin/support/encoding/xml/core_ext/string'

describe String do
  subject { "one & two" }

  it "must provide String#xml_escape" do
    should respond_to(:xml_escape)
  end

  it "must provide String#xml_unescape" do
    should respond_to(:xml_unescape)
  end

  it "must provide String#format_xml" do
    should respond_to(:format_xml)
  end

  describe "#xml_escape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must HTML escape itself" do
      expect(subject.xml_escape).to eq(xml_escaped)
    end
  end

  describe "#xml_unescape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must HTML unescape itself" do
      expect(xml_escaped.xml_unescape).to eq(subject)
    end
  end

  describe "#format_xml" do
    let(:formatted_xml) do
      "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
    end

    it "must HTML format all chars" do
      expect(subject.format_xml).to eq(formatted_xml)
    end
  end

  describe "#xml_encode" do
    subject { "ABC" }

    let(:xml_encoded) { "&#65;&#66;&#67;" }

    it "must XML encode each character in the String" do
      expect(subject.xml_encode).to eq(xml_encoded)
    end
  end
end
