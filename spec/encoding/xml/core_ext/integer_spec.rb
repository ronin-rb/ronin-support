require 'spec_helper'
require 'ronin/support/encoding/xml/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it "must provide Integer#xml_escape" do
    should respond_to(:xml_escape)
  end

  it "must provide Integer#xml_encode" do
    should respond_to(:xml_encode)
  end

  describe "#xml_escape" do
    let(:xml_escaped) { "&amp;" }

    it "must XML escape itself" do
      expect(subject.xml_escape).to eq(xml_escaped)
    end
  end

  describe "#xml_encode" do
    let(:formatted_xml) { "&#38;" }

    it "must XML format all chars" do
      expect(subject.xml_encode).to eq(formatted_xml)
    end
  end
end
