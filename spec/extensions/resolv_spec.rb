require 'spec_helper'
require 'ronin/extensions/resolv'

describe Resolv do
  describe "resolver" do
    let(:nameserver) { '4.2.2.1' }

    subject { described_class }

    it "should create a new Resolv::DNS object if a nameserver is given" do
      expect(subject.resolver(nameserver)).to be_kind_of(Resolv::DNS)
    end

    it "should return the default resolver otherwise" do
      expect(subject.resolver).to eq(Resolv)
    end
  end
end
