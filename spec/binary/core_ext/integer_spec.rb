require 'spec_helper'
require 'ronin/support/binary/core_ext/integer'

describe Integer do
  subject { 0x00 }

  it { expect(subject).to respond_to(:pack)          }
  it { expect(subject).to respond_to(:to_uint8)      }
  it { expect(subject).to respond_to(:to_uint16)     }
  it { expect(subject).to respond_to(:to_uint32)     }
  it { expect(subject).to respond_to(:to_uint64)     }
  it { expect(subject).to respond_to(:to_u8)         }
  it { expect(subject).to respond_to(:to_u16)        }
  it { expect(subject).to respond_to(:to_u32)        }
  it { expect(subject).to respond_to(:to_u64)        }
  it { expect(subject).to respond_to(:to_int8)       }
  it { expect(subject).to respond_to(:to_int16)      }
  it { expect(subject).to respond_to(:to_int32)      }
  it { expect(subject).to respond_to(:to_int64)      }
  it { expect(subject).to respond_to(:to_i8)         }
  it { expect(subject).to respond_to(:to_i16)        }
  it { expect(subject).to respond_to(:to_i32)        }
  it { expect(subject).to respond_to(:to_i64)        }

  describe "#pack" do
    subject { 0x1337 }

    let(:packed) { "7\023\000\000" }

    context "when only given a String" do
      it "must pack Integers using Array#pack codes" do
        expect(subject.pack('V')).to eq(packed)
      end
    end

    context "when given a Ronin::Support::Binary::CTypes type name" do
      it "must pack Integers using the Ronin::Support::Binary::CTypes type" do
        expect(subject.pack(:uint32_le)).to eq(packed)
      end
    end

    context "when given more than 1 or 2 arguments" do
      it "must raise an ArgumentError" do
        expect {
          subject.pack(1,2,3)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#to_uint8" do
    subject { 0x1fff }

    it "must truncate the integer to 8-bits" do
      expect(subject.to_uint8).to eq(0xff)
    end
  end

  describe "#to_uint16" do
    subject { 0x1fffff }

    it "must truncate the integer to 16-bits" do
      expect(subject.to_uint16).to eq(0xffff)
    end
  end

  describe "#to_uint32" do
    subject { 0x1fffffffff }

    it "must truncate the integer to 32-bits" do
      expect(subject.to_uint32).to eq(0xffffffff)
    end
  end

  describe "#to_uint64" do
    subject { 0x1fffffffffffffffff }

    it "must truncate the integer to 64-bits" do
      expect(subject.to_uint64).to eq(0xffffffffffffffff)
    end
  end

  describe "#to_int8" do
    subject { 0x100 | 127 }

    it "must truncate the integer to 8-bits" do
      expect(subject.to_int8).to eq(127)
    end

    context "but the 7th bit is 1" do
      subject { 0xfe }

      it "must interpret the 7th bit as a signedness bit" do
        expect(subject.to_int8).to eq(-2)
      end
    end
  end

  describe "#to_int16" do
    subject { 0x10000 | 32767 }

    it "must truncate the integer to 16-bits" do
      expect(subject.to_int16).to eq(32767)
    end

    context "but the 15th bit is 1" do
      subject { 0xfffe }

      it "must interpret the 15th bit as a signedness bit" do
        expect(subject.to_int16).to eq(-2)
      end
    end
  end

  describe "#to_int32" do
    subject { 0x100000000 | 2147483647 }

    it "must truncate the integer to 32-bits" do
      expect(subject.to_int32).to eq(2147483647)
    end

    context "but the 31th bit is 1" do
      subject { 0xfffffffe }

      it "must interpret the 31th bit as a signedness bit" do
        expect(subject.to_int32).to eq(-2)
      end
    end
  end

  describe "#to_int64" do
    subject { 0x10000000000000000 | 9223372036854775807 }

    it "must truncate the integer to 64-bits" do
      expect(subject.to_int64).to eq(9223372036854775807)
    end

    context "but the 63th bit is 1" do
      subject { 0xfffffffffffffffe }

      it "must interpret the 63th bit as a signedness bit" do
        expect(subject.to_int64).to eq(-2)
      end
    end
  end
end
