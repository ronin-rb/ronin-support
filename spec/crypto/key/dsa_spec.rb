require 'spec_helper'
require 'ronin/support/crypto/key/dsa'

describe Ronin::Support::Crypto::Key::DSA do
  let(:path) { File.join(__dir__,'dsa.key') }
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

    it "must parse a PEM encoded DSA key" do
      expect(subject.parse(pem).to_pem).to eq(pem)
    end
  end

  describe ".open" do
    subject { described_class }

    it "must read and parse the path to the key file" do
      expect(subject.open(path).to_pem).to eq(pem)
    end
  end

  subject { described_class.open(path) }

  describe "#p" do
    it "must return the 'p' value" do
      expect(subject.p).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#q" do
    it "must return the 'q' value" do
      expect(subject.q).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#g" do
    it "must return the 'g' value" do
      expect(subject.g).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#size" do
    it "must return the bit size of the 'p' variable" do
      expect(subject.size).to eq(subject.p.num_bits)
    end
  end
end
