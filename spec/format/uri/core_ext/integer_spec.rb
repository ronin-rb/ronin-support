require 'spec_helper'
require 'ronin/support/format/uri/core_ext/integer'

describe Integer do
  subject { 0x20 }

  it "must provide String#uri_encode" do
    expect(subject).to respond_to(:uri_encode)
  end

  it "must provide String#uri_escape" do
    expect(subject).to respond_to(:uri_escape)
  end

  describe "#uri_encode" do
    let(:uri_encoded) { '%20' }

    it "must URI encode itself" do
      expect(subject.uri_encode).to eq(uri_encoded)
    end

    context "when given unsafe characters" do
      let(:not_encoded) { ' ' }

      it "must encode itself if listed as unsafe" do
        expect(subject.uri_encode(' ', "\n", "\r")).to eq(uri_encoded)
      end

      it "must not encode itself if not listed as unsafe" do
        expect(subject.uri_encode('A', 'B', 'C')).to eq(not_encoded)
      end
    end
  end

  describe "#uri_escape" do
    let(:uri_escaped) { '+' }

    it "must URI escape itself" do
      expect(subject.uri_escape).to eq(uri_escaped)
    end
  end
end
