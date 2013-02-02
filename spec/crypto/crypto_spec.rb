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
    let(:name) { 'aes-256-cbc' }
    let(:key)  { Digest::MD5.hexdigest('secret') }

    it "should return a new OpenSSL::Cipher" do
      subject.cipher(name).should be_kind_of(OpenSSL::Cipher)
    end

    pending "OpenSSL::Cipher#key does not exist" do
      it "should set the key" do
        subject.cipher(name,key: key).key.should == key
      end
    end

    pending "OpenSSL::Cipher#iv does not exist" do
      it "should iv should be nil by default" do
        subject.cipher(name,key: key).iv.should be_nil
      end
    end

    context "when iv is given" do
      let(:iv) { '1234567890abcdef' }

      pending "OpenSSL::Cipher#iv does not exist" do
        it "should set the iv" do
          subject.cipher(name, key: key, iv: iv).iv.should == iv
        end
      end
    end
  end
end
