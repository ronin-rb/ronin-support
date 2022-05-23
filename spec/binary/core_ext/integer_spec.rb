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
end
