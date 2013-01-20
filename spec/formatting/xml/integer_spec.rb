require 'spec_helper'
require 'ronin/formatting/extensions/xml/integer'

describe Integer do
  subject { 0x26 }

  it "should provide String#xml_escape" do
    should respond_to(:xml_escape)
  end

  it "should provide String#format_xml" do
    should respond_to(:format_xml)
  end

  describe "#xml_escape" do
    let(:xml_escaped) { "&amp;" }

    it "should XML escape itself" do
      subject.xml_escape.should == xml_escaped
    end
  end

  describe "#format_xml" do
    let(:formatted_xml) { "&#38;" }

    it "should XML format all chars" do
      subject.format_xml.should == formatted_xml
    end
  end
end
