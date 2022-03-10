require 'spec_helper'
require 'ronin/support/network/ssl'

describe Ronin::Support::Network::SSL do
  describe 'VERIFY' do
    subject { described_class::VERIFY }

    it "must define :client_once" do
      expect(subject[:client_once]).to eq(OpenSSL::SSL::VERIFY_CLIENT_ONCE)
    end

    it "must define :fail_if_no_peer_cert" do
      expect(subject[:fail_if_no_peer_cert]).to eq(OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
    end

    it "must define :none" do
      expect(subject[:none]).to eq(OpenSSL::SSL::VERIFY_NONE)
    end

    it "must define :peer" do
      expect(subject[:peer]).to eq(OpenSSL::SSL::VERIFY_PEER)
    end

    it "must map true to :peer" do
      expect(subject[true]).to eq(subject[:peer])
    end

    it "must map false to :none" do
      expect(subject[false]).to eq(subject[:none])
    end
  end
end
