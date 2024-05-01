# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/encoding/base64/core_ext/string'

describe String do
  subject { "hello" }

  it { expect(subject).to respond_to(:base64_encode) }
  it { expect(subject).to respond_to(:base64_decode) }

  describe "#base64_encode" do
    subject { "hello" }

    it "must Base64 encode the String" do
      expect(subject.base64_encode).to eq(Base64.encode64(subject))
    end

    context "when given the mode: keyword of :strict" do
      subject { 'A' * 256 }

      it "must strict encode the String" do
        expect(subject.base64_encode(mode: :strict)).to eq(
          Base64.strict_encode64(subject)
        )
      end
    end

    context "when given the mode: keyword of :url_safe" do
      subject { 'A' * 256 }

      it "must URL-safe encode the String" do
        expect(subject.base64_encode(mode: :url_safe)).to eq(
          Base64.strict_encode64(subject)
        )
      end
    end

    context "when given any other value" do
      let(:mode) { :foo }

      it do
        expect {
          subject.base64_encode(mode: mode)
        }.to raise_error(ArgumentError,"Base64 mode must be either :string, :url_safe, or nil: #{mode.inspect}")
      end
    end
  end

  describe "#base64_decode" do
    let(:data)    { "hello" }
    let(:subject) { Base64.encode64(data) }

    it "must Base64 decode the given data" do
      expect(subject.base64_decode).to eq(data)
    end

    context "when given the mode: keyword of :strict" do
      let(:data)    { 'A' * 256 }
      let(:subject) { Base64.strict_encode64(data) }

      it "must strict decode the given data" do
        expect(subject.base64_decode(mode: :strict)).to eq(data)
      end
    end

    context "when given the mode: keyword of :url_safe" do
      let(:data)    { 'A' * 256 }
      let(:subject) { Base64.urlsafe_encode64(data) }

      it "must URL-safe decode the given data" do
        expect(subject.base64_decode(mode: :url_safe)).to eq(data)
      end
    end

    context "when given any other value" do
      let(:mode) { :foo }

      it do
        expect {
          subject.base64_decode(mode: mode)
        }.to raise_error(ArgumentError,"Base64 mode must be either :string, :url_safe, or nil: #{mode.inspect}")
      end
    end
  end
end
