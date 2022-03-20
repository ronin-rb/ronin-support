require 'spec_helper'
require 'ronin/support/binary/types/little_endian'

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

  describe "SHORT" do
    subject { described_class::SHORT }

    it { expect(subject).to eq(described_class::INT16) }
  end

  describe "INT" do
    subject { described_class::INT }

    it { expect(subject).to eq(described_class::INT32) }
  end

  describe "LONG" do
    subject { described_class::LONG }

    if described_class::ADDRESS_SIZE == 8
      context "when ADDRESS_SIZE is 8" do
        it "must be an alias to INT64" do
          expect(subject).to eq(described_class::INT64)
        end
      end
    else
      context "when the ADDRESS_SIZE is #{described_class::ADDRESS_SIZE}" do
        it "must be an alias to INT32" do
          expect(subject).to eq(described_class::INT32)
        end
      end
    end
  end

  describe "LONG_LONG" do
    subject { described_class::LONG_LONG }

    it { expect(subject).to eq(described_class::INT64) }
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

  describe "BYTE" do
    subject { described_class::BYTE }

    it { expect(subject).to eq(described_class::UINT8) }
  end

  describe "USHORT" do
    subject { described_class::USHORT}

    it { expect(subject).to eq(described_class::UINT16) }
  end

  describe "UINT" do
    subject { described_class::UINT}

    it { expect(subject).to eq(described_class::UINT32) }
  end

  describe "ULONG" do
    subject { described_class::ULONG }

    if described_class::ADDRESS_SIZE == 8
      context "when ADDRESS_SIZE is 8" do
        it "must be an alias to UINT64" do
          expect(subject).to eq(described_class::UINT64)
        end
      end
    else
      context "when the ADDRESS_SIZE is #{described_class::ADDRESS_SIZE}" do
        it "must be an alias to UINT32" do
          expect(subject).to eq(described_class::UINT32)
        end
      end
    end
  end

  describe "ULONG_LONG" do
    subject { described_class::ULONG_LONG }

    it { expect(subject).to eq(described_class::UINT64) }
  end

  describe "WORD" do
    subject { described_class::WORD }

    it { expect(subject).to eq(described_class::UINT16) }
  end

  describe "DWORD" do
    subject { described_class::DWORD }

    it { expect(subject).to eq(described_class::UINT32) }
  end

  describe "QWORD" do
    subject { described_class::QWORD }

    it { expect(subject).to eq(described_class::UINT64) }
  end

  describe "MACHINE_WORD" do
    subject { described_class::MACHINE_WORD }

    if described_class::ADDRESS_SIZE == 8
      context "when ADDRESS_SIZE is 8" do
        it "must return UINT64" do
          expect(subject).to be(described_class::UINT64)
        end
      end
    else
      context "when the ADDRESS_SIZE is #{described_class::ADDRESS_SIZE}" do
        it "must be an alias to UINT32" do
          expect(subject).to be(described_class::UINT32)
        end
      end
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

  describe "FLOAT" do
    subject { described_class::FLOAT }

    it { expect(subject).to eq(described_class::FLOAT32) }
  end

  describe "DOUBLE" do
    subject { described_class::DOUBLE }

    it { expect(subject).to eq(described_class::FLOAT64) }
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":byte" do
      subject { super()[:byte] }

      it "must equal #{described_class}::BYTE" do
        expect(subject).to eq(described_class::BYTE)
      end
    end

    describe ":char" do
      subject { super()[:char] }

      it "must equal #{described_class}::CHAR" do
        expect(subject).to eq(described_class::CHAR)
      end
    end

    describe ":uchar" do
      subject { super()[:uchar] }

      it "must equal #{described_class}::UCHAR" do
        expect(subject).to eq(described_class::UCHAR)
      end
    end

    describe ":int8" do
      subject { super()[:int8] }

      it "must equal #{described_class}::INT8" do
        expect(subject).to eq(described_class::INT8)
      end
    end

    describe ":uint8" do
      subject { super()[:uint8] }

      it "must equal #{described_class}::UINT8" do
        expect(subject).to eq(described_class::UINT8)
      end
    end

    describe ":int16" do
      subject { super()[:int16] }

      it "must equal #{described_class}::INT16" do
        expect(subject).to eq(described_class::INT16)
      end
    end

    describe ":uint16" do
      subject { super()[:uint16] }

      it "must equal #{described_class}::UINT16" do
        expect(subject).to eq(described_class::UINT16)
      end
    end

    describe ":int32" do
      subject { super()[:int32] }

      it "must equal #{described_class}::INT32" do
        expect(subject).to eq(described_class::INT32)
      end
    end

    describe ":uint32" do
      subject { super()[:uint32] }

      it "must equal #{described_class}::UINT32" do
        expect(subject).to eq(described_class::UINT32)
      end
    end

    describe ":int64" do
      subject { super()[:int64] }

      it "must equal #{described_class}::INT64" do
        expect(subject).to eq(described_class::INT64)
      end
    end

    describe ":uint64" do
      subject { super()[:uint64] }

      it "must equal #{described_class}::UINT64" do
        expect(subject).to eq(described_class::UINT64)
      end
    end

    describe ":short" do
      subject { super()[:short] }

      it "must equal #{described_class}::SHORT" do
        expect(subject).to eq(described_class::SHORT)
      end
    end

    describe ":int" do
      subject { super()[:int] }

      it "must equal #{described_class}::INT" do
        expect(subject).to eq(described_class::INT)
      end
    end

    describe ":long" do
      subject { super()[:long] }

      it "must equal #{described_class}::LONG" do
        expect(subject).to eq(described_class::LONG)
      end
    end

    describe ":long_long" do
      subject { super()[:long_long] }

      it "must equal #{described_class}::LONG_LONG" do
        expect(subject).to eq(described_class::LONG_LONG)
      end
    end

    describe ":ushort" do
      subject { super()[:ushort] }

      it "must equal #{described_class}::USHORT" do
        expect(subject).to eq(described_class::USHORT)
      end
    end

    describe ":uint" do
      subject { super()[:uint] }

      it "must equal #{described_class}::UINT" do
        expect(subject).to eq(described_class::UINT)
      end
    end

    describe ":ulong" do
      subject { super()[:ulong] }

      it "must equal #{described_class}::ULONG" do
        expect(subject).to eq(described_class::ULONG)
      end
    end

    describe ":ulong_long" do
      subject { super()[:ulong_long] }

      it "must equal #{described_class}::ULONG_LONG" do
        expect(subject).to eq(described_class::ULONG_LONG)
      end
    end

    describe ":word" do
      subject { super()[:word] }

      it "must equal #{described_class}::WORD" do
        expect(subject).to eq(described_class::WORD)
      end
    end

    describe ":dword" do
      subject { super()[:dword] }

      it "must equal #{described_class}::DWORD" do
        expect(subject).to eq(described_class::DWORD)
      end
    end

    describe ":qword" do
      subject { super()[:qword] }

      it "must equal #{described_class}::QWORD" do
        expect(subject).to eq(described_class::QWORD)
      end
    end

    describe ":machine_word" do
      subject { super()[:machine_word] }

      it "must equal #{described_class}::MACHINE_WORD" do
        expect(subject).to eq(described_class::MACHINE_WORD)
      end
    end

    describe ":pointer" do
      it "must be an alias to machine_word" do
        expect(subject[:pointer]).to be(subject[:machine_word])
      end
    end

    describe ":float32" do
      subject { super()[:float32] }

      it "must equal #{described_class}::FLOAT32" do
        expect(subject).to eq(described_class::FLOAT32)
      end
    end

    describe ":float64" do
      subject { super()[:float64] }

      it "must equal #{described_class}::FLOAT64" do
        expect(subject).to eq(described_class::FLOAT64)
      end
    end

    describe ":float" do
      it "must be an alias to float32" do
        expect(subject[:float]).to eq(described_class::FLOAT)
      end
    end

    describe ":double" do
      it "must be an alias to float64" do
        expect(subject[:double]).to eq(described_class::DOUBLE)
      end
    end
  end

  describe ".[]" do
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
end
