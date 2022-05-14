require 'spec_helper'
require 'ronin/support/crypto/key/rsa'

require_relative 'methods_examples'

describe Ronin::Support::Crypto::Key::RSA do
  let(:path) { File.join(__dir__,'rsa.pem') }
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

  include_examples "Ronin::Support::Crypto::Key::Methods examples"

  subject { described_class.load_file(path) }

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
