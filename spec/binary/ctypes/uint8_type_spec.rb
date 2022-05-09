require 'spec_helper'
require 'ronin/support/binary/ctypes/uint8_type'

describe Ronin::Support::Binary::CTypes::UInt8Type do
  it { expect(described_class).to be < Ronin::Support::Binary::CTypes::UIntType }

  describe "#initialize" do
    it "must default #size to 1" do
      expect(subject.size).to eq(1)
    end

    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    it "must default #signed to false" do
      expect(subject.signed).to be(false)
    end

    it "must default #pack_string to 'C'" do
      expect(subject.pack_string).to eq('C')
    end
  end
end
