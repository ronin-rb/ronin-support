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
    it "must decrypt the given String" do
      expect(subject.decrypt(cipher_text, cipher: cipher, password: password)).to eq(clear_text)
    end
  end

  let(:aes_cipher_text) do
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe ".aes_cipher" do
    let(:key_size)  { 256      }
    let(:hash)      { :sha256  }
    let(:password)  { 'secret' }
    let(:direction) { :decrypt }

    it "must return a Ronin::Support::Crypto::Cipher::AES object" do
      new_cipher = subject.aes_cipher(key_size:  key_size,
                                      direction: direction,
                                      password:  password,
                                      hash:      hash)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher::AES)
    end

    it "must default to cipher 'AES-256-CBC'" do
      new_cipher = subject.aes_cipher(key_size:  key_size,
                                      direction: direction,
                                      password:  password,
                                      hash:      hash)

      expect(new_cipher.name).to eq("AES-256-CBC")
    end

    context "when the mode: keyword argument is given" do
      let(:mode) { :ctr }

      it "must use the given mode" do
        new_cipher = subject.aes_cipher(key_size:  key_size,
                                        mode:      mode,
                                        direction: direction,
                                        password:  password,
                                        hash:      hash)

        expect(new_cipher.name).to eq("AES-256-#{mode.upcase}")
      end
    end
  end

  describe ".aes_encrypt" do
    let(:key_size) { 256 }

    it "must encrypt a given String using AES in CBC mode with the key size" do
      expect(subject.aes_encrypt(clear_text, key_size: key_size, password: password)).to eq(aes_cipher_text)
    end
  end

  describe ".aes_decrypt" do
    let(:key_size) { 256 }

    it "must decrypt the given String" do
      expect(subject.aes_decrypt(aes_cipher_text, key_size: key_size, password: password)).to eq(clear_text)
    end
  end

  describe ".aes128_cipher" do
    let(:password)  { 'secret' }
    let(:direction) { :decrypt }

    it "must return a Ronin::Support::Crypto::Cipher::AES128 object" do
      new_cipher = subject.aes128_cipher(direction: direction,
                                         password:  password)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher::AES128)
    end

    it "must default to cipher 'AES-128-CBC'" do
      new_cipher = subject.aes128_cipher(direction: direction,
                                         password:  password)

      expect(new_cipher.name).to eq("AES-128-CBC")
    end

    context "when the mode: keyword argument is given" do
      let(:mode) { :ctr }

      it "must use the given mode" do
        new_cipher = subject.aes128_cipher(mode:      mode,
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

  describe ".aes128_encrypt" do
    it "must encrypt a given String using AES-128-CBC" do
      expect(subject.aes128_encrypt(clear_text, password: password)).to eq(aes128_cipher_text)
    end
  end

  describe ".aes128_decrypt" do
    it "must decrypt the given String" do
      expect(subject.aes128_decrypt(aes128_cipher_text, password: password)).to eq(clear_text)
    end
  end

  describe ".aes256_cipher" do
    let(:password)  { 'secret' }
    let(:direction) { :decrypt }

    it "must return a Ronin::Support::Crypto::Cipher::AES256 object" do
      new_cipher = subject.aes256_cipher(direction: direction,
                                         password:  password)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher::AES256)
    end

    it "must default to cipher 'AES-256-CBC'" do
      new_cipher = subject.aes256_cipher(direction: direction,
                                         password:  password)

      expect(new_cipher.name).to eq("AES-256-CBC")
    end

    context "when the mode: keyword argument is given" do
      let(:mode) { :ctr }

      it "must use the given mode" do
        new_cipher = subject.aes256_cipher(mode:      mode,
                                           direction: direction,
                                           password:  password)

        expect(new_cipher.name).to eq("AES-256-#{mode.upcase}")
      end
    end
  end

  let(:aes256_cipher_text) do
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe ".aes256_encrypt" do
    it "must encrypt a given String using AES-256-CBC" do
      expect(subject.aes256_encrypt(clear_text, password: password)).to eq(aes256_cipher_text)
    end
  end

  describe ".aes256_decrypt" do
    it "must decrypt the given String" do
      expect(subject.aes256_decrypt(aes256_cipher_text, password: password)).to eq(clear_text)
    end
  end

  describe ".rsa_key" do
    let(:dir)  { File.join(__dir__,'crypto','key') }
    let(:path) { File.join(dir,'rsa.pem') }
    let(:pem)  { File.read(path) }

    let(:password) { "secret" }
    let(:encrypted_pem_file) { File.join(dir,"rsa_encrypted.pem") }
    let(:encrypted_pem)      { File.read(encrypted_pem_file) }

    context "when given a #{described_class::Key::RSA} object" do
      let(:key)  { described_class::Key::RSA.load_file(path) }

      it "must return the #{described_class::Key::RSA} object" do
        expect(subject.rsa_key(key)).to be(key)
      end
    end

    context "when given an OpenSSL::PKey::RSA object" do
      let(:key)  { OpenSSL::PKey::RSA.new(pem) }

      it "must convert the object into a #{described_class::Key::RSA} object" do
        new_key = subject.rsa_key(key)

        expect(new_key).to be_kind_of(described_class::Key::RSA)
        expect(new_key.to_pem).to eq(pem)
      end
    end

    context "when given a String object" do
      let(:key)  { described_class::Key::RSA.load_file(path) }

      it "must return the #{described_class::Key::RSA} object" do
        key = subject.rsa_key(pem)

        expect(key).to be_kind_of(described_class::Key::RSA)
        expect(key.to_pem).to eq(pem)
      end

      context "when also given the password: keyword argument" do
        it "must return a #{described_class::Key::RSA} object" do
          key = subject.rsa_key(encrypted_pem, password: password)

          expect(key).to be_kind_of(described_class::Key::RSA)
        end

        it "must decrypt the key" do
          key = subject.rsa_key(encrypted_pem, password: password)

          expect(key.to_pem).to eq(pem)
        end
      end
    end

    context "when given the path: keyword argument" do
      it "must return a #{described_class::Key::RSA} object" do
        key = subject.rsa_key(path: path)

        expect(key).to be_kind_of(described_class::Key::RSA)
      end

      it "must load the RSA key from the given path" do
        key = subject.rsa_key(path: path)

        expect(key.to_pem).to eq(pem)
      end

      context "when also given the password: keyword argument" do
        it "must return a #{described_class::Key::RSA} object" do
          key = subject.rsa_key(path: encrypted_pem_file, password: password)

          expect(key).to be_kind_of(described_class::Key::RSA)
        end

        it "must decrypt the key" do
          key = subject.rsa_key(path: encrypted_pem_file, password: password)

          expect(key.to_pem).to eq(pem)
        end
      end
    end
  end
end
