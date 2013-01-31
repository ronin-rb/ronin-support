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

    it "should return a new OpenSSL::Cipher" do
      subject.cipher(name).should be_kind_of(OpenSSL::Cipher)
    end
  end
end
