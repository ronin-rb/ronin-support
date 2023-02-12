require 'spec_helper'
require 'ronin/support/encoding/base62/core_ext/integer'

describe Integer do
  subject { 1337 }

  it { expect(subject).to respond_to(:base62_encode) }

  describe "#base62_encode" do
    it "must Base62 encode the Integer" do
      expect(subject.base62_encode).to eq('LZ')
    end
  end
end
