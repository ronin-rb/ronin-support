# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/encoding/base64/core_ext/string'

describe String do
  subject { "hello" }

  it { expect(subject).to respond_to(:base64_encode) }
  it { expect(subject).to respond_to(:base64_decode) }

  describe "#base64_encode" do
    subject { "hello\0" }

    it "must base64 encode a String" do
      expect(subject.base64_encode).to eq("aGVsbG8A\n")
    end
  end

  describe "#base64_decode" do
    subject { "aGVsbG8A\n" }

    it "must base64 decode a String" do
      expect(subject.base64_decode).to eq("hello\0")
    end
  end
end
