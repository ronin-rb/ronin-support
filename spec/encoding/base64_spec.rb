require 'spec_helper'
require 'ronin/support/encoding/base64'

describe Ronin::Support::Encoding::Base64 do
  describe ".encode" do
    let(:data) { "hello" }

    it "must Base64 encode the given data" do
      expect(subject.encode(data)).to eq(Base64.encode64(data))
    end

    context "when given the mode: keyword of :strict" do
      let(:data) { 'A' * 256 }

      it "must strict encode the given data" do
        expect(subject.encode(data, mode: :strict)).to eq(
          Base64.strict_encode64(data)
        )
      end
    end

    context "when given the mode: keyword of :url_safe" do
      let(:data) { 'A' * 256 }

      it "must URL-safe encode the given data" do
        expect(subject.encode(data, mode: :url_safe)).to eq(
          Base64.strict_encode64(data)
        )
      end
    end

    context "when given any other value" do
      let(:mode) { :foo }

      it do
        expect {
          subject.encode(data, mode: mode)
        }.to raise_error(ArgumentError,"Base64 mode must be either :string, :url_safe, or nil: #{mode.inspect}")
      end
    end
  end

  describe ".decode" do
    let(:data)         { "hello" }
    let(:encoded_data) { Base64.encode64(data) }

    it "must Base64 decode the given data" do
      expect(subject.decode(encoded_data)).to eq(data)
    end

    context "when given the mode: keyword of :strict" do
      let(:data)         { 'A' * 256 }
      let(:encoded_data) { Base64.strict_encode64(data) }

      it "must strict decode the given data" do
        expect(subject.decode(encoded_data, mode: :strict)).to eq(data)
      end
    end

    context "when given the mode: keyword of :url_safe" do
      let(:data)         { 'A' * 256 }
      let(:encoded_data) { Base64.urlsafe_encode64(data) }

      it "must URL-safe decode the given data" do
        expect(subject.decode(encoded_data, mode: :url_safe)).to eq(data)
      end
    end

    context "when given any other value" do
      let(:mode) { :foo }

      it do
        expect {
          subject.decode(encoded_data, mode: mode)
        }.to raise_error(ArgumentError,"Base64 mode must be either :string, :url_safe, or nil: #{mode.inspect}")
      end
    end
  end
end
