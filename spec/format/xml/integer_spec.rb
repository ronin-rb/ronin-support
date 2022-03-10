require 'spec_helper'
require 'ronin/support/format/core_ext/xml/integer'

describe Integer do
  subject { 0x26 }

  it "must provide String#xml_escape" do
    should respond_to(:xml_escape)
  end

  it "must provide String#format_xml" do
    should respond_to(:format_xml)
  end

  describe "#xml_escape" do
    let(:xml_escaped) { "&amp;" }

    it "must XML escape itself" do
      expect(subject.xml_escape).to eq(xml_escaped)
    end
  end

  describe "#format_xml" do
    let(:formatted_xml) { "&#38;" }

    it "must XML format all chars" do
      expect(subject.format_xml).to eq(formatted_xml)
    end
  end
end
