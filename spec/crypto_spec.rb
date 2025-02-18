require 'spec_helper'
require 'ronin/support/crypto'

describe Ronin::Support::Crypto do
  let(:fixtures_dir) { File.join(__dir__,'crypto','fixtures') }

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
    let(:key) { 'secret' }

    it "must return an OpenSSL::HMAC" do
      expect(subject.hmac(key: key)).to be_kind_of(OpenSSL::HMAC)
    end

    let(:data) { "hello world" }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "must use the key when calculating the HMAC" do
      hmac = subject.hmac(key: key)
      hmac.update(clear_text)

      expect(hmac.hexdigest).to eq(hash)
    end

    context "when digest is given" do
      let(:digest) { :md5 }
      let(:hash)   { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "must use the digest algorithm when calculating the HMAC" do
        hmac = subject.hmac(key: key, digest: digest)
        hmac.update(clear_text)

        expect(hmac.hexdigest).to eq(hash)
      end
    end

    context "when given a data argument" do
      let(:data) { "hello world" }
      let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

      it "must use the key when calculating the HMAC" do
        hmac = subject.hmac(clear_text, key: key)

        expect(hmac.hexdigest).to eq(hash)
      end

      context "when digest is given" do
        let(:digest) { :md5 }
        let(:hash)   { '8319187ae2b6c1623205354d8f5d1a6e' }

        it "must use the digest algorithm when calculating the HMAC" do
          hmac = subject.hmac(clear_text, key: key, digest: digest)

          expect(hmac.hexdigest).to eq(hash)
        end
      end
    end
  end

  describe ".supported_ciphers" do
    it "must return Cipher.supported" do
      expect(subject.supported_ciphers).to eq(
        Ronin::Support::Crypto::Cipher.supported
      )
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

  describe ".des3_cipher" do
    let(:key)       { 'A' * 24 }
    let(:direction) { :decrypt }

    it "must return a Ronin::Support::Crypto::Cipher::DES3 object" do
      new_cipher = subject.des3_cipher(direction: direction, key: key)

      expect(new_cipher).to be_kind_of(Ronin::Support::Crypto::Cipher::DES3)
    end

    it "must default to cipher 'DES-EDE3-CBC'" do
      new_cipher = subject.des3_cipher(direction: direction, key: key)

      expect(new_cipher.name).to eq("DES-EDE3-CBC")
    end

    # NOTE: Ruby 3.0's openssl does not support des3-wrap
    if RUBY_VERSION >= '3.1.0'
      context "when the mode: keyword argument is given" do
        let(:mode) { :wrap }

        it "must use the given mode" do
          new_cipher = subject.des3_cipher(mode:      mode,
                                           direction: direction,
                                           key:       key)

          expect(new_cipher.name).to eq("DES3-#{mode.upcase}")
        end
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
      expect(subject.des3_encrypt(clear_text, key: des3_key)).to eq(des3_cipher_text)
    end
  end

  describe ".des3_decrypt" do
    it "must decrypt the given String" do
      expect(subject.des3_decrypt(des3_cipher_text, key: des3_key)).to eq(clear_text)
    end
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
    let(:path) { File.join(fixtures_dir,'rsa.pem') }
    let(:pem)  { File.read(path) }

    let(:password)           { "secret" }
    let(:encrypted_pem_file) { File.join(fixtures_dir,"rsa_encrypted.pem") }
    let(:encrypted_pem)      { File.read(encrypted_pem_file) }

    context "when given a #{described_class::Key::RSA} object" do
      let(:key) { described_class::Key::RSA.load_file(path) }

      it "must return the #{described_class::Key::RSA} object" do
        expect(subject.rsa_key(key)).to be(key)
      end
    end

    context "when given an OpenSSL::PKey::RSA object" do
      let(:key) { OpenSSL::PKey::RSA.new(pem) }

      it "must convert the object into a #{described_class::Key::RSA} object" do
        new_key = subject.rsa_key(key)

        expect(new_key).to be_kind_of(described_class::Key::RSA)
        expect(new_key.to_pem).to eq(pem)
      end
    end

    context "when given a String object" do
      let(:key) { described_class::Key::RSA.load_file(path) }

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

  let(:rsa_pem_file) { File.join(fixtures_dir,'rsa.pem') }
  let(:rsa_pem)      { File.read(rsa_pem_file) }

  let(:rsa_key_password)       { "secret" }
  let(:rsa_encrypted_pem_file) { File.join(fixtures_dir,"rsa_encrypted.pem") }
  let(:rsa_encrypted_pem)      { File.read(rsa_encrypted_pem_file) }

  describe ".rsa_encrypt" do
    let(:clear_text) { "the quick brown fox" }

    context "when the key: value is a #{described_class::Key::RSA} object" do
      let(:key)     { described_class::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      it "must encrypt the data using the #{described_class::Key::RSA} object" do
        cipher_text = subject.rsa_encrypt(clear_text, key: key)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end
    end

    context "when the key: value is a OpenSSL::PKey::RSA object" do
      let(:key)     { OpenSSL::PKey::RSA.new(rsa_pem)         }
      let(:new_key) { described_class::Key::RSA.load(rsa_pem) }

      it "must convert the key into and use #{described_class::Key::RSA} to encrypt the data" do
        cipher_text = subject.rsa_encrypt(clear_text, key: key)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end
    end

    context "when the key: value is a String" do
      let(:key)     { rsa_pem }
      let(:new_key) { described_class::Key::RSA.load(rsa_pem) }

      it "must parse the key String and use it to encrypt the data" do
        cipher_text = subject.rsa_encrypt(clear_text, key: key)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key) { rsa_encrypted_pem }
        let(:new_key) do
          described_class::Key::RSA.load(rsa_pem, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          cipher_text = subject.rsa_encrypt(clear_text, key: key, key_password: rsa_key_password)

          expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
        end
      end
    end

    context "when given the key_file: keyword argument" do
      let(:key_file) { rsa_pem_file }
      let(:new_key)  { described_class::Key::RSA.load_file(key_file) }

      it "must read the key at the given path and encrypt the data" do
        cipher_text = subject.rsa_encrypt(clear_text, key_file: key_file)

        expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key_file) { rsa_encrypted_pem_file }
        let(:new_key) do
          described_class::Key::RSA.load_file(key_file, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          cipher_text = subject.rsa_encrypt(clear_text, key_file: key_file, key_password: rsa_key_password)

          expect(new_key.private_decrypt(cipher_text, padding: :pkcs1)).to eq(clear_text)
        end
      end
    end

    context "when the padding: keyword argument is given" do
      let(:key)     { described_class::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      let(:padding) { :pkcs1_oaep }

      it "must use the given padding" do
        cipher_text = subject.rsa_encrypt(clear_text, key: key, padding: padding)

        expect(new_key.private_decrypt(cipher_text, padding: padding)).to eq(clear_text)
      end
    end
  end

  describe ".rsa_decrypt" do
    let(:clear_text)  { "the quick brown fox" }
    let(:cipher_text) do
      new_key.public_encrypt(clear_text)
    end

    context "when the key: value is a #{described_class::Key::RSA} object" do
      let(:key)     { described_class::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      it "must decrypt the data using the #{described_class::Key::RSA} object" do
        expect(subject.rsa_decrypt(cipher_text, key: key)).to eq(clear_text)
      end
    end

    context "when the key: value is a OpenSSL::PKey::RSA object" do
      let(:key)     { OpenSSL::PKey::RSA.new(rsa_pem)         }
      let(:new_key) { described_class::Key::RSA.load(rsa_pem) }

      it "must convert the key into and use #{described_class::Key::RSA} to encrypt the data" do
        expect(subject.rsa_decrypt(cipher_text, key: key)).to eq(clear_text)
      end
    end

    context "when the key: value is a String" do
      let(:key)     { rsa_pem }
      let(:new_key) { described_class::Key::RSA.load(rsa_pem) }

      it "must parse the key String and use it to encrypt the data" do
        expect(subject.rsa_decrypt(cipher_text, key: key)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key) { rsa_encrypted_pem }
        let(:new_key) do
          described_class::Key::RSA.load(rsa_pem, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          expect(subject.rsa_decrypt(cipher_text, key: key, key_password: rsa_key_password)).to eq(clear_text)
        end
      end
    end

    context "when given the key_file: keyword argument" do
      let(:key_file) { rsa_pem_file }
      let(:new_key)  { described_class::Key::RSA.load_file(key_file) }

      it "must read the key at the given path and encrypt the data" do
        expect(subject.rsa_decrypt(cipher_text, key_file: key_file)).to eq(clear_text)
      end

      context "and when the key_password: keyword argument is also given" do
        let(:key_file) { rsa_encrypted_pem_file }
        let(:new_key) do
          described_class::Key::RSA.load_file(key_file, password: rsa_key_password)
        end

        it "must decrypt the encrypted key using the key_password: argument" do
          expect(subject.rsa_decrypt(cipher_text, key_file: key_file, key_password: rsa_key_password)).to eq(clear_text)
        end
      end
    end

    context "when the padding: keyword argument is given" do
      let(:key)     { described_class::Key::RSA.load_file(rsa_pem_file) }
      let(:new_key) { key }

      let(:padding)     { :pkcs1_oaep }
      let(:cipher_text) { new_key.public_encrypt(clear_text, padding: padding) }

      it "must use the given padding" do
        expect(subject.rsa_decrypt(cipher_text, key: key, padding: padding)).to eq(clear_text)
      end
    end
  end

  describe ".rot" do
    let(:string) { "The quick brown fox jumps over 13 lazy dogs" }

    it "must ROT13 \"encrypt\" the String by default" do
      expect(subject.rot(string)).to eq("Gur dhvpx oebja sbk whzcf bire 46 ynml qbtf")
    end

    context "when the String's encoding is not Encoding::UTF_8" do
      let(:string) { String.new(super(), encoding: Encoding::ASCII_8BIT) }

      it "must return a new String of the same encoding as the String" do
        expect(subject.rot(string).encoding).to eq(string.encoding)
      end
    end

    context "when the String contains characters not within the alphabets" do
      let(:string) { "The quick brown fox, jumps over 13 lazy dogs." }

      it "must leave the characters un-rotated" do
        expect(subject.rot(string)).to eq("Gur dhvpx oebja sbk, whzcf bire 46 ynml qbtf.")
      end
    end

    context "when given a specific 'n' value" do
      it "must rotate forward the characters by that amount" do
        expect(subject.rot(string,3)).to eq("Wkh txlfn eurzq ira mxpsv ryhu 46 odcb grjv")
      end

      context "and when the 'n' value is negative" do
        let(:string) { "Wkh txlfn eurzq ira mxpsv ryhu 46 odcb grjv" }

        it "must rotate backwards the characters by that amount" do
          expect(subject.rot(string,-3)).to eq("The quick brown fox jumps over 13 lazy dogs")
        end
      end
    end
  end

  describe ".xor" do
    let(:string) { 'hello' }

    let(:key)        { 0x50 }
    let(:keys)       { [0x50, 0x55] }
    let(:key_string) { "\x50\x55" }

    it "must not contain the key used in the xor" do
      expect(subject.xor(string,key)).to_not include(key.chr)
    end

    it "must not equal the original string" do
      expect(subject.xor(string,key)).to_not eq(string)
    end

    it "must be able to be decoded with another xor" do
      expect(subject.xor(subject.xor(string,key),key)).to eq(string)
    end

    context "when the key is a single byte" do
      it "must xor each byte against the single byte" do
        expect(subject.xor(string,key)).to eq("85<<?")
      end
    end

    context "when the key is multiple bytes" do
      it "must xor each byte against the multiple bytes" do
        expect(subject.xor(string,keys)).to eq("80<9?")
      end
    end

    context "when the key is a String" do
      it "must xor each byte against the bytes in the key String" do
        expect(subject.xor(string,key_string)).to eq("80<9?")
      end
    end

    context "when the String's encoding is not Encoding::UTF_8" do
      let(:string) { String.new(super(), encoding: Encoding::ASCII_8BIT) }

      it "must return a new String of the same encoding as the String" do
        expect(subject.xor(string,key).encoding).to eq(string.encoding)
      end
    end
  end
end
