require 'spec_helper'
require 'ronin/support/encoding/base16'

describe Ronin::Support::Encoding::Base16 do
  describe ".encode" do
    let(:data) { "hello\x4e" }

    it "must Base16 encode each byte in the String" do
      expect(subject.encode(data)).to eq("68656c6c6f4e")
    end
  end

  describe ".decode" do
    let(:data) { "68656c6c6f4e" }

    it "must Base16 decode each two hex characters in the String" do
      expect(subject.decode(data)).to eq("hello\x4e")
    end
  end
end
