require 'spec_helper'
require 'ronin/support/encoding/xml/core_ext/string'

describe String do
  subject { "one & two" }

  it "must provide String#xml_escape" do
    should respond_to(:xml_escape)
  end

  it "must provide String#xml_unescape" do
    should respond_to(:xml_unescape)
  end

  it "must provide String#xml_encode" do
    should respond_to(:xml_encode)
  end

  describe "#xml_escape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must XML escape itself" do
      expect(subject.xml_escape).to eq(xml_escaped)
    end

    context "when the String contains invalid byte sequences" do
      subject { "one & two\xfe\xff" }

      let(:xml_escaped) do
        "one &amp; two\xfe\xff".force_encoding(Encoding::ASCII_8BIT)
      end

      it "must XML escape each byte in the String" do
        expect(subject.xml_escape).to eq(xml_escaped)
      end
    end

    context "when `case: :upper` is given" do
      let(:xml_escaped) { "one &AMP; two" }

      it "must use uppercase XML escaped characters" do
        expect(subject.xml_escape(case: :upper)).to eq(xml_escaped)
      end
    end
  end

  describe "#xml_unescape" do
    let(:xml_escaped) { "one &amp; two" }

    it "must XML unescape itself" do
      expect(xml_escaped.xml_unescape).to eq(subject)
    end

    context "when the String contains XML decimal escape characters" do
      let(:xml_escaped) do
        "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
      end

      it "must XML unescape the String" do
        expect(xml_escaped.xml_unescape).to eq(subject)
      end

      context "and the characters are zero-padded" do
        let(:xml_escaped) do
          "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
        end

        it "must XML unescape the String" do
          expect(xml_escaped.xml_unescape).to eq(subject)
        end
      end
    end

    context "when the String contains XML hex escape characters" do
      let(:xml_escaped) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must XML unescape the String" do
        expect(xml_escaped.xml_unescape).to eq(subject)
      end

      context "and the characters are zero-padded" do
        let(:xml_escaped) do
          "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must XML unescape the String" do
          expect(xml_escaped.xml_unescape).to eq(subject)
        end
      end
    end
  end

  describe "#xml_encode" do
    let(:encoded_xml) do
      "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
    end

    it "must XML format all chars" do
      expect(subject.xml_encode).to eq(encoded_xml)
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:encoded_xml) { "&#104;&#101;&#108;&#108;&#111;&#254;&#255;" }

      it "must XML encode each byte in the String" do
        expect(subject.xml_encode).to eq(encoded_xml)
      end
    end

    context "when also given `format: :hex`" do
      let(:encoded_xml) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must encode the String with '&#xXX' XML escaped characters" do
        expect(subject.xml_encode(format: :hex)).to eq(encoded_xml)
      end

      context "and when `case: :upper` is given" do
        let(:encoded_xml) do
          "&#X6F;&#X6E;&#X65;&#X20;&#X26;&#X20;&#X74;&#X77;&#X6F;"
        end

        it "must encode the String with '&#Xxx' XML escaped characters" do
          expect(subject.xml_encode(format: :hex, case: :upper)).to eq(encoded_xml)
        end

        context "and when `zero_pad: true` is given" do
          let(:encoded_xml) do
            "&#X000006F;&#X000006E;&#X0000065;&#X0000020;&#X0000026;&#X0000020;&#X0000074;&#X0000077;&#X000006F;"
          end

          it "must encode the String with '&#X00000xx' XML escaped characters" do
            expect(subject.xml_encode(format: :hex, case: :upper, zero_pad: true)).to eq(encoded_xml)
          end
        end
      end

      context "and when `zero_pad: true` is given" do
        let(:encoded_xml) do
          "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must encode the String with '&#X00000xx' XML escaped characters" do
          expect(subject.xml_encode(format: :hex, zero_pad: true)).to eq(encoded_xml)
        end
      end
    end

    context "when also given `zero_pad: true`" do
      let(:encoded_xml) do
        "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
      end

      it "must encode the String with '&#00000DD' XML escaped characters" do
        expect(subject.xml_encode(zero_pad: true)).to eq(encoded_xml)
      end
    end
  end
end
