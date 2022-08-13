require 'spec_helper'
require 'ronin/support/encoding/uuencoding'

describe Ronin::Support::Encoding::UUEncoding do
  describe ".encode" do
    let(:data) { "hello world" }

    it "must UU encode the String" do
      expect(subject.encode(data)).to eq("+:&5L;&\\@=V]R;&0`\n")
    end
  end

  describe ".decode" do
    let(:data) { "+:&5L;&\\@=V]R;&0`\n" }

    it "must UU encode the String" do
      expect(subject.decode(data)).to eq("hello world")
    end
  end
end
