require 'spec_helper'
require 'ronin/support/encoding/html/core_ext/string'

describe String do
  subject { "one & two" }

  it "must provide String#html_escape" do
    expect(subject).to respond_to(:html_escape)
  end

  it "must provide String#html_unescape" do
    expect(subject).to respond_to(:html_unescape)
  end

  it "must provide String#html_encode" do
    expect(subject).to respond_to(:html_encode)
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

  describe "#html_encode" do
    it "must behave like #xml_enocde" do
      expect(subject.html_encode).to eq(subject.xml_encode)
    end
  end
end
