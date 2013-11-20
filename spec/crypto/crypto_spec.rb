require 'spec_helper'
require 'ronin/crypto'

describe Crypto do
  let(:clear_text) { 'the quick brown fox' }

  describe "digest" do
    context "when given a lower-case name" do
      let(:name) { :md5 }

      it "should return the OpenSSL::Digest:: class" do
        subject.digest(name).should == OpenSSL::Digest::MD5
      end
    end

    context "when given a upper-case name" do
      let(:name) { :MD5 }

      it "should return the OpenSSL::Digest:: class" do
        subject.digest(name).should == OpenSSL::Digest::MD5
      end
    end

    context "when given a unknown name" do
      let(:name) { :foo }

      it "should raise a NameError" do
        lambda { subject.digest(name) }.should raise_error(NameError)
      end
    end
  end

  describe "hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "should return an OpenSSL::HMAC" do
      subject.hmac(key).should be_kind_of(OpenSSL::HMAC)
    end

    it "should use the key when calculating the HMAC" do
      hmac = subject.hmac(key)
      hmac.update(clear_text)
      
      hmac.hexdigest.should == hash
    end

    context "when digest is given" do
      let(:digest) { :md5 }
      let(:hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "should use the digest algorithm when calculating the HMAC" do
        hmac = subject.hmac(key,digest)
        hmac.update(clear_text)

        hmac.hexdigest.should == hash
      end
    end
  end

  describe "cipher" do
    let(:name)     { 'aes-256-cbc' }
    let(:password) { 'secret'      }

    subject { described_class.cipher(name) }

    it "should return a new OpenSSL::Cipher" do
      subject.should be_kind_of(OpenSSL::Cipher)
    end

    context "when :key is set" do
      let(:key)         { Digest::MD5.hexdigest(password) }
      let(:cipher_text) { "O\xA2\xE7\xEF\x84\xF0\xA2\x82\x1F\x00\e\n\x9B\xE4XY\b\x9C_`\xE9\xCC\xBF\xAF\xB8\xF0\xF4\x1A\xB3\x1F)\xA1" }

      subject { described_class.cipher(name, mode: :decrypt, key: key) }

      it "should set the key" do
        (subject.update(cipher_text) + subject.final).should == clear_text
      end

      context "when :iv is set" do
        let(:iv)          { '0123456789abcdef' }
        let(:cipher_text) { "L\x91Z\xF7\xC7;\xCFr\x99H\x05\xDB\xF6\x93\xB0\xCC5N`\x19f\x06m\n[\xF37\x99\xFE!\x99\xFD" }

        subject do
          described_class.cipher(name, mode: :decrypt, key: key, iv: iv)
        end

        it "should set the IV" do
          (subject.update(cipher_text) + subject.final).should == clear_text
        end
      end
    end

    context "when :password is given" do
      let(:cipher_text) { "\xC8+\xE3\x05\xD3\xBE\xC6d\x0F=N\x90\xB9\x87\xD8bk\x1C#0\x96`4\xBC\xB1\xB5tD\xF3\x98\xAD`" }

      subject do
        described_class.cipher(name, mode: :decrypt,  password: password)
      end

      it "should default :hash to :sha1" do
        (subject.update(cipher_text) + subject.final).should == clear_text
      end

      context "when :hash is given" do
        let(:cipher_text) { "O\xA2\xE7\xEF\x84\xF0\xA2\x82\x1F\x00\e\n\x9B\xE4XY\b\x9C_`\xE9\xCC\xBF\xAF\xB8\xF0\xF4\x1A\xB3\x1F)\xA1" }

        subject do
          described_class.cipher(name, mode:     :decrypt, 
                                       hash:     :md5,
                                       password: password)
        end

        it "should set the key" do
          (subject.update(cipher_text) + subject.final).should == clear_text
        end
      end
    end
  end
end
