require 'spec_helper'
require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/scalar_type'

require_relative 'aggregate_type_examples'

describe Ronin::Support::Binary::Types::ArrayType do
  let(:size)        { 4       }
  let(:endian)      { :little }
  let(:signed)      { true    }
  let(:pack_string) { 'L<'    }

  let(:type) do
    Ronin::Support::Binary::Types::ScalarType.new(
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

  describe "#initialize_value" do
    it "must return an Array of #length and of the #type's #initialize_value" do
      expect(subject.initialize_value).to eq(
        Array.new(length) { type.initialize_value }
      )
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

    context "when given a multi-dimensional Array of values" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ScalarType.new(
            size:        size,
            endian:      endian,
            signed:      signed,
            pack_string: pack_string
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:values) { [(0..9).to_a, (10..19).to_a] }

      it "must flatten then pack the multi-dimensional Array of values" do
        expect(subject.pack(*values)).to eq(values.flatten.pack(subject.pack_string))
      end
    end
  end

  describe "#unpack" do
    let(:values) { (1..10).to_a }
    let(:data)   { values.pack(subject.pack_string) }

    it "must unpack multiple values using String#unpack and #pack_string" do
      expect(subject.unpack(data)).to eq(data.unpack(subject.pack_string))
    end

    context "when initialized with another ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ScalarType.new(
            size:        size,
            endian:      endian,
            signed:      signed,
            pack_string: pack_string
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:values) { [(0..9).to_a, (10..19).to_a] }
      let(:data)   { values.flatten.pack(subject.pack_string) }

      it "must unpack multiple values and return a multi-dimensional Array" do
        expect(subject.unpack(data)).to eq(values)
      end
    end
  end

  include_examples "AggregateType examples"
end
