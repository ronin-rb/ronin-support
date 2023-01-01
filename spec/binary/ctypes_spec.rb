require 'spec_helper'
require 'ronin/support/binary/ctypes'

describe Ronin::Support::Binary::CTypes do
  it { expect(subject).to include(Ronin::Support::Binary::CTypes::Native) }

  #
  # Little-endian constant specs
  #
  describe "INT16_LE" do
    subject { described_class::INT16_LE }

    it { expect(subject).to eq(described_class::LittleEndian::INT16) }
  end

  describe "INT32_LE" do
    subject { described_class::INT32_LE }

    it { expect(subject).to eq(described_class::LittleEndian::INT32) }
  end

  describe "INT64_LE" do
    subject { described_class::INT64_LE }

    it { expect(subject).to eq(described_class::LittleEndian::INT64) }
  end

  describe "UINT16_LE" do
    subject { described_class::UINT16_LE }

    it { expect(subject).to eq(described_class::LittleEndian::UINT16) }
  end

  describe "UINT32_LE" do
    subject { described_class::UINT32_LE }

    it { expect(subject).to eq(described_class::LittleEndian::UINT32) }
  end

  describe "UINT64_LE" do
    subject { described_class::UINT64_LE }

    it { expect(subject).to eq(described_class::LittleEndian::UINT64) }
  end

  describe "WORD_LE" do
    subject { described_class::WORD_LE }

    it { expect(subject).to eq(described_class::LittleEndian::WORD) }
  end

  describe "DWORD_LE" do
    subject { described_class::DWORD_LE }

    it { expect(subject).to eq(described_class::LittleEndian::DWORD) }
  end

  describe "QWORD_LE" do
    subject { described_class::QWORD_LE }

    it { expect(subject).to eq(described_class::LittleEndian::QWORD) }
  end

  describe "MACHINE_WORD_LE" do
    subject { described_class::MACHINE_WORD_LE }

    it { expect(subject).to eq(described_class::LittleEndian::MACHINE_WORD) }
  end

  describe "POINTER_LE" do
    subject { described_class::POINTER_LE }

    it { expect(subject).to eq(described_class::LittleEndian::POINTER) }
  end

  describe "FLOAT32_LE" do
    subject { described_class::FLOAT32_LE }

    it { expect(subject).to eq(described_class::LittleEndian::FLOAT32) }
  end

  describe "FLOAT64_LE" do
    subject { described_class::FLOAT64_LE }

    it { expect(subject).to eq(described_class::LittleEndian::FLOAT64) }
  end

  describe "FLOAT_LE" do
    subject { described_class::FLOAT_LE }

    it { expect(subject).to eq(described_class::LittleEndian::FLOAT) }
  end

  describe "DOUBLE_LE" do
    subject { described_class::DOUBLE_LE }

    it { expect(subject).to eq(described_class::LittleEndian::DOUBLE) }
  end

  #
  # Big-endian constant specs
  #
  describe "INT16_BE" do
    subject { described_class::INT16_BE }

    it { expect(subject).to eq(described_class::BigEndian::INT16) }
  end

  describe "INT32_BE" do
    subject { described_class::INT32_BE }

    it { expect(subject).to eq(described_class::BigEndian::INT32) }
  end

  describe "INT64_BE" do
    subject { described_class::INT64_BE }

    it { expect(subject).to eq(described_class::BigEndian::INT64) }
  end

  describe "UINT16_BE" do
    subject { described_class::UINT16_BE }

    it { expect(subject).to eq(described_class::BigEndian::UINT16) }
  end

  describe "UINT32_BE" do
    subject { described_class::UINT32_BE }

    it { expect(subject).to eq(described_class::BigEndian::UINT32) }
  end

  describe "UINT64_BE" do
    subject { described_class::UINT64_BE }

    it { expect(subject).to eq(described_class::BigEndian::UINT64) }
  end

  describe "WORD_BE" do
    subject { described_class::WORD_BE }

    it { expect(subject).to eq(described_class::BigEndian::WORD) }
  end

  describe "DWORD_BE" do
    subject { described_class::DWORD_BE }

    it { expect(subject).to eq(described_class::BigEndian::DWORD) }
  end

  describe "QWORD_BE" do
    subject { described_class::QWORD_BE }

    it { expect(subject).to eq(described_class::BigEndian::QWORD) }
  end

  describe "MACHINE_WORD_BE" do
    subject { described_class::MACHINE_WORD_BE }

    it { expect(subject).to eq(described_class::BigEndian::MACHINE_WORD) }
  end

  describe "POINTER_BE" do
    subject { described_class::POINTER_BE }

    it { expect(subject).to eq(described_class::BigEndian::POINTER) }
  end

  describe "FLOAT32_BE" do
    subject { described_class::FLOAT32_BE }

    it { expect(subject).to eq(described_class::BigEndian::FLOAT32) }
  end

  describe "FLOAT64_BE" do
    subject { described_class::FLOAT64_BE }

    it { expect(subject).to eq(described_class::BigEndian::FLOAT64) }
  end

  describe "FLOAT_BE" do
    subject { described_class::FLOAT_BE }

    it { expect(subject).to eq(described_class::BigEndian::FLOAT) }
  end

  describe "DOUBLE_BE" do
    subject { described_class::DOUBLE_BE }

    it { expect(subject).to eq(described_class::BigEndian::DOUBLE) }
  end

  #
  # Network-endian constant specs
  #
  describe "INT16_NE" do
    subject { described_class::INT16_NE }

    it { expect(subject).to eq(described_class::Network::INT16) }
  end

  describe "INT32_NE" do
    subject { described_class::INT32_NE }

    it { expect(subject).to eq(described_class::Network::INT32) }
  end

  describe "INT64_NE" do
    subject { described_class::INT64_NE }

    it { expect(subject).to eq(described_class::Network::INT64) }
  end

  describe "UINT16_NE" do
    subject { described_class::UINT16_NE }

    it { expect(subject).to eq(described_class::Network::UINT16) }
  end

  describe "UINT32_NE" do
    subject { described_class::UINT32_NE }

    it { expect(subject).to eq(described_class::Network::UINT32) }
  end

  describe "UINT64_NE" do
    subject { described_class::UINT64_NE }

    it { expect(subject).to eq(described_class::Network::UINT64) }
  end

  describe "WORD_NE" do
    subject { described_class::WORD_NE }

    it { expect(subject).to eq(described_class::Network::WORD) }
  end

  describe "DWORD_NE" do
    subject { described_class::DWORD_NE }

    it { expect(subject).to eq(described_class::Network::DWORD) }
  end

  describe "QWORD_NE" do
    subject { described_class::QWORD_NE }

    it { expect(subject).to eq(described_class::Network::QWORD) }
  end

  describe "MACHINE_WORD_NE" do
    subject { described_class::MACHINE_WORD_NE }

    it { expect(subject).to eq(described_class::Network::MACHINE_WORD) }
  end

  describe "POINTER_NE" do
    subject { described_class::POINTER_NE }

    it { expect(subject).to eq(described_class::Network::POINTER) }
  end

  describe "FLOAT32_NE" do
    subject { described_class::FLOAT32_NE }

    it { expect(subject).to eq(described_class::Network::FLOAT32) }
  end

  describe "FLOAT64_NE" do
    subject { described_class::FLOAT64_NE }

    it { expect(subject).to eq(described_class::Network::FLOAT64) }
  end

  describe "FLOAT_NE" do
    subject { described_class::FLOAT_NE }

    it { expect(subject).to eq(described_class::Network::FLOAT) }
  end

  describe "DOUBLE_NE" do
    subject { described_class::DOUBLE_NE }

    it { expect(subject).to eq(described_class::Network::DOUBLE) }
  end

  describe "INT16_NET" do
    subject { described_class::INT16_NET }

    it { expect(subject).to eq(described_class::Network::INT16) }
  end

  describe "INT32_NET" do
    subject { described_class::INT32_NET }

    it { expect(subject).to eq(described_class::Network::INT32) }
  end

  describe "INT64_NET" do
    subject { described_class::INT64_NET }

    it { expect(subject).to eq(described_class::Network::INT64) }
  end

  describe "UINT16_NET" do
    subject { described_class::UINT16_NET }

    it { expect(subject).to eq(described_class::Network::UINT16) }
  end

  describe "UINT32_NET" do
    subject { described_class::UINT32_NET }

    it { expect(subject).to eq(described_class::Network::UINT32) }
  end

  describe "UINT64_NET" do
    subject { described_class::UINT64_NET }

    it { expect(subject).to eq(described_class::Network::UINT64) }
  end

  describe "WORD_NET" do
    subject { described_class::WORD_NET }

    it { expect(subject).to eq(described_class::Network::WORD) }
  end

  describe "DWORD_NET" do
    subject { described_class::DWORD_NET }

    it { expect(subject).to eq(described_class::Network::DWORD) }
  end

  describe "QWORD_NET" do
    subject { described_class::QWORD_NET }

    it { expect(subject).to eq(described_class::Network::QWORD) }
  end

  describe "MACHINE_WORD_NET" do
    subject { described_class::MACHINE_WORD_NET }

    it { expect(subject).to eq(described_class::Network::MACHINE_WORD) }
  end

  describe "POINTER_NET" do
    subject { described_class::POINTER_NET }

    it { expect(subject).to eq(described_class::Network::POINTER) }
  end

  describe "FLOAT32_NET" do
    subject { described_class::FLOAT32_NET }

    it { expect(subject).to eq(described_class::Network::FLOAT32) }
  end

  describe "FLOAT64_NET" do
    subject { described_class::FLOAT64_NET }

    it { expect(subject).to eq(described_class::Network::FLOAT64) }
  end

  describe "FLOAT_NET" do
    subject { described_class::FLOAT_NET }

    it { expect(subject).to eq(described_class::Network::FLOAT) }
  end

  describe "DOUBLE_NET" do
    subject { described_class::DOUBLE_NET }

    it { expect(subject).to eq(described_class::Network::DOUBLE) }
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    #
    # Native types specs
    #
    describe ":char" do
      subject { super()[:char] }

      it "must equal #{described_class}::Native::CHAR" do
        expect(subject).to eq(described_class::Native::CHAR)
      end
    end

    describe ":uchar" do
      subject { super()[:uchar] }

      it "must equal #{described_class}::Native::UCHAR" do
        expect(subject).to eq(described_class::Native::UCHAR)
      end
    end

    describe ":int8" do
      subject { super()[:int8] }

      it "must equal #{described_class}::Native::INT8" do
        expect(subject).to eq(described_class::Native::INT8)
      end
    end

    describe ":int16" do
      subject { super()[:int16] }

      it "must equal #{described_class}::Native::INT16" do
        expect(subject).to eq(described_class::Native::INT16)
      end
    end

    describe ":int32" do
      subject { super()[:int32] }

      it "must equal #{described_class}::Native::INT32" do
        expect(subject).to eq(described_class::Native::INT32)
      end
    end

    describe ":int64" do
      subject { super()[:int64] }

      it "must equal #{described_class}::Native::INT64" do
        expect(subject).to eq(described_class::Native::INT64)
      end
    end

    describe ":uint8" do
      subject { super()[:uint8] }

      it "must equal #{described_class}::Native::UINT8" do
        expect(subject).to eq(described_class::Native::UINT8)
      end
    end

    describe ":uint16" do
      subject { super()[:uint16] }

      it "must equal #{described_class}::Native::UINT16" do
        expect(subject).to eq(described_class::Native::UINT16)
      end
    end

    describe ":uint32" do
      subject { super()[:uint32] }

      it "must equal #{described_class}::Native::UINT32" do
        expect(subject).to eq(described_class::Native::UINT32)
      end
    end

    describe ":uint64" do
      subject { super()[:uint64] }

      it "must equal #{described_class}::Native::UINT64" do
        expect(subject).to eq(described_class::Native::UINT64)
      end
    end

    describe ":byte" do
      it "must be an alias to uint8" do
        expect(subject[:byte]).to be(subject[:uint8])
      end
    end

    describe ":short" do
      it "must be an alias to int16" do
        expect(subject[:short]).to be(subject[:int16])
      end
    end

    describe ":int" do
      it "must be an alias to int32" do
        expect(subject[:int]).to be(subject[:int32])
      end
    end

    describe ":long" do
      subject { super()[:long] }

      it "must equal #{described_class}::Native::LONG" do
        expect(subject).to eq(described_class::Native::LONG)
      end
    end

    describe ":long_long" do
      it "must be an alias to int64" do
        expect(subject[:long_long]).to be(subject[:int64])
      end
    end

    describe ":ushort" do
      it "must be an alias to uint16" do
        expect(subject[:ushort]).to be(subject[:uint16])
      end
    end

    describe ":uint" do
      it "must be an alias to uint32" do
        expect(subject[:uint]).to be(subject[:uint32])
      end
    end

    describe ":ulong" do
      subject { super()[:ulong] }

      it "must equal #{described_class}::Native::ULONG" do
        expect(subject).to eq(described_class::Native::ULONG)
      end
    end

    describe ":ulong_long" do
      it "must be an alias to uint64" do
        expect(subject[:ulong_long]).to be(subject[:uint64])
      end
    end

    describe ":word" do
      it "must be an alias to uint16" do
        expect(subject[:word]).to be(subject[:uint16])
      end
    end

    describe ":dword" do
      it "must be an alias to uint32" do
        expect(subject[:dword]).to be(subject[:uint32])
      end
    end

    describe ":qword" do
      it "must be an alias to uint64" do
        expect(subject[:qword]).to be(subject[:uint64])
      end
    end

    describe ":machine_word" do
      subject { super()[:machine_word] }

      it "must equal #{described_class}::Native::MACHINE_WORD" do
        expect(subject).to eq(described_class::Native::MACHINE_WORD)
      end
    end

    describe ":pointer" do
      subject { super()[:pointer] }

      it "must equal #{described_class}::Native::POINTER" do
        expect(subject).to eq(described_class::Native::POINTER)
      end
    end

    describe ":float32" do
      subject { super()[:float32] }

      it "must equal #{described_class}::Native::FLOAT32" do
        expect(subject).to eq(described_class::Native::FLOAT32)
      end
    end

    describe ":float64" do
      subject { super()[:float64] }

      it "must equal #{described_class}::Native::FLOAT64" do
        expect(subject).to eq(described_class::Native::FLOAT64)
      end
    end

    describe ":float" do
      it "must be an alias to float32" do
        expect(subject[:float]).to eq(described_class::Native::FLOAT)
      end
    end

    describe ":double" do
      it "must be an alias to float64" do
        expect(subject[:double]).to eq(described_class::Native::DOUBLE)
      end
    end

    #
    # Little-endian specs
    #
    describe ":int16_le" do
      subject { super()[:int16_le] }

      it "must equal #{described_class}::LittleEndian::INT16" do
        expect(subject).to eq(described_class::LittleEndian::INT16)
      end
    end

    describe ":int32_le" do
      subject { super()[:int32_le] }

      it "must equal #{described_class}::LittleEndian::INT32" do
        expect(subject).to eq(described_class::LittleEndian::INT32)
      end
    end

    describe ":int64_le" do
      subject { super()[:int64_le] }

      it "must equal #{described_class}::LittleEndian::INT64" do
        expect(subject).to eq(described_class::LittleEndian::INT64)
      end
    end

    describe ":uint16_le" do
      subject { super()[:uint16_le] }

      it "must equal #{described_class}::LittleEndian::UINT16" do
        expect(subject).to eq(described_class::LittleEndian::UINT16)
      end
    end

    describe ":uint32_le" do
      subject { super()[:uint32_le] }

      it "must equal #{described_class}::LittleEndian::UINT32" do
        expect(subject).to eq(described_class::LittleEndian::UINT32) 
      end
    end

    describe ":uint64_le" do
      subject { super()[:uint64_le] }

      it "must equal #{described_class}::LittleEndian::UINT64" do
        expect(subject).to eq(described_class::LittleEndian::UINT64)
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
      subject { super()[:long_le] }

      it "must equal #{described_class}::LittleEndian::LONG" do
        expect(subject).to eq(described_class::LittleEndian::LONG)
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
      subject { super()[:ulong_le] }

      it "must equal #{described_class}::LittleEndian::ULONG" do
        expect(subject).to eq(described_class::LittleEndian::ULONG)
      end
    end

    describe ":ulong_long_le" do
      it "must be an alias to uint64_le" do
        expect(subject[:ulong_long_le]).to be(subject[:uint64_le])
      end
    end

    describe ":word_le" do
      it "must be an alias to uint16_le" do
        expect(subject[:word_le]).to be(subject[:uint16_le])
      end
    end

    describe ":dword_le" do
      it "must be an alias to uint32_le" do
        expect(subject[:dword_le]).to be(subject[:uint32_le])
      end
    end

    describe ":qword_le" do
      it "must be an alias to uint64_le" do
        expect(subject[:qword_le]).to be(subject[:uint64_le])
      end
    end

    describe ":machine_word_le" do
      subject { super()[:machine_word_le] }

      it "must equal #{described_class}::LittleEndian::MACHINE_WORD" do
        expect(subject).to eq(described_class::LittleEndian::MACHINE_WORD)
      end
    end

    describe ":pointer_le" do
      subject { super()[:pointer_le] }

      it "must equal #{described_class}::LittleEndian::POINTER" do
        expect(subject).to eq(described_class::LittleEndian::POINTER)
      end
    end

    describe ":float32_le" do
      subject { super()[:float32_le] }

      it "must equal #{described_class}::LittleEndian::FLOAT32" do
        expect(subject).to eq(described_class::LittleEndian::FLOAT32)
      end
    end

    describe ":float64_le" do
      subject { super()[:float64_le] }

      it "must equal #{described_class}::LittleEndian::FLOAT64" do
        expect(subject).to eq(described_class::LittleEndian::FLOAT64)
      end
    end

    describe ":float_le" do
      it "must be an alias to float32_le" do
        expect(subject[:float_le]).to eq(described_class::LittleEndian::FLOAT)
      end
    end

    describe ":double_le" do
      it "must be an alias to float64_le" do
        expect(subject[:double_le]).to eq(described_class::LittleEndian::DOUBLE)
      end
    end

    #
    # Big-endian specs
    #
    describe ":int16_be" do
      subject { super()[:int16_be] }

      it "must equal #{described_class}::BigEndian::INT16" do
        expect(subject).to eq(described_class::BigEndian::INT16)
      end
    end

    describe ":int32_be" do
      subject { super()[:int32_be] }

      it "must equal #{described_class}::BigEndian::INT32" do
        expect(subject).to eq(described_class::BigEndian::INT32)
      end
    end

    describe ":int64_be" do
      subject { super()[:int64_be] }

      it "must equal #{described_class}::BigEndian::INT64" do
        expect(subject).to eq(described_class::BigEndian::INT64)
      end
    end

    describe ":uint16_be" do
      subject { super()[:uint16_be] }

      it "must equal #{described_class}::BigEndian::UINT16" do
        expect(subject).to eq(described_class::BigEndian::UINT16)
      end
    end

    describe ":uint32_be" do
      subject { super()[:uint32_be] }

      it "must equal #{described_class}::BigEndian::UINT32" do
        expect(subject).to eq(described_class::BigEndian::UINT32)
      end
    end

    describe ":uint64_be" do
      subject { super()[:uint64_be] }

      it "must equal #{described_class}::BigEndian::UINT64" do
        expect(subject).to eq(described_class::BigEndian::UINT64)
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
      subject { super()[:long_be] }

      it "must equal #{described_class}::BigEndian::LONG" do
        expect(subject).to eq(described_class::BigEndian::LONG)
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
      subject { super()[:ulong_be] }

      it "must equal #{described_class}::BigEndian::ULONG" do
        expect(subject).to eq(described_class::BigEndian::ULONG)
      end
    end

    describe ":ulong_long_be" do
      it "must be an alias to uint64_be" do
        expect(subject[:ulong_long_be]).to be(subject[:uint64_be])
      end
    end

    describe ":word_be" do
      it "must be an alias to uint16_be" do
        expect(subject[:word_be]).to be(subject[:uint16_be])
      end
    end

    describe ":dword_be" do
      it "must be an alias to uint32_be" do
        expect(subject[:dword_be]).to be(subject[:uint32_be])
      end
    end

    describe ":qword_be" do
      it "must be an alias to uint64_be" do
        expect(subject[:qword_be]).to be(subject[:uint64_be])
      end
    end

    describe ":machine_word_be" do
      subject { super()[:machine_word_be] }

      it "must equal #{described_class}::BigEndian::MACHINE_WORD" do
        expect(subject).to eq(described_class::BigEndian::MACHINE_WORD)
      end
    end

    describe ":pointer_be" do
      subject { super()[:pointer_be] }

      it "must equal #{described_class}::BigEndian::POINTER" do
        expect(subject).to eq(described_class::BigEndian::POINTER)
      end
    end

    describe ":float32_be" do
      subject { super()[:float32_be] }

      it "must equal #{described_class}::BigEndian::FLOAT32" do
        expect(subject).to eq(described_class::BigEndian::FLOAT32)
      end
    end

    describe ":float64_be" do
      subject { super()[:float64_be] }

      it "must equal #{described_class}::BigEndian::FLOAT64" do
        expect(subject).to eq(described_class::BigEndian::FLOAT64)
      end
    end

    describe ":float_be" do
      it "must be an alias to float32_be" do
        expect(subject[:float_be]).to eq(described_class::BigEndian::FLOAT)
      end
    end

    describe ":double_be" do
      it "must be an alias to float64_be" do
        expect(subject[:double_be]).to eq(described_class::BigEndian::DOUBLE)
      end
    end

    #
    # Network-endian specs
    #
    describe ":int16_ne" do
      subject { super()[:int16_ne] }

      it "must equal #{described_class}::Network::INT16" do
        expect(subject).to eq(described_class::Network::INT16)
      end
    end

    describe ":int32_ne" do
      subject { super()[:int32_ne] }

      it "must equal #{described_class}::Network::INT32" do
        expect(subject).to eq(described_class::Network::INT32)
      end
    end

    describe ":int64_ne" do
      subject { super()[:int64_ne] }

      it "must equal #{described_class}::Network::INT64" do
        expect(subject).to eq(described_class::Network::INT64)
      end
    end

    describe ":uint16_ne" do
      subject { super()[:uint16_ne] }

      it "must equal #{described_class}::Network::UINT16" do
        expect(subject).to eq(described_class::Network::UINT16)
      end
    end

    describe ":uint32_ne" do
      subject { super()[:uint32_ne] }

      it "must equal #{described_class}::Network::UINT32" do
        expect(subject).to eq(described_class::Network::UINT32)
      end
    end

    describe ":uint64_ne" do
      subject { super()[:uint64_ne] }

      it "must equal #{described_class}::Network::UINT64" do
        expect(subject).to eq(described_class::Network::UINT64)
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
      subject { super()[:long_ne] }

      it "must equal #{described_class}::Network::LONG" do
        expect(subject).to eq(described_class::Network::LONG)
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
      subject { super()[:ulong_ne] }

      it "must equal #{described_class}::Network::ULONG" do
        expect(subject).to eq(described_class::Network::ULONG)
      end
    end

    describe ":ulong_long_ne" do
      it "must be an alias to uint64_ne" do
        expect(subject[:ulong_long_ne]).to be(subject[:uint64_ne])
      end
    end

    describe ":word_ne" do
      it "must be an alias to uint16_ne" do
        expect(subject[:word_ne]).to be(subject[:uint16_ne])
      end
    end

    describe ":dword_ne" do
      it "must be an alias to uint32_ne" do
        expect(subject[:dword_ne]).to be(subject[:uint32_ne])
      end
    end

    describe ":qword_ne" do
      it "must be an alias to uint64_ne" do
        expect(subject[:qword_ne]).to be(subject[:uint64_ne])
      end
    end

    describe ":machine_word_ne" do
      subject { super()[:machine_word_ne] }

      it "must equal #{described_class}::Network::MACHINE_WORD" do
        expect(subject).to eq(described_class::Network::MACHINE_WORD)
      end
    end

    describe ":pointer_ne" do
      subject { super()[:pointer_ne] }

      it "must equal #{described_class}::Network::POINTER" do
        expect(subject).to eq(described_class::Network::POINTER)
      end
    end

    describe ":float32_ne" do
      subject { super()[:float32_ne] }

      it "must equal #{described_class}::Network::FLOAT32" do
        expect(subject).to eq(described_class::Network::FLOAT32)
      end
    end

    describe ":float64_ne" do
      subject { super()[:float64_ne] }

      it "must equal #{described_class}::Network::FLOAT64" do
        expect(subject).to eq(described_class::Network::FLOAT64)
      end
    end

    describe ":float_ne" do
      it "must be an alias to float32_ne" do
        expect(subject[:float_ne]).to eq(described_class::Network::FLOAT)
      end
    end

    describe ":double_ne" do
      it "must be an alias to float64_ne" do
        expect(subject[:double_ne]).to eq(described_class::Network::DOUBLE)
      end
    end

    describe ":int16_net" do
      subject { super()[:int16_net] }

      it "must equal #{described_class}::Network::INT16" do
        expect(subject).to eq(described_class::Network::INT16)
      end
    end

    describe ":int32_net" do
      subject { super()[:int32_net] }

      it "must equal #{described_class}::Network::INT32" do
        expect(subject).to eq(described_class::Network::INT32)
      end
    end

    describe ":int64_net" do
      subject { super()[:int64_net] }

      it "must equal #{described_class}::Network::INT64" do
        expect(subject).to eq(described_class::Network::INT64)
      end
    end

    describe ":uint16_net" do
      subject { super()[:uint16_net] }

      it "must equal #{described_class}::Network::UINT16" do
        expect(subject).to eq(described_class::Network::UINT16)
      end
    end

    describe ":uint32_net" do
      subject { super()[:uint32_net] }

      it "must equal #{described_class}::Network::UINT32" do
        expect(subject).to eq(described_class::Network::UINT32)
      end
    end

    describe ":uint64_net" do
      subject { super()[:uint64_net] }

      it "must equal #{described_class}::Network::UINT64" do
        expect(subject).to eq(described_class::Network::UINT64)
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
      subject { super()[:long_net] }

      it "must equal #{described_class}::Network::LONG" do
        expect(subject).to eq(described_class::Network::LONG)
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
      subject { super()[:ulong_net] }

      it "must equal #{described_class}::Network::ULONG" do
        expect(subject).to eq(described_class::Network::ULONG)
      end
    end

    describe ":ulong_long_net" do
      it "must be an alias to uint64_net" do
        expect(subject[:ulong_long_net]).to be(subject[:uint64_net])
      end
    end

    describe ":word_net" do
      it "must be an alias to uint16_net" do
        expect(subject[:word_net]).to be(subject[:uint16_net])
      end
    end

    describe ":dword_net" do
      it "must be an alias to uint32_net" do
        expect(subject[:dword_net]).to be(subject[:uint32_net])
      end
    end

    describe ":qword_net" do
      it "must be an alias to uint64_net" do
        expect(subject[:qword_net]).to be(subject[:uint64_net])
      end
    end

    describe ":machine_word_net" do
      subject { super()[:machine_word_net] }

      it "must equal #{described_class}::Network::MACHINE_WORD" do
        expect(subject).to eq(described_class::Network::MACHINE_WORD)
      end
    end

    describe ":pointer_net" do
      subject { super()[:pointer_net] }

      it "must equal #{described_class}::Network::POINTER" do
        expect(subject).to eq(described_class::Network::POINTER)
      end
    end

    describe ":float32_net" do
      subject { super()[:float32_net] }

      it "must equal #{described_class}::Network::FLOAT32" do
        expect(subject).to eq(described_class::Network::FLOAT32)
      end
    end

    describe ":float64_net" do
      subject { super()[:float64_net] }

      it "must equal #{described_class}::Network::FLOAT64" do
        expect(subject).to eq(described_class::Network::FLOAT64)
      end
    end

    describe ":float_net" do
      it "must be an alias to float32_net" do
        expect(subject[:float_net]).to eq(described_class::Network::FLOAT)
      end
    end

    describe ":double_net" do
      it "must be an alias to float64_net" do
        expect(subject[:double_net]).to eq(described_class::Network::DOUBLE)
      end
    end
  end

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
        }.to raise_error(ArgumentError,"unknown type: #{name.inspect}")
      end
    end
  end

  describe "ENDIAN" do
    subject { described_class::ENDIAN }

    describe ":little" do
      subject { super()[:little] }

      it { expect(subject).to be(described_class::LittleEndian) }
    end

    describe ":big" do
      subject { super()[:big] }

      it { expect(subject).to be(described_class::BigEndian) }
    end

    describe ":net" do
      subject { super()[:net] }

      it { expect(subject).to be(described_class::Network) }
    end

    describe "nil" do
      subject { super()[nil] }

      it { expect(subject).to be(described_class) }
    end
  end

  describe "ARCHES" do
    subject { described_class::ARCHES }

    describe ":x86" do
      subject { super()[:x86] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::X86) }
    end

    describe ":x86_64" do
      subject { super()[:x86_64] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::X86_64) }
    end

    describe ":ia64" do
      it "must be an alias to :x86_64" do
        expect(subject[:ia64]).to be(subject[:x86_64])
      end
    end

    describe ":amd64" do
      it "must be an alias to :x86_64" do
        expect(subject[:amd64]).to be(subject[:x86_64])
      end
    end

    describe ":ppc" do
      subject { super()[:ppc] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::PPC) }
    end

    describe ":ppc64" do
      subject { super()[:ppc64] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::PPC64) }
    end

    describe ":mips" do
      subject { super()[:mips] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::MIPS) }
    end

    describe ":mips_le" do
      subject { super()[:mips_le] }

      it do
        expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::MIPS::LittleEndian)
      end
    end

    describe ":mips_be" do
      it "must be an alias to :mips" do
        expect(subject[:mips_be]).to be(subject[:mips])
      end
    end

    describe ":mips64" do
      subject { super()[:mips64] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::MIPS64) }
    end

    describe ":mips64_le" do
      subject { super()[:mips64_le] }

      it do
        expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::MIPS64::LittleEndian)
      end
    end

    describe ":mips64_be" do
      it "must be an alias to :mips64" do
        expect(subject[:mips64_be]).to be(subject[:mips64])
      end
    end

    describe ":arm" do
      subject { super()[:arm] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::ARM) }
    end

    describe ":arm_le" do
      it "must be an alias to :arm" do
        expect(subject[:arm_le]).to be(subject[:arm])
      end
    end

    describe ":arm_be" do
      subject { super()[:arm_be] }

      it do
        expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::ARM::BigEndian)
      end
    end

    describe ":arm64" do
      subject { super()[:arm64] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::ARM64) }
    end

    describe ":arm64_le" do
      it "must be an alias to :arm64" do
        expect(subject[:arm64_le]).to be(subject[:arm64])
      end
    end

    describe ":arm64_be" do
      subject { super()[:arm64_be] }

      it do
        expect(subject).to be(Ronin::Support::Binary::CTypes::Arch::ARM64::BigEndian)
      end
    end
  end

  describe "OSES" do
    subject { described_class::OSES }

    describe ":unix" do
      subject { super()[:unix] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::UNIX) }
    end

    describe ":bsd" do
      subject { super()[:bsd] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::BSD) }
    end

    describe ":freebsd" do
      subject { super()[:freebsd] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::FreeBSD) }
    end

    describe ":openbsd" do
      subject { super()[:openbsd] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::OpenBSD) }
    end

    describe ":netbsd" do
      subject { super()[:netbsd] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::NetBSD) }
    end

    describe ":linux" do
      subject { super()[:linux] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::Linux ) }
    end

    describe ":macos" do
      subject { super()[:macos] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::MacOS) }
    end

    describe ":windows" do
      subject { super()[:windows] }

      it { expect(subject).to be(Ronin::Support::Binary::CTypes::OS::Windows) }
    end
  end

  describe ".platform" do
    context "when given no keyword arguments" do
      it "must return #{described_class}" do
        expect(subject.platform).to eq(subject)
      end
    end

    context "when given the endian: keyword argument" do
      context "and it's :little" do
        it "must return #{described_class::LittleEndian}" do
          expect(subject.platform(endian: :little)).to be(described_class::LittleEndian)
        end
      end

      context "and it's :big" do
        it "must return #{described_class::BigEndian}" do
          expect(subject.platform(endian: :big)).to be(described_class::BigEndian)
        end
      end

      context "and it's :net" do
        it "must return #{described_class::Network}" do
          expect(subject.platform(endian: :net)).to be(described_class::Network)
        end
      end

      context "and it's nil" do
        it "must return self" do
          expect(subject.platform(endian: nil)).to be(subject)
        end
      end

      context "but it's an unknown endian" do
        let(:endian) { :foo }

        it do
          expect {
            subject.platform(endian: endian)
          }.to raise_error(ArgumentError,"unknown endian: #{endian.inspect}")
        end
      end
    end

    context "when given the arch: keyword argument" do
      context "and it's a valid arch name" do
        it "must return the #{described_class::Arch}:: module" do
          expect(subject.platform(arch: :x86_64)).to be(described_class::Arch::X86_64)
        end
      end

      context "but it's an unknown arch name" do
        let(:arch) { :foo }

        it do
          expect {
            subject.platform(arch: arch)
          }.to raise_error(ArgumentError,"unknown architecture: #{arch.inspect}")
        end
      end
    end

    context "when given the os: keyword argument" do
      context "and it's a valid OS name" do
        it "must return an instance of the #{described_class::OS}:: class" do
          expect(subject.platform(os: :linux)).to be_kind_of(described_class::OS::Linux)
        end

        context "and the endian: keyword is also given" do
          it "must initialize the #{described_class::OS}:: class with the correspding endian module" do
            expect(subject.platform(endian: :big, os: :linux).types).to be(described_class::BigEndian)
          end
        end

        context "and the arch: keyword is also given" do
          it "must initialize the #{described_class::OS}:: class with the correspding #{described_class}::Arch:: module" do
            expect(subject.platform(arch: :arm64, os: :linux).types).to be(described_class::Arch::ARM64)
          end
        end
      end

      context "but it's an unknown OS name" do
        let(:os) { :foo }

        it do
          expect {
            subject.platform(os: os)
          }.to raise_error(ArgumentError,"unknown OS: #{os.inspect}")
        end
      end
    end
  end
end
