require 'spec_helper'
require 'ronin/extensions/resolv'

describe Resolv do
  describe "resolver" do
    let(:nameserver) { '4.2.2.1' }

    subject { described_class }

    it "should create a new Resolv::DNS object if a nameserver is given" do
      subject.resolver(nameserver).should be_kind_of(Resolv::DNS)
    end

    it "should return the default resolver otherwise" do
      subject.resolver.should == Resolv
    end
  end
end
