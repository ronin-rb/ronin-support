require 'spec_helper'
require 'ronin/support/binary/ctypes/int8_type'

describe Ronin::Support::Binary::CTypes::Int8Type do
  it { expect(described_class).to be < Ronin::Support::Binary::CTypes::IntType }

  describe "#initialize" do
    it "must default #size to 1" do
      expect(subject.size).to eq(1)
    end

    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    it "must default #signed to true" do
      expect(subject.signed).to be(true)
    end

    it "must default #pack_string to 'c'" do
      expect(subject.pack_string).to eq('c')
    end
  end
end
