require 'spec_helper'
require 'ronin/support/encoding/uri'

describe Ronin::Support::Encoding::URI do
  describe ".encode_byte" do
    let(:byte)        { 0x41  }
    let(:uri_encoded) { '%41' }

    it "must URI encode the Integer" do
      expect(subject.encode_byte(byte)).to eq(uri_encoded)
    end

    context "when given a byte less than 0x10" do
      let(:byte)        { 0x01  }
      let(:uri_encoded) { '%01' }

      it "must zero-pad the escaped character" do
        expect(subject.encode_byte(byte)).to eq(uri_encoded)
      end
    end

    context "when given `case: :lower`" do
      let(:byte)        { 0xFF  }
      let(:uri_encoded) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.encode_byte(byte, case: :lower)).to eq(uri_encoded)
      end
    end

    context "when given `case: :upper`" do
      let(:byte)        { 0xFF  }
      let(:uri_encoded) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.encode_byte(byte, case: :upper)).to eq(uri_encoded)
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
    [33, 36, 38, *(39..59), 61, *(63..91), 93, 95, *(97..122), 126].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        let(:byte) { byte     }
        let(:char) { byte.chr }

        it "must return the ASCII character for the byte" do
          expect(subject.escape_byte(byte)).to eq(char)
        end
      end
    end

    [*(0..32), 34, 35, 37, 60, 62, 92, 94, 96, *(123..125), *(127..255)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        let(:byte)        { byte           }
        let(:uri_escaped) { "%%%.2X" % byte }

        it "must URI escape the Integer" do
          expect(subject.escape_byte(byte)).to eq(uri_escaped)
        end
      end
    end

    context "when called on a printable ASCII character" do
      let(:byte) { 0x41 }

      it "must return that character" do
        expect(subject.escape_byte(byte)).to eq(byte.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      let(:byte)        { 0xFF  }
      let(:uri_escaped) { '%FF' }

      it "must URI encode the Integer" do
        expect(subject.escape_byte(byte)).to eq(uri_escaped)
      end
    end

    context "when given `case: :lower`" do
      let(:byte)        { 0xFF  }
      let(:uri_escaped) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.escape_byte(byte, case: :lower)).to eq(uri_escaped)
      end
    end

    context "when given `case: :upper`" do
      let(:byte)        { 0xFF  }
      let(:uri_escaped) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.escape_byte(byte, case: :upper)).to eq(uri_escaped)
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
    let(:data)        { "mod % 3" }
    let(:uri_escaped) { "mod%20%25%203" }

    it "must URI encode the String" do
      expect(subject.escape(data)).to eq(uri_escaped)
    end

    context "when given `case: :lower`" do
      let(:data)        { "\xff" }
      let(:uri_escaped) { '%ff'  }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.escape(data, case: :lower)).to eq(uri_escaped)
      end
    end

    context "when given `case: :upper`" do
      let(:data)        { "\xff" }
      let(:uri_escaped) { '%FF'  }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.escape(data, case: :upper)).to eq(uri_escaped)
      end
    end

    context "when the String contains invalid byte sequences" do
      let(:data)        { "hello\xfe\xff" }
      let(:uri_escaped) { "hello%FE%FF"   }

      it "must URI escape each byte in the String" do
        expect(subject.escape(data)).to eq(uri_escaped)
      end
    end
  end

  describe ".unescape" do
    let(:data)          { "x%20%2B%20y" }
    let(:uri_unescaped) { "x + y"       }

    it "must URI unescape the String" do
      expect(subject.unescape(data)).to eq(uri_unescaped)
    end

    context "when the %xx escaped character is lowercase hexadecimal" do
      let(:data)          { "x%20%2b%20y" }
      let(:uri_unescaped) { "x + y"       }

      it "must URI unescape the String" do
        expect(subject.unescape(data)).to eq(uri_unescaped)
      end
    end
  end

  describe ".encode" do
    let(:data)        { "hello world" }
    let(:uri_encoded) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.encode(data)).to eq(uri_encoded)
    end

    context "when given `case: :lower`" do
      let(:data)        { "\xff" }
      let(:uri_encoded) { '%ff'  }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.encode(data, case: :lower)).to eq(uri_encoded)
      end
    end

    context "when given `case: :upper`" do
      let(:data)        { "\xff" }
      let(:uri_encoded) { '%FF'  }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.encode(data, case: :upper)).to eq(uri_encoded)
      end
    end

    context "when the String contains invalid byte sequences" do
      let(:data)        { "hello world\xfe\xff" }
      let(:uri_encoded) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64%FE%FF" }

      it "must URI encode each byte in the String" do
        expect(subject.encode(data)).to eq(uri_encoded)
      end
    end
  end

  describe described_class::Form do
    describe ".encode_byte" do
      let(:byte)             { 0x41  }
      let(:uri_form_encoded) { '%41' }

      it "must URI form encode the Integer" do
        expect(subject.encode_byte(byte)).to eq(uri_form_encoded)
      end

      context "when given `case: :lower`" do
        let(:byte)             { 0xFF  }
        let(:uri_form_encoded) { '%ff' }

        it "must return a lowercase hexadecimal escaped character" do
          expect(subject.encode_byte(byte, case: :lower)).to eq(uri_form_encoded)
        end
      end

      context "when given `case: :upper`" do
        let(:byte)        { 0xFF  }
        let(:uri_form_encoded) { '%FF' }

        it "must return a uppercase hexadecimal escaped character" do
          expect(subject.encode_byte(byte, case: :upper)).to eq(uri_form_encoded)
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
      [42, 45, 46, *(48..57), *(65..90), 95, *(97..122)].each do |byte|
        context "when given the byte 0x#{byte.to_s(16)}" do
          let(:byte) { byte     }
          let(:char) { byte.chr }

          it "must return the ASCII character for the byte" do
            expect(subject.escape_byte(byte)).to eq(char)
          end
        end
      end

      context "when the Integer is 0x20" do
        let(:byte) { 0x20 }

        it "must return '+'" do
          expect(subject.escape_byte(byte)).to eq('+')
        end
      end

      [*(0..31), *(33..41), 43, 44, 47, *(58..64), *(91..94), 96, *(123..255)].each do |byte|
        context "when given the byte 0x#{byte.to_s(16)}" do
          let(:byte)        { byte           }
          let(:uri_escaped) { "%%%.2X" % byte }

          it "must URI escape the Integer" do
            expect(subject.escape_byte(byte)).to eq(uri_escaped)
          end
        end
      end

      context "when given `case: :lower`" do
        let(:byte)             { 0xFF  }
        let(:uri_form_escaped) { '%ff' }

        it "must return a lowercase hexadecimal escaped character" do
          expect(subject.escape_byte(byte, case: :lower)).to eq(uri_form_escaped)
        end
      end

      context "when given `case: :upper`" do
        let(:byte)             { 0xFF  }
        let(:uri_form_escaped) { '%FF' }

        it "must return a uppercase hexadecimal escaped character" do
          expect(subject.escape_byte(byte, case: :upper)).to eq(uri_form_escaped)
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
      let(:data)             { "mod % 3"   }
      let(:uri_form_escaped) { "mod+%25+3" }

      it "must URI form escape the String" do
        expect(subject.escape(data)).to eq(uri_form_escaped)
      end

      context "when the String contains invalid byte sequences" do
        let(:data)             { "hello world\xfe\xff" }
        let(:uri_form_escaped) { "hello+world%FE%FF"   }

        it "must URI form escape each byte in the String" do
          expect(subject.escape(data)).to eq(uri_form_escaped)
        end
      end

      context "when given `case: :lower`" do
        let(:data)             { "\xff" }
        let(:uri_form_escaped) { '%ff'  }

        it "must return a lowercase hexadecimal escaped String" do
          expect(subject.escape(data, case: :lower)).to eq(uri_form_escaped)
        end
      end

      context "when given `case: :upper`" do
        let(:data)             { "\xff" }
        let(:uri_form_escaped) { '%FF'  }

        it "must return a uppercase hexadecimal escaped String" do
          expect(subject.escape(data, case: :upper)).to eq(uri_form_escaped)
        end
      end
    end

    describe ".unescape" do
      let(:data)               { "x+%2B+y" }
      let(:uri_form_unescaped) { "x + y"   }

      it "must URI form unescape the String" do
        expect(subject.unescape(data)).to eq(uri_form_unescaped)
      end

      context "when the %xx escaped character is lowercase hexadecimal" do
        let(:data)               { "x+%2b+y" }
        let(:uri_form_unescaped) { "x + y"   }

        it "must URI form unescape the String" do
          expect(subject.unescape(data)).to eq(uri_form_unescaped)
        end
      end
    end

    describe ".encode" do
      let(:data)             { "hello world" }
      let(:uri_form_encoded) { "%68%65%6C%6C%6F+%77%6F%72%6C%64" }

      it "must URI form encode every character in the String" do
        expect(subject.encode(data)).to eq(uri_form_encoded)
      end

      context "when the String contains invalid byte sequences" do
        let(:data)             { "hello world\xfe\xff" }
        let(:uri_form_encoded) { "%68%65%6C%6C%6F+%77%6F%72%6C%64%FE%FF" }

        it "must URI form encode each byte in the String" do
          expect(subject.encode(data)).to eq(uri_form_encoded)
        end
      end

      context "when given `case: :lower`" do
        let(:data)             { "\xff" }
        let(:uri_form_encoded) { '%ff'  }

        it "must return a lowercase hexadecimal escaped String" do
          expect(subject.encode(data, case: :lower)).to eq(uri_form_encoded)
        end
      end

      context "when given `case: :upper`" do
        let(:data)             { "\xff" }
        let(:uri_form_encoded) { '%FF'  }

        it "must return a uppercase hexadecimal escaped String" do
          expect(subject.encode(data, case: :upper)).to eq(uri_form_encoded)
        end
      end
    end
  end
end
