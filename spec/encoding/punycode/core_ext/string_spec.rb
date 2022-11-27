require 'spec_helper'
require 'ronin/support/encoding/punycode/core_ext/string'

describe String do
  let(:unicode)  { "詹姆斯" }
  let(:punycode) { "xn--8ws00zhy3a" }

  describe ".encode" do
    subject { unicode }

    it "must encode the unicode String into a punycode String" do
      expect(subject.punycode_encode).to eq(punycode)
    end
  end

  describe ".decode" do
    subject { punycode }

    it "must decode the punycode String back into a unicode String" do
      expect(subject.punycode_decode).to eq(unicode)
    end
  end
end
