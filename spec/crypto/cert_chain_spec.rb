require 'spec_helper'
require 'ronin/support/crypto/cert_chain'

describe Ronin::Support::Crypto::CertChain do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:cert_chain_path) { File.join(fixtures_dir,'cert_chain.crt') }
  let(:cert_chain) do
    OpenSSL::X509::Certificate.load_file(cert_chain_path)
  end

  it { expect(described_class).to include(Enumerable) }

  describe ".parse" do
    subject { described_class }

    it "must return a #{described_class} object" do
      cert_chain = subject.parse(File.read(cert_chain_path))

      expect(cert_chain).to be_kind_of(described_class)
    end

    it "must convert each parsed certificate into a Ronin::Support::Crypto::Cert object" do
      cert_chain = subject.parse(File.read(cert_chain_path))

      expect(cert_chain.certs).to all(be_kind_of(Ronin::Support::Crypto::Cert))
    end

    it "must parse the certificates within the given string" do
      cert_chain = subject.parse(File.read(cert_chain_path))

      expect(cert_chain.map(&:to_pem)).to eq(cert_chain.map(&:to_pem))
    end
  end

  describe ".load" do
    subject { described_class }

    it "must return a #{described_class} object" do
      cert_chain = subject.load(File.read(cert_chain_path))

      expect(cert_chain).to be_kind_of(described_class)
    end

    it "must convert each parsed certificate into a Ronin::Support::Crypto::Cert object" do
      cert_chain = subject.load(File.read(cert_chain_path))

      expect(cert_chain.certs).to all(be_kind_of(Ronin::Support::Crypto::Cert))
    end

    it "must parse the certificates within the given string" do
      cert_chain = subject.load(File.read(cert_chain_path))

      expect(cert_chain.map(&:to_pem)).to eq(cert_chain.map(&:to_pem))
    end
  end

  describe ".load_file" do
    subject { described_class }

    it "must return a #{described_class} object" do
      cert_chain = subject.load_file(cert_chain_path)

      expect(cert_chain).to be_kind_of(described_class)
    end

    it "must convert each parsed certificate into a Ronin::Support::Crypto::Cert object" do
      cert_chain = subject.load_file(cert_chain_path)

      expect(cert_chain.certs).to all(be_kind_of(Ronin::Support::Crypto::Cert))
    end

    it "must parse the certificates within the given file" do
      cert_chain = subject.load_file(cert_chain_path)

      expect(cert_chain.map(&:to_pem)).to eq(cert_chain.map(&:to_pem))
    end
  end

  let(:certs) do
    cert_chain.map { |cert| Ronin::Support::Crypto::Cert.new(cert) }
  end

  subject { described_class.new(certs) }

  describe "#initialize" do
    it "must set #certs" do
      expect(subject.certs).to eq(certs)
    end
  end

  describe "#each" do
    context "when given a block" do
      it "must yield each certificate in the certificate chain" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*certs)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator object" do
        expect(subject.each.to_a).to eq(certs)
      end
    end
  end

  describe "#[]" do
    context "when called with a single Integer" do
      it "must return the certificate at the given index" do
        expect(subject[1]).to eq(certs[1])
      end
    end

    context "when called with a single Range object" do
      it "must return the certificates within the range" do
        expect(subject[1..2]).to eq(certs[1..2])
      end
    end

    context "when called with an index Integer and a length Integer" do
      it "must return length number of certificates starting at the index " do
        expect(subject[1,2]).to eq(certs[1,2])
      end
    end
  end

  describe "#leaf" do
    it "must return the first certificate in the certificate chain" do
      expect(subject.leaf).to eq(certs.first)
    end
  end

  describe "#issuer" do
    it "must return the second certificate in the certificate chain" do
      expect(subject.issuer).to eq(certs[1])
    end
  end

  describe "#intermediates" do
    it "must return all certificates besides the first and last certificates" do
      expect(subject.intermediates).to eq(certs[1..-2])
    end
  end

  describe "#root" do
    it "must return the last certificate in the certificate chain" do
      expect(subject.root).to eq(certs.last)
    end
  end

  describe "#length" do
    it "must return the number of certificates in the certificate chain" do
      expect(subject.length).to eq(certs.length)
    end
  end

  describe "#to_pem" do
    it "must PEM encode each certificate in the certificate chain" do
      expect(subject.to_pem).to eq(certs.map(&:to_pem).join)
    end
  end
end
