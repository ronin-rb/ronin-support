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

  it "must provide String#xml_encode" do
    should respond_to(:xml_encode)
  end

  describe "#xml_escape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must XML escape itself" do
      expect(subject.xml_escape).to eq(xml_escaped)
    end

    context "when the String contains invalid byte sequences" do
      subject { "one & two\xfe\xff" }

      let(:xml_escaped) { "one &amp; two\xfe\xff" }

      it "must XML escape each byte in the String" do
        expect(subject.xml_escape).to eq(xml_escaped)
      end
    end
  end

  describe "#xml_unescape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must XML unescape itself" do
      expect(xml_escaped.xml_unescape).to eq(subject)
    end
  end

  describe "#xml_encode" do
    let(:encoded_xml) do
      "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
    end

    it "must XML format all chars" do
      expect(subject.xml_encode).to eq(encoded_xml)
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:encoded_xml) { "&#104;&#101;&#108;&#108;&#111;&#254;&#255;" }

      it "must XML encode each byte in the String" do
        expect(subject.xml_encode).to eq(encoded_xml)
      end
    end
  end
end
