require 'spec_helper'
require 'ronin/support/binary/types/big_endian'

describe Ronin::Support::Binary::Types::BigEndian do
  describe "Int8" do
    subject { described_class::Int8 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int8Type)
    end

    it "must have a #pack_string of 'c'" do
      expect(subject.pack_string).to eq('c')
    end
  end

  describe "Int16" do
    subject { described_class::Int16 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int16Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 's>'" do
      expect(subject.pack_string).to eq('s>')
    end
  end

  describe "Int32" do
    subject { described_class::Int32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int32Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'l>'" do
      expect(subject.pack_string).to eq('l>')
    end
  end

  describe "Int64" do
    subject { described_class::Int64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Int64Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'q>'" do
      expect(subject.pack_string).to eq('q>')
    end
  end

  describe "UInt8" do
    subject { described_class::UInt8 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt8Type)
    end

    it "must have a #pack_string of 'C'" do
      expect(subject.pack_string).to eq('C')
    end
  end

  describe "UInt16" do
    subject { described_class::UInt16 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt16Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'S>'" do
      expect(subject.pack_string).to eq('S>')
    end
  end

  describe "UInt32" do
    subject { described_class::UInt32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt32Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'L>'" do
      expect(subject.pack_string).to eq('L>')
    end
  end

  describe "UInt64" do
    subject { described_class::UInt64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt64Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'Q>'" do
      expect(subject.pack_string).to eq('Q>')
    end
  end

  describe "Float32" do
    subject { described_class::Float32 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Float32Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'g'" do
      expect(subject.pack_string).to eq('g')
    end
  end

  describe "Float64" do
    subject { described_class::Float64 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::Float64Type)
    end

    it "must have an #endian of :big" do
      expect(subject.endian).to be(:big)
    end

    it "must have a #pack_string of 'G'" do
      expect(subject.pack_string).to eq('G')
    end
  end

  describe "Char" do
    subject { described_class::Char }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::CharType)
    end

    it "must have a #pack_string of 'Z'" do
      expect(subject.pack_string).to eq('Z')
    end
  end

  describe "UChar" do
    subject { described_class::UChar }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::CharType)
    end

    it "must have a #pack_string of 'A'" do
      expect(subject.pack_string).to eq('A')
    end
  end

  describe "Byte" do
    subject { described_class::Byte }

    it { expect(subject).to eq(described_class::UInt8) }
  end

  describe "CString" do
    subject { described_class::CString }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
    end

    it "must have a #type of Char" do
      expect(subject.type).to be(described_class::Char)
    end
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    describe "byte" do
      it "must be an alias to uint8" do
        expect(subject[:byte]).to be(subject[:uint8])
      end
    end

    describe "char" do
      subject { super()[:char] }

      it "must equal #{described_class}::Char" do
        expect(subject).to eq(described_class::Char)
      end
    end

    describe "uchar" do
      subject { super()[:uchar] }

      it "must equal #{described_class}::UChar" do
        expect(subject).to eq(described_class::UChar)
      end
    end

    describe "int8" do
      subject { super()[:int8] }

      it "must equal #{described_class}::Int8" do
        expect(subject).to eq(described_class::Int8)
      end
    end

    describe "uint8" do
      subject { super()[:uint8] }

      it "must equal #{described_class}::UInt8" do
        expect(subject).to eq(described_class::UInt8)
      end
    end

    describe "int16" do
      subject { super()[:int16] }

      it "must equal #{described_class}::Int16" do
        expect(subject).to eq(described_class::Int16)
      end
    end

    describe "uint16" do
      subject { super()[:uint16] }

      it "must equal #{described_class}::UInt16" do
        expect(subject).to eq(described_class::UInt16)
      end
    end

    describe "short" do
      it "must be an alias to int16" do
        expect(subject[:short]).to be(subject[:int16])
      end
    end

    describe "ushort" do
      it "must be an alias to uint16" do
        expect(subject[:ushort]).to be(subject[:uint16])
      end
    end

    describe "int32" do
      subject { super()[:int32] }

      it "must equal #{described_class}::Int32" do
        expect(subject).to eq(described_class::Int32)
      end
    end

    describe "uint32" do
      subject { super()[:uint32] }

      it "must equal #{described_class}::UInt32" do
        expect(subject).to eq(described_class::UInt32)
      end
    end

    describe "int" do
      it "must be an alias to int32" do
        expect(subject[:int]).to be(subject[:int32])
      end
    end

    describe "long" do
      it "must be an alias to int32" do
        expect(subject[:long]).to be(subject[:int32])
      end
    end

    describe "uint" do
      it "must be an alias to uint32" do
        expect(subject[:uint]).to be(subject[:uint32])
      end
    end

    describe "ulong" do
      it "must be an alias to uint32" do
        expect(subject[:ulong]).to be(subject[:uint32])
      end
    end

    describe "int64" do
      subject { super()[:int64] }

      it "must equal #{described_class}::Int64" do
        expect(subject).to eq(described_class::Int64)
      end
    end

    describe "uint64" do
      subject { super()[:uint64] }

      it "must equal #{described_class}::UInt64" do
        expect(subject).to eq(described_class::UInt64)
      end
    end

    describe "long_long" do
      it "must be an alias to int64" do
        expect(subject[:long_long]).to be(subject[:int64])
      end
    end

    describe "ulong_long" do
      it "must be an alias to uint64" do
        expect(subject[:ulong_long]).to be(subject[:uint64])
      end
    end

    describe "#float32" do
      subject { super()[:float32] }

      it "must equal #{described_class}::Float32" do
        expect(subject).to eq(described_class::Float32)
      end
    end

    describe "#float64" do
      subject { super()[:float64] }

      it "must equal #{described_class}::Float64" do
        expect(subject).to eq(described_class::Float64)
      end
    end

    describe "float" do
      it "must be an alias to float32" do
        expect(subject[:float]).to be(subject[:float32])
      end
    end

    describe "double" do
      it "must be an alias to float64" do
        expect(subject[:double]).to be(subject[:float64])
      end
    end
  end

  describe ".[]" do
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
        }.to raise_error(ArgumentError,"unknown type: #{name.inspect}")
      end
    end
  end
end
