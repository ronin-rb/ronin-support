require 'spec_helper'
require 'ronin/support/crypto/cipher/aes'

describe Ronin::Support::Crypto::Cipher::AES do
  let(:key_size) { 256  }
  let(:mode)     { :ctr }
  let(:password) { 'secret' }

  describe "#initialize" do
    context "when only given a key-size" do
      subject do
        described_class.new(
          key_size:  key_size,
          direction: :encrypt,
          password:  password
        )
      end

      it "must initialize an AES cipher with the given key-size and CBC direction" do
        expect(subject.name).to eq("AES-#{key_size}-CBC")
      end
    end

    context "when a key-size and a direction argument are given" do
      subject do
        described_class.new(
          key_size:  key_size,
          mode:      mode,
          direction: :encrypt,
          password:  password
        )
      end

      it "must initialize an AES cipher with the given key-size and the direction" do
        expect(subject.name).to eq("AES-#{key_size}-#{mode.upcase}")
      end
    end
  end

  describe ".supported" do
    subject { described_class }

    it "must return all ciphers beginning with 'aes'" do
      expect(subject.supported).to_not be_empty
      expect(subject.supported).to all(be =~ /^aes/)
    end
  end
end
