require 'spec_helper'
require 'ronin/support/encoding/base16/core_ext/string'

describe String do
  let(:text) { "The quick brown fox jumps over the lazy dog" }
  let(:base16) do
    "54686520717569636b2062726f776e20666f78206a756d7073206f76657220746865206c617a7920646f67"
  end

  describe "#base16_encode" do
    subject { text }

    it "must Base32 encode the String" do
      expect(subject.base16_encode).to eq(base16)
    end
  end

  describe "#base16_decode" do
    subject { base16 }

    it "must Base32 decode the String" do
      expect(subject.base16_decode).to eq(text)
    end
  end
end
