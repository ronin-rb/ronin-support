require 'spec_helper'
require 'ronin/support/crypto/key/rsa'

describe Ronin::Support::Crypto::Key::RSA do
  let(:path) { File.join(__dir__,'rsa.key') }
  let(:pem)  { File.read(path) }

  describe ".random" do
    subject { described_class }

    it "must call .generate with a key size of 1024" do
      expect(subject).to receive(:generate).with(1024).and_return(pem)

      expect(subject.random).to be_kind_of(subject)
    end

    context "when given a key size" do
      let(:key_size) { 4096 }

      it "must call .generate with the given key size" do
        expect(subject).to receive(:generate).with(key_size).and_return(pem)

        expect(subject.random(key_size)).to be_kind_of(subject)
      end
    end
  end

  describe ".parse" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
      expect(subject.parse(pem).to_pem).to eq(pem)
    end
  end

  describe ".load" do
    subject { described_class }

    it "must read and parse the path to the key file" do
      expect(subject.load(path).to_pem).to eq(pem)
    end
  end

  subject { described_class.load(path) }

  describe "#n" do
    it "must return the 'n' value" do
      expect(subject.n).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#e" do
    it "must return the 'e' value" do
      expect(subject.e).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#d" do
    it "must return the 'd' value" do
      expect(subject.d).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#size" do
    it "must return the bit size of the 'n' variable" do
      expect(subject.size).to eq(subject.n.num_bits)
    end
  end
end
