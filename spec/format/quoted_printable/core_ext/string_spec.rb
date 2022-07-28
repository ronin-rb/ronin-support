require 'spec_helper'
require 'ronin/support/format/quoted_printable/core_ext/string'

describe String do
  subject { "hello=world" }

  it "must provide String#quoted_printable_escape" do
    expect(subject).to respond_to(:quoted_printable_escape)
  end

  it "must provide String#quoted_printable_unescape" do
    expect(subject).to respond_to(:quoted_printable_unescape)
  end

  it "must provide String#quoted_printable_encode" do
    expect(subject).to respond_to(:quoted_printable_encode)
  end

  it "must provide String#quoted_printable_decode" do
    expect(subject).to respond_to(:quoted_printable_decode)
  end

  it "must provide String#qp_escape" do
    expect(subject).to respond_to(:qp_escape)
  end

  it "must provide String#qp_unescape" do
    expect(subject).to respond_to(:qp_unescape)
  end

  it "must provide String#qp_encode" do
    expect(subject).to respond_to(:qp_encode)
  end

  it "must provide String#qp_decode" do
    expect(subject).to respond_to(:qp_decode)
  end

  describe "#quoted_printable_escape" do
    it "must escape '=' characters as '=3D' and append '=\\n' to the end of Strings" do
      expect(subject.quoted_printable_escape).to eq("hello=3Dworld=\n")
    end
  end

  describe "#quoted_printable_unescape" do
    subject { "hello=3Dworld=\n" }

    it "must unescape '=3D' as a '=' character and remove '=\\n' from the String" do
      expect(subject.quoted_printable_unescape).to eq("hello=world")
    end
  end
end
