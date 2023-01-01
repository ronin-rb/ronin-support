require 'spec_helper'
require 'ronin/support/encoding/punycode'

describe Ronin::Support::Encoding::Punycode do
  let(:unicode)  { "詹姆斯" }
  let(:punycode) { "xn--8ws00zhy3a" }

  describe ".encode" do
    it "must encode the given unicode String into punycode" do
      expect(subject.encode(unicode)).to eq(punycode)
    end
  end

  describe ".decode" do
    it "must decode the given punycode String back into unicode" do
      expect(subject.decode(punycode)).to eq(unicode)
    end
  end
end
