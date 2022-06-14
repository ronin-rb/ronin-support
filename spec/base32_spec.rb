require 'spec_helper'
require 'ronin/support/base32'

describe Ronin::Support::Base32 do
  let(:decoded) { "The quick brown fox jumps over the lazy dog" }
  let(:encoded) do
    "KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO==="
  end

  describe ".encode" do
    it "must Base32 encode the given String" do
      expect(subject.encode(decoded)).to eq(encoded)
    end
  end

  describe ".decode" do
    it "must Base32 decode the given String" do
      expect(subject.decode(encoded)).to eq(decoded)
    end
  end
end
