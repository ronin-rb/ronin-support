require 'spec_helper'
require 'ronin/support/encoding/uri'

describe Ronin::Support::Encoding::URI do
  describe ".encode_byte" do
    let(:byte)        { 0x41  }
    let(:uri_encoded) { '%41' }

    it "must URI encode the Integer" do
      expect(subject.encode_byte(byte)).to eq(uri_encoded)
    end
  end

  describe ".escape_byte" do
    context "when the Integer maps to a special character" do
      let(:byte)        { 0x20  }
      let(:uri_escaped) { '%20' }

      it "must URI escape the Integer" do
        expect(subject.escape_byte(byte)).to eq(uri_escaped)
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

    context "when given the unsafe: keyword argument" do
      context "and the Integer is in the list of unsafe characters" do
        let(:byte)        { 0x20 }
        let(:unsafe)      { [' ', "\n", "\r"] }
        let(:uri_encoded) { '%20' }

        it "must URI encode the Integer" do
          expect(subject.escape_byte(byte, unsafe: unsafe)).to eq(uri_encoded)
        end
      end

      context "when the Integer is not in the list of unsafe characters" do
        let(:byte)   { 0x20      }
        let(:unsafe) { %w[A B C] }

        it "must not encode the byte if not listed as unsafe" do
          expect(subject.escape_byte(byte, unsafe: unsafe)).to eq(byte.chr)
        end
      end
    end
  end

  describe ".escape" do
    let(:data)        { "mod % 3" }
    let(:uri_escaped) { "mod%20%25%203" }

    it "must URI encode the String" do
      expect(subject.escape(data)).to eq(uri_escaped)
    end

    context "when given the unsafe: keyword argument" do
      let(:uri_unsafe_encoded) { "mod %25 3" }

      it "must encode the characters listed as unsafe" do
        expect(subject.escape(data, unsafe: ['%'])).to eq(uri_unsafe_encoded)
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
  end

  describe ".encode" do
    let(:data)        { "hello world" }
    let(:uri_encoded) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.encode(data)).to eq(uri_encoded)
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
    end

    describe ".escape_byte" do
      context "when the Integer is 0x20" do
        let(:byte) { 0x20 }

        it "must return '+'" do
          expect(subject.escape_byte(byte)).to eq('+')
        end
      end

      context "when the Integer maps to a special character" do
        let(:byte)             { 0x23 } # '#'
        let(:uri_form_escaped) { '%23' }

        it "must URI form escape the Integer" do
          expect(subject.escape_byte(byte)).to eq(uri_form_escaped)
        end
      end

      context "when called on a printable ASCII character" do
        let(:byte) { 0x41 }

        it "must return the character" do
          expect(subject.escape_byte(byte)).to eq(byte.chr)
        end
      end

      context "when called on an Integer that does not map to an ASCII char" do
        let(:byte)             { 0xFF }
        let(:uri_form_escaped) { '%FF' }

        it "must URI form encode the Integer" do
          expect(subject.escape_byte(byte)).to eq(uri_form_escaped)
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
    end

    describe ".unescape" do
      let(:data)               { "x+%2B+y" }
      let(:uri_form_unescaped) { "x + y"   }

      it "must URI form unescape the String" do
        expect(subject.unescape(data)).to eq(uri_form_unescaped)
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
    end
  end
end
