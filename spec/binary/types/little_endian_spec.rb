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

  describe "UINT8" do
    subject { described_class::UINT8 }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::UInt8Type)
    end

    it "must have a #pack_string of 'C'" do
      expect(subject.pack_string).to eq('C')
    end
  end

  describe "BYTE" do
    subject { described_class::BYTE }

    it { expect(subject).to eq(described_class::UINT8) }
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

  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":byte" do
      it "must be an alias to uint8" do
        expect(subject[:byte]).to be(subject[:uint8])
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

    describe ":int" do
      it "must be an alias to int32" do
        expect(subject[:int]).to be(subject[:int32])
      end
    end

    describe ":long" do
      if Ronin::Support::Binary::Types::Native::ADDRESS_SIZE == 8
        context "when ADDRESS_SIZE is 8" do
          it "must be an alias to int64" do
            expect(subject[:long]).to be(subject[:int64])
          end
        end
      else
        context "when the ADDRESS_SIZE is #{Ronin::Support::Binary::Types::Native::ADDRESS_SIZE}" do
          it "must be an alias to int32" do
            expect(subject[:long]).to be(subject[:int32])
          end
        end
      end
    end

    describe ":uint" do
      it "must be an alias to uint32" do
        expect(subject[:uint]).to be(subject[:uint32])
      end
    end

    describe ":ulong" do
      if Ronin::Support::Binary::Types::Native::ADDRESS_SIZE == 8
        context "when ADDRESS_SIZE is 8" do
          it "must be an alias to uint64" do
            expect(subject[:ulong]).to be(subject[:uint64])
          end
        end
      else
        context "when the ADDRESS_SIZE is #{Ronin::Support::Binary::Types::Native::ADDRESS_SIZE}" do
          it "must be an alias to uint32" do
            expect(subject[:ulong]).to be(subject[:uint32])
          end
        end
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
      if described_class::ADDRESS_SIZE == 8
        context "when ADDRESS_SIZE is 8" do
          it "must be an alias to uint64" do
            expect(subject[:machine_word]).to be(subject[:uint64])
          end
        end
      else
        context "when the ADDRESS_SIZE is #{described_class::ADDRESS_SIZE}" do
          it "must be an alias to uint32" do
            expect(subject[:machine_word]).to be(subject[:uint32])
          end
        end
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
        expect(subject[:float]).to be(subject[:float32])
      end
    end

    describe ":double" do
      it "must be an alias to float64" do
        expect(subject[:double]).to be(subject[:float64])
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
