require 'spec_helper'
require 'ronin/support/formatting/core_ext/html/integer'

describe Integer do
  subject { 0x26 }

  it "should provide String#html_escape" do
    expect(subject).to respond_to(:html_escape)
  end

  it "should provide String#format_html" do
    expect(subject).to respond_to(:format_html)
  end

  it "should provide String#js_escape" do
    expect(subject).to respond_to(:js_escape)
  end

  it "should provide String#format_js" do
    expect(subject).to respond_to(:format_js)
  end

  describe "#html_escape" do
    it "should behave like #xml_escape" do
      expect(subject.html_escape).to eq(subject.xml_escape)
    end
  end

  describe "#format_html" do
    it "should have like #format_xml" do
      expect(subject.format_html).to eq(subject.format_xml)
    end
  end

  describe "#js_escape" do
    let(:special_byte) { 0x0a }
    let(:escaped_special_byte) { '\n' }

    let(:normal_byte) { 0x41 }
    let(:normal_char) { 'A' }

    it "should escape special JavaScript characters" do
      expect(special_byte.js_escape).to eq(escaped_special_byte)
    end

    it "should ignore normal characters" do
      expect(normal_byte.js_escape).to eq(normal_char)
    end
  end

  describe "#format_js" do
    let(:js_escaped) { '\x26' }

    it "should JavaScript format ascii bytes" do
      expect(subject.format_js).to eq(js_escaped)
    end

    it "should JavaScript format unicode bytes" do
      expect(0xd556.format_js).to eq('\uD556')
    end
  end
end
