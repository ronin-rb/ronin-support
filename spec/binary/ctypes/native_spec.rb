require 'spec_helper'
require 'ronin/support/binary/ctypes/native'

require_relative 'types_examples'

describe Ronin::Support::Binary::CTypes::Native do
  it do
    expect(described_class).to include(Ronin::Support::Binary::CTypes::CharTypes)
  end

  describe "ENDIAN" do
    subject { described_class::ENDIAN }

    if [0x1].pack('S') == [0x1].pack('S>')
      it { expect(subject).to be(:big) }
    else
      it { expect(subject).to be(:little) }
    end
  end

  describe "ADDRESS_SIZE" do
    subject { described_class::ADDRESS_SIZE }

    it "must be equal the size of a pointer" do
      if RUBY_ENGINE == 'jruby'
        pending "JRuby does not correctly implement Array#pack('p')"
      end

      expect(subject).to eq(['a'].pack('p').bytesize)
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

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 's'" do
      expect(subject.pack_string).to eq('s')
    end
  end

  describe "INT32" do
    subject { described_class::INT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Int32Type)
    end

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 'l'" do
      expect(subject.pack_string).to eq('l')
    end
  end

  describe "INT64" do
    subject { described_class::INT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Int64Type)
    end

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 'q'" do
      expect(subject.pack_string).to eq('q')
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

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 'S'" do
      expect(subject.pack_string).to eq('S')
    end
  end

  describe "UINT32" do
    subject { described_class::UINT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::UInt32Type)
    end

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 'L'" do
      expect(subject.pack_string).to eq('L')
    end
  end

  describe "UINT64" do
    subject { described_class::UINT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::UInt64Type)
    end

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 'Q'" do
      expect(subject.pack_string).to eq('Q')
    end
  end

  describe "FLOAT32" do
    subject { described_class::FLOAT32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Float32Type)
    end

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 'f'" do
      expect(subject.pack_string).to eq('f')
    end
  end

  describe "FLOAT64" do
    subject { described_class::FLOAT64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::Float64Type)
    end

    it "must be native endian" do
      expect(subject.endian).to be(described_class::ENDIAN)
    end

    it "must have a #pack_string of 'd'" do
      expect(subject.pack_string).to eq('d')
    end
  end

  include_examples "Types examples"
end
