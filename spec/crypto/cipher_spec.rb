require 'spec_helper'
require 'ronin/support/crypto/cipher'

describe Ronin::Support::Crypto::Cipher do
  let(:clear_text) { 'the quick brown fox' }

  let(:name)     { 'aes-256-cbc' }
  let(:password) { 'secret'      }

  describe "#initialize" do
    context "when :key is set" do
      let(:key)         { Digest::MD5.hexdigest(password) }
      let(:cipher_text) do
        cipher = OpenSSL::Cipher.new('aes-256-cbc')
        cipher.encrypt
        cipher.key = key

        cipher.update(clear_text) + cipher.final
      end

      subject { described_class.new(name, mode: :decrypt, key: key) }

      it "must set #name" do
        expect(subject.name).to eq(name.upcase)
      end

      it "must use the given key" do
        expect(subject.decrypt(cipher_text)).to eq(clear_text)
      end

      context "when :iv is set" do
        let(:iv)          { '0123456789abcdef' }
        let(:cipher_text) do
          cipher = OpenSSL::Cipher.new('aes-256-cbc')
          cipher.encrypt
          cipher.iv  = iv
          cipher.key = key

          cipher.update(clear_text) + cipher.final
        end

        subject do
          described_class.new(name, mode: :decrypt, key: key, iv: iv)
        end

        it "must set the IV" do
          expect(subject.decrypt(cipher_text)).to eq(clear_text)
        end
      end
    end

    context "when :password is given" do
      let(:password)    { "other secret" }
      let(:cipher_text) do
        cipher = OpenSSL::Cipher.new('aes-256-cbc')
        cipher.encrypt
        cipher.key = OpenSSL::Digest::SHA256.digest(password)

        cipher.update(clear_text) + cipher.final
      end

      subject do
        described_class.new(name, mode: :decrypt, password: password)
      end

      it "must set #name" do
        expect(subject.name).to eq(name.upcase)
      end

      it "must default :hash to :sha256" do
        expect(subject.decrypt(cipher_text)).to eq(clear_text)
      end

      context "when :hash and :password are given" do
        let(:hash)        { :sha256 }
        let(:cipher_text) do
          cipher = OpenSSL::Cipher.new('aes-256-cbc')
          cipher.encrypt
          cipher.key = OpenSSL::Digest::SHA256.digest(password)

          cipher.update(clear_text) + cipher.final
        end

        subject do
          described_class.new(name, mode:     :decrypt,
                                    hash:     hash,
                                    password: password)
        end

        it "must derive the key from the hash and password" do
          expect(subject.decrypt(cipher_text)).to eq(clear_text)
        end
      end
    end

    context "when either key: nor password: are given" do
      it do
        expect {
          described_class.new(name, mode: :encrypt)
        }.to raise_error(ArgumentError,"the the key: or password: keyword argument must be given")
      end
    end
  end

  let(:cipher_text) do
    cipher = OpenSSL::Cipher.new(name)
    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe "#encrypt" do
    subject { described_class.new(name, mode: :encrypt, password: password) }

    it "must encrypt a given String using the cipher" do
      expect(subject.encrypt(clear_text)).to eq(cipher_text)
    end
  end

  describe "#decrypt" do
    subject { described_class.new(name, mode: :decrypt, password: password) }

    it "must decrypt the String" do
      expect(subject.decrypt(cipher_text)).to eq(clear_text)
    end
  end
end
