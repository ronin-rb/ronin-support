require 'spec_helper'
require 'ronin/support/binary/types/float_type'

describe Ronin::Support::Binary::Types::FloatType do
  it { expect(described_class).to be < Ronin::Support::Binary::Types::Type }

  let(:size)        { 4       }
  let(:endian)      { :little }
  let(:pack_string) { 'e'     }

  subject do
    described_class.new(
      size:        size,
      endian:      endian,
      pack_string: pack_string
    )
  end

  describe "#initialize" do
    it "must set #size" do
      expect(subject.size).to eq(size)
    end

    it "must set #endian" do
      expect(subject.endian).to eq(endian)
    end

    it "must default #signed to true" do
      expect(subject.signed).to be(true)
    end

    it "must set #pack_string" do
      expect(subject.pack_string).to eq(pack_string)
    end

    context "when the size: keyword is not given" do
      it do
        expect {
          described_class.new(
            endian: endian,
            pack_string: pack_string
          )
        }.to raise_error(ArgumentError)
      end
    end

    context "when the endian: keyword is not given" do
      it do
        expect {
          described_class.new(
            size:   size,
            pack_string: pack_string
          )
        }.to raise_error(ArgumentError)
      end
    end

    context "when the pack_string: keyword is not given" do
      it do
        expect {
          described_class.new(
            size:   size,
            endian: endian
          )
        }.to raise_error(ArgumentError)
      end
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
end