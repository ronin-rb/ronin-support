require 'spec_helper'
require 'ronin/support/crypto/key/rsa'

require_relative 'methods_examples'

describe Ronin::Support::Crypto::Key::RSA do
  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:path) { File.join(fixtures_dir,'rsa.pem') }
  let(:pem)  { File.read(path) }

  describe ".generate" do
    subject { described_class }

    let(:openssl_key) { OpenSSL::PKey::RSA.new(pem) }

    it "must call super() with a key size of 4096" do
      expect(subject.superclass).to receive(:generate).with(4096).and_return(openssl_key)

      expect(subject.generate).to be_kind_of(described_class)
    end

    context "when given a key size" do
      let(:key_size) { 2048 }

      it "must call super() with the given key size" do
        expect(subject.superclass).to receive(:generate).with(key_size).and_return(openssl_key)

        expect(subject.generate(key_size)).to be_kind_of(described_class)
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

  describe "#public_encrypt" do
    let(:clear_text) { "the quick brown fox" }

    it "must encrypt the data using the public key and PKCS1 padding" do
      cipher_text = subject.public_encrypt(clear_text)

      expect(subject.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
    end

    context "when the padding: keyword argument is given" do
      let(:padding) { :pkcs1_oaep }

      it "must lookup and use the given padding" do
        cipher_text = subject.public_encrypt(clear_text, padding: padding)

        expect(subject.private_decrypt(cipher_text, padding: :pkcs1_oaep)).to eq(clear_text)
      end

      context "but the padding: value is invalid" do
        let(:padding) { :foo }

        it do
          expect {
            subject.public_encrypt(clear_text, padding: padding)
          }.to raise_error(ArgumentError,"padding must be :pkcs1_oaep, :pkcs1, :sslv23, nil, false: #{padding.inspect}")
        end
      end
    end
  end

  describe "#private_decrypt" do
    let(:clear_text)  { "the quick brown fox" }
    let(:cipher_text) do
      subject.public_encrypt(clear_text)
    end

    it "must decrypt the data using the private key and PKCS1 padding" do
      expect(subject.private_decrypt(cipher_text)).to eq(clear_text)
    end

    context "when the padding: keyword argument is given" do
      let(:cipher_text) do
        subject.public_encrypt(clear_text, padding: :pkcs1_oaep)
      end

      let(:padding) { :pkcs1_oaep }

      it "must lookup and use the given padding" do
        expect(subject.private_decrypt(cipher_text, padding: padding)).to eq(clear_text)
      end

      context "but the padding: value is invalid" do
        let(:padding) { :foo }

        it do
          expect {
            subject.private_decrypt(cipher_text, padding: padding)
          }.to raise_error(ArgumentError,"padding must be :pkcs1_oaep, :pkcs1, :sslv23, nil, false: #{padding.inspect}")
        end
      end
    end
  end
end
