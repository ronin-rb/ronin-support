require 'spec_helper'
require 'ronin/support/encoding/quoted_printable'

describe Ronin::Support::Encoding::QuotedPrintable do
  let(:data) { "hello=world" }

  describe ".escape" do
    it "must escape '=' characters as '=3D' and append '=\\n' to the end of Strings" do
      expect(subject.escape(data)).to eq("hello=3Dworld=\n")
    end
  end

  describe ".encode" do
    it "must call .escape" do
      expect(subject.encode(data)).to eq(subject.escape(data))
    end
  end

  describe ".unescape" do
    let(:data) { "hello=3Dworld=\n" }

    it "must unescape '=3D' as a '=' character and remove '=\\n' from the String" do
      expect(subject.unescape(data)).to eq("hello=world")
    end
  end

  describe ".decode" do
    let(:data) { "hello=3Dworld=\n" }

    it "must call .unescape" do
      expect(subject.decode(data)).to eq(subject.unescape(data))
    end
  end
end
