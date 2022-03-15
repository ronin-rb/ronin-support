require 'spec_helper'
require 'ronin/support/binary/types/arch/mips/little_endian'

describe Ronin::Support::Binary::Types::Arch::MIPS::LittleEndian do
  it { expect(subject).to include(Ronin::Support::Binary::Types::LittleEndian) }

  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":long" do
      it "must be an alias to :int32" do
        expect(subject[:long]).to be(subject[:int32])
      end
    end

    describe ":ulong" do
      it "must be an alias to :uint32" do
        expect(subject[:ulong]).to be(subject[:uint32])
      end
    end
  end

  describe "[]" do
    context "when given a valid type name" do
      it "must return the type constant value" do
        expect(subject[:uint32]).to be(described_class::UInt32)
      end
    end

    context "when given an unknown type name" do
      let(:name) { :foo }

      it do
        expect {
          subject[name]
        }.to raise_error(ArgumentError,"unknown MIPS (little-endian) type: #{name.inspect}")
      end
    end
  end
end