require 'spec_helper'
require 'ronin/support/encoding/base36/core_ext/integer'

describe Integer do
  subject { 1_000 }

  it { expect(subject).to respond_to(:base36_encode) }

  describe "#base36_encode" do
    it "must Base36 encoded the Integer and return a String" do
      expect(subject.base36_encode).to eq('rs')
    end
  end
end
