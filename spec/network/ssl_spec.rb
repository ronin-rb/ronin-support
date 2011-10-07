require 'spec_helper'
require 'ronin/network/ssl'

describe Network::SSL do
  describe 'VERIFY' do
    subject { Network::SSL::VERIFY }

    it "should map verify mode names to OpenSSL VERIFY_* constants" do
      subject[:peer].should == OpenSSL::SSL::VERIFY_PEER
    end

    it "should default to VERIFY_NONE if no verify mode name is given" do
      subject[nil].should == OpenSSL::SSL::VERIFY_NONE
    end

    it "should raise an exception for unknown verify modes" do
      lambda { subject[:foo_bar] }.should raise_error
    end
  end
end
