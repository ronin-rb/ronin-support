require 'spec_helper'
require 'ronin/support/format/http/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#uri_encode" do
    expect(subject).to respond_to(:uri_encode)
  end

  it "must provide String#uri_decode" do
    expect(subject).to respond_to(:uri_decode)
  end

  it "must provide String#uri_escape" do
    expect(subject).to respond_to(:uri_escape)
  end

  it "must provide String#uri_unescape" do
    expect(subject).to respond_to(:uri_unescape)
  end

  it "must provide String#format_http" do
    expect(subject).to respond_to(:format_http)
  end

  describe "#uri_encode" do
    subject { "mod % 3" }

    let(:uri_encoded) { "mod%20%25%203" }

    it "must URI encode itself" do
      expect(subject.uri_encode).to eq(uri_encoded)
    end

    context "when given unsafe characters" do
      let(:uri_unsafe_encoded) { "mod %25 3" }

      it "must encode the characters listed as unsafe" do
        expect(subject.uri_encode('%')).to eq(uri_unsafe_encoded)
      end
    end
  end

  describe "#uri_decode" do
    subject { "mod%20%25%203" }

    let(:uri_decoded) { "mod % 3" }

    it "must URI decode itself" do
      expect(subject.uri_decode).to eq(uri_decoded)
    end
  end

  describe "#uri_escape" do
    subject { "x + y" }

    let(:uri_escaped) { "x+%2B+y" }

    it "must URI escape itself" do
      expect(subject.uri_escape).to eq(uri_escaped)
    end
  end

  describe "#uri_unescape" do
    subject { "x+%2B+y" }

    let(:uri_unescaped) { "x + y" }

    it "must URI unescape itself" do
      expect(subject.uri_unescape).to eq(uri_unescaped)
    end
  end

  describe "#format_http" do
    subject { "mod % 3" }

    let(:http_formatted) { "%6D%6F%64%20%25%20%33" }

    it "must format each byte of the String" do
      expect(subject.format_http).to eq(http_formatted)
    end
  end
end
