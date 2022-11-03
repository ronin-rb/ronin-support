require 'spec_helper'
require 'ronin/support/binary/bit_flip'

describe Ronin::Support::Binary::BitFlip do
  describe described_class::Integer do
    let(:int)  { 0b00001111 }
    let(:bits) { 6 }

    describe ".each_bit_flip" do
      context "when givne an Integer bits argument" do
        it "must incrementally invert the given number of LSB bits" do
          expect { |b|
            subject.each_bit_flip(int,bits,&b)
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
            expect(subject.each_bit_flip(int,bits).to_a).to eq(
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

      context "when givne a Range bits argument" do
        let(:bits) { 1...6 }

        it "must incrementally invert the given range of bits" do
          expect { |b|
            subject.each_bit_flip(int,bits,&b)
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
            expect(subject.each_bit_flip(int,bits).to_a).to eq(
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

    describe ".bit_flips" do
      context "when givne an Integer bits argument" do
        it "must return all bit-flip variations for the given number of bits" do
          expect(subject.bit_flips(int,bits)).to eq(
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

      context "when givne a Range bits argument" do
        let(:bits) { 1...6 }

        it "must return all bit-flip variations for the given range of bits" do
          expect(subject.bit_flips(int,bits)).to eq(
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

  describe described_class::String do
    describe ".each_bit_flip" do
      let(:string) { "AB".encode(Encoding::ASCII_8BIT) }

      it "must incrementally invert each bit of each byte in the String" do
        expect { |b|
          subject.each_bit_flip(string,&b)
        }.to yield_successive_args(
          "#{0b01000000.chr}B",
          "#{0b01000011.chr}B",
          "#{0b01000101.chr}B",
          "#{0b01001001.chr}B",
          "#{0b01010001.chr}B",
          "#{0b01100001.chr}B",
          "#{0b00000001.chr}B",
          "#{0b11000001.chr}B",
          "A#{0b01000011.chr}",
          "A#{0b01000000.chr}",
          "A#{0b01000110.chr}",
          "A#{0b01001010.chr}",
          "A#{0b01010010.chr}",
          "A#{0b01100010.chr}",
          "A#{0b00000010.chr}",
          "A#{0b11000010.chr}"
        )
      end

      context "when the String has UTF-8 encoding" do
        let(:string) { "AB" }

        it "must yield ASCII 8bit encoded Strings" do
          yielded_strings = []

          subject.each_bit_flip(string) do |string|
            yielded_strings << string
          end

          expect(yielded_strings.map(&:encoding)).to all(be(Encoding::ASCII_8BIT))
        end
      end

      context "but no block is given" do
        it "must return an Enumerator for #each_bit_flip" do
          expect(subject.each_bit_flip(string).to_a).to eq(
            [
              "#{0b01000000.chr}B",
              "#{0b01000011.chr}B",
              "#{0b01000101.chr}B",
              "#{0b01001001.chr}B",
              "#{0b01010001.chr}B",
              "#{0b01100001.chr}B",
              "#{0b00000001.chr}B",
              "#{0b11000001.chr}B",
              "A#{0b01000011.chr}",
              "A#{0b01000000.chr}",
              "A#{0b01000110.chr}",
              "A#{0b01001010.chr}",
              "A#{0b01010010.chr}",
              "A#{0b01100010.chr}",
              "A#{0b00000010.chr}",
              "A#{0b11000010.chr}"
            ]
          )
        end
      end
    end

    describe "#bit_flips" do
      let(:string) { "AB".encode(Encoding::ASCII_8BIT) }

      it "must return all bit-flip variations of the String" do
        array    = subject.bit_flips(string)
        expected = [
          "#{0b01000000.chr}B",
          "#{0b01000011.chr}B",
          "#{0b01000101.chr}B",
          "#{0b01001001.chr}B",
          "#{0b01010001.chr}B",
          "#{0b01100001.chr}B",
          "#{0b00000001.chr}B",
          "#{0b11000001.chr}B",
          "A#{0b01000011.chr}",
          "A#{0b01000000.chr}",
          "A#{0b01000110.chr}",
          "A#{0b01001010.chr}",
          "A#{0b01010010.chr}",
          "A#{0b01100010.chr}",
          "A#{0b00000010.chr}",
          "A#{0b11000010.chr}"
        ]
      end
    end
  end
end
