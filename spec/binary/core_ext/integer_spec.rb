require 'spec_helper'
require 'ronin/support/binary/core_ext/integer'

describe Integer do
  subject { 0x00 }

  it "must provide Integer#each_bit_flip" do
    expect(subject).to respond_to(:each_bit_flip)
  end

  it "must provide Integer#bit_flips" do
    expect(subject).to respond_to(:bit_flips)
  end

  it "must provide Integer#pack" do
    expect(subject).to respond_to(:pack)
  end

  describe "#each_bit_flip" do
    subject { 0b00001111 }

    context "when givne an Integer" do
      let(:bits) { 6 }

      it "must incrementally invert the given number of LSB bits" do
        expect { |b|
          subject.each_bit_flip(bits,&b)
        }.to yield_successive_args(
          0b000001110,
          0b000001101,
          0b000001011,
          0b000000111,
          0b000011111,
          0b000101111
        )
      end

      context "but no block is given" do
        it "must return an Enumerator for #each_bit_flip" do
          expect(subject.each_bit_flip(bits).to_a).to eq(
            [
              0b000001110,
              0b000001101,
              0b000001011,
              0b000000111,
              0b000011111,
              0b000101111
            ]
          )
        end
      end
    end

    context "when givne a Range" do
      let(:bits) { 1...6 }

      it "must incrementally invert the given range of bits" do
        expect { |b|
          subject.each_bit_flip(bits,&b)
        }.to yield_successive_args(
          0b000001101,
          0b000001011,
          0b000000111,
          0b000011111,
          0b000101111
        )
      end

      context "but no block is given" do
        it "must return an Enumerator for #each_bit_flip" do
          expect(subject.each_bit_flip(bits).to_a).to eq(
            [
              0b000001101,
              0b000001011,
              0b000000111,
              0b000011111,
              0b000101111
            ]
          )
        end
      end
    end
  end

  describe "#bit_flips" do
    subject { 0b00001111 }

    context "when givne an Integer" do
      let(:bits) { 6 }

      it "must return all bit-flip variations for the given number of bits" do
        expect(subject.bit_flips(bits)).to eq(
          [
            0b000001110,
            0b000001101,
            0b000001011,
            0b000000111,
            0b000011111,
            0b000101111
          ]
        )
      end
    end

    context "when givne a Range" do
      let(:bits) { 1...6 }

      it "must return all bit-flip variations for the given range of bits" do
        expect(subject.bit_flips(bits)).to eq(
          [
            0b000001101,
            0b000001011,
            0b000000111,
            0b000011111,
            0b000101111
          ]
        )
      end
    end
  end

  describe "#bytes" do
    let(:little_endian_char)  { [0x37] }
    let(:little_endian_short) { [0x37, 0x13] }
    let(:little_endian_long)  { [0x37, 0x13, 0x0, 0x0] }
    let(:little_endian_quad)  { [0x37, 0x13, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0] }

    let(:big_endian_char)  { [0x37] }
    let(:big_endian_short) { [0x13, 0x37] }
    let(:big_endian_long)  { [0, 0, 0x13, 0x37] }
    let(:big_endian_quad)  { [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x13, 0x37] }

    subject { 0x1337 }

    it "must return the bytes in little endian ordering by default" do
      expect(subject.bytes(4)).to eq(little_endian_long)
    end

    it "must return the bytes for a char in little endian ordering" do
      expect(subject.bytes(1, :little)).to eq(little_endian_char)
    end

    it "must return the bytes for a short in little endian ordering" do
      expect(subject.bytes(2, :little)).to eq(little_endian_short)
    end

    it "must return the bytes for a long in little endian ordering" do
      expect(subject.bytes(4, :little)).to eq(little_endian_long)
    end

    it "must return the bytes for a quad in little endian ordering" do
      expect(subject.bytes(8, :little)).to eq(little_endian_quad)
    end

    it "must return the bytes for a char in big endian ordering" do
      expect(subject.bytes(1, :big)).to eq(big_endian_char)
    end

    it "must return the bytes for a short in big endian ordering" do
      expect(subject.bytes(2, :big)).to eq(big_endian_short)
    end

    it "must return the bytes for a long in big endian ordering" do
      expect(subject.bytes(4, :big)).to eq(big_endian_long)
    end

    it "must return the bytes for a quad in big endian ordering" do
      expect(subject.bytes(8, :big)).to eq(big_endian_quad)
    end
  end

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

  describe "#to_u8" do
    subject { 0x1fff }

    it "must truncate the integer to 8-bits" do
      expect(subject.to_u8).to eq(0xff)
    end
  end

  describe "#to_u16" do
    subject { 0x1fffff }

    it "must truncate the integer to 16-bits" do
      expect(subject.to_u16).to eq(0xffff)
    end
  end

  describe "#to_u32" do
    subject { 0x1fffffffff }

    it "must truncate the integer to 32-bits" do
      expect(subject.to_u32).to eq(0xffffffff)
    end
  end

  describe "#to_u64" do
    subject { 0x1fffffffffffffffff }

    it "must truncate the integer to 64-bits" do
      expect(subject.to_u64).to eq(0xffffffffffffffff)
    end
  end

  describe "#to_i8" do
    subject { 0x100 | 127 }

    it "must truncate the integer to 8-bits" do
      expect(subject.to_i8).to eq(127)
    end

    context "but the 7th bit is 1" do
      subject { 0xfe }

      it "must interpret the 7th bit as a signedness bit" do
        expect(subject.to_i8).to eq(-2)
      end
    end
  end

  describe "#to_i16" do
    subject { 0x10000 | 32767 }

    it "must truncate the integer to 16-bits" do
      expect(subject.to_i16).to eq(32767)
    end

    context "but the 15th bit is 1" do
      subject { 0xfffe }

      it "must interpret the 15th bit as a signedness bit" do
        expect(subject.to_i16).to eq(-2)
      end
    end
  end

  describe "#to_i32" do
    subject { 0x100000000 | 2147483647 }

    it "must truncate the integer to 32-bits" do
      expect(subject.to_i32).to eq(2147483647)
    end

    context "but the 31th bit is 1" do
      subject { 0xfffffffe }

      it "must interpret the 31th bit as a signedness bit" do
        expect(subject.to_i32).to eq(-2)
      end
    end
  end

  describe "#to_i64" do
    subject { 0x10000000000000000 | 9223372036854775807 }

    it "must truncate the integer to 64-bits" do
      expect(subject.to_i64).to eq(9223372036854775807)
    end

    context "but the 63th bit is 1" do
      subject { 0xfffffffffffffffe }

      it "must interpret the 63th bit as a signedness bit" do
        expect(subject.to_i64).to eq(-2)
      end
    end
  end
end
