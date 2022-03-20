require 'spec_helper'
require 'ronin/support/binary/types/little_endian'

require_relative 'types_examples'

describe Ronin::Support::Binary::Types::LittleEndian do
  it do
    expect(described_class).to include(Ronin::Support::Binary::Types::CharTypes)
  end

  describe "ADDRESS_SIZE" do
    subject { described_class::ADDRESS_SIZE }

    it "must equal Native::ADDRESS_SIZE" do
      expect(subject).to eq(Ronin::Support::Binary::Types::Native::ADDRESS_SIZE)
    end
  end

  describe "INT8" do
    subject { described_class::INT8 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int8Type)
    end

    it "must have a #pack_string of 'c'" do
      expect(subject.pack_string).to eq('c')
    end
  end

  describe "INT16" do
    subject { described_class::INT16 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int16Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 's<'" do
      expect(subject.pack_string).to eq('s<')
    end
  end

  describe "INT32" do
    subject { described_class::INT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int32Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 'l<'" do
      expect(subject.pack_string).to eq('l<')
    end
  end

  describe "INT64" do
    subject { described_class::INT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int64Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 'q<'" do
      expect(subject.pack_string).to eq('q<')
    end
  end

  describe "UINT8" do
    subject { described_class::UINT8 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt8Type)
    end

    it "must have a #pack_string of 'C'" do
      expect(subject.pack_string).to eq('C')
    end
  end

  describe "UINT16" do
    subject { described_class::UINT16 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt16Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 'S<'" do
      expect(subject.pack_string).to eq('S<')
    end
  end

  describe "UINT32" do
    subject { described_class::UINT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt32Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 'L<'" do
      expect(subject.pack_string).to eq('L<')
    end
  end

  describe "UINT64" do
    subject { described_class::UINT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt64Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 'Q<'" do
      expect(subject.pack_string).to eq('Q<')
    end
  end

  describe "FLOAT32" do
    subject { described_class::FLOAT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Float32Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 'e'" do
      expect(subject.pack_string).to eq('e')
    end
  end

  describe "FLOAT64" do
    subject { described_class::FLOAT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Float64Type)
    end

    it "must have an #endian of :little" do
      expect(subject.endian).to be(:little)
    end

    it "must have a #pack_string of 'E'" do
      expect(subject.pack_string).to eq('E')
    end
  end

  include_examples "Types examples"
end
