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

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:key_file)  { File.join(fixtures_dir,'ssl.key')    }
  let(:key)       { Crypto::Key::RSA.load_file(key_file) }
  let(:cert_file) { File.join(fixtures_dir,'ssl.crt')    }
  let(:cert)      { Crypto::Cert.load_file(cert_file)    }

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

    context "when no version: keyword argument is given" do
      subject { described_class }

      let(:context) { double(OpenSSL::SSL::SSLContext) }

      it "must call OpenSSL::SSL::SSLContext#ssl_version with :TLSv1_2" do
        expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
        expect(context).to receive(:ssl_version=).with(:TLSv1_2)
        allow(context).to receive(:verify_mode=).with(0)

        subject.context(version: 1.2)
      end
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

    context "when given the key: keyword argument" do
      subject { described_class.context(key: key, cert: cert) }

      it "must set key" do
        expect(subject.key).to eq(key)
      end
    end

    context "when given the key_file: keyword argument" do
      subject { described_class.context(key_file: key_file, cert: cert) }

      it "must set key" do
        expect(subject.key.to_s).to eq(key.to_s)
      end
    end

    context "when given the cert: keyword argument" do
      subject { described_class.context(key: key, cert: cert) }

      it "must set cert" do
        expect(subject.cert).to eq(cert)
      end
    end

    context "when given the cert_file: keyword argument" do
      subject { described_class.context(key: key, cert_file: cert_file) }

      it "must set cert" do
        expect(subject.cert.to_s).to eq(cert.to_s)
      end
    end

    context "when given the ca_bundle: keyword argument" do
      context "when value is a file" do
        let(:ca_bundle) { File.join(fixtures_dir,'ssl.crt') }

        subject { described_class.context(ca_bundle: ca_bundle) }

        it "must set ca_file" do
          expect(subject.ca_file).to eq(ca_bundle)
        end
      end

      context "when value is a directory" do
        let(:ca_bundle) { fixtures_dir }

        subject { described_class.context(ca_bundle: ca_bundle) }

        it "must set ca_path" do
          expect(subject.ca_path).to eq(ca_bundle)
        end
      end
    end
  end
end
