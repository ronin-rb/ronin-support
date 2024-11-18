require 'spec_helper'
require 'ronin/support/network/defang/core_ext/uri/http'

describe URI::HTTP do
  describe "#defang" do
    subject { URI('http://www.example.com/foo?q=1') }

    let(:defanged) { 'hxxp[://]www[.]example[.]com/foo?q=1' }

    it "must return the defanged URL" do
      expect(subject.defang).to eq(defanged)
    end
  end
end
