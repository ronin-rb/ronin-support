require 'spec_helper'
require 'ronin/support/binary/types'

describe Ronin::Support::Binary::Types do
  #
  # Native constant specs
  #
  describe "Int8" do
    subject { described_class::Int8 }

    it { expect(subject).to eq(described_class::Native::Int8) }
  end

  describe "Int16" do
    subject { described_class::Int16 }

    it { expect(subject).to eq(described_class::Native::Int16) }
  end

  describe "Int32" do
    subject { described_class::Int32 }

    it { expect(subject).to eq(described_class::Native::Int32) }
  end

  describe "Int64" do
    subject { described_class::Int64 }

    it { expect(subject).to eq(described_class::Native::Int64) }
  end

  describe "UInt8" do
    subject { described_class::UInt8 }

    it { expect(subject).to eq(described_class::Native::UInt8) }
  end

  describe "UInt16" do
    subject { described_class::UInt16 }

    it { expect(subject).to eq(described_class::Native::UInt16) }
  end

  describe "UInt32" do
    subject { described_class::UInt32 }

    it { expect(subject).to eq(described_class::Native::UInt32) }
  end

  describe "UInt64" do
    subject { described_class::UInt64 }

    it { expect(subject).to eq(described_class::Native::UInt64) }
  end

  describe "Float32" do
    subject { described_class::Float32 }

    it { expect(subject).to eq(described_class::Native::Float32) }
  end

  describe "Float64" do
    subject { described_class::Float64 }

    it { expect(subject).to eq(described_class::Native::Float64) }
  end

  describe "Char" do
    subject { described_class::Char }

    it { expect(subject).to eq(described_class::Native::Char) }
  end

  describe "UChar" do
    subject { described_class::UChar }

    it { expect(subject).to eq(described_class::Native::UChar) }
  end

  describe "Byte" do
    subject { described_class::Byte }

    it { expect(subject).to eq(described_class::Native::Byte) }
  end

  describe "CString" do
    subject { described_class::CString }

    it { expect(subject).to eq(described_class::Native::CString) }
  end

  #
  # Little-endian constant specs
  #
  describe "Int16_LE" do
    subject { described_class::Int16_LE }

    it { expect(subject).to eq(described_class::LittleEndian::Int16) }
  end

  describe "Int32_LE" do
    subject { described_class::Int32_LE }

    it { expect(subject).to eq(described_class::LittleEndian::Int32) }
  end

  describe "Int64_LE" do
    subject { described_class::Int64_LE }

    it { expect(subject).to eq(described_class::LittleEndian::Int64) }
  end

  describe "UInt16_LE" do
    subject { described_class::UInt16_LE }

    it { expect(subject).to eq(described_class::LittleEndian::UInt16) }
  end

  describe "UInt32_LE" do
    subject { described_class::UInt32_LE }

    it { expect(subject).to eq(described_class::LittleEndian::UInt32) }
  end

  describe "UInt64_LE" do
    subject { described_class::UInt64_LE }

    it { expect(subject).to eq(described_class::LittleEndian::UInt64) }
  end

  describe "Float32_LE" do
    subject { described_class::Float32_LE }

    it { expect(subject).to eq(described_class::LittleEndian::Float32) }
  end

  describe "Float64_LE" do
    subject { described_class::Float64_LE }

    it { expect(subject).to eq(described_class::LittleEndian::Float64) }
  end

  #
  # Big-endian constant specs
  #
  describe "Int16_BE" do
    subject { described_class::Int16_BE }

    it { expect(subject).to eq(described_class::BigEndian::Int16) }
  end

  describe "Int32_BE" do
    subject { described_class::Int32_BE }

    it { expect(subject).to eq(described_class::BigEndian::Int32) }
  end

  describe "Int64_BE" do
    subject { described_class::Int64_BE }

    it { expect(subject).to eq(described_class::BigEndian::Int64) }
  end

  describe "UInt16_BE" do
    subject { described_class::UInt16_BE }

    it { expect(subject).to eq(described_class::BigEndian::UInt16) }
  end

  describe "UInt32_BE" do
    subject { described_class::UInt32_BE }

    it { expect(subject).to eq(described_class::BigEndian::UInt32) }
  end

  describe "UInt64_BE" do
    subject { described_class::UInt64_BE }

    it { expect(subject).to eq(described_class::BigEndian::UInt64) }
  end

  describe "Float32_BE" do
    subject { described_class::Float32_BE }

    it { expect(subject).to eq(described_class::BigEndian::Float32) }
  end

  describe "Float64_BE" do
    subject { described_class::Float64_BE }

    it { expect(subject).to eq(described_class::BigEndian::Float64) }
  end

  #
  # Network-endian constant specs
  #
  describe "Int16_NE" do
    subject { described_class::Int16_NE }

    it { expect(subject).to eq(described_class::Network::Int16) }
  end

  describe "Int32_NE" do
    subject { described_class::Int32_NE }

    it { expect(subject).to eq(described_class::Network::Int32) }
  end

  describe "Int64_NE" do
    subject { described_class::Int64_NE }

    it { expect(subject).to eq(described_class::Network::Int64) }
  end

  describe "UInt16_NE" do
    subject { described_class::UInt16_NE }

    it { expect(subject).to eq(described_class::Network::UInt16) }
  end

  describe "UInt32_NE" do
    subject { described_class::UInt32_NE }

    it { expect(subject).to eq(described_class::Network::UInt32) }
  end

  describe "UInt64_NE" do
    subject { described_class::UInt64_NE }

    it { expect(subject).to eq(described_class::Network::UInt64) }
  end

  describe "Float32_NE" do
    subject { described_class::Float32_NE }

    it { expect(subject).to eq(described_class::Network::Float32) }
  end

  describe "Float64_NE" do
    subject { described_class::Float64_NE }

    it { expect(subject).to eq(described_class::Network::Float64) }
  end

  describe "Int16_Net" do
    subject { described_class::Int16_Net }

    it { expect(subject).to eq(described_class::Network::Int16) }
  end

  describe "Int32_Net" do
    subject { described_class::Int32_Net }

    it { expect(subject).to eq(described_class::Network::Int32) }
  end

  describe "Int64_Net" do
    subject { described_class::Int64_Net }

    it { expect(subject).to eq(described_class::Network::Int64) }
  end

  describe "UInt16_Net" do
    subject { described_class::UInt16_Net }

    it { expect(subject).to eq(described_class::Network::UInt16) }
  end

  describe "UInt32_Net" do
    subject { described_class::UInt32_Net }

    it { expect(subject).to eq(described_class::Network::UInt32) }
  end

  describe "UInt64_Net" do
    subject { described_class::UInt64_Net }

    it { expect(subject).to eq(described_class::Network::UInt64) }
  end

  describe "Float32_Net" do
    subject { described_class::Float32_Net }

    it { expect(subject).to eq(described_class::Network::Float32) }
  end

  describe "Float64_Net" do
    subject { described_class::Float64_Net }

    it { expect(subject).to eq(described_class::Network::Float64) }
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    #
    # Native types specs
    #
    describe ":byte" do
      it "must be an alias to uint8" do
        expect(subject[:byte]).to be(subject[:uint8])
      end
    end

    describe ":char" do
      subject { super()[:char] }

      it "must equal #{described_class}::Native::Char" do
        expect(subject).to eq(described_class::Native::Char)
      end
    end

    describe ":uchar" do
      subject { super()[:uchar] }

      it "must equal #{described_class}::Native::UChar" do
        expect(subject).to eq(described_class::Native::UChar)
      end
    end

    describe ":int8" do
      subject { super()[:int8] }

      it "must equal #{described_class}::Native::Int8" do
        expect(subject).to eq(described_class::Native::Int8)
      end
    end

    describe ":uint8" do
      subject { super()[:uint8] }

      it "must equal #{described_class}::Native::UInt8" do
        expect(subject).to eq(described_class::Native::UInt8)
      end
    end

    describe ":int16" do
      subject { super()[:int16] }

      it "must equal #{described_class}::Native::Int16" do
        expect(subject).to eq(described_class::Native::Int16)
      end
    end

    describe ":uint16" do
      subject { super()[:uint16] }

      it "must equal #{described_class}::Native::UInt16" do
        expect(subject).to eq(described_class::Native::UInt16)
      end
    end

    describe ":short" do
      it "must be an alias to int16" do
        expect(subject[:short]).to be(subject[:int16])
      end
    end

    describe ":ushort" do
      it "must be an alias to uint16" do
        expect(subject[:ushort]).to be(subject[:uint16])
      end
    end

    describe ":int32" do
      subject { super()[:int32] }

      it "must equal #{described_class}::Native::Int32" do
        expect(subject).to eq(described_class::Native::Int32)
      end
    end

    describe ":uint32" do
      subject { super()[:uint32] }

      it "must equal #{described_class}::Native::UInt32" do
        expect(subject).to eq(described_class::Native::UInt32)
      end
    end

    describe ":int" do
      it "must be an alias to int32" do
        expect(subject[:int]).to be(subject[:int32])
      end
    end

    describe ":long" do
      it "must be an alias to int64" do
        expect(subject[:long]).to be(subject[:int64])
      end
    end

    describe ":uint" do
      it "must be an alias to uint32" do
        expect(subject[:uint]).to be(subject[:uint32])
      end
    end

    describe ":ulong" do
      it "must be an alias to uint64" do
        expect(subject[:ulong]).to be(subject[:uint64])
      end
    end

    describe ":int64" do
      subject { super()[:int64] }

      it "must equal #{described_class}::Native::Int64" do
        expect(subject).to eq(described_class::Native::Int64)
      end
    end

    describe ":uint64" do
      subject { super()[:uint64] }

      it "must equal #{described_class}::Native::UInt64" do
        expect(subject).to eq(described_class::Native::UInt64)
      end
    end

    describe ":long_long" do
      it "must be an alias to int64" do
        expect(subject[:long_long]).to be(subject[:int64])
      end
    end

    describe ":ulong_long" do
      it "must be an alias to uint64" do
        expect(subject[:ulong_long]).to be(subject[:uint64])
      end
    end

    describe ":float32" do
      subject { super()[:float32] }

      it "must equal #{described_class}::Native::Float32" do
        expect(subject).to eq(described_class::Native::Float32)
      end
    end

    describe ":float64" do
      subject { super()[:float64] }

      it "must equal #{described_class}::Native::Float64" do
        expect(subject).to eq(described_class::Native::Float64)
      end
    end

    describe ":float" do
      it "must be an alias to float32" do
        expect(subject[:float]).to be(subject[:float32])
      end
    end

    describe ":double" do
      it "must be an alias to float64" do
        expect(subject[:double]).to be(subject[:float64])
      end
    end

    #
    # Little-endian specs
    #
    describe ":int16_le" do
      subject { super()[:int16_le] }

      it "must equal #{described_class}::LittleEndian::Int16" do
        expect(subject).to eq(described_class::LittleEndian::Int16)
      end
    end

    describe ":int32_le" do
      subject { super()[:int32_le] }

      it "must equal #{described_class}::LittleEndian::Int32" do
        expect(subject).to eq(described_class::LittleEndian::Int32)
      end
    end

    describe ":int64_le" do
      subject { super()[:int64_le] }

      it "must equal #{described_class}::LittleEndian::Int64" do
        expect(subject).to eq(described_class::LittleEndian::Int64)
      end
    end

    describe ":uint16_le" do
      subject { super()[:uint16_le] }

      it "must equal #{described_class}::LittleEndian::UInt16" do
        expect(subject).to eq(described_class::LittleEndian::UInt16)
      end
    end

    describe ":uint32_le" do
      subject { super()[:uint32_le] }

      it "must equal #{described_class}::LittleEndian::UInt32" do
        expect(subject).to eq(described_class::LittleEndian::UInt32) 
      end
    end

    describe ":uint64_le" do
      subject { super()[:uint64_le] }

      it "must equal #{described_class}::LittleEndian::UInt64" do
        expect(subject).to eq(described_class::LittleEndian::UInt64)
      end
    end

    describe ":float32_le" do
      subject { super()[:float32_le] }

      it "must equal #{described_class}::LittleEndian::Float32" do
        expect(subject).to eq(described_class::LittleEndian::Float32)
      end
    end

    describe ":float64_le" do
      subject { super()[:float64_le] }

      it "must equal #{described_class}::LittleEndian::Float64" do
        expect(subject).to eq(described_class::LittleEndian::Float64)
      end
    end

    describe ":short_le" do
      it "must be an alias to int16_le" do
        expect(subject[:short_le]).to be(subject[:int16_le])
      end
    end

    describe ":int_le" do
      it "must be an alias to int32_le" do
        expect(subject[:int_le]).to be(subject[:int32_le])
      end
    end

    describe ":long_le" do
      it "must be an alias to int64_le" do
        expect(subject[:long_le]).to be(subject[:int64_le])
      end
    end

    describe ":long_long_le" do
      it "must be an alias to int64_le" do
        expect(subject[:long_long_le]).to be(subject[:int64_le])
      end
    end

    describe ":ushort_le" do
      it "must be an alias to uint16_le" do
        expect(subject[:ushort_le]).to be(subject[:uint16_le])
      end
    end

    describe ":uint_le" do
      it "must be an alias to uint32_le" do
        expect(subject[:uint_le]).to be(subject[:uint32_le])
      end
    end

    describe ":ulong_le" do
      it "must be an alias to uint64_le" do
        expect(subject[:ulong_le]).to be(subject[:uint64_le])
      end
    end

    describe ":ulong_long_le" do
      it "must be an alias to uint64_le" do
        expect(subject[:ulong_long_le]).to be(subject[:uint64_le])
      end
    end

    describe ":float_le" do
      it "must be an alias to float32_le" do
        expect(subject[:float_le]).to be(subject[:float32_le])
      end
    end

    describe ":double_le" do
      it "must be an alias to float64_le" do
        expect(subject[:double_le]).to be(subject[:float64_le])
      end
    end

    #
    # Big-endian specs
    #
    describe ":int16_be" do
      subject { super()[:int16_be] }

      it "must equal #{described_class}::BigEndian::Int16" do
        expect(subject).to eq(described_class::BigEndian::Int16)
      end
    end

    describe ":int32_be" do
      subject { super()[:int32_be] }

      it "must equal #{described_class}::BigEndian::Int32" do
        expect(subject).to eq(described_class::BigEndian::Int32)
      end
    end

    describe ":int64_be" do
      subject { super()[:int64_be] }

      it "must equal #{described_class}::BigEndian::Int64" do
        expect(subject).to eq(described_class::BigEndian::Int64)
      end
    end

    describe ":uint16_be" do
      subject { super()[:uint16_be] }

      it "must equal #{described_class}::BigEndian::UInt16" do
        expect(subject).to eq(described_class::BigEndian::UInt16)
      end
    end

    describe ":uint32_be" do
      subject { super()[:uint32_be] }

      it "must equal #{described_class}::BigEndian::UInt32" do
        expect(subject).to eq(described_class::BigEndian::UInt32)
      end
    end

    describe ":uint64_be" do
      subject { super()[:uint64_be] }

      it "must equal #{described_class}::BigEndian::UInt64" do
        expect(subject).to eq(described_class::BigEndian::UInt64)
      end
    end

    describe ":float32_be" do
      subject { super()[:float32_be] }

      it "must equal #{described_class}::BigEndian::Float32" do
        expect(subject).to eq(described_class::BigEndian::Float32)
      end
    end

    describe ":float64_be" do
      subject { super()[:float64_be] }

      it "must equal #{described_class}::BigEndian::Float64" do
        expect(subject).to eq(described_class::BigEndian::Float64)
      end
    end

    describe ":short_be" do
      it "must be an alias to int16_be" do
        expect(subject[:short_be]).to be(subject[:int16_be])
      end
    end

    describe ":int_be" do
      it "must be an alias to int32_be" do
        expect(subject[:int_be]).to be(subject[:int32_be])
      end
    end

    describe ":long_be" do
      it "must be an alias to int64_be" do
        expect(subject[:long_be]).to be(subject[:int64_be])
      end
    end

    describe ":long_long_be" do
      it "must be an alias to int64_be" do
        expect(subject[:long_long_be]).to be(subject[:int64_be])
      end
    end

    describe ":ushort_be" do
      it "must be an alias to uint16_be" do
        expect(subject[:ushort_be]).to be(subject[:uint16_be])
      end
    end

    describe ":uint_be" do
      it "must be an alias to uint32_be" do
        expect(subject[:uint_be]).to be(subject[:uint32_be])
      end
    end

    describe ":ulong_be" do
      it "must be an alias to uint64_be" do
        expect(subject[:ulong_be]).to be(subject[:uint64_be])
      end
    end

    describe ":ulong_long_be" do
      it "must be an alias to uint64_be" do
        expect(subject[:ulong_long_be]).to be(subject[:uint64_be])
      end
    end

    describe ":float_be" do
      it "must be an alias to float32_be" do
        expect(subject[:float_be]).to be(subject[:float32_be])
      end
    end

    describe ":double_be" do
      it "must be an alias to float64_be" do
        expect(subject[:double_be]).to be(subject[:float64_be])
      end
    end

    #
    # Network-endian specs
    #
    describe ":int16_ne" do
      subject { super()[:int16_ne] }

      it "must equal #{described_class}::Network::Int16" do
        expect(subject).to eq(described_class::Network::Int16)
      end
    end

    describe ":int32_ne" do
      subject { super()[:int32_ne] }

      it "must equal #{described_class}::Network::Int32" do
        expect(subject).to eq(described_class::Network::Int32)
      end
    end

    describe ":int64_ne" do
      subject { super()[:int64_ne] }

      it "must equal #{described_class}::Network::Int64" do
        expect(subject).to eq(described_class::Network::Int64)
      end
    end

    describe ":uint16_ne" do
      subject { super()[:uint16_ne] }

      it "must equal #{described_class}::Network::UInt16" do
        expect(subject).to eq(described_class::Network::UInt16)
      end
    end

    describe ":uint32_ne" do
      subject { super()[:uint32_ne] }

      it "must equal #{described_class}::Network::UInt32" do
        expect(subject).to eq(described_class::Network::UInt32)
      end
    end

    describe ":uint64_ne" do
      subject { super()[:uint64_ne] }

      it "must equal #{described_class}::Network::UInt64" do
        expect(subject).to eq(described_class::Network::UInt64)
      end
    end

    describe ":float32_ne" do
      subject { super()[:float32_ne] }

      it "must equal #{described_class}::Network::Float32" do
        expect(subject).to eq(described_class::Network::Float32)
      end
    end

    describe ":float64_ne" do
      subject { super()[:float64_ne] }

      it "must equal #{described_class}::Network::Float64" do
        expect(subject).to eq(described_class::Network::Float64)
      end
    end

    describe ":short_ne" do
      it "must be an alias to int16_ne" do
        expect(subject[:short_ne]).to be(subject[:int16_ne])
      end
    end

    describe ":int_ne" do
      it "must be an alias to int32_ne" do
        expect(subject[:int_ne]).to be(subject[:int32_ne])
      end
    end

    describe ":long_ne" do
      it "must be an alias to int64_ne" do
        expect(subject[:long_ne]).to be(subject[:int64_ne])
      end
    end

    describe ":long_long_ne" do
      it "must be an alias to int64_ne" do
        expect(subject[:long_long_ne]).to be(subject[:int64_ne])
      end
    end

    describe ":ushort_ne" do
      it "must be an alias to uint16_ne" do
        expect(subject[:ushort_ne]).to be(subject[:uint16_ne])
      end
    end

    describe ":uint_ne" do
      it "must be an alias to uint32_ne" do
        expect(subject[:uint_ne]).to be(subject[:uint32_ne])
      end
    end

    describe ":ulong_ne" do
      it "must be an alias to uint64_ne" do
        expect(subject[:ulong_ne]).to be(subject[:uint64_ne])
      end
    end

    describe ":ulong_long_ne" do
      it "must be an alias to uint64_ne" do
        expect(subject[:ulong_long_ne]).to be(subject[:uint64_ne])
      end
    end

    describe ":float_ne" do
      it "must be an alias to float32_ne" do
        expect(subject[:float_ne]).to be(subject[:float32_ne])
      end
    end

    describe ":double_ne" do
      it "must be an alias to float64_ne" do
        expect(subject[:double_ne]).to be(subject[:float64_ne])
      end
    end

    describe ":int16_net" do
      subject { super()[:int16_net] }

      it "must equal #{described_class}::Network::Int16" do
        expect(subject).to eq(described_class::Network::Int16)
      end
    end

    describe ":int32_net" do
      subject { super()[:int32_net] }

      it "must equal #{described_class}::Network::Int32" do
        expect(subject).to eq(described_class::Network::Int32)
      end
    end

    describe ":int64_net" do
      subject { super()[:int64_net] }

      it "must equal #{described_class}::Network::Int64" do
        expect(subject).to eq(described_class::Network::Int64)
      end
    end

    describe ":uint16_net" do
      subject { super()[:uint16_net] }

      it "must equal #{described_class}::Network::UInt16" do
        expect(subject).to eq(described_class::Network::UInt16)
      end
    end

    describe ":uint32_net" do
      subject { super()[:uint32_net] }

      it "must equal #{described_class}::Network::UInt32" do
        expect(subject).to eq(described_class::Network::UInt32)
      end
    end

    describe ":uint64_net" do
      subject { super()[:uint64_net] }

      it "must equal #{described_class}::Network::UInt64" do
        expect(subject).to eq(described_class::Network::UInt64)
      end
    end

    describe ":float32_net" do
      subject { super()[:float32_net] }

      it "must equal #{described_class}::Network::Float32" do
        expect(subject).to eq(described_class::Network::Float32)
      end
    end

    describe ":float64_net" do
      subject { super()[:float64_net] }

      it "must equal #{described_class}::Network::Float64" do
        expect(subject).to eq(described_class::Network::Float64)
      end
    end

    describe ":short_net" do
      it "must be an alias to int16_net" do
        expect(subject[:short_net]).to be(subject[:int16_net])
      end
    end

    describe ":int_net" do
      it "must be an alias to int32_net" do
        expect(subject[:int_net]).to be(subject[:int32_net])
      end
    end

    describe ":long_net" do
      it "must be an alias to int64_net" do
        expect(subject[:long_net]).to be(subject[:int64_net])
      end
    end

    describe ":long_long_net" do
      it "must be an alias to int64_net" do
        expect(subject[:long_long_net]).to be(subject[:int64_net])
      end
    end

    describe ":ushort_net" do
      it "must be an alias to uint16_net" do
        expect(subject[:ushort_net]).to be(subject[:uint16_net])
      end
    end

    describe ":uint_net" do
      it "must be an alias to uint32_net" do
        expect(subject[:uint_net]).to be(subject[:uint32_net])
      end
    end

    describe ":ulong_net" do
      it "must be an alias to uint64_net" do
        expect(subject[:ulong_net]).to be(subject[:uint64_net])
      end
    end

    describe ":ulong_long_net" do
      it "must be an alias to uint64_net" do
        expect(subject[:ulong_long_net]).to be(subject[:uint64_net])
      end
    end

    describe ":float_net" do
      it "must be an alias to float32_net" do
        expect(subject[:float_net]).to be(subject[:float32_net])
      end
    end

    describe ":double_net" do
      it "must be an alias to float64_net" do
        expect(subject[:double_net]).to be(subject[:float64_net])
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
        }.to raise_error(ArgumentError,"unknown type: #{name.inspect}")
      end
    end
  end
end
