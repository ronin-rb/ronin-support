require 'spec_helper'
require 'ronin/support/encoding/base32/core_ext/string'

describe String do
  let(:text) { "The quick brown fox jumps over the lazy dog" }
  let(:base32) do
    "KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO==="
  end

  describe "#base32_encode" do
    subject { text }

    it "must Base32 encode the String" do
      expect(subject.base32_encode).to eq(base32)
    end
  end

  describe "#base32_decode" do
    subject { base32 }

    it "must Base32 decode the String" do
      expect(subject.base32_decode).to eq(text)
    end
  end
end
