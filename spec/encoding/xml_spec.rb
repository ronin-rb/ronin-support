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

    context "when the byte is 0x22" do
      let(:byte)         { 0x22     }
      let(:escaped_byte) { '&quot;' }

      it "must return '&quote;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&QUOT;' }

        it "must return '&QUOT;'" do
          expect(subject.escape_byte(byte, case: :upper)).to eq(escaped_byte)
        end
      end
    end

    context "when the byte is 0x26" do
      let(:byte)         { 0x26    }
      let(:escaped_byte) { '&amp;' }

      it "must return '&amp;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&AMP;' }

        it "must return '&AMP;'" do
          expect(subject.escape_byte(byte, case: :upper)).to eq(escaped_byte)
        end
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

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&LT;' }

        it "must return '&LT;'" do
          expect(subject.escape_byte(byte, case: :upper)).to eq(escaped_byte)
        end
      end
    end

    context "when the byte is 0x3e" do
      let(:byte)         { 0x3e   }
      let(:escaped_byte) { '&gt;' }

      it "must return '&gt;'" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&GT;' }

        it "must return '&GT;'" do
          expect(subject.escape_byte(byte, case: :upper)).to eq(escaped_byte)
        end
      end
    end

    context "when given a byte greater than 0xff" do
      let(:byte)         { 0x100 }
      let(:escaped_byte) { byte.chr(Encoding::UTF_8) }

      it "must return the UTF-8 character for the byte" do
        expect(subject.escape_byte(byte)).to eq(escaped_byte)
      end
    end

    context "when given the `case:` keyword argument with another value" do
      let(:byte) { 0xff }

      it do
        expect {
          subject.escape_byte(byte, case: :foo)
        }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
      end
    end
  end

  describe ".encode_byte" do
    context "when the byte is a printable ASCII character" do
      let(:byte)        { 0x41    }
      let(:encoded_xml) { "&#65;" }

      it "must XML encode the character as a XML special character" do
        expect(subject.encode_byte(byte)).to eq(encoded_xml)
      end
    end

    context "when the byte is an unprintable ASCII character" do
      let(:byte)         { 0xff     }
      let(:encoded_byte) { "&#255;" }

      it "must XML encode the character as a XML special character" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end
    end

    context "when the byte is 0x22" do
      let(:byte)         { 0x22    }
      let(:encoded_byte) { '&#34;' }

      it "must return '&#34;'" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end
    end

    context "when the byte is 0x26" do
      let(:byte)         { 0x26    }
      let(:encoded_byte) { '&#38;' }

      it "must return '&#38;'" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end
    end

    context "when the byte is 0x27" do
      let(:byte)         { 0x27    }
      let(:encoded_byte) { '&#39;' }

      it "must return '&#39;'" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end
    end

    context "when the byte is 0x3c" do
      let(:byte)         { 0x3c    }
      let(:encoded_byte) { '&#60;' }

      it "must return '&#60;'" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end
    end

    context "when the byte is 0x3e" do
      let(:byte)         { 0x3e    }
      let(:encoded_byte) { '&#62;' }

      it "must return '&#62;'" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end
    end

    context "when given a byte greater than 0xff" do
      let(:byte)         { 0x100    }
      let(:encoded_byte) { "&#256;" }

      it "must return the UTF-8 character as an XML escaped character" do
        expect(subject.encode_byte(byte)).to eq(encoded_byte)
      end

      context "when also given `zero_pad: true`" do
        let(:byte)         { 0x100        }
        let(:encoded_byte) { "&#0000256;" }

        it "must zero-pad the XML escaped decimal character up to seven digits" do
          expect(subject.encode_byte(byte, zero_pad: true)).to eq(encoded_byte)
        end
      end
    end

    context "when also given `format: :hex`" do
      let(:byte)         { 0xff     }
      let(:encoded_byte) { "&#xff;" }

      it "must encode the byte as '&#xXX' XML escaped characters" do
        expect(subject.encode_byte(byte, format: :hex)).to eq(encoded_byte)
      end

      context "and when `case: :upper` is given" do
        let(:encoded_byte) { "&#XFF;" }

        it "must encode the byte as '&#Xxx' XML escaped characters" do
          expect(subject.encode_byte(byte, format: :hex, case: :upper)).to eq(encoded_byte)
        end

        context "and when `zero_pad: true` is given" do
          let(:encoded_byte) { "&#X00000FF;" }

          it "must encode the byte as '&#X00000xx' XML escaped characters" do
            expect(subject.encode_byte(byte, format: :hex, case: :upper, zero_pad: true)).to eq(encoded_byte)
          end
        end
      end

      context "when given the `case:` keyword argument with another value" do
        let(:byte) { 0xff }

        it do
          expect {
            subject.encode_byte(byte, format: :hex, case: :foo)
          }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
        end
      end

      context "and when `zero_pad: true` is given" do
        let(:encoded_byte) { "&#x00000ff;" }

        it "must encode the byte as '&#x00000xx' XML escaped characters" do
          expect(subject.encode_byte(byte, format: :hex, zero_pad: true)).to eq(encoded_byte)
        end
      end
    end

    context "when also given `format:` with another value" do
      let(:byte)   { 0xff }
      let(:format) { :foo }

      it do
        expect {
          subject.encode_byte(byte, format: format)
        }.to raise_error(ArgumentError,"format (#{format.inspect}) must be :decimal or :hex")
      end
    end

    context "when also given `zero_pad: true`" do
      let(:byte)         { 0x41         }
      let(:encoded_byte) { "&#0000065;" }

      it "must encode the byte as '&#00000DD' XML escaped characters" do
        expect(subject.encode_byte(byte, zero_pad: true)).to eq(encoded_byte)
      end
    end
  end

  let(:data) { "one & two" }

  describe ".escape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must XML escape the String" do
      expect(subject.escape(data)).to eq(xml_escaped)
    end

    context "when the String contains invalid byte sequences" do
      let(:data)        { "one & two\xfe\xff" }
      let(:xml_escaped) do
        "one &amp; two\xfe\xff".force_encoding(Encoding::ASCII_8BIT)
      end

      it "must XML escape each byte in the String" do
        expect(subject.escape(data)).to eq(xml_escaped)
      end
    end

    context "when `case: :upper` is given" do
      let(:xml_escaped) { "one &AMP; two" }

      it "must use uppercase XML escaped characters" do
        expect(subject.escape(data, case: :upper)).to eq(xml_escaped)
      end
    end
  end

  describe ".unescape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must XML unescape the String" do
      expect(subject.unescape(xml_escaped)).to eq(data)
    end

    context "when the String contains XML decimal escape characters" do
      let(:xml_escaped) do
        "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
      end

      it "must XML unescape the String" do
        expect(subject.unescape(xml_escaped)).to eq(data)
      end

      context "and the characters are zero-padded" do
        let(:xml_escaped) do
          "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
        end

        it "must XML unescape the String" do
          expect(subject.unescape(xml_escaped)).to eq(data)
        end
      end
    end

    context "when the String contains XML hex escape characters" do
      let(:xml_escaped) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must XML unescape the String" do
        expect(subject.unescape(xml_escaped)).to eq(data)
      end

      context "and the characters are zero-padded" do
        let(:xml_escaped) do
          "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must XML unescape the String" do
          expect(subject.unescape(xml_escaped)).to eq(data)
        end
      end
    end
  end

  describe ".encode" do
    let(:encoded_xml) do
      "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
    end

    it "must XML format all chars" do
      expect(subject.encode(data)).to eq(encoded_xml)
    end

    context "when the String contains invalid byte sequences" do
      let(:data)        { "hello\xfe\xff" }
      let(:encoded_xml) { "&#104;&#101;&#108;&#108;&#111;&#254;&#255;" }

      it "must XML encode each byte in the String" do
        expect(subject.encode(data)).to eq(encoded_xml)
      end
    end

    context "when also given `format: :hex`" do
      let(:encoded_xml) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must encode the String with '&#xXX' XML escaped characters" do
        expect(subject.encode(data, format: :hex)).to eq(encoded_xml)
      end

      context "and when `case: :upper` is given" do
        let(:encoded_xml) do
          "&#X6F;&#X6E;&#X65;&#X20;&#X26;&#X20;&#X74;&#X77;&#X6F;"
        end

        it "must encode the String with '&#Xxx' XML escaped characters" do
          expect(subject.encode(data, format: :hex, case: :upper)).to eq(encoded_xml)
        end

        context "and when `zero_pad: true` is given" do
          let(:encoded_xml) do
            "&#X000006F;&#X000006E;&#X0000065;&#X0000020;&#X0000026;&#X0000020;&#X0000074;&#X0000077;&#X000006F;"
          end

          it "must encode the String with '&#X00000xx' XML escaped characters" do
            expect(subject.encode(data, format: :hex, case: :upper, zero_pad: true)).to eq(encoded_xml)
          end
        end
      end

      context "and when `zero_pad: true` is given" do
        let(:encoded_xml) do
            "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must encode the String with '&#X00000xx' XML escaped characters" do
          expect(subject.encode(data, format: :hex, zero_pad: true)).to eq(encoded_xml)
        end
      end
    end

    context "when also given `zero_pad: true`" do
      let(:encoded_xml) do
        "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
      end

      it "must encode the String with '&#00000DD' XML escaped characters" do
        expect(subject.encode(data, zero_pad: true)).to eq(encoded_xml)
      end
    end
  end

  describe ".decode" do
    let(:xml_escaped) { "one &amp; two" }

    it "must XML unescape the String" do
      expect(subject.decode(xml_escaped)).to eq(data)
    end

    context "when the String contains XML decimal escape characters" do
      let(:xml_escaped) do
        "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
      end

      it "must XML unescape the String" do
        expect(subject.decode(xml_escaped)).to eq(data)
      end

      context "and the characters are zero-padded" do
        let(:xml_escaped) do
          "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
        end

        it "must XML unescape the String" do
          expect(subject.decode(xml_escaped)).to eq(data)
        end
      end
    end

    context "when the String contains XML hex escape characters" do
      let(:xml_escaped) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must XML unescape the String" do
        expect(subject.decode(xml_escaped)).to eq(data)
      end

      context "and the characters are zero-padded" do
        let(:xml_escaped) do
          "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must XML unescape the String" do
          expect(subject.decode(xml_escaped)).to eq(data)
        end
      end
    end
  end
end
