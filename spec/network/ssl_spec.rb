require 'spec_helper'
require 'ronin/network/ssl'

describe Network::SSL do
  describe 'verify' do
    it "should map verify mode names to numeric values" do
      Network::SSL.verify(:peer).should == OpenSSL::SSL::VERIFY_PEER
    end

    it "should default to VERIFY_NONE if no verify mode name is given" do
      Network::SSL.verify.should == OpenSSL::SSL::VERIFY_NONE
    end
  end
end
