require 'spec_helper'
require 'ronin/support/encoding/base62/core_ext/string'

describe String do
  subject { 'LZ' }

  it { expect(subject).to respond_to(:base62_decode) }

  describe "#base62_decode" do
    it "must Base62 decode the String" do
      expect(subject.base62_decode).to eq(1337)
    end
  end
end
