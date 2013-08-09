# encoding: US-ASCII

require 'spec_helper'
require 'ronin/crypto/extensions/file'

require 'tempfile'

describe File do
  before(:all) do
    @clear_text = 'the quick brown fox'

    @file = Tempfile.new('ronin-support')
    @file.write(@clear_text)
    @file.close
  end

  let(:path) { @file.path }

  subject { described_class }

  it { should respond_to(:md5)     }
  it { should respond_to(:sha1)    }
  it { should respond_to(:sha2)    }
  it { should respond_to(:sha256)  }
  it { should respond_to(:sha512)  }
  it { should respond_to(:rmd160)  }
  it { should respond_to(:hmac)    }
  it { should respond_to(:encrypt) }
  it { should respond_to(:decrypt) }

  describe "#md5" do
    let(:digest_md5) { "30f3c93e46436deb58ba70816a8ec124" }

    it "should return the MD5 digest of itself" do
      subject.md5(path).should == digest_md5
    end
  end

  describe "#sha1" do
    let(:digest_sha1) { "ced71fa7235231bed383facfdc41c4ddcc22ecf1" }

    it "should return the SHA1 digest of itself" do
      subject.sha1(path).should == digest_sha1
    end
  end

  describe "#sha2" do
    let(:digest_sha2) do
      "9ecb36561341d18eb65484e833efea61edc74b84cf5e6ae1b81c63533e25fc8f"
    end

    it "should return the SHA2 digest of itself" do
      subject.sha2(path).should == digest_sha2
    end
  end

  describe "#sha256" do
    let(:digest_sha256) do
      "9ecb36561341d18eb65484e833efea61edc74b84cf5e6ae1b81c63533e25fc8f"
    end

    it "should return the SHA256 digest of itself" do
      subject.sha256(path).should == digest_sha256
    end
  end

  describe "#sha512" do
    let(:digest_sha512) do
      "d9d380f29b97ad6a1d92e987d83fa5a02653301e1006dd2bcd51afa59a9147e9caedaf89521abc0f0b682adcd47fb512b8343c834a32f326fe9bef00542ce887"
    end

    it "should return the SHA512 digest of itself" do
      subject.sha512(path).should == digest_sha512
    end
  end

  describe "#rmd160" do
    let(:digest_rmd160) { "1e76c9c004a440a285d130bc41a8d027b268afcd" }

    it "should return the RMD160 digest of itself" do
      subject.rmd160(path).should == digest_rmd160
    end
  end

  describe "#hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "should calculate the HMAC of the file" do
      subject.hmac(path,key).should == hash
    end

    context "when digest is not given" do
      let(:digest)      { :md5 }
      let(:digest_hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "should use the digest when calculating the HMAC" do
        subject.hmac(path,key,digest).should == digest_hash
      end
    end
  end

  describe "#encrypt" do
    let(:cipher)   { 'aes-256-cbc' }
    let(:password) { 'secret' }

    let(:cipher_text) { "\xC8+\xE3\x05\xD3\xBE\xC6d\x0F=N\x90\xB9\x87\xD8bk\x1C#0\x96`4\xBC\xB1\xB5tD\xF3\x98\xAD`" }

    it "should encrypt the String with the cipher and key" do
      subject.encrypt(path,cipher, password: password).should == cipher_text
    end

    context "when given a block" do
      it "should yield each encrypted block" do
        output = ''

        subject.encrypt(path,cipher, password: password) do |block|
          output << block
        end

        output.should == cipher_text
      end
    end
  end

  describe "#decrypt" do
    before(:all) do
      @cipher      = 'aes-256-cbc'
      @password    = 'secret'
      @cipher_text = "\xC8+\xE3\x05\xD3\xBE\xC6d\x0F=N\x90\xB9\x87\xD8bk\x1C#0\x96`4\xBC\xB1\xB5tD\xF3\x98\xAD`"

      @file = Tempfile.new('ronin-support')
      @file.write(@cipher_text)
      @file.close
    end

    it "should decrypt the String with the cipher and key" do
      subject.decrypt(@file.path,@cipher,password: @password).should == @clear_text
    end

    context "when given a block" do
      it "should yield each decrypted block" do
        output = ''

        subject.decrypt(@file.path,@cipher,password: @password) do |block|
          output << block
        end

        output.should == @clear_text
      end
    end
  end
end
