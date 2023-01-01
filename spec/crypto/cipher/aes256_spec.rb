require 'spec_helper'
require 'ronin/support/crypto/cipher/aes256'

describe Ronin::Support::Crypto::Cipher::AES256 do
  let(:mode)     { :ctr }
  let(:password) { 'secret' }

  describe "#initialize" do
    subject do
      described_class.new(
        direction: :encrypt,
        password:  password
      )
    end

    it "must initialize an AES-256 cipher with CBC mode" do
      expect(subject.name).to eq("AES-256-CBC")
    end

    context "when a mode argument is given" do
      subject do
        described_class.new(
          mode:      mode,
          direction: :encrypt,
          password:  password
        )
      end

      it "must initialize an AES-256 cipher with the given mode" do
        expect(subject.name).to eq("AES-256-#{mode.upcase}")
      end
    end
  end

  describe ".supported" do
    subject { described_class }

    it "must return all ciphers beginning with 'aes-256' or 'aes256'" do
      expect(subject.supported).to_not be_empty
      expect(subject.supported).to all(be =~ /^aes[-]?256/)
    end
  end
end
