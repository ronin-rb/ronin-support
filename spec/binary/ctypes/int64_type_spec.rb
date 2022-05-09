require 'spec_helper'
require 'ronin/support/binary/ctypes/int64_type'

require_relative 'type_examples'
require_relative 'scalar_type_examples'

describe Ronin::Support::Binary::CTypes::Int64Type do
  it { expect(described_class).to be < Ronin::Support::Binary::CTypes::IntType }

  let(:endian)      { :little }
  let(:pack_string) { 'q<' }

  subject do
    described_class.new(
      endian:      endian,
      pack_string: pack_string
    )
  end

  describe "#initialize" do
    it "must default #size to 8" do
      expect(subject.size).to eq(8)
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

    context "when the endian: keyword is not given" do
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
            endian: endian
          )
        }.to raise_error(ArgumentError)
      end
    end
  end

  include_examples "Type examples"
  include_examples "Ronin::Support::Binary::CTypes::ScalarType examples"
end
