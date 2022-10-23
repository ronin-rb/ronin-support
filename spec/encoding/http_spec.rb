require 'spec_helper'
require 'ronin/support/encoding/http'

describe Ronin::Support::Encoding::HTTP do
  describe ".encode_byte" do
    let(:byte)         { 0x20  }
    let(:encoded_byte) { '%20' }

    it "must HTTP encode the byte as '%XX'" do
      expect(subject.encode_byte(byte)).to eq(encoded_byte)
    end

    context "when given a byte below 0x10" do
      let(:byte)         { 0x01  }
      let(:encoded_byte) { '%01' }

      it "must zero-pad the escaped character to ensure two digits" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end
    end
  end

  describe ".escape_byte" do
    context "when the byte is a printable ASCII character" do
      let(:byte) { 0x41 }

      it "must return the character form of the byte" do
        expect(subject.escape_byte(byte)).to eq(byte.chr)
      end
    end

    context "when the byte is a non-printable ASCII character" do
      let(:byte)         { 0xff }
      let(:escaped_byte) { '%FF'  }

      it "must HTTP escape the byte" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when the byte is a reserved character" do
      let(:byte)         { 0x20 }
      let(:escaped_byte) { '+'  }

      it "must HTTP escape the byte" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end
  end

  describe ".escape" do
    let(:data)         { "mod % 3"   }
    let(:http_escaped) { "mod+%25+3" }

    it "must escape special characters as '%XX'" do
      expect(subject.escape(data)).to eq(http_escaped)
    end
  end

  describe "#unescape" do
    let(:data)           { "mod %25 3" }
    let(:http_unescaped) { "mod % 3"   }

    it "must unescape '%XX' characters" do
      expect(subject.unescape(data)).to eq(http_unescaped)
    end
  end

  describe ".encode" do
    let(:data)         { "mod % 3" }
    let(:http_encoded) { "%6D%6F%64%20%25%20%33" }

    it "must format each byte of the String" do
      expect(subject.encode(data)).to eq(http_encoded)
    end
  end

  describe ".encode" do
    let(:data)         { "ABC" }
    let(:http_encoded) { "%41%42%43" }

    it "must encode each byte of the String" do
      expect(subject.encode(data)).to eq(http_encoded)
    end
  end
end
