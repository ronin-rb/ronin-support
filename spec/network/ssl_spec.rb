require 'spec_helper'
require 'ronin/support/network/ssl'

describe Ronin::Support::Network::SSL do
  describe "VERSIONS" do
    subject { described_class::VERSIONS }

    it "must map 1 to :TLSv1" do
      expect(subject[1]).to eq(:TLSv1)
    end

    it "must map 1.1 to :TLSv1_!" do
      expect(subject[1.1]).to eq(:TLSv1_1)
    end

    it "must map 1.2 to :TLSv1_2" do
      expect(subject[1.2]).to eq(:TLSv1_2)
    end
  end

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

  describe ".context" do
    subject { described_class.context }

    it "must return an OpenSSL::SSL::SSLContext object" do
      expect(subject).to be_kind_of(OpenSSL::SSL::SSLContext)
    end

    it "must set verify_mode to OpenSSL::SSL::VERIFY_NONE" do
      expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
    end

    it "must set cert to nil" do
      expect(subject.cert).to be(nil)
    end

    it "must set key to nil" do
      expect(subject.key).to be(nil)
    end

    context "when given the version: keyword argument" do
      subject { described_class }

      let(:context) { double(OpenSSL::SSL::SSLContext) }

      context "and it's 1" do
        it "must call OpenSSL::SSL::SSLContext#ssl_version with :TLSv1" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:ssl_version=).with(:TLSv1)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: 1)
        end
      end

      context "and it's 1.1" do
        it "must call OpenSSL::SSL::SSLContext#ssl_version with :TLSv1_1" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:ssl_version=).with(:TLSv1_1)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: 1.1)
        end
      end

      context "and it's 1_2" do
        it "must call OpenSSL::SSL::SSLContext#ssl_version with :TLSv1_2" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:ssl_version=).with(:TLSv1_2)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: 1.2)
        end
      end

      context "and it's a Symbol" do
        let(:symbol) { :TLSv1 }

        it "must call OpenSSL::SSL::SSLContext#ssl_version= with the Symbol" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:ssl_version=).with(symbol)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: symbol)
        end
      end

      context "and it's a String" do
        let(:string) { "SSLv23" }

        it "must call OpenSSL::SSL::SSLContext#ssl_version= with the String" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:ssl_version=).with(string)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: string)
        end
      end
    end

    context "when given the verify: keyword argument" do
      subject { described_class.context(verify: :peer) }

      it "must set verify_mode" do
        expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
      end
    end

    context "when given the cert: keyword argument" do
      let(:cert) { File.join(__dir__,'ssl.crt') }

      subject { described_class.context(cert: cert) }

      it "must set cert" do
        expect(subject.cert.to_s).to eq(File.read(cert))
      end
    end

    context "when given the key: keyword argument" do
      let(:key) { File.join(__dir__,'ssl.key') }

      subject { described_class.context(key: key) }

      it "must set key" do
        expect(subject.key.to_s).to eq(File.read(key))
      end
    end

    context "when given the certs: keyword argument" do
      context "when value is a file" do
        let(:file) { File.join(__dir__,'ssl.crt') }

        subject { described_class.context(certs: file) }

        it "must set ca_file" do
          expect(subject.ca_file).to eq(file)
        end
      end

      context "when value is a directory" do
        let(:dir) { __dir__ }

        subject { described_class.context(certs: dir) }

        it "must set ca_path" do
          expect(subject.ca_path).to eq(dir)
        end
      end
    end
  end
end
