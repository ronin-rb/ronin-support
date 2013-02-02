require 'spec_helper'
require 'ronin/crypto/extensions/file'

require 'tempfile'

describe File do
  let(:clear_text) { 'the quick brown fox' }

  subject { described_class }

  it { should respond_to(:hmac)    }
  it { should respond_to(:encrypt) }
  it { should respond_to(:decrypt) }

  describe "#hmac" do
    let(:key)  { 'secret' }
    let(:hash) { 'cf5073193fae1bfdaa1b31355076f99bfb249f51' }

    let(:path) { Tempfile.new('ronin-support').path }

    before(:all) { File.write(path,clear_text) }

    it "should calculate the HMAC of the file" do
      subject.hmac(path,key).should == hash
    end

    context "when digest is not given" do
      let(:digest)      { :md5 }
      let(:digest_hash) { '8319187ae2b6c1623205354d8f5d1a6e' }

      it "should use the digest when calculating the HMAC" do
        subject.hmac(path,key,digest).should == digest_hash
      end
    end
  end

  describe "#encrypt" do
    let(:cipher)   { 'aes-256-cbc' }
    let(:password) { 'secret' }

    let(:cipher_text) { "\xC8+\xE3\x05\xD3\xBE\xC6d\x0F=N\x90\xB9\x87\xD8bk\x1C#0\x96`4\xBC\xB1\xB5tD\xF3\x98\xAD`" }

    let(:path)       { Tempfile.new('ronin-support').path }

    before(:all) { File.write(path,clear_text) }

    it "should encrypt the String with the cipher and key" do
      subject.encrypt(path,cipher, password: password).should == cipher_text
    end

    context "when given a block" do
      it "should yield each encrypted block" do
        output = ''

        subject.encrypt(path,cipher, password: password) do |block|
          output << block
        end

        output.should == cipher_text
      end
    end
  end

  describe "#decrypt" do
    let(:cipher)   { 'aes-256-cbc' }
    let(:password) { 'secret'      }
    let(:cipher_text) { "\xC8+\xE3\x05\xD3\xBE\xC6d\x0F=N\x90\xB9\x87\xD8bk\x1C#0\x96`4\xBC\xB1\xB5tD\xF3\x98\xAD`" }

    let(:path) { Tempfile.new('ronin-support').path }

    before(:all) { File.write(path,cipher_text) }

    it "should decrypt the String with the cipher and key" do
      subject.decrypt(path,cipher, password: password).should == clear_text
    end

    context "when given a block" do
      it "should yield each decrypted block" do
        output = ''

        subject.decrypt(path,cipher, password: password) do |block|
          output << block
        end

        output.should == clear_text
      end
    end
  end
end
