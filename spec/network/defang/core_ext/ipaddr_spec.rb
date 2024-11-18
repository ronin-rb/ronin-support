require 'spec_helper'
require 'ronin/support/network/defang/core_ext/ipaddr'

describe IPAddr do
  describe "#defang" do
    subject { described_class.new('192.168.1.1') }

    let(:defanged) { '192[.]168[.]1[.]1' }

    it "must return the defanged IP address" do
      expect(subject.defang).to eq(defanged)
    end
  end
end
