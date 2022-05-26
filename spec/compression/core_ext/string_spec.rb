# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/compression/core_ext/string'

describe String do
  subject { "hello" }

  it { expect(subject).to respond_to(:zlib_inflate) }
  it { expect(subject).to respond_to(:zlib_deflate) }

  describe "#zlib_inflate" do
    subject do
      "x\xda3H\xb3H3MM6\xd354II\xd651K5\xd7M43N\xd4M\xb3\xb0L2O14423Mb\0\0\xc02\t\xae"
    end

    it "must inflate a zlib deflated String" do
      expect(subject.zlib_inflate).to eq("0f8f5ec6-14dc-46e7-a63a-f89b7d11265b\0")
    end
  end

  describe "#zlib_deflate" do
    subject { "hello" }

    it "must zlib deflate a String" do
      expect(subject.zlib_deflate).to eq("x\x9c\xcbH\xcd\xc9\xc9\a\0\x06,\x02\x15")
    end
  end

  describe "#gzip" do
    subject { "hello world\n" }

    it "must gzip the String" do
      expect(subject.gzip.gunzip).to eq(subject)
    end

    it "must return an ASCII 8bit encoded String" do
      expect(subject.gzip.encoding).to be(Encoding::ASCII_8BIT)
    end
  end

  describe "#gunzip" do
    subject { "\x1F\x8B\b\x00K\x05\x8Fb\x00\x03\xCBH\xCD\xC9\xC9W(\xCF/\xCAI\xE1\x02\x00-;\b\xAF\f\x00\x00\x00" }

    it "must gunzip the String" do
      expect(subject.gunzip).to eq("hello world\n")
    end
  end
end
