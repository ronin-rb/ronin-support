require 'spec_helper'
require 'ronin/support/encoding/html/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it "must provide Integer#html_escape" do
    expect(subject).to respond_to(:html_escape)
  end

  it "must provide Integer#html_encode" do
    expect(subject).to respond_to(:html_encode)
  end

  describe "#html_escape" do
    it "must behave like #xml_escape" do
      expect(subject.html_escape).to eq(subject.xml_escape)
    end
  end

  describe "#html_enocde" do
    it "must have like #xml_encode" do
      expect(subject.html_encode).to eq(subject.xml_encode)
    end
  end
end
