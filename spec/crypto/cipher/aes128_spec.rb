require 'spec_helper'
require 'ronin/support/crypto/cipher/aes128'

describe Ronin::Support::Crypto::Cipher::AES128 do
  let(:mode)     { :ctr }
  let(:hash)     { :md5 }
  let(:password) { 'secret' }

  describe "#initialize" do
    subject do
      described_class.new(mode:     :encrypt,
                          hash:     hash,
                          password: password)
    end

    it "must initialize an AES-128 cipher with CBC mode" do
      expect(subject.name).to eq("AES-128-CBC")
    end

    context "when a mode argument is given" do
      subject do
        described_class.new(mode, mode:     :encrypt,
                                  hash:     hash,
                                  password: password)
      end

      it "must initialize an AES-128 cipher with the given mode" do
        expect(subject.name).to eq("AES-128-#{mode.upcase}")
      end
    end
  end

  describe ".supported" do
    subject { described_class }

    it "must return all ciphers beginning with 'aes-128' or 'aes128'" do
      expect(subject.supported).to_not be_empty
      expect(subject.supported).to all(be =~ /^aes[-]?128/)
    end
  end
end
