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

    context "when given `case: :lower`" do
      let(:byte)         { 0xFF  }
      let(:http_encoded) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.encode_byte(byte, case: :lower)).to eq(http_encoded)
      end
    end

    context "when given `case: :upper`" do
      let(:byte)         { 0xFF  }
      let(:http_encoded) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.encode_byte(byte, case: :upper)).to eq(http_encoded)
      end
    end

    context "when given the `case:` keyword argument with another value" do
      let(:byte) { 0xFF  }

      it do
        expect {
          subject.encode_byte(byte, case: :foo)
        }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
      end
    end

    context "when given an Integer greater that 0xff" do
      let(:byte) { 0x100 }

      it do
        expect {
          subject.encode_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      let(:byte) { -1 }

      it do
        expect {
          subject.encode_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end
  end

  describe ".escape_byte" do
    [45, 46, *(48..57), *(65..90), 95, *(97..122), 126].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        let(:byte) { byte     }
        let(:char) { byte.chr }

        it "must return the ASCII character for the byte" do
          expect(subject.escape_byte(byte)).to eq(char)
        end
      end
    end

    context "when given the byte 0x20" do
      let(:byte) { 0x20 }

      it "must return '+'" do
        expect(subject.escape_byte(byte)).to eq('+')
      end
    end

    [*(0..31), *(33..44), 47, *(58..64), *(91..94), 96, *(123..125), *(127..255)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        let(:byte)        { byte             }
        let(:http_escaped) { "%%%.2X" % byte }

        it "must URI escape the Integer" do
          expect(subject.escape_byte(byte)).to eq(http_escaped)
        end
      end
    end

    context "when given `case: :lower`" do
      let(:byte)         { 0xFF  }
      let(:http_escaped) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.escape_byte(byte, case: :lower)).to eq(http_escaped)
      end
    end

    context "when given `case: :upper`" do
      let(:byte)         { 0xFF  }
      let(:http_escaped) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.escape_byte(byte, case: :upper)).to eq(http_escaped)
      end
    end

    context "when given the `case:` keyword argument with another value" do
      let(:byte) { 0xFF }

      it do
        expect {
          subject.escape_byte(byte, case: :foo)
        }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
      end
    end

    context "when given an Integer greater that 0xff" do
      let(:byte) { 0x100 }

      it do
        expect {
          subject.escape_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      let(:byte) { -1 }

      it do
        expect {
          subject.escape_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end
  end

  describe ".escape" do
    let(:data)         { "mod % 3"   }
    let(:http_escaped) { "mod+%25+3" }

    it "must escape special characters as '%XX'" do
      expect(subject.escape(data)).to eq(http_escaped)
    end

    context "when given `case: :lower`" do
      let(:data)         { "\xff" }
      let(:http_escaped) { '%ff'  }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.escape(data, case: :lower)).to eq(http_escaped)
      end
    end

    context "when given `case: :upper`" do
      let(:data)         { "\xff" }
      let(:http_escaped) { '%FF'  }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.escape(data, case: :upper)).to eq(http_escaped)
      end
    end

    context "when the String contains invalid byte sequences" do
      let(:data)         { "mod % 3\xfe\xff" }
      let(:http_escaped) { "mod+%25+3%FE%FF" }

      it "must HTTP escape each byte in the String" do
        expect(subject.escape(data)).to eq(http_escaped)
      end
    end
  end

  describe "#unescape" do
    let(:data)           { "mod+%25+3" }
    let(:http_unescaped) { "mod % 3"   }

    it "must unescape '+' and '%XX' characters" do
      expect(subject.unescape(data)).to eq(http_unescaped)
    end

    context "when the URI escaped characters contain lowercase hexadecimal" do
      let(:data)           { "%6d%6f%64%20%25%20%33" }
      let(:http_unescaped) { "mod % 3" }

      it "must unescape the lowercase hexadecimal escaped characters" do
        expect(subject.unescape(data)).to eq(http_unescaped)
      end
    end
  end

  describe ".encode" do
    let(:data)         { "mod % 3" }
    let(:http_encoded) { "%6D%6F%64%20%25%20%33" }

    it "must format each byte of the String" do
      expect(subject.encode(data)).to eq(http_encoded)
    end

    context "when given `case: :lower`" do
      let(:data)         { "\xff" }
      let(:http_encoded) { '%ff'  }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.encode(data, case: :lower)).to eq(http_encoded)
      end
    end

    context "when given `case: :upper`" do
      let(:data)         { "\xff" }
      let(:http_encoded) { '%FF'  }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.encode(data, case: :upper)).to eq(http_encoded)
      end
    end

    context "when the String contains invalid byte sequences" do
      let(:data)         { "mod % 3\xfe\xff" }
      let(:http_encoded) { "%6D%6F%64%20%25%20%33%FE%FF" }

      it "must HTTP escape each byte in the String" do
        expect(subject.encode(data)).to eq(http_encoded)
      end
    end
  end

  describe ".decode" do
    let(:data)         { "ABC" }
    let(:http_encoded) { "%41%42%43" }

    it "must encode each byte of the String" do
      expect(subject.decode(http_encoded)).to eq(data)
    end

    context "when the URI escaped characters contain lowercase hexadecimal" do
      let(:data)         { "%6d%6f%64%20%25%20%33" }
      let(:http_decoded) { "mod % 3" }

      it "must unescape the lowercase hexadecimal escaped characters" do
        expect(subject.decode(data)).to eq(http_decoded)
      end
    end
  end
end
