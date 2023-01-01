require 'spec_helper'
require 'ronin/support/binary/ctypes/arch/arm/big_endian'

require_relative '../32bit_be_arch_examples'

describe Ronin::Support::Binary::CTypes::Arch::ARM::BigEndian do
  include_examples "32bit BE Arch examples"

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
        }.to raise_error(ArgumentError,"unknown ARM (big-endian) type: #{name.inspect}")
      end
    end
  end
end
