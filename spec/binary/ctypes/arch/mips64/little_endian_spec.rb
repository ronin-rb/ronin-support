require 'spec_helper'
require 'ronin/support/binary/ctypes/arch/mips64/little_endian'

require_relative '../64bit_le_arch_examples'

describe Ronin::Support::Binary::CTypes::Arch::MIPS64::LittleEndian do
  include_examples "64bit LE Arch examples"

  describe "[]" do
    context "when given a valid type name" do
      it "must return the type constant value" do
        expect(subject[:uint32]).to be(described_class::UINT32)
      end
    end

    context "when given an unknown type name" do
      let(:name) { :foo }

      it do
        expect {
          subject[name]
        }.to raise_error(ArgumentError,"unknown MIPS64 (little-endian) type: #{name.inspect}")
      end
    end
  end
end
