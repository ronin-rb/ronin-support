require 'spec_helper'
require 'ronin/support/crypto/mixin'

describe Ronin::Support::Crypto::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  let(:clear_text) { 'the quick brown fox' }

  describe "#crypto_digest" do
    context "when given a lower-case name" do
      let(:name) { :md5 }

      it "must return the OpenSSL::Digest:: class" do
        expect(subject.crypto_digest(name)).to eq(OpenSSL::Digest::MD5)
      end
    end

    context "when given a upper-case name" do
      let(:name) { :MD5 }

      it "must return the OpenSSL::Digest:: class" do
        expect(subject.crypto_digest(name)).to eq(OpenSSL::Digest::MD5)
      end
    end

    context "when given a unknown name" do
      let(:name) { :foo }

      it "must raise a NameError" do
        expect { subject.crypto_digest(name) }.to raise_error(NameError)
      end
    end
  end

  describe "#crypto_hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "must return an OpenSSL::HMAC" do
      expect(subject.crypto_hmac(key)).to be_kind_of(OpenSSL::HMAC)
    end

    it "must use the key when calculating the HMAC" do
      hmac = subject.crypto_hmac(key)
      hmac.update(clear_text)

      expect(hmac.hexdigest).to eq(hash)
    end

    context "when digest is given" do
      let(:digest) { :md5 }
      let(:hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "must use the digest algorithm when calculating the HMAC" do
        hmac = subject.crypto_hmac(key,digest)
        hmac.update(clear_text)

        expect(hmac.hexdigest).to eq(hash)
      end
    end
  end

  describe "#crypto_cipher" do
    let(:name)      { 'aes-256-cbc' }
    let(:password)  { 'secret'      }
    let(:direction) { :decrypt      }

    it "must return a Ronin::Support::Crypto::Cipher object" do
      new_cipher = subject.crypto_cipher(name, direction: direction,
                                               password:  password)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher)
      expect(new_cipher.name).to eq(name.upcase)
    end
  end

  let(:cipher)   { 'aes-256-cbc' }
  let(:password) { 'secret'      }

  let(:cipher_text) do
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe "#crypto_encrypt" do
    it "must encrypt a given String using the cipher" do
      expect(subject.crypto_encrypt(clear_text, cipher: cipher, password: password)).to eq(cipher_text)
    end
  end

  describe "#crypto_decrypt" do
    it "must decrypt the String" do
      expect(subject.crypto_decrypt(cipher_text, cipher: cipher, password: password)).to eq(clear_text)
    end
  end

  let(:aes_cipher_text) do
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe "#crypto_aes_encrypt" do
    let(:key_size) { 256 }

    it "must encrypt a given String using AES in CBC mode with the key size" do
      expect(subject.crypto_aes_encrypt(clear_text, key_size: key_size, password: password)).to eq(aes_cipher_text)
    end
  end

  describe "#crypto_aes_decrypt" do
    let(:key_size) { 256 }

    it "must decrypt the given String" do
      expect(subject.crypto_aes_decrypt(aes_cipher_text, key_size: key_size, password: password)).to eq(clear_text)
    end
  end

  describe "#crypto_aes128" do
    let(:password)  { 'secret' }
    let(:direction) { :decrypt }

    it "must return a Ronin::Support::Crypto::Cipher::AES128 object" do
      new_cipher = subject.crypto_aes128(direction: direction,
                                         password:  password)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher::AES128)
    end

    it "must default to cipher 'AES-128-CBC'" do
      new_cipher = subject.crypto_aes128(direction: direction,
                                         password:  password)

      expect(new_cipher.name).to eq("AES-128-CBC")
    end

    context "when the mode: keyword argument is given" do
      let(:mode) { :ctr }

      it "must use the given mode" do
        new_cipher = subject.crypto_aes128(mode:      mode,
                                           direction: direction,
                                           password:  password)

        expect(new_cipher.name).to eq("AES-128-#{mode.upcase}")
      end
    end
  end

  let(:aes128_cipher_text) do
    cipher = OpenSSL::Cipher.new('aes-128-cbc')
    cipher.encrypt
    cipher.key = OpenSSL::Digest::MD5.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe "#crypto_aes128_encrypt" do
    it "must encrypt a given String using AES-128-CBC" do
      expect(subject.crypto_aes128_encrypt(clear_text, password: password)).to eq(aes128_cipher_text)
    end
  end

  describe "#crypto_aes128_decrypt" do
    it "must decrypt the given String" do
      expect(subject.crypto_aes128_decrypt(aes128_cipher_text, password: password)).to eq(clear_text)
    end
  end
end
