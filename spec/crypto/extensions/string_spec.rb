require 'spec_helper'
require 'ronin/crypto/extensions/string'

describe String do
  subject { 'the quick brown fox' }

  it { should respond_to(:hmac)    }
  it { should respond_to(:encrypt) }
  it { should respond_to(:decrypt) }

  describe "#hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    it "should calculate the HMAC of the String" do
      subject.hmac(key).should == hash
    end

    context "when digest is not given" do
      let(:digest)      { :md5 }
      let(:digest_hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "should default to using SHA1" do
        subject.hmac(key,digest).should == digest_hash
      end
    end
  end

  describe "#encrypt" do
    let(:cipher)   { 'aes-256-cbc' }
    let(:password) { 'secret' }

    let(:cipher_text) { "\xC8+\xE3\x05\xD3\xBE\xC6d\x0F=N\x90\xB9\x87\xD8bk\x1C#0\x96`4\xBC\xB1\xB5tD\xF3\x98\xAD`" }

    it "should encrypt the String with the cipher and key" do
      subject.encrypt(cipher, password: password).should == cipher_text
    end
  end

  describe "#decrypt" do
    let(:cipher)   { 'aes-256-cbc' }
    let(:password) { 'secret'      }

    let(:cipher_text) { "\xC8+\xE3\x05\xD3\xBE\xC6d\x0F=N\x90\xB9\x87\xD8bk\x1C#0\x96`4\xBC\xB1\xB5tD\xF3\x98\xAD`" }

    it "should decrypt the String with the cipher and key" do
      cipher_text.decrypt(cipher, password: password).should == subject
    end
  end
end
