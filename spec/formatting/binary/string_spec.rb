require 'spec_helper'
require 'ronin/formatting/extensions/binary/string'

require 'ostruct'

describe String do
  subject { "hello" }

  it "should provide String#unpack_original" do
    should respond_to(:unpack_original)
  end

  it "should provide String#unpack" do
    should respond_to(:unpack)
  end

  it "should provide String#depack" do
    should respond_to(:depack)
  end

  it "should provide String#zlib_inflate" do
    should respond_to(:zlib_inflate)
  end

  it "should provide String#zlib_deflate" do
    should respond_to(:zlib_deflate)
  end

  it "should provide String#hex_unescape" do
    should respond_to(:hex_unescape)
  end

  it "should provide String#xor" do
    should respond_to(:xor)
  end

  it "should provide String#unhexdump" do
    should respond_to(:unhexdump)
  end

  describe "#unpack" do
    subject { "4\x12\x00\x00hello\0" }

    let(:data) { [0x1234, "hello"] }

    it "should unpack Strings using String#unpack template Strings" do
      subject.unpack('VZ*').should == data
    end

    it "should unpack Strings using a Binary::Template" do
      subject.unpack(:uint32_le, :string).should == data
    end
  end

  context "deprecated" do
    describe "#depack" do
      subject { 0x1337 }

      let(:i386) do
        OpenStruct.new(:endian => :little, :address_length => 4)
      end

      let(:ppc) do
        OpenStruct.new(:endian => :big, :address_length => 4)
      end

      let(:i386_packed_int)   { "7\023\000\000" }
      let(:i386_packed_short) { "7\023" }
      let(:i386_packed_long)  { "7\023\000\000" }
      let(:i386_packed_quad)  { "7\023\000\000\000\000\000\000" }

      let(:ppc_packed_int)   { "\000\000\0237" }
      let(:ppc_packed_short) { "\0237" }
      let(:ppc_packed_long)  { "\000\000\0237" }
      let(:ppc_packed_quad)  { "\000\000\000\000\000\000\0237" }

      it "should depack itself for a little-endian architecture" do
        i386_packed_int.depack(i386).should == subject
      end

      it "should depack itself as a short for a little-endian architecture" do
        i386_packed_short.depack(i386,2).should == subject
      end

      it "should depack itself as a long for a little-endian architecture" do
        i386_packed_long.depack(i386,4).should == subject
      end

      it "should depack itself as a quad for a little-endian architecture" do
        i386_packed_quad.depack(i386,8).should == subject
      end

      it "should depack itself for a big-endian architecture" do
        ppc_packed_int.depack(ppc).should == subject
      end

      it "should depack itself as a short for a big-endian architecture" do
        ppc_packed_short.depack(ppc,2).should == subject
      end

      it "should depack itself as a long for a big-endian architecture" do
        ppc_packed_long.depack(ppc,4).should == subject
      end

      it "should depack itself as a quad for a big-endian architecture" do
        ppc_packed_quad.depack(ppc,8).should == subject
      end

      it "should accept String#unpack template strings" do
        i386_packed_long.depack('L').should == [subject]
      end
    end
  end

  describe "#base64_encode" do
    subject { "hello\0" }

    it "should base64 encode a String" do
      subject.base64_encode.should == "aGVsbG8A\n"
    end
  end

  describe "#base64_decode" do
    subject { "aGVsbG8A\n" }

    it "should base64 decode a String" do
      subject.base64_decode.should == "hello\0"
    end
  end

  describe "#zlib_inflate" do
    subject do
      "x\xda3H\xb3H3MM6\xd354II\xd651K5\xd7M43N\xd4M\xb3\xb0L2O14423Mb\0\0\xc02\t\xae"
    end

    it "should inflate a zlib deflated String" do
      subject.zlib_inflate.should == "0f8f5ec6-14dc-46e7-a63a-f89b7d11265b\0"
    end
  end

  describe "#zlib_deflate" do
    subject { "hello" }

    it "should zlib deflate a String" do
      subject.zlib_deflate.should == "x\x9c\xcbH\xcd\xc9\xc9\a\0\x06,\x02\x15"
    end
  end

  describe "#hex_escape" do
    subject { "hello\x4e" }

    it "should hex escape a String" do
      subject.hex_escape.should == "\\x68\\x65\\x6c\\x6c\\x6f\\x4e"
    end
  end

  describe "#hex_unescape" do
    it "should unescape a normal String" do
      "hello".hex_unescape.should == "hello"
    end

    it "should unescape a hex String" do
      "\\x68\\x65\\x6c\\x6c\\x6f\\x4e".hex_unescape.should == "hello\x4e"
    end

    it "should unescape an octal String" do
      "hello\012".hex_unescape.should == "hello\n"
    end

    it "should unescape control characters" do
      "hello\\n".hex_unescape.should == "hello\n"
    end

    it "should unescape normal characters" do
      "hell\\o".hex_unescape.should == "hello"
    end
  end

  describe "#xor" do
    subject { 'hello' }

    let(:key) { 0x50 }
    let(:keys) { [0x50, 0x55] }

    it "should not contain the key used in the xor" do
      should_not include(key.chr)
    end

    it "should not equal the original string" do
      subject.xor(key).should_not == subject
    end

    it "should be able to be decoded with another xor" do
      subject.xor(key).xor(key).should == subject
    end

    it "should allow xoring against a single key" do
      subject.xor(key).should == "85<<?"
    end

    it "should allow xoring against multiple keys" do
      subject.xor(keys).should == "80<9?"
    end
  end

  describe "#unhexdump" do
    subject { "00000000  23 20 52 6f 6e 69 6e 20  53 75 70 70 6f 72 74 0a  |# Ronin Support.|\n00000010\n" }

    let(:raw) { "# Ronin Support\n" }

    it "should unhexdump a String" do
      subject.unhexdump.should == raw
    end
  end
end
