require 'spec_helper'
require 'ronin/crypto/crypto'

describe Crypto do
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

  describe "cipher" do
    let(:name)     { 'aes-256-cbc' }
    let(:password) { 'secret'      }
    let(:key)      { Digest::MD5.hexdigest(password) }

    it "should return a new OpenSSL::Cipher" do
      subject.cipher(name).should be_kind_of(OpenSSL::Cipher)
    end

    context "when :key is set" do
      let(:cipher) { subject.cipher(name, mode: :decrypt, key: key) }

      let(:clear_text)  { 'the quick brown fox' }
      let(:cipher_text) { "O\xA2\xE7\xEF\x84\xF0\xA2\x82\x1F\x00\e\n\x9B\xE4XY\b\x9C_`\xE9\xCC\xBF\xAF\xB8\xF0\xF4\x1A\xB3\x1F)\xA1" }

      it "should set the key" do
        (cipher.update(cipher_text) + cipher.final).should == clear_text
      end

      context "when :iv is set" do
        let(:iv)     { '0123456789abcdef' }
        let(:cipher) { subject.cipher(name, mode: :decrypt, key: key, iv: iv) }

        let(:cipher_text) { "\x00\xA0\xFE\x9C\xD3\x81I\xD5\x9E\x7Fq\x87\xB9\xC6\xB5\xDF\xA9T\xD0\xA5\xC5)\x0E\x0E\xCE\xA5\xAF!f\xC5\xB3a" }

        it "should set the IV" do
          (cipher.update(cipher_text) + cipher.final).should == clear_text
        end
      end
    end

    context "when :password and :hash are given" do
      let(:cipher) do
        subject.cipher(name, mode:     :decrypt, 
                             password: password,
                             hash:     :md5)
      end

      let(:clear_text)  { 'the quick brown fox' }
      let(:cipher_text) { "O\xA2\xE7\xEF\x84\xF0\xA2\x82\x1F\x00\e\n\x9B\xE4XY\b\x9C_`\xE9\xCC\xBF\xAF\xB8\xF0\xF4\x1A\xB3\x1F)\xA1" }

      it "should set the key" do
        (cipher.update(cipher_text) + cipher.final).should == clear_text
      end
    end
  end
end
