# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/crypto/core_ext/file'

require 'tempfile'

describe File do
  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:tempfile)     { Tempfile.new('ronin-support') }
  let(:path)         { tempfile.path }

  let(:clear_text) { 'the quick brown fox' }

  before { File.write(path,clear_text) }

  subject { described_class }

  it { expect(subject).to respond_to(:md5)     }
  it { expect(subject).to respond_to(:sha1)    }
  it { expect(subject).to respond_to(:sha2)    }
  it { expect(subject).to respond_to(:sha256)  }
  it { expect(subject).to respond_to(:sha512)  }
  it { expect(subject).to respond_to(:rmd160)  }
  it { expect(subject).to respond_to(:hmac)    }
  it { expect(subject).to respond_to(:encrypt) }
  it { expect(subject).to respond_to(:decrypt) }

  describe ".md5" do
    let(:digest_md5) { "30f3c93e46436deb58ba70816a8ec124" }

    it "must return the MD5 digest of itself" do
      expect(subject.md5(path)).to eq(digest_md5)
    end
  end

  describe ".sha1" do
    let(:digest_sha1) { "ced71fa7235231bed383facfdc41c4ddcc22ecf1" }

    it "must return the SHA1 digest of itself" do
      expect(subject.sha1(path)).to eq(digest_sha1)
    end
  end

  describe ".sha2" do
    let(:digest_sha2) do
      "9ecb36561341d18eb65484e833efea61edc74b84cf5e6ae1b81c63533e25fc8f"
    end

    it "must return the SHA2 digest of itself" do
      expect(subject.sha2(path)).to eq(digest_sha2)
    end
  end

  describe ".sha256" do
    let(:digest_sha256) do
      "9ecb36561341d18eb65484e833efea61edc74b84cf5e6ae1b81c63533e25fc8f"
    end

    it "must return the SHA256 digest of itself" do
      expect(subject.sha256(path)).to eq(digest_sha256)
    end
  end

  describe ".sha512" do
    let(:digest_sha512) do
      "d9d380f29b97ad6a1d92e987d83fa5a02653301e1006dd2bcd51afa59a9147e9caedaf89521abc0f0b682adcd47fb512b8343c834a32f326fe9bef00542ce887"
    end

    it "must return the SHA512 digest of itself" do
      expect(subject.sha512(path)).to eq(digest_sha512)
    end
  end

  describe ".rmd160" do
    let(:digest_rmd160) { "1e76c9c004a440a285d130bc41a8d027b268afcd" }

    it "must return the RMD160 digest of itself" do
      case RUBY_ENGINE
      when 'jruby'
        pending "JRuby's bouncy-castle-java does not yet support RMD160"
      when 'truffleruby'
        pending "TruffleRuby does not yet support RMD160"
      end

      expect(subject.rmd160(path)).to eq(digest_rmd160)
    end
  end

  describe ".hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "must calculate the HMAC of the file" do
      expect(subject.hmac(path, key: key)).to eq(hash)
    end

    context "when digest is not given" do
      let(:digest)      { :md5 }
      let(:digest_hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "must use the digest when calculating the HMAC" do
        expect(subject.hmac(path, key: key, digest: digest)).to eq(digest_hash)
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
    it "must encrypt the String" do
      expect(subject.encrypt(path,cipher, password: password)).to eq(cipher_text)
    end

    context "when given a block" do
      it "must yield each encrypted block" do
        output = String.new

        subject.encrypt(path,cipher, password: password) do |block|
          output << block
        end

        expect(output).to eq(cipher_text)
      end
    end
  end

  describe ".decrypt" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    before { File.write(path,cipher_text) }

    it "must decrypt the String" do
      expect(subject.decrypt(path,cipher, password: password)).to eq(clear_text)
    end

    context "when given a block" do
      it "must yield each decrypted block" do
        output = String.new

        subject.decrypt(path,cipher, password: password) do |block|
          output << block
        end

        expect(output).to eq(clear_text)
      end
    end
  end

  let(:des3_key) { 'A' * 24 }
  let(:des3_cipher_text) do
    cipher = OpenSSL::Cipher.new('des3')

    cipher.encrypt
    cipher.key = des3_key

    cipher.update(clear_text) + cipher.final
  end

  describe ".des3_encrypt" do
    it "must encrypt a given String using DES3" do
      expect(subject.des3_encrypt(path, key: des3_key)).to eq(des3_cipher_text)
    end

    context "when given a block" do
      it "must yield each AES encrypted block" do
        output = String.new

        subject.des3_encrypt(path, key: des3_key) do |block|
          output << block
        end

        expect(output).to eq(des3_cipher_text)
      end
    end
  end

  describe ".des3_decrypt" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    before { File.write(path,des3_cipher_text) }

    it "must decrypt the given String" do
      expect(subject.des3_decrypt(path, key: des3_key)).to eq(clear_text)
    end

    context "when given a block" do
      it "must yield each AES decrypted block" do
        output = String.new

        subject.des3_decrypt(path, key: des3_key) do |block|
          output << block
        end

        expect(output).to eq(clear_text)
      end
    end
  end

  let(:aes_cipher_text) do
    cipher = OpenSSL::Cipher.new('aes-256-cbc')

    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe ".aes_encrypt" do
    let(:key_size) { 256 }

    it "must AES encrypt the String" do
      expect(subject.aes_encrypt(path, key_size: key_size, password: password)).to eq(aes_cipher_text)
    end

    context "when given a block" do
      it "must yield each AES encrypted block" do
        output = String.new

        subject.aes_encrypt(path, key_size: key_size, password: password) do |block|
          output << block
        end

        expect(output).to eq(aes_cipher_text)
      end
    end
  end

  describe ".aes_decrypt" do
    let(:key_size) { 256 }

    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    before { File.write(path,aes_cipher_text) }

    it "must AES decrypt the String" do
      expect(subject.aes_decrypt(path, key_size: key_size, password: password)).to eq(clear_text)
    end

    context "when given a block" do
      it "must yield each AES decrypted block" do
        output = String.new

        subject.aes_decrypt(path, key_size: key_size, password: password) do |block|
          output << block
        end

        expect(output).to eq(clear_text)
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
    it "must AES-128 encrypt the String" do
      expect(subject.aes128_encrypt(path, password: password)).to eq(aes128_cipher_text)
    end

    context "when given a block" do
      it "must yield each AES encrypted block" do
        output = String.new

        subject.aes128_encrypt(path, password: password) do |block|
          output << block
        end

        expect(output).to eq(aes128_cipher_text)
      end
    end
  end

  describe ".aes128_decrypt" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    before { File.write(path,aes128_cipher_text) }

    it "must AES-128 decrypt the String" do
      expect(subject.aes128_decrypt(path, password: password)).to eq(clear_text)
    end

    context "when given a block" do
      it "must yield each AES decrypted block" do
        output = String.new

        subject.aes128_decrypt(path, password: password) do |block|
          output << block
        end

        expect(output).to eq(clear_text)
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
    it "must AES-256 encrypt the String" do
      expect(subject.aes256_encrypt(path, password: password)).to eq(aes256_cipher_text)
    end

    context "when given a block" do
      it "must yield each AES encrypted block" do
        output = String.new

        subject.aes256_encrypt(path, password: password) do |block|
          output << block
        end

        expect(output).to eq(aes256_cipher_text)
      end
    end
  end

  describe ".aes256_decrypt" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    before { File.write(path,aes256_cipher_text) }

    it "must AES-256 decrypt the String" do
      expect(subject.aes256_decrypt(path, password: password)).to eq(clear_text)
    end

    context "when given a block" do
      it "must yield each AES decrypted block" do
        output = String.new

        subject.aes256_decrypt(path, password: password) do |block|
          output << block
        end

        expect(output).to eq(clear_text)
      end
    end
  end

  let(:rsa_pem_file) { File.join(fixtures_dir,'rsa.pem') }
  let(:rsa_pem)      { File.read(rsa_pem_file) }

  let(:rsa_key_password)       { "secret" }
  let(:rsa_encrypted_pem_file) { File.join(fixtures_dir,"rsa_encrypted.pem") }
  let(:rsa_encrypted_pem)      { File.read(rsa_encrypted_pem_file) }

  describe ".rsa_encrypt" do
    context "when the key: value is a #{Ronin::Support::Crypto::Key::RSA} object" do
      let(:key)     { Ronin::Support::Crypto::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      it "must encrypt the data using the #{Ronin::Support::Crypto::Key::RSA} object" do
        cipher_text = subject.rsa_encrypt(path, key: key)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end
    end

    context "when the key: value is a OpenSSL::PKey::RSA object" do
      let(:key)     { OpenSSL::PKey::RSA.new(rsa_pem) }
      let(:new_key) { Ronin::Support::Crypto::Key::RSA.load(rsa_pem) }

      it "must convert the key into and use #{Ronin::Support::Crypto::Key::RSA} to encrypt the data" do
        cipher_text = subject.rsa_encrypt(path, key: key)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end
    end

    context "when the key: value is a String" do
      let(:key)     { rsa_pem }
      let(:new_key) { Ronin::Support::Crypto::Key::RSA.load(rsa_pem) }

      it "must parse the key String and use it to encrypt the data" do
        cipher_text = subject.rsa_encrypt(path, key: key)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key) { rsa_encrypted_pem }
        let(:new_key) do
          Ronin::Support::Crypto::Key::RSA.load(rsa_pem, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          cipher_text = subject.rsa_encrypt(path, key: key, key_password: rsa_key_password)

          expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
        end
      end
    end

    context "when given the key_file: keyword argument" do
      let(:key_file) { rsa_pem_file }
      let(:new_key)  { Ronin::Support::Crypto::Key::RSA.load_file(key_file) }

      it "must read the key at the given path and encrypt the data" do
        cipher_text = subject.rsa_encrypt(path, key_file: key_file)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key_file) { rsa_encrypted_pem_file }
        let(:new_key) do
          Ronin::Support::Crypto::Key::RSA.load_file(key_file, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          cipher_text = subject.rsa_encrypt(path, key_file: key_file, key_password: rsa_key_password)

          expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
        end
      end
    end

    context "when the padding: keyword argument is given" do
      let(:key)     { Ronin::Support::Crypto::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      let(:padding) { :pkcs1_oaep }

      it "must use the given padding" do
        cipher_text = subject.rsa_encrypt(path, key: key, padding: padding)

        expect(new_key.private_decrypt(cipher_text, padding: padding)).to eq(clear_text)
      end
    end
  end

  describe ".rsa_decrypt" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    let(:clear_text)  { "the quick brown fox" }
    let(:cipher_text) { new_key.public_encrypt(clear_text) }

    before { File.write(path,cipher_text) }

    context "when the key: value is a #{Ronin::Support::Crypto::Key::RSA} object" do
      let(:key)     { Ronin::Support::Crypto::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      it "must decrypt the data using the #{Ronin::Support::Crypto::Key::RSA} object" do
        expect(subject.rsa_decrypt(path, key: key)).to eq(clear_text)
      end
    end

    context "when the key: value is a OpenSSL::PKey::RSA object" do
      let(:key)     { OpenSSL::PKey::RSA.new(rsa_pem) }
      let(:new_key) { Ronin::Support::Crypto::Key::RSA.load(rsa_pem) }

      it "must convert the key into and use #{Ronin::Support::Crypto::Key::RSA} to encrypt the data" do
        expect(subject.rsa_decrypt(path, key: key)).to eq(clear_text)
      end
    end

    context "when the key: value is a String" do
      let(:key)     { rsa_pem }
      let(:new_key) { Ronin::Support::Crypto::Key::RSA.load(rsa_pem) }

      it "must parse the key String and use it to encrypt the data" do
        expect(subject.rsa_decrypt(path, key: key)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key) { rsa_encrypted_pem }
        let(:new_key) do
          Ronin::Support::Crypto::Key::RSA.load(rsa_pem, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          expect(subject.rsa_decrypt(path, key: key, key_password: rsa_key_password)).to eq(clear_text)
        end
      end
    end

    context "when given the key_file: keyword argument" do
      let(:key_file) { rsa_pem_file }
      let(:new_key)  { Ronin::Support::Crypto::Key::RSA.load_file(key_file) }

      it "must read the key at the given path and encrypt the data" do
        expect(subject.rsa_decrypt(path, key_file: key_file)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key_file) { rsa_encrypted_pem_file }
        let(:new_key) do
          Ronin::Support::Crypto::Key::RSA.load_file(key_file, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          expect(subject.rsa_decrypt(path, key_file: key_file, key_password: rsa_key_password)).to eq(clear_text)
        end
      end
    end

    context "when the padding: keyword argument is given" do
      let(:key)     { Ronin::Support::Crypto::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      let(:padding)     { :pkcs1_oaep }
      let(:cipher_text) { new_key.public_encrypt(clear_text, padding: padding) }

      it "must use the given padding" do
        expect(subject.rsa_decrypt(path, key: key, padding: padding)).to eq(clear_text)
      end
    end
  end
end
