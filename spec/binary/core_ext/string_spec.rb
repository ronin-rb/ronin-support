require 'spec_helper'
require 'ronin/support/binary/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#unpack_original" do
    expect(subject).to respond_to(:unpack_original)
  end

  describe "#unpack" do
    subject { "\x34\x12\x00\x00hello\0" }

    let(:data) { [0x1234, "hello"] }

    context "when given only a String" do
      it "must unpack Strings using String#unpack template Strings" do
        expect(subject.unpack('VZ*')).to eq(data)
      end
    end

    context "otherwise" do
      it "must unpack Strings using Ronin::Support::Binary::Template" do
        expect(subject.unpack(:uint32_le, :string)).to eq(data)
      end
    end
  end

  describe "#each_bit_flip" do
    subject { "AB".encode(Encoding::ASCII_8BIT) }

    it "must incrementally invert each bit of each byte in the String" do
      expect { |b|
        subject.each_bit_flip(&b)
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
      subject { "AB" }

      it "must yield ASCII 8bit encoded Strings" do
        yielded_strings = []

        subject.each_bit_flip do |string|
          yielded_strings << string
        end

        expect(yielded_strings.map(&:encoding)).to all(be(Encoding::ASCII_8BIT))
      end
    end

    context "but no block is given" do
      it "must return an Enumerator for #each_bit_flip" do
        expect(subject.each_bit_flip.to_a).to eq(
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
    subject { "AB".encode(Encoding::ASCII_8BIT) }

    it "must return all bit-flip variations of the String" do
      array    = subject.bit_flips
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
