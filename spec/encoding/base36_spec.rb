require 'spec_helper'
require 'ronin/support/encoding/base36'

describe Ronin::Support::Encoding::Base36 do
  describe ".encode_int" do
    it "must convert the integer into a Base36 string" do
      expect(subject.encode_int(1_000)).to eq('rs')
    end
  end

  describe ".decode" do
    it "must decode the Base36 string and return an integer" do
      expect(subject.decode('rs')).to eq(1_000)
    end
  end
end
