require 'spec_helper'
require 'ronin/support/binary/bit_flip/core_ext/integer'

describe Integer do
  subject { 0x00 }

  it { expect(subject).to respond_to(:each_bit_flip) }
  it { expect(subject).to respond_to(:bit_flips)     }

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
end
