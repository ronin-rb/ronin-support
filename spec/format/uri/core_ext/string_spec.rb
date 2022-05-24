require 'spec_helper'
require 'ronin/support/format/uri/core_ext/string'

describe String do
  subject { "hello" }

  it { expect(subject).to respond_to(:uri_encode)   }
  it { expect(subject).to respond_to(:uri_decode)   }
  it { expect(subject).to respond_to(:format_uri)   }

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
  end

  describe "#uri_unescape" do
    subject { "x%20%2B%20y" }

    let(:uri_unescaped) { "x + y" }

    it "must URI unescape itself" do
      expect(subject.uri_unescape).to eq(uri_unescaped)
    end
  end

  describe "#format_uri" do
    subject { "hello world" }

    let(:uri_formatted) { "%68%65%6C%6C%6F%20%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.format_uri).to eq(uri_formatted)
    end
  end

  describe "#uri_form_escape" do
    subject { "mod % 3" }

    let(:uri_form_escaped) { "mod+%25+3" }

    it "must URI encode itself" do
      expect(subject.uri_form_escape).to eq(uri_form_escaped)
    end
  end

  describe "#uri_form_unescape" do
    subject { "x+%2B+y" }

    let(:uri_form_unescaped) { "x + y" }

    it "must URI unescape itself" do
      expect(subject.uri_form_unescape).to eq(uri_form_unescaped)
    end
  end

  describe "#format_uri" do
    subject { "hello world" }

    let(:uri_form_formatted) { "%68%65%6C%6C%6F+%77%6F%72%6C%64" }

    it "must URI encode every character in the String" do
      expect(subject.format_uri_form).to eq(uri_form_formatted)
    end
  end
end
