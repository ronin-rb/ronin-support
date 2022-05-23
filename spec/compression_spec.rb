require 'spec_helper'
require 'ronin/support/compression'

describe Ronin::Support::Compression do
  let(:zlib_uncompressed) { "hello" }
  let(:zlib_compressed) do
    "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15".force_encoding(Encoding::ASCII_8BIT)
  end

  describe "#zlib_inflate" do
    it "must inflate a zlib deflated String" do
      expect(subject.zlib_inflate(zlib_compressed)).to eq(zlib_uncompressed)
    end
  end

  describe "#zlib_deflate" do
    it "must zlib deflate a String" do
      expect(subject.zlib_deflate(zlib_uncompressed)).to eq(zlib_compressed)
    end
  end
end
