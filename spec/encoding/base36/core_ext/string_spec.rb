require 'spec_helper'
require 'ronin/support/encoding/base36/core_ext/string'

describe String do
  subject { 'rs' }

  it { expect(subject).to respond_to(:base36_decode) }

  describe "#base36_decode" do
    it "must Base36 decode the String into an Integer" do
      expect(subject.base36_decode).to eq(1_000)
    end
  end
end
