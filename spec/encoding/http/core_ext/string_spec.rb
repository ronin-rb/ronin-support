require 'spec_helper'
require 'ronin/support/encoding/http/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#http_encode" do
    expect(subject).to respond_to(:http_encode)
  end

  describe "#http_encode" do
    subject { "mod % 3" }

    let(:http_encoded) { "%6D%6F%64%20%25%20%33" }

    it "must format each byte of the String" do
      expect(subject.http_encode).to eq(http_encoded)
    end
  end

  describe "#http_encode" do
    subject { "ABC" }

    let(:http_encoded) { "%41%42%43" }

    it "must encode each byte of the String" do
      expect(subject.http_encode).to eq(http_encoded)
    end
  end
end
