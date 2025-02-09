require 'spec_helper'
require 'ronin/support/encoding/base64'

describe Ronin::Support::Encoding::Base64 do
  describe ".encode" do
    let(:data) { "hello" }

    it "must Base64 encode the given data" do
      expect(subject.encode(data)).to eq(described_class.encode64(data))
    end

    context "when given the mode: keyword of :strict" do
      let(:data) { 'A' * 256 }

      it "must strict encode the given data" do
        expect(subject.encode(data, mode: :strict)).to eq(
          described_class.strict_encode64(data)
        )
      end
    end

    context "when given the mode: keyword of :url_safe" do
      let(:data) { 'A' * 256 }

      it "must URL-safe encode the given data" do
        expect(subject.encode(data, mode: :url_safe)).to eq(
          described_class.strict_encode64(data)
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
    let(:encoded_data) { described_class.encode64(data) }

    it "must Base64 decode the given data" do
      expect(subject.decode(encoded_data)).to eq(data)
    end

    context "when given the mode: keyword of :strict" do
      let(:data)         { 'A' * 256 }
      let(:encoded_data) { described_class.strict_encode64(data) }

      it "must strict decode the given data" do
        expect(subject.decode(encoded_data, mode: :strict)).to eq(data)
      end
    end

    context "when given the mode: keyword of :url_safe" do
      let(:data)         { 'A' * 256 }
      let(:encoded_data) { described_class.urlsafe_encode64(data) }

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

  describe "#encode64" do
    let(:data) { "AAAA" }
    let(:encoded_data) { "QUFBQQ==\n" }

    it "must encode the given data" do
      expect(subject.encode64(data)).to eq(encoded_data)
    end
  end

  describe "#strict_encode64" do
    let(:data) { "AAAA" }
    let(:encoded_data) { "QUFBQQ==" }

    it "must strict encode the given data" do
      expect(subject.strict_encode64(data)).to eq(encoded_data)
    end
  end

  describe "#urlsafe_encode64" do
    let(:data) { "AAAA" }
    let(:encoded_data) { "QUFBQQ==" }

    it "must URL-safe encode the given data" do
      expect(subject.urlsafe_encode64(data)).to eq(encoded_data)
    end
  end

  describe "#decode64" do
    let(:data) { "QUFBQQ==\n" }
    let(:decoded_data) { "AAAA" }

    it "must decode the given data" do
      expect(subject.decode64(data)).to eq(decoded_data)
    end
  end

  describe "#strict_decode64" do
    let(:data) { "QUFBQQ==" }
    let(:decoded_data) { "AAAA" }

    it "must strict decode the given data" do
      expect(subject.strict_decode64(data)).to eq(decoded_data)
    end
  end

  describe "#urlsafe_decode64" do
    let(:data) { "QUFBQQ==" }
    let(:decoded_data) { "AAAA" }

    it "must URL-safe decode the given data" do
      expect(subject.urlsafe_decode64(data)).to eq(decoded_data)
    end
  end
end
