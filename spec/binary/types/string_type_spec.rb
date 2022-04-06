require 'spec_helper'
require 'ronin/support/binary/types/string_type'

describe Ronin::Support::Binary::Types::StringType do
  it do
    expect(described_class).to be < Ronin::Support::Binary::Types::Type
  end

  describe "#initialize" do
    it "must have a #pack_string of 'Z*'" do
      expect(subject.pack_string).to eq('Z*')
    end
  end

  describe "#size" do
    it "must return Float::INFINITY" do
      expect(subject.size).to eq(Float::INFINITY)
    end
  end

  describe "#alignment" do
    it "must return 1" do
      expect(subject.alignment).to eq(1)
    end
  end

  describe "#length" do
    it "must return Float::INFINITY" do
      expect(subject.length).to eq(Float::INFINITY)
    end
  end

  describe "#signed?" do
    it "must return true" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "#unsigned?" do
    it "must return false" do
      expect(subject.unsigned?).to be(false)
    end
  end

  let(:string) { "hello world" }

  describe "#pack" do
    it "must append a null-byte to the end of the String" do
      expect(subject.pack(string)).to eq("#{string}\0")
    end
  end

  describe "#unpack" do
    let(:data) { "#{string}\0" }

    it "must read the String until a null-byte is encountered" do
      expect(subject.unpack(data)).to eq(string)
    end

    context "when there is no null-byte" do
      let(:data) { string }

      it "must read until the end of the data" do
        expect(subject.unpack(data)).to eq(data)
      end
    end
  end
end
