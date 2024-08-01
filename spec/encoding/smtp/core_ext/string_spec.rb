require 'spec_helper'
require 'ronin/support/encoding/smtp/core_ext/string'

describe String do
  subject { "hello=world" }

  it "must provide String#smtp_escape" do
    expect(subject).to respond_to(:smtp_escape)
  end

  it "must provide String#smtp_unescape" do
    expect(subject).to respond_to(:smtp_unescape)
  end

  it "must provide String#smtp_encode" do
    expect(subject).to respond_to(:smtp_encode)
  end

  it "must provide String#smtp_decode" do
    expect(subject).to respond_to(:smtp_decode)
  end

  describe "#smtp_escape" do
    it "must escape '=' characters as '=3D' and append '=\\n' to the end of Strings" do
      expect(subject.smtp_escape).to eq("hello=3Dworld=\n")
    end
  end

  describe "#smtp_unescape" do
    subject { "hello=3Dworld=\n" }

    it "must unescape '=3D' as a '=' character and remove '=\\n' from the String" do
      expect(subject.smtp_unescape).to eq("hello=world")
    end
  end
end
