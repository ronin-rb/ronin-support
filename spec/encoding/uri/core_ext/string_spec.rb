require 'spec_helper'
require 'ronin/support/encoding/uri/core_ext/string'

describe String do
  subject { "hello" }

  it { expect(subject).to respond_to(:uri_encode)   }
  it { expect(subject).to respond_to(:uri_decode)   }
  it { expect(subject).to respond_to(:uri_escape)   }
  it { expect(subject).to respond_to(:uri_unescape) }

  describe "#uri_escape" do
    subject { "mod % 3" }

    let(:uri_escaped) { "mod%20%25%203" }

    it "must URI encode itself" do
      expect(subject.uri_escape).to eq(uri_escaped)
    end

    context "when given `case: :lower`" do
      subject { "\xff" }

      let(:uri_escaped) { '%ff' }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.uri_escape(case: :lower)).to eq(uri_escaped)
      end
    end

    context "when given `case: :upper`" do
      subject { "\xff" }

      let(:uri_escaped) { '%FF' }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.uri_escape(case: :upper)).to eq(uri_escaped)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:uri_escaped) { "hello%FE%FF" }

      it "must URI escape each byte in the String" do
        expect(subject.uri_escape).to eq(uri_escaped)
      end
    end
  end

  describe "#uri_unescape" do
    subject { "x%20%2B%20y" }

    let(:uri_unescaped) { "x + y" }

    it "must URI unescape itself" do
      expect(subject.uri_unescape).to eq(uri_unescaped)
    end

    context "when the %xx escaped character is lowercase hexadecimal" do
      let(:data)          { "x%20%2b%20y" }
      let(:uri_unescaped) { "x + y"       }

      it "must URI unescape the String" do
        expect(subject.uri_unescape).to eq(uri_unescaped)
      end
    end
  end

  describe "#uri_encode" do
    subject { "hello world" }

    let(:uri_encoded) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.uri_encode).to eq(uri_encoded)
    end

    context "when given `case: :lower`" do
      subject { "\xff" }

      let(:uri_encoded) { '%ff' }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.uri_encode(case: :lower)).to eq(uri_encoded)
      end
    end

    context "when given `case: :upper`" do
      subject { "\xff" }

      let(:uri_encoded) { '%FF' }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.uri_encode(case: :upper)).to eq(uri_encoded)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello world\xfe\xff" }

      let(:uri_encoded) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64%FE%FF" }

      it "must URI encode each byte in the String" do
        expect(subject.uri_encode).to eq(uri_encoded)
      end
    end
  end

  describe "#uri_decode" do
    subject { "%68%65%6C%6C%6F%20%77%6F%72%6C%64" }

    let(:data) { "hello world" }

    it "must URI form encode every character in the String" do
      expect(subject.uri_decode).to eq(data)
    end

    context "when the %xx escaped character is lowercase hexadecimal" do
      subject { "%68%65%6c%6c%6f%20%77%6f%72%6c%64" }

      it "must URI form unescape the String" do
        expect(subject.uri_decode).to eq(data)
      end
    end
  end

  describe "#uri_form_escape" do
    subject { "mod % 3" }

    let(:uri_form_escaped) { "mod+%25+3" }

    it "must URI encode itself" do
      expect(subject.uri_form_escape).to eq(uri_form_escaped)
    end

    context "when given `case: :lower`" do
      subject { "\xff" }

      let(:uri_form_escaped) { '%ff' }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.uri_form_escape(case: :lower)).to eq(uri_form_escaped)
      end
    end

    context "when given `case: :upper`" do
      subject { "\xff" }

      let(:uri_form_escaped) { '%FF' }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.uri_form_escape(case: :upper)).to eq(uri_form_escaped)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello world\xfe\xff" }

      let(:uri_form_escaped) { "hello+world%FE%FF" }

      it "must URI form escape each byte in the String" do
        expect(subject.uri_form_escape).to eq(uri_form_escaped)
      end
    end
  end

  describe "#uri_form_unescape" do
    subject { "x+%2B+y" }

    let(:uri_form_unescaped) { "x + y" }

    it "must URI unescape itself" do
      expect(subject.uri_form_unescape).to eq(uri_form_unescaped)
    end

    context "when the %xx escaped character is lowercase hexadecimal" do
      subject { "x+%2b+y" }

      let(:uri_form_unescaped) { "x + y" }

      it "must URI form unescape the String" do
        expect(subject.uri_form_unescape).to eq(uri_form_unescaped)
      end
    end
  end

  describe "#uri_form_encode" do
    subject { "hello world" }

    let(:uri_form_encoded) { "%68%65%6C%6C%6F+%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.uri_form_encode).to eq(uri_form_encoded)
    end

    context "when given `case: :lower`" do
      subject { "\xff" }

      let(:uri_form_encoded) { '%ff' }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.uri_form_encode(case: :lower)).to eq(uri_form_encoded)
      end
    end

    context "when given `case: :upper`" do
      subject { "\xff" }

      let(:uri_form_encoded) { '%FF' }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.uri_form_encode(case: :upper)).to eq(uri_form_encoded)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello world\xfe\xff" }

      let(:uri_form_encoded) { "%68%65%6C%6C%6F+%77%6F%72%6C%64%FE%FF" }

      it "must URI form encode each byte in the String" do
        expect(subject.uri_form_encode).to eq(uri_form_encoded)
      end
    end

    describe "#uri_form_decode" do
      subject { "%68%65%6C%6C%6F+%77%6F%72%6C%64" }

      let(:uri_form_decoded) { "hello world" }

      it "must URI form encode every character in the String" do
        expect(subject.uri_form_decode).to eq(uri_form_decoded)
      end

      context "when the %xx escaped character is lowercase hexadecimal" do
        subject { "%68%65%6c%6c%6f+%77%6f%72%6c%64" }

        it "must URI form unescape the String" do
          expect(subject.uri_form_decode).to eq(uri_form_decoded)
        end
      end
    end
  end
end
