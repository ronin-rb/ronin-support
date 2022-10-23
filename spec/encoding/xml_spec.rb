require 'spec_helper'
require 'ronin/support/encoding/xml'

describe Ronin::Support::Encoding::XML do
  describe ".escape_byte" do
    context "when the byte is a printable ASCII character" do
      let(:byte)         { 0x41 }
      let(:escaped_byte) { 'A'  }

      it "must return the ASCII character version of the byte" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when the byte is an unprintable ASCII character" do
      let(:byte)         { 0xff }
      let(:escaped_byte) { "\xff".force_encoding(Encoding::ASCII_8BIT) }

      it "must return the ASCII character version of the byte" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when the byte is 0x26" do
      let(:byte)         { 0x22     }
      let(:escaped_byte) { '&quot;' }

      it "must return '&quote;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when the byte is 0x26" do
      let(:byte)         { 0x26    }
      let(:escaped_byte) { '&amp;' }

      it "must return '%amp;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when the byte is 0x27" do
      let(:byte)         { 0x27     }
      let(:escaped_byte) { '&#39;' }

      it "must return '&#39;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when the byte is 0x3c" do
      let(:byte)         { 0x3c   }
      let(:escaped_byte) { '&lt;' }

      it "must return '&lt;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when the byte is 0x3e" do
      let(:byte)         { 0x3e   }
      let(:escaped_byte) { '&gt;' }

      it "must return '&gt;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end
  end

  describe ".encode_byte" do
    let(:byte)        { 0x26    }
    let(:encoded_xml) { "&#38;" }

    it "must XML format all chars" do
      expect(subject.encode_byte(byte)).to eq(encoded_xml)
    end
  end

  let(:data) { "one & two" }

  describe ".escape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must HTML escape itself" do
      expect(subject.escape(data)).to eq(xml_escaped)
    end

    context "when the String contains invalid byte sequences" do
      let(:data)        { "one & two\xfe\xff"     }
      let(:xml_escaped) { "one &amp; two\xfe\xff" }

      it "must XML escape each byte in the String" do
        expect(subject.escape(data)).to eq(xml_escaped)
      end
    end
  end

  describe ".unescape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must HTML unescape itself" do
      expect(subject.unescape(data)).to eq(data)
    end
  end

  describe ".encode" do
    let(:encoded_xml) do
      "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
    end

    it "must HTML format all chars" do
      expect(subject.encode(data)).to eq(encoded_xml)
    end

    context "when the String contains invalid byte sequences" do
      let(:data)        { "hello\xfe\xff" }
      let(:encoded_xml) { "&#104;&#101;&#108;&#108;&#111;&#254;&#255;" }

      it "must XML encode each byte in the String" do
        expect(subject.encode(data)).to eq(encoded_xml)
      end
    end
  end
end
