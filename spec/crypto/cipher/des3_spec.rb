require 'spec_helper'
require 'ronin/support/crypto/cipher/des3'

describe Ronin::Support::Crypto::Cipher::DES3 do
  let(:key) { 'A' * 24 }

  describe "#initialize" do
    subject do
      described_class.new(
        direction: :encrypt,
        key:       key
      )
    end

    it "must default #mode to nil" do
      expect(subject.mode).to be(nil)
    end

    it "must initialize an DES3 cipher" do
      expect(subject.name).to eq("DES-EDE3-CBC")
    end

    # NOTE: Ruby 3.0's openssl does not support des3-wrap
    if RUBY_VERSION >= '3.1.0'
      context "when given the mode: keyword argument" do
        let(:mode) { :wrap }
        let(:key)  { "A" * 24 }

        subject do
          described_class.new(
            direction: :encrypt,
            mode:      mode,
            key:       key
          )
        end

        it "must set #mode" do
          expect(subject.mode).to eq(mode)
        end

        it "must initialize an DES3 cipher with the mode and direction" do
          expect(subject.name).to eq("DES3-#{mode.upcase}")
        end
      end
    end
  end

  describe ".supported" do
    subject { described_class }

    it "must return all ciphers beginning with 'des3'" do
      expect(subject.supported).to_not be_empty
      expect(subject.supported).to all(be =~ /^des3/)
    end
  end
end
