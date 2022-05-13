require 'spec_helper'
require 'ronin/support/crypto'

describe Crypto do
  let(:clear_text) { 'the quick brown fox' }

  describe ".digest" do
    context "when given a lower-case name" do
      let(:name) { :md5 }

      it "must return the OpenSSL::Digest:: class" do
        expect(subject.digest(name)).to eq(OpenSSL::Digest::MD5)
      end
    end

    context "when given a upper-case name" do
      let(:name) { :MD5 }

      it "must return the OpenSSL::Digest:: class" do
        expect(subject.digest(name)).to eq(OpenSSL::Digest::MD5)
      end
    end

    context "when given a unknown name" do
      let(:name) { :foo }

      it "must raise a NameError" do
        expect { subject.digest(name) }.to raise_error(NameError)
      end
    end
  end

  describe ".hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "must return an OpenSSL::HMAC" do
      expect(subject.hmac(key)).to be_kind_of(OpenSSL::HMAC)
    end

    it "must use the key when calculating the HMAC" do
      hmac = subject.hmac(key)
      hmac.update(clear_text)

      expect(hmac.hexdigest).to eq(hash)
    end

    context "when digest is given" do
      let(:digest) { :md5 }
      let(:hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "must use the digest algorithm when calculating the HMAC" do
        hmac = subject.hmac(key,digest)
        hmac.update(clear_text)

        expect(hmac.hexdigest).to eq(hash)
      end
    end
  end

  describe ".ciphers" do
    it "must return Cipher.supported" do
      expect(subject.ciphers).to eq(Ronin::Support::Crypto::Cipher.supported)
    end
  end

  describe ".cipher" do
    let(:name)      { 'aes-256-cbc' }
    let(:password)  { 'secret'      }
    let(:direction) { :decrypt      }

    it "must return a Ronin::Support::Crypto::Cipher object" do
      new_cipher = subject.cipher(name, direction: direction,
                                        password:  password)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher)
      expect(new_cipher.name).to eq(name.upcase)
    end
  end

  describe ".aes" do
    let(:password)  { 'secret'      }
    let(:direction) { :decrypt      }

    it "must return a Ronin::Support::Crypto::Cipher::AES object" do
      new_cipher = subject.aes(direction: direction,
                               password:  password)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher::AES)
    end

    it "must default to cipher 'AES-256-CBC'" do
      new_cipher = subject.aes(direction: direction,
                               password:  password)

      expect(new_cipher.name).to eq("AES-256-CBC")
    end

    context "when the key_size: keyword argument is given" do
      let(:key_size) { 128 }

      it "must use the given key size" do
        new_cipher = subject.aes(key_size:  key_size,
                                 direction: direction,
                                 password:  password,
                                 hash:      :md5)

        expect(new_cipher.name).to eq("AES-#{key_size}-CBC")
      end
    end

    context "when the key_size: keyword argument is given" do
      let(:mode) { :ctr }

      it "must use the given mode" do
        new_cipher = subject.aes(mode:      mode,
                                 direction: direction,
                                 password:  password)

        expect(new_cipher.name).to eq("AES-256-#{mode.upcase}")
      end
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

  describe ".encrypt" do
    it "must encrypt a given String using the cipher" do
      expect(subject.encrypt(clear_text, cipher: cipher, password: password)).to eq(cipher_text)
    end
  end

  describe ".decrypt" do
    it "must decrypt the String" do
      expect(subject.decrypt(cipher_text, cipher: cipher, password: password)).to eq(clear_text)
    end
  end
end
