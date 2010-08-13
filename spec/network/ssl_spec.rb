require 'spec_helper'
require 'ronin/network/ssl'

describe Network::SSL do
  describe 'verify' do
    it "should map verify mode names to numeric values" do
      subject.verify(:peer).should == OpenSSL::SSL::VERIFY_PEER
    end

    it "should default to VERIFY_NONE if no verify mode name is given" do
      subject.verify.should == OpenSSL::SSL::VERIFY_NONE
    end
  end
end
