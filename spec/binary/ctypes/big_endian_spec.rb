require 'spec_helper'
require 'ronin/support/binary/ctypes/big_endian'

require_relative 'types_examples'

describe Ronin::Support::Binary::CTypes::BigEndian do
  it do
    expect(described_class).to include(Ronin::Support::Binary::CTypes::CharTypes)
  end

  describe "ADDRESS_SIZE" do
    subject { described_class::ADDRESS_SIZE }

    it "must equal Native::ADDRESS_SIZE" do
      expect(subject).to eq(Ronin::Support::Binary::CTypes::Native::ADDRESS_SIZE)
    end
  end

  describe "INT8" do
    subject { described_class::INT8 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Int8Type)
    end

    it "must have a #pack_string of 'c'" do
      expect(subject.pack_string).to eq('c')
    end
  end

  describe "INT16" do
    subject { described_class::INT16 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Int16Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 's>'" do
      expect(subject.pack_string).to eq('s>')
    end
  end

  describe "INT32" do
    subject { described_class::INT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Int32Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'l>'" do
      expect(subject.pack_string).to eq('l>')
    end
  end

  describe "INT64" do
    subject { described_class::INT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Int64Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'q>'" do
      expect(subject.pack_string).to eq('q>')
    end
  end

  describe "UINT8" do
    subject { described_class::UINT8 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::UInt8Type)
    end

    it "must have a #pack_string of 'C'" do
      expect(subject.pack_string).to eq('C')
    end
  end

  describe "UINT16" do
    subject { described_class::UINT16 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::UInt16Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'S>'" do
      expect(subject.pack_string).to eq('S>')
    end
  end

  describe "UINT32" do
    subject { described_class::UINT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::UInt32Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'L>'" do
      expect(subject.pack_string).to eq('L>')
    end
  end

  describe "UINT64" do
    subject { described_class::UINT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::UInt64Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'Q>'" do
      expect(subject.pack_string).to eq('Q>')
    end
  end

  describe "FLOAT32" do
    subject { described_class::FLOAT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Float32Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'g'" do
      expect(subject.pack_string).to eq('g')
    end
  end

  describe "FLOAT64" do
    subject { described_class::FLOAT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Float64Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'G'" do
      expect(subject.pack_string).to eq('G')
    end
  end

  include_examples "Types examples"
end
