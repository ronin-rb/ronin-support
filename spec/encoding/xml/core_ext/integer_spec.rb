require 'spec_helper'
require 'ronin/support/encoding/xml/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it "must provide Integer#xml_escape" do
    should respond_to(:xml_escape)
  end

  it "must provide Integer#xml_encode" do
    should respond_to(:xml_encode)
  end

  describe "#xml_escape" do
    let(:xml_escaped) { "&amp;" }

    it "must XML escape itself" do
      expect(subject.xml_escape).to eq(xml_escaped)
    end

    context "when the Integer is an unprintable ASCII character" do
      subject { 0xff }

      let(:escaped_byte) { "\xff".force_encoding(Encoding::ASCII_8BIT) }

      it "must return the ASCII character version of itself" do
        expect(subject.xml_escape).to eq(escaped_byte)
      end
    end

    context "when the Integer is 0x26" do
      subject { 0x22 }

      let(:escaped_byte) { '&quot;' }

      it "must return '&quote;'" do
        expect(subject.xml_escape).to eq(escaped_byte)
      end

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&QUOT;' }

        it "must return '&QUOT;'" do
          expect(subject.xml_escape(case: :upper)).to eq(escaped_byte)
        end
      end
    end

    context "when the Integer is 0x26" do
      subject { 0x26 }

      let(:escaped_byte) { '&amp;' }

      it "must return '%amp;'" do
        expect(subject.xml_escape).to eq(escaped_byte)
      end

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&AMP;' }

        it "must return '&AMP;'" do
          expect(subject.xml_escape(case: :upper)).to eq(escaped_byte)
        end
      end
    end

    context "when the Integer is 0x27" do
      subject { 0x27 }

      let(:escaped_byte) { '&#39;' }

      it "must return '&#39;'" do
        expect(subject.xml_escape).to eq(escaped_byte)
      end
    end

    context "when the Integer is 0x3c" do
      subject { 0x3c }

      let(:escaped_byte) { '&lt;' }

      it "must return '&lt;'" do
        expect(subject.xml_escape).to eq(escaped_byte)
      end

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&LT;' }

        it "must return '&LT;'" do
          expect(subject.xml_escape(case: :upper)).to eq(escaped_byte)
        end
      end
    end

    context "when the Integer is 0x3e" do
      subject { 0x3e }

      let(:escaped_byte) { '&gt;' }

      it "must return '&gt;'" do
        expect(subject.xml_escape).to eq(escaped_byte)
      end

      context "and when `case: :upper` is given" do
        let(:escaped_byte) { '&GT;' }

        it "must return '&GT;'" do
          expect(subject.xml_escape(case: :upper)).to eq(escaped_byte)
        end
      end
    end

    context "when given a byte greater than 0xff" do
      subject { 0x100 }

      let(:escaped_byte) { subject.chr(Encoding::UTF_8) }

      it "must return the UTF-8 character for itself" do
        expect(subject.xml_escape).to eq(escaped_byte)
      end
    end

    context "when given the `case:` keyword argument with another value" do
      subject { 0xff }

      it do
        expect {
          subject.xml_escape(case: :foo)
        }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
      end
    end
  end

  describe "#xml_encode" do
    context "when the Integer is a printable ASCII character" do
      subject { 0x41 }
      let(:encoded_xml) { "&#65;" }

      it "must XML encode the character as a XML special character" do
        expect(subject.xml_encode).to eq(encoded_xml)
      end
    end

    context "when the Integer is an unprintable ASCII character" do
      subject { 0xff }
      let(:encoded_byte) { "&#255;" }

      it "must XML encode the character as a XML special character" do
        expect(subject.xml_encode).to eq(encoded_byte)
      end
    end

    context "when the Integer is 0x22" do
      subject { 0x22 }
      let(:encoded_byte) { '&#34;' }

      it "must return '&#34;'" do
        expect(subject.xml_encode).to eq(encoded_byte)
      end
    end

    context "when the Integer is 0x26" do
      subject { 0x26 }
      let(:encoded_byte) { '&#38;' }

      it "must return '&#38;'" do
        expect(subject.xml_encode).to eq(encoded_byte)
      end
    end

    context "when the Integer is 0x27" do
      subject { 0x27 }
      let(:encoded_byte) { '&#39;' }

      it "must return '&#39;'" do
        expect(subject.xml_encode).to eq(encoded_byte)
      end
    end

    context "when the Integer is 0x3c" do
      subject { 0x3c }
      let(:encoded_byte) { '&#60;' }

      it "must return '&#60;'" do
        expect(subject.xml_encode).to eq(encoded_byte)
      end
    end

    context "when the Integer is 0x3e" do
      subject { 0x3e }
      let(:encoded_byte) { '&#62;' }

      it "must return '&#62;'" do
        expect(subject.xml_encode).to eq(encoded_byte)
      end
    end

    context "when given a byte greater than 0xff" do
      subject { 0x100 }
      let(:encoded_byte) { "&#256;" }

      it "must return the UTF-8 character as an XML escaped character" do
        expect(subject.xml_encode).to eq(encoded_byte)
      end

      context "when also given `zero_pad: true`" do
        subject { 0x100 }
        let(:encoded_byte) { "&#0000256;" }

        it "must zero-pad the XML escaped decimal character up to seven digits" do
          expect(subject.xml_encode(zero_pad: true)).to eq(encoded_byte)
        end
      end
    end

    context "when also given `format: :hex`" do
      subject { 0xff }
      let(:encoded_byte) { "&#xff;" }

      it "must encode the Integer as '&#xXX' XML escaped characters" do
        expect(subject.xml_encode(format: :hex)).to eq(encoded_byte)
      end

      context "and when `case: :upper` is given" do
        let(:encoded_byte) { "&#XFF;" }

        it "must encode the Integer as '&#Xxx' XML escaped characters" do
          expect(subject.xml_encode(format: :hex, case: :upper)).to eq(encoded_byte)
        end

        context "and when `zero_pad: true` is given" do
          let(:encoded_byte) { "&#X00000FF;" }

          it "must encode the Integer as '&#X00000xx' XML escaped characters" do
            expect(subject.xml_encode(format: :hex, case: :upper, zero_pad: true)).to eq(encoded_byte)
          end
        end
      end

      context "when given the `case:` keyword argument with another value" do
        subject { 0xff }

        it do
          expect {
            subject.xml_encode(format: :hex, case: :foo)
          }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
        end
      end

      context "and when `zero_pad: true` is given" do
        let(:encoded_byte) { "&#x00000ff;" }

        it "must encode the Integer as '&#X00000xx' XML escaped characters" do
          expect(subject.xml_encode(format: :hex, zero_pad: true)).to eq(encoded_byte)
        end
      end
    end

    context "when also given `format:` with another value" do
      subject { 0xff }

      let(:format) { :foo }

      it do
        expect {
          subject.xml_encode(format: format)
        }.to raise_error(ArgumentError,"format (#{format.inspect}) must be :decimal or :hex")
      end
    end

    context "when also given `zero_pad: true`" do
      subject { 0x41 }

      let(:encoded_byte) { "&#0000065;" }

      it "must encode the Integer as '&#00000DD' XML escaped characters" do
        expect(subject.xml_encode(zero_pad: true)).to eq(encoded_byte)
      end
    end
  end
end
