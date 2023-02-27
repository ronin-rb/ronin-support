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

      subject { described_class.new(name, direction: :decrypt, key: key) }

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
          described_class.new(name, direction: :decrypt, key: key, iv: iv)
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
        described_class.new(name, direction: :decrypt, password: password)
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
          described_class.new(name, direction:     :decrypt,
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
          described_class.new(name, direction: :encrypt)
        }.to raise_error(ArgumentError,"the the key: or password: keyword argument must be given")
      end
    end
  end

  describe ".supported" do
    subject { described_class }

    it "must return OpenSSL::Cipher.ciphers" do
      expect(subject.supported).to eq(OpenSSL::Cipher.ciphers)
    end
  end

  let(:cipher_text) do
    cipher = OpenSSL::Cipher.new(name)

    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.digest(password)

    cipher.update(clear_text) + cipher.final
  end

  describe "#encrypt" do
    subject do
      described_class.new(name, direction: :encrypt, password: password)
    end

    it "must encrypt a given String using the cipher" do
      expect(subject.encrypt(clear_text)).to eq(cipher_text)
    end
  end

  describe "#decrypt" do
    subject do
      described_class.new(name, direction: :decrypt, password: password)
    end

    it "must decrypt the String" do
      expect(subject.decrypt(cipher_text)).to eq(clear_text)
    end
  end

  describe "#stream" do
    let(:data_blocks) do
      [
        'A' * 16384,
        'B' * 16384,
        'C' * 1024
      ]
    end
    let(:data) { data_blocks.join }

    let(:encrypt_cipher) do
      described_class.new(name, direction: :encrypt, password: password)
    end

    let(:decrypt_cipher) do
      described_class.new(name, direction: :decrypt, password: password)
    end

    let(:encrypted_data) { encrypt_cipher.encrypt(data) }
    let(:encrypted_io)   { StringIO.new(encrypted_data) }

    it "must pipe the IO through the cipher" do
      expect(decrypt_cipher.stream(encrypted_io)).to eq(data)
    end

    context "when given the output: keyword argument" do
      let(:output) { [] }

      it "must apend each block to the given output" do
        decrypt_cipher.stream(encrypted_io, output: output)

        expect(output.length).to be > 1
        expect(output.join).to eq(data)
      end
    end

    context "when given a block" do
      it "must yield each encrypted/decrypted block" do
        yielded_blocks = []

        decrypt_cipher.stream(encrypted_io) do |block|
          yielded_blocks << block
        end

        expect(yielded_blocks.length).to be > 1
        expect(yielded_blocks.join).to eq(data)
      end
    end
  end
end
