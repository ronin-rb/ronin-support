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

    context "when given the unsafe: keyword argument" do
      let(:uri_unsafe_encoded) { "mod %25 3" }

      it "must encode the characters listed as unsafe" do
        expect(subject.uri_escape(unsafe: ['%'])).to eq(uri_unsafe_encoded)
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
  end

  describe "#uri_encode" do
    subject { "hello world" }

    let(:uri_encoded) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.uri_encode).to eq(uri_encoded)
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello world\xfe\xff" }

      let(:uri_encoded) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64%FE%FF" }

      it "must URI encode each byte in the String" do
        expect(subject.uri_encode).to eq(uri_encoded)
      end
    end
  end

  describe "#uri_form_escape" do
    subject { "mod % 3" }

    let(:uri_form_escaped) { "mod+%25+3" }

    it "must URI encode itself" do
      expect(subject.uri_form_escape).to eq(uri_form_escaped)
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello world\xfe\xff" }

      let(:uri_form_escaped) { "hello+world%FE%FF"   }

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
  end

  describe "#uri_form_encode" do
    subject { "hello world" }

    let(:uri_form_encoded) { "%68%65%6C%6C%6F+%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.uri_form_encode).to eq(uri_form_encoded)
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello world\xfe\xff" }

      let(:uri_form_encoded) { "%68%65%6C%6C%6F+%77%6F%72%6C%64%FE%FF" }

      it "must URI form encode each byte in the String" do
        expect(subject.uri_form_encode).to eq(uri_form_encoded)
      end
    end
  end
end
