require 'spec_helper'
require 'ronin/support/network/ssl'

describe Ronin::Support::Network::SSL do
  describe 'VERIFY' do
    subject { described_class::VERIFY }

    it "should define :client_once" do
      expect(subject[:client_once]).to eq(OpenSSL::SSL::VERIFY_CLIENT_ONCE)
    end

    it "should define :fail_if_no_peer_cert" do
      expect(subject[:fail_if_no_peer_cert]).to eq(OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
    end

    it "should define :none" do
      expect(subject[:none]).to eq(OpenSSL::SSL::VERIFY_NONE)
    end

    it "should define :peer" do
      expect(subject[:peer]).to eq(OpenSSL::SSL::VERIFY_PEER)
    end

    it "should map true to :peer" do
      expect(subject[true]).to eq(subject[:peer])
    end

    it "should map false to :none" do
      expect(subject[false]).to eq(subject[:none])
    end
  end
end
