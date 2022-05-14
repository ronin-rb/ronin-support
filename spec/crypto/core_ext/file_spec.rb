# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/crypto/core_ext/file'

require 'tempfile'

describe File do
  let(:clear_text) { 'the quick brown fox' }
  let(:tempfile)   { Tempfile.new('ronin-support') }
  let(:path)       { tempfile.path }

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
      if RUBY_ENGINE == 'jruby'
        pending "JRuby's bouncy-castle-java does not yet support RMD160"
      elsif RUBY_ENGINE == 'truffleruby'
        pending "TruffleRuby does not yet support RMD160"
      end

      expect(subject.rmd160(path)).to eq(digest_rmd160)
    end
  end

  describe ".hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "must calculate the HMAC of the file" do
      expect(subject.hmac(path,key)).to eq(hash)
    end

    context "when digest is not given" do
      let(:digest)      { :md5 }
      let(:digest_hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "must use the digest when calculating the HMAC" do
        expect(subject.hmac(path,key,digest)).to eq(digest_hash)
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
        output = String.new('', encoding: Encoding::ASCII_8BIT)

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
        output = String.new('', encoding: Encoding::ASCII_8BIT)

        subject.decrypt(path,cipher, password: password) do |block|
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
        output = String.new('', encoding: Encoding::ASCII_8BIT)

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
        output = String.new('', encoding: Encoding::ASCII_8BIT)

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
        output = String.new('', encoding: Encoding::ASCII_8BIT)

        subject.aes128_encrypt(path, password: password) do |block|
          output << block
        end

        expect(output).to eq(aes128_cipher_text)
      end
    end
  end

  describe ".aes_decrypt" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    before { File.write(path,aes128_cipher_text) }

    it "must AES-128 decrypt the String" do
      expect(subject.aes128_decrypt(path, password: password)).to eq(clear_text)
    end

    context "when given a block" do
      it "must yield each AES decrypted block" do
        output = String.new('', encoding: Encoding::ASCII_8BIT)

        subject.aes128_decrypt(path, password: password) do |block|
          output << block
        end

        expect(output).to eq(clear_text)
      end
    end
  end
end
