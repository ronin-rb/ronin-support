require 'spec_helper'
require 'ronin/formatting/digest'

describe String do
  subject { "hello" }

  it "should provide String#md5" do
    should respond_to(:md5)
  end

  it "should provide String#sha1" do
    should respond_to(:sha1)
  end

  it "should provide String#sha2" do
    should respond_to(:sha2)
  end

  it "should provide String#sha256" do
    should respond_to(:sha256)
  end

  it "should provide String#sha512" do
    should respond_to(:sha512)
  end

  it "should provide String#rmd160" do
    should respond_to(:rmd160)
  end

  describe "#md5" do
    subject { "test" }

    let(:digest_md5) { "098f6bcd4621d373cade4e832627b4f6" }

    it "should return the MD5 digest of itself" do
      subject.md5.should == digest_md5
    end
  end

  describe "#sha1" do
    subject { "test" }

    let(:digest_sha1) { "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3" }

    it "should return the SHA1 digest of itself" do
      subject.sha1.should == digest_sha1
    end
  end

  describe "#sha2" do
    subject { "test" }

    let(:digest_sha2) do
      "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
    end

    it "should return the SHA2 digest of itself" do
      subject.sha2.should == digest_sha2
    end
  end

  describe "#sha256" do
    subject { "test" }

    let(:digest_sha256) do
      "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
    end

    it "should return the SHA256 digest of itself" do
      subject.sha256.should == digest_sha256
    end
  end

  describe "#sha512" do
    subject { "test" }

    let(:digest_sha512) do
      "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"
    end

    it "should return the SHA512 digest of itself" do
      subject.sha512.should == digest_sha512
    end
  end

  describe "#rmd160" do
    subject { "test" }

    let(:digest_rmd160) { "5e52fee47e6b070565f74372468cdc699de89107" }

    it "should return the RMD160 digest of itself" do
      subject.rmd160.should == digest_rmd160
    end
  end
end
