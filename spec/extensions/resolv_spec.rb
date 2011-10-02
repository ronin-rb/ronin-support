require 'spec_helper'
require 'ronin/extensions/resolv'

describe Resolv do
  describe "[]" do
    let(:nameserver) { '4.2.2.1' }

    it "should create a new Resolv::DNS object if a nameserver is given" do
      Resolv[nameserver].should be_kind_of(Resolv::DNS)
    end

    it "should return the default resolver otherwise" do
      Resolv[nil].should == Resolv
    end
  end
end
