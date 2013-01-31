require 'spec_helper'
require 'ronin/crypto/extensions/string'

describe String do
  subject { "hello" }

  it { should respond_to(:hmac)    }
  it { should respond_to(:encrypt) }
  it { should respond_to(:decrypt) }

  describe "#hmac" do
    let(:key)    { "secret" }
    let(:digest) { :md5 }

    it "should calculate the HMAC of the String" do
      subject.hmac(key,digest).should == "bade63863c61ed0b3165806ecd6acefc"
    end

    context "when digest is not given" do
      it "should default to using SHA1" do
        subject.hmac(key).should == "5112055c05f944f85755efc5cd8970e194e9f45b"
      end
    end
  end

  describe "#encrypt" do
    let(:cipher) { 'aes-256-cbc' }
    let(:key)    { Digest::MD5.hexdigest('secret') }

    it "should encrypt the String with the cipher and key" do
      subject.encrypt(cipher,key).should == "\x8B\xDCx\x90[\x83M\x9A\x8F\x159\x1Fi\x95\xDA\xD9"
    end

    context "when iv is given" do
      let(:iv) { '1234567890abcdef' }

      it "should encrypt the String using the given IV" do
        subject.encrypt(cipher,key,iv).should == "`\xED\x85\xF7\xA5\xE3W8#/\xDB3\xE3\x83\x82-"
      end
    end
  end

  describe "#decrypt" do
    let(:cipher) { 'aes-256-cbc' }
    let(:key)    { Digest::MD5.hexdigest('secret') }

    subject { "\x8B\xDCx\x90[\x83M\x9A\x8F\x159\x1Fi\x95\xDA\xD9" }

    it "should decrypt the String with the cipher and key" do
      subject.decrypt(cipher,key).should == "hello"
    end

    context "when iv is given" do
      let(:iv) { '1234567890abcdef' }

      subject { "`\xED\x85\xF7\xA5\xE3W8#/\xDB3\xE3\x83\x82-" }

      it "should decrypt the String using the given IV" do
        subject.decrypt(cipher,key,iv).should == "hello"
      end
    end
  end
end
