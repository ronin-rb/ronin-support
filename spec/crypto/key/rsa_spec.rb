require 'spec_helper'
require 'ronin/support/crypto/key/rsa'

require 'tempfile'

describe Ronin::Support::Crypto::Key::RSA do
  describe ".random" do
    subject { described_class }

    it "must generate a new random RSA key" do
      new_key = subject.random

      expect(new_key).to be_kind_of(described_class)
      expect(new_key).to_not eq(subject.random)
    end

    context "when given a key size" do
      let(:key_size) { 2048 }

      it "must generate a new RSA key of the given key size" do
        new_key = subject.random(key_size)

        expect(new_key.size).to eq(key_size)
      end
    end
  end

  let(:path) { File.join(__dir__,'rsa.key') }
  let(:pem)  { File.read(path) }

  describe ".parse" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
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
