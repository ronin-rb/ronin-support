# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/format/binary/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#unpack" do
    expect(subject).to respond_to(:unpack)
  end

  it "must provide String#zlib_inflate" do
    expect(subject).to respond_to(:zlib_inflate)
  end

  it "must provide String#zlib_deflate" do
    expect(subject).to respond_to(:zlib_deflate)
  end

  it "must provide String#hex_encode" do
    expect(subject).to respond_to(:hex_encode)
  end

  it "must provide String#hex_decode" do
    expect(subject).to respond_to(:hex_decode)
  end

  it "must provide String#hex_unescape" do
    expect(subject).to respond_to(:hex_unescape)
  end

  it "must provide String#xor" do
    expect(subject).to respond_to(:xor)
  end

  describe "#base64_encode" do
    subject { "hello\0" }

    it "must base64 encode a String" do
      expect(subject.base64_encode).to eq("aGVsbG8A\n")
    end
  end

  describe "#base64_decode" do
    subject { "aGVsbG8A\n" }

    it "must base64 decode a String" do
      expect(subject.base64_decode).to eq("hello\0")
    end
  end

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

  describe "#hex_encode" do
    subject { "hello\x4e" }

    it "must hex encode a String" do
      expect(subject.hex_encode).to eq("68656c6c6f4e")
    end
  end

  describe "#hex_decode" do
    subject { "68656c6c6f4e" }

    it "must hex decode a String" do
      expect(subject.hex_decode).to eq("hello\x4e")
    end
  end

  describe "#hex_escape" do
    subject { "hello\x4e" }

    it "must hex escape a String" do
      expect(subject.hex_escape).to eq("\\x68\\x65\\x6c\\x6c\\x6f\\x4e")
    end
  end
end
