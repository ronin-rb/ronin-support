require 'spec_helper'
require 'ronin/support/crypto'

describe Crypto do
  let(:clear_text) { 'the quick brown fox' }

  describe "digest" do
    context "when given a lower-case name" do
      let(:name) { :md5 }

      it "should return the OpenSSL::Digest:: class" do
        expect(subject.digest(name)).to eq(OpenSSL::Digest::MD5)
      end
    end

    context "when given a upper-case name" do
      let(:name) { :MD5 }

      it "should return the OpenSSL::Digest:: class" do
        expect(subject.digest(name)).to eq(OpenSSL::Digest::MD5)
      end
    end

    context "when given a unknown name" do
      let(:name) { :foo }

      it "should raise a NameError" do
        expect { subject.digest(name) }.to raise_error(NameError)
      end
    end
  end

  describe "hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "should return an OpenSSL::HMAC" do
      expect(subject.hmac(key)).to be_kind_of(OpenSSL::HMAC)
    end

    it "should use the key when calculating the HMAC" do
      hmac = subject.hmac(key)
      hmac.update(clear_text)
      
      expect(hmac.hexdigest).to eq(hash)
    end

    context "when digest is given" do
      let(:digest) { :md5 }
      let(:hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "should use the digest algorithm when calculating the HMAC" do
        hmac = subject.hmac(key,digest)
        hmac.update(clear_text)

        expect(hmac.hexdigest).to eq(hash)
      end
    end
  end

  describe "cipher" do
    let(:name)     { 'aes-256-cbc' }
    let(:password) { 'secret'      }

    subject { described_class.cipher(name) }

    it "should return a new OpenSSL::Cipher" do
      expect(subject).to be_kind_of(OpenSSL::Cipher)
    end

    context "when :key is set" do
      let(:key)         { Digest::MD5.hexdigest(password) }
      let(:cipher_text) do
        cipher = OpenSSL::Cipher.new('aes-256-cbc')
        cipher.encrypt
        cipher.key = key

        cipher.update(clear_text) + cipher.final
      end

      subject { described_class.cipher(name, mode: :decrypt, key: key) }

      it "should use the given key" do
        expect(subject.update(cipher_text) + subject.final).to eq(clear_text)
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
          described_class.cipher(name, mode: :decrypt, key: key, iv: iv)
        end

        it "should set the IV" do
          expect(subject.update(cipher_text) + subject.final).to eq(clear_text)
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
        described_class.cipher(name, mode: :decrypt,  password: password)
      end

      it "should default :hash to :sha256" do
        expect(subject.update(cipher_text) + subject.final).to eq(clear_text)
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
          described_class.cipher(name, mode:     :decrypt, 
                                       hash:     hash,
                                       password: password)
        end

        it "should derive the key from the hash and password" do
          expect(subject.update(cipher_text) + subject.final).to eq(clear_text)
        end
      end
    end
  end
end
