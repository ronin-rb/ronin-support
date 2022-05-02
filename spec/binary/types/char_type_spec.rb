require 'spec_helper'
require 'ronin/support/binary/types/char_type'

require_relative 'scalar_type_examples'

describe Ronin::Support::Binary::Types::CharType do
  it { expect(described_class).to be < Ronin::Support::Binary::Types::Type }

  let(:size)        { 4       }
  let(:signed)      { true    }
  let(:pack_string) { 'Z'     }

  subject do
    described_class.new(
      size:        size,
      signed:      signed,
      pack_string: pack_string
    )
  end

  describe "#initialize" do
    it "must set #size" do
      expect(subject.size).to eq(size)
    end

    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    it "must set #signed" do
      expect(subject.signed).to be(signed)
    end

    it "must set #pack_string" do
      expect(subject.pack_string).to eq(pack_string)
    end

    context "when the signed: keyword is not given" do
      it do
        expect {
          described_class.new(
            pack_string: pack_string
          )
        }.to raise_error(ArgumentError)
      end
    end

    context "when the pack_string: keyword is not given" do
      it do
        expect {
          described_class.new(
            signed: signed
          )
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#uninitialized_value" do
    it "must return ''" do
      expect(subject.uninitialized_value).to eq('')
    end
  end

  include_examples "Ronin::Support::Binary::Types::ScalarType examples"
end
