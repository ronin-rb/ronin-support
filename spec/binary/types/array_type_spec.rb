require 'spec_helper'
require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/type'

describe Ronin::Support::Binary::Types::ArrayType do
  let(:size)        { 4       }
  let(:endian)      { :little }
  let(:signed)      { true    }
  let(:pack_string) { 'L<'    }

  let(:type) do
    Ronin::Support::Binary::Types::Type.new(
      size:        size,
      endian:      endian,
      signed:      signed,
      pack_string: pack_string
    )
  end

  let(:length) { 10 }
  subject { described_class.new(type,length) }

  describe "#initialize" do
    it "must set #type" do
      expect(subject.type).to eq(type)
    end

    it "must set #length" do
      expect(subject.length).to eq(length)
    end

    it "must set #size as #type.size * length" do
      expect(subject.size).to eq(type.size * length)
    end

    it "must set #pack_string to type.pack_string * length'" do
      expect(subject.pack_string).to eq(type.pack_string * length)
    end
  end

  describe "#endian" do
    it "must return #type.endian" do
      expect(subject.endian).to eq(type.endian)
    end
  end

  describe "#signed?" do
    it "must return #type.signed?" do
      expect(subject.signed?).to eq(type.signed?)
    end
  end

  describe "#unsigned?" do
    it "must return #type.unsigned?" do
      expect(subject.unsigned?).to eq(type.unsigned?)
    end
  end

  describe "#pack" do
    let(:values) { (1..10).to_a }

    it "must pack multiple values using Array#pack and #pack_string" do
      expect(subject.pack(*values)).to eq(values.pack(subject.pack_string))
    end
  end

  describe "#unpack" do
    let(:data) do
      [
        "\x01\x00\x00\x00",
        "\x02\x00\x00\x00",
        "\x03\x00\x00\x00",
        "\x04\x00\x00\x00",
        "\x05\x00\x00\x00",
        "\x06\x00\x00\x00",
        "\x07\x00\x00\x00",
        "\x08\x00\x00\x00",
        "\x09\x00\x00\x00",
        "\x0a\x00\x00\x00"
      ].join
    end

    it "must unpack multiple values using String#unpack and #pack_string" do
      expect(subject.unpack(data)).to eq(data.unpack(subject.pack_string))
    end
  end
end
