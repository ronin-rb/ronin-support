require 'spec_helper'
require 'ronin/support/binary/types'

describe Ronin::Support::Binary::Types do
  describe "TYPES" do
    subject { described_class::TYPES }

    describe "byte" do
      it "must be an alias to uint8" do
        expect(subject[:byte]).to be(subject[:uint8])
      end
    end

    describe "char" do
      subject { super()[:char] }

      it "must equal #{described_class}::Native::Char" do
        expect(subject).to eq(described_class::Native::Char)
      end
    end

    describe "uchar" do
      subject { super()[:uchar] }

      it "must equal #{described_class}::Native::UChar" do
        expect(subject).to eq(described_class::Native::UChar)
      end
    end

    describe "int8" do
      subject { super()[:int8] }

      it "must equal #{described_class}::Native::Int8" do
        expect(subject).to eq(described_class::Native::Int8)
      end
    end

    describe "uint8" do
      subject { super()[:uint8] }

      it "must equal #{described_class}::Native::UInt8" do
        expect(subject).to eq(described_class::Native::UInt8)
      end
    end

    describe "int16" do
      subject { super()[:int16] }

      it "must equal #{described_class}::Native::Int16" do
        expect(subject).to eq(described_class::Native::Int16)
      end
    end

    describe "int16_le" do
      subject { super()[:int16_le] }

      it "must equal #{described_class}::LittleEndian::Int16" do
        expect(subject).to eq(described_class::LittleEndian::Int16)
      end
    end

    describe "int16_be" do
      subject { super()[:int16_be] }

      it "must equal #{described_class}::BigEndian::Int16" do
        expect(subject).to eq(described_class::BigEndian::Int16)
      end
    end

    describe "int16_ne" do
      subject { super()[:int16_ne] }

      it "must equal #{described_class}::Network::Int16" do
        expect(subject).to eq(described_class::Network::Int16)
      end
    end

    describe "uint16" do
      subject { super()[:uint16] }

      it "must equal #{described_class}::Native::UInt16" do
        expect(subject).to eq(described_class::Native::UInt16)
      end
    end

    describe "uint16_le" do
      subject { super()[:uint16_le] }

      it "must equal #{described_class}::LittleEndian::UInt16" do
        expect(subject).to eq(described_class::LittleEndian::UInt16)
      end
    end

    describe "uint16_be" do
      subject { super()[:uint16_be] }

      it "must equal #{described_class}::BigEndian::UInt16" do
        expect(subject).to eq(described_class::BigEndian::UInt16)
      end
    end

    describe "uint16_ne" do
      subject { super()[:uint16_ne] }

      it "must equal #{described_class}::Network::UInt16" do
        expect(subject).to eq(described_class::Network::UInt16)
      end
    end

    describe "short" do
      it "must be an alias to int16" do
        expect(subject[:short]).to be(subject[:int16])
      end
    end

    describe "short_le" do
      it "must be an alias to int16_le" do
        expect(subject[:short_le]).to be(subject[:int16_le])
      end
    end

    describe "short_be" do
      it "must be an alias to int16_be" do
        expect(subject[:short_be]).to be(subject[:int16_be])
      end
    end

    describe "short_ne" do
      it "must be an alias to int16_ne" do
        expect(subject[:short_ne]).to be(subject[:int16_ne])
      end
    end

    describe "ushort" do
      it "must be an alias to uint16" do
        expect(subject[:ushort]).to be(subject[:uint16])
      end
    end

    describe "ushort_le" do
      it "must be an alias to uint16_le" do
        expect(subject[:ushort_le]).to be(subject[:uint16_le])
      end
    end

    describe "ushort_be" do
      it "must be an alias to uint16_be" do
        expect(subject[:ushort_be]).to be(subject[:uint16_be])
      end
    end

    describe "ushort_ne" do
      it "must be an alias to uint16_ne" do
        expect(subject[:ushort_ne]).to be(subject[:uint16_ne])
      end
    end

    describe "int32" do
      subject { super()[:int32] }

      it "must equal #{described_class}::Native::Int32" do
        expect(subject).to eq(described_class::Native::Int32)
      end
    end

    describe "int32_le" do
      subject { super()[:int32_le] }

      it "must equal #{described_class}::LittleEndian::Int32" do
        expect(subject).to eq(described_class::LittleEndian::Int32)
      end
    end

    describe "int32_be" do
      subject { super()[:int32_be] }

      it "must equal #{described_class}::BigEndian::Int32" do
        expect(subject).to eq(described_class::BigEndian::Int32)
      end
    end

    describe "int32_ne" do
      subject { super()[:int32_ne] }

      it "must equal #{described_class}::Network::Int32" do
        expect(subject).to eq(described_class::Network::Int32)
      end
    end

    describe "uint32" do
      subject { super()[:uint32] }

      it "must equal #{described_class}::Native::UInt32" do
        expect(subject).to eq(described_class::Native::UInt32)
      end
    end

    describe "uint32_le" do
      subject { super()[:uint32_le] }

      it "must equal #{described_class}::LittleEndian::UInt32" do
        expect(subject).to eq(described_class::LittleEndian::UInt32) 
      end
    end

    describe "uint32_be" do
      subject { super()[:uint32_be] }

      it "must equal #{described_class}::BigEndian::UInt32" do
        expect(subject).to eq(described_class::BigEndian::UInt32)
      end
    end

    describe "uint32_ne" do
      subject { super()[:uint32_ne] }

      it "must equal #{described_class}::Network::UInt32" do
        expect(subject).to eq(described_class::Network::UInt32)
      end
    end

    describe "int" do
      it "must be an alias to int32" do
        expect(subject[:int]).to be(subject[:int32])
      end
    end

    describe "int_le" do
      it "must be an alias to int32_le" do
        expect(subject[:int_le]).to be(subject[:int32_le])
      end
    end

    describe "int_be" do
      it "must be an alias to int32_be" do
        expect(subject[:int_be]).to be(subject[:int32_be])
      end
    end

    describe "int_ne" do
      it "must be an alias to int32_ne" do
        expect(subject[:int_ne]).to be(subject[:int32_ne])
      end
    end

    describe "long" do
      it "must be an alias to int32" do
        expect(subject[:long]).to be(subject[:int32])
      end
    end

    describe "long_le" do
      it "must be an alias to int32_le" do
        expect(subject[:long_le]).to be(subject[:int32_le])
      end
    end

    describe "long_be" do
      it "must be an alias to int32_be" do
        expect(subject[:long_be]).to be(subject[:int32_be])
      end
    end

    describe "long_ne" do
      it "must be an alias to int32_ne" do
        expect(subject[:long_ne]).to be(subject[:int32_ne])
      end
    end

    describe "uint" do
      it "must be an alias to uint32" do
        expect(subject[:uint]).to be(subject[:uint32])
      end
    end

    describe "uint_le" do
      it "must be an alias to uint32_le" do
        expect(subject[:uint_le]).to be(subject[:uint32_le])
      end
    end

    describe "uint_be" do
      it "must be an alias to uint32_be" do
        expect(subject[:uint_be]).to be(subject[:uint32_be])
      end
    end

    describe "uint_ne" do
      it "must be an alias to uint32_ne" do
        expect(subject[:uint_ne]).to be(subject[:uint32_ne])
      end
    end

    describe "ulong" do
      it "must be an alias to uint32" do
        expect(subject[:ulong]).to be(subject[:uint32])
      end
    end

    describe "ulong_le" do
      it "must be an alias to uint32_le" do
        expect(subject[:ulong_le]).to be(subject[:uint32_le])
      end
    end

    describe "ulong_be" do
      it "must be an alias to uint32_be" do
        expect(subject[:ulong_be]).to be(subject[:uint32_be])
      end
    end

    describe "ulong_ne" do
      it "must be an alias to uint32_ne" do
        expect(subject[:ulong_ne]).to be(subject[:uint32_ne])
      end
    end

    describe "int64" do
      subject { super()[:int64] }

      it "must equal #{described_class}::Native::Int64" do
        expect(subject).to eq(described_class::Native::Int64)
      end
    end

    describe "int64_le" do
      subject { super()[:int64_le] }

      it "must equal #{described_class}::LittleEndian::Int64" do
        expect(subject).to eq(described_class::LittleEndian::Int64)
      end
    end

    describe "int64_be" do
      subject { super()[:int64_be] }

      it "must equal #{described_class}::BigEndian::Int64" do
        expect(subject).to eq(described_class::BigEndian::Int64)
      end
    end

    describe "int64_ne" do
      subject { super()[:int64_ne] }

      it "must equal #{described_class}::Network::Int64" do
        expect(subject).to eq(described_class::Network::Int64)
      end
    end

    describe "uint64" do
      subject { super()[:uint64] }

      it "must equal #{described_class}::Native::UInt64" do
        expect(subject).to eq(described_class::Native::UInt64)
      end
    end

    describe "uint64_le" do
      subject { super()[:uint64_le] }

      it "must equal #{described_class}::LittleEndian::UInt64" do
        expect(subject).to eq(described_class::LittleEndian::UInt64)
      end
    end

    describe "uint64_be" do
      subject { super()[:uint64_be] }

      it "must equal #{described_class}::BigEndian::UInt64" do
        expect(subject).to eq(described_class::BigEndian::UInt64)
      end
    end

    describe "uint64_ne" do
      subject { super()[:uint64_ne] }

      it "must equal #{described_class}::Network::UInt64" do
        expect(subject).to eq(described_class::Network::UInt64)
      end
    end

    describe "long_long" do
      it "must be an alias to int64" do
        expect(subject[:long_long]).to be(subject[:int64])
      end
    end

    describe "long_long_le" do
      it "must be an alias to int64_le" do
        expect(subject[:long_long_le]).to be(subject[:int64_le])
      end
    end

    describe "long_long_be" do
      it "must be an alias to int64_be" do
        expect(subject[:long_long_be]).to be(subject[:int64_be])
      end
    end

    describe "long_long_ne" do
      it "must be an alias to int64_ne" do
        expect(subject[:long_long_ne]).to be(subject[:int64_ne])
      end
    end

    describe "ulong_long" do
      it "must be an alias to uint64" do
        expect(subject[:ulong_long]).to be(subject[:uint64])
      end
    end

    describe "ulong_long_le" do
      it "must be an alias to uint64_le" do
        expect(subject[:ulong_long_le]).to be(subject[:uint64_le])
      end
    end

    describe "ulong_long_be" do
      it "must be an alias to uint64_be" do
        expect(subject[:ulong_long_be]).to be(subject[:uint64_be])
      end
    end

    describe "ulong_long_ne" do
      it "must be an alias to uint64_ne" do
        expect(subject[:ulong_long_ne]).to be(subject[:uint64_ne])
      end
    end

    describe "#float32" do
      subject { super()[:float32] }

      it "must equal #{described_class}::Native::Float32" do
        expect(subject).to eq(described_class::Native::Float32)
      end
    end

    describe "#float32_le" do
      subject { super()[:float32_le] }

      it "must equal #{described_class}::LittleEndian::Float32" do
        expect(subject).to eq(described_class::LittleEndian::Float32)
      end
    end

    describe "#float32_be" do
      subject { super()[:float32_be] }

      it "must equal #{described_class}::BigEndian::Float32" do
        expect(subject).to eq(described_class::BigEndian::Float32)
      end
    end

    describe "#float32_ne" do
      subject { super()[:float32_ne] }

      it "must equal #{described_class}::Network::Float32" do
        expect(subject).to eq(described_class::Network::Float32)
      end
    end

    describe "#float64" do
      subject { super()[:float64] }

      it "must equal #{described_class}::Native::Float64" do
        expect(subject).to eq(described_class::Native::Float64)
      end
    end

    describe "#float64_le" do
      subject { super()[:float64_le] }

      it "must equal #{described_class}::LittleEndian::Float64" do
        expect(subject).to eq(described_class::LittleEndian::Float64)
      end
    end

    describe "#float64_be" do
      subject { super()[:float64_be] }

      it "must equal #{described_class}::BigEndian::Float64" do
        expect(subject).to eq(described_class::BigEndian::Float64)
      end
    end

    describe "#float64_ne" do
      subject { super()[:float64_ne] }

      it "must equal #{described_class}::Network::Float64" do
        expect(subject).to eq(described_class::Network::Float64)
      end
    end

    describe "float" do
      it "must be an alias to float32" do
        expect(subject[:float]).to be(subject[:float32])
      end
    end

    describe "float_le" do
      it "must be an alias to float32_le" do
        expect(subject[:float_le]).to be(subject[:float32_le])
      end
    end

    describe "float_be" do
      it "must be an alias to float32_be" do
        expect(subject[:float_be]).to be(subject[:float32_be])
      end
    end

    describe "float_ne" do
      it "must be an alias to float32_ne" do
        expect(subject[:float_ne]).to be(subject[:float32_ne])
      end
    end

    describe "double" do
      it "must be an alias to float64" do
        expect(subject[:double]).to be(subject[:float64])
      end
    end

    describe "double_le" do
      it "must be an alias to float64_le" do
        expect(subject[:double_le]).to be(subject[:float64_le])
      end
    end

    describe "double_be" do
      it "must be an alias to float64_be" do
        expect(subject[:double_be]).to be(subject[:float64_be])
      end
    end

    describe "double_ne" do
      it "must be an alias to float64_ne" do
        expect(subject[:double_ne]).to be(subject[:float64_ne])
      end
    end
  end
end
