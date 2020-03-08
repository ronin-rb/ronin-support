require 'spec_helper'
require 'ronin/network/ssl'

describe Network::SSL do
  describe 'VERIFY' do
    subject { Network::SSL::VERIFY }

    it "should map verify mode names to OpenSSL VERIFY_* constants" do
      expect(subject[:peer]).to eq(OpenSSL::SSL::VERIFY_PEER)
    end

    it "should default to VERIFY_NONE if no verify mode name is given" do
      expect(subject[nil]).to eq(OpenSSL::SSL::VERIFY_NONE)
    end

    it "should raise an exception for unknown verify modes" do
      expect { subject[:foo_bar] }.to raise_error
    end
  end

  describe "helpers", :network do
    let(:host) { 'github.com' }
    let(:port) { 443 }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#ssl_connect" do
      it "should connect to an SSL protected port" do
        expect {
          subject.ssl_connect(host,port)
        }.not_to raise_error
      end

      it "should return an OpenSSL::SSL::SSLSocket" do
        socket = subject.ssl_connect(host,port)

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
      end

      context "when a block is given" do
        it "should yield the OpenSSL::SSL::SSLSocket" do
          socket = nil

          subject.ssl_connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
        end
      end
    end

    describe "#ssl_session" do
      it "should open then close a OpenSSL::SSL::SSLSocket" do
        socket = nil

        subject.ssl_session(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
        expect(socket).to be_closed
      end
    end
  end
end
