require 'spec_helper'
require 'ronin/support/encoding/html/core_ext/string'

describe String do
  subject { "one & two" }

  it "must provide String#html_escape" do
    should respond_to(:html_escape)
  end

  it "must provide String#html_unescape" do
    should respond_to(:html_unescape)
  end

  it "must provide String#html_encode" do
    should respond_to(:html_encode)
  end

  describe "#html_escape" do
    let(:html_escaped) { "one &amp; two" }

    it "must HTML escape itself" do
      expect(subject.html_escape).to eq(html_escaped)
    end

    context "when the String contains invalid byte sequences" do
      subject { "one & two\xfe\xff" }

      let(:html_escaped) do
        "one &amp; two\xfe\xff".force_encoding(Encoding::ASCII_8BIT)
      end

      it "must HTML escape each byte in the String" do
        expect(subject.html_escape).to eq(html_escaped)
      end
    end

    context "when `case: :upper` is given" do
      let(:html_escaped) { "one &AMP; two" }

      it "must use uppercase HTML escaped characters" do
        expect(subject.html_escape(case: :upper)).to eq(html_escaped)
      end
    end
  end

  describe "#html_unescape" do
    let(:html_escaped) { "one &amp; two" }

    it "must HTML unescape itself" do
      expect(html_escaped.html_unescape).to eq(subject)
    end

    context "when the String contains HTML decimal escape characters" do
      let(:html_escaped) do
        "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
      end

      it "must HTML unescape the String" do
        expect(html_escaped.html_unescape).to eq(subject)
      end

      context "and the characters are zero-padded" do
        let(:html_escaped) do
          "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
        end

        it "must HTML unescape the String" do
          expect(html_escaped.html_unescape).to eq(subject)
        end
      end
    end

    context "when the String contains HTML hex escape characters" do
      let(:html_escaped) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must HTML unescape the String" do
        expect(html_escaped.html_unescape).to eq(subject)
      end

      context "and the characters are zero-padded" do
        let(:html_escaped) do
          "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must HTML unescape the String" do
          expect(html_escaped.html_unescape).to eq(subject)
        end
      end
    end
  end

  describe "#html_encode" do
    let(:encoded_html) do
      "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
    end

    it "must HTML format all chars" do
      expect(subject.html_encode).to eq(encoded_html)
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:encoded_html) { "&#104;&#101;&#108;&#108;&#111;&#254;&#255;" }

      it "must HTML encode each byte in the String" do
        expect(subject.html_encode).to eq(encoded_html)
      end
    end

    context "when also given `format: :hex`" do
      let(:encoded_html) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must encode the String with '&#xXX' HTML escaped characters" do
        expect(subject.html_encode(format: :hex)).to eq(encoded_html)
      end

      context "and when `case: :upper` is given" do
        let(:encoded_html) do
          "&#X6F;&#X6E;&#X65;&#X20;&#X26;&#X20;&#X74;&#X77;&#X6F;"
        end

        it "must encode the String with '&#Xxx' HTML escaped characters" do
          expect(subject.html_encode(format: :hex, case: :upper)).to eq(encoded_html)
        end

        context "and when `zero_pad: true` is given" do
          let(:encoded_html) do
            "&#X000006F;&#X000006E;&#X0000065;&#X0000020;&#X0000026;&#X0000020;&#X0000074;&#X0000077;&#X000006F;"
          end

          it "must encode the String with '&#X00000xx' HTML escaped characters" do
            expect(subject.html_encode(format: :hex, case: :upper, zero_pad: true)).to eq(encoded_html)
          end
        end
      end

      context "and when `zero_pad: true` is given" do
        let(:encoded_html) do
          "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must encode the String with '&#X00000xx' HTML escaped characters" do
          expect(subject.html_encode(format: :hex, zero_pad: true)).to eq(encoded_html)
        end
      end
    end

    context "when also given `zero_pad: true`" do
      let(:encoded_html) do
        "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
      end

      it "must encode the String with '&#00000DD' HTML escaped characters" do
        expect(subject.html_encode(zero_pad: true)).to eq(encoded_html)
      end
    end
  end

  describe "#html_decode" do
    let(:html_escaped) { "one &amp; two" }

    it "must HTML unescape the String" do
      expect(html_escaped.html_decode).to eq(subject)
    end

    context "when the String contains HTML decimal escape characters" do
      let(:html_escaped) do
        "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
      end

      it "must HTML unescape the String" do
        expect(html_escaped.html_decode).to eq(subject)
      end

      context "and the characters are zero-padded" do
        let(:html_escaped) do
          "&#0000111;&#0000110;&#0000101;&#0000032;&#0000038;&#0000032;&#0000116;&#0000119;&#0000111;"
        end

        it "must HTML unescape the String" do
          expect(html_escaped.html_decode).to eq(subject)
        end
      end
    end

    context "when the String contains HTML hex escape characters" do
      let(:html_escaped) do
        "&#x6f;&#x6e;&#x65;&#x20;&#x26;&#x20;&#x74;&#x77;&#x6f;"
      end

      it "must HTML unescape the String" do
        expect(html_escaped.html_decode).to eq(subject)
      end

      context "and the characters are zero-padded" do
        let(:html_escaped) do
          "&#x000006f;&#x000006e;&#x0000065;&#x0000020;&#x0000026;&#x0000020;&#x0000074;&#x0000077;&#x000006f;"
        end

        it "must HTML unescape the String" do
          expect(html_escaped.html_decode).to eq(subject)
        end
      end
    end
  end
end
