require 'spec_helper'
require 'ronin/support/encoding/base32'

describe Ronin::Support::Encoding::Base32 do
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

    it "must set the String encoding to Encoding::UTF_8" do
      expect(subject.decode(encoded).encoding).to be(Encoding::UTF_8)
    end
  end
end
