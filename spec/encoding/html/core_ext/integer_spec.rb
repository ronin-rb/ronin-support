require 'spec_helper'
require 'ronin/support/encoding/html/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it "must provide String#html_escape" do
    expect(subject).to respond_to(:html_escape)
  end

  it "must provide String#format_html" do
    expect(subject).to respond_to(:format_html)
  end

  describe "#html_escape" do
    it "must behave like #xml_escape" do
      expect(subject.html_escape).to eq(subject.xml_escape)
    end
  end

  describe "#format_html" do
    it "must have like #format_xml" do
      expect(subject.format_html).to eq(subject.format_xml)
    end
  end
end
