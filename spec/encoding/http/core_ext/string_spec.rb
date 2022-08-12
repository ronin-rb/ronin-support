require 'spec_helper'
require 'ronin/support/encoding/http/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#format_http" do
    expect(subject).to respond_to(:format_http)
  end

  describe "#format_http" do
    subject { "mod % 3" }

    let(:http_formatted) { "%6D%6F%64%20%25%20%33" }

    it "must format each byte of the String" do
      expect(subject.format_http).to eq(http_formatted)
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
