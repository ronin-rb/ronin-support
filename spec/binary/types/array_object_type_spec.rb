require 'spec_helper'
require 'ronin/support/binary/types/array_object_type'
require 'ronin/support/binary/types/uint32_type'
require 'ronin/support/binary/array'

require_relative 'type_examples'

describe Ronin::Support::Binary::Types::ArrayObjectType do
  let(:type_endian)      { :little }
  let(:type_pack_string) { 'L<'    }

  let(:type) do
    Ronin::Support::Binary::Types::UInt32Type.new(
      endian:      type_endian,
      pack_string: type_pack_string
    )
  end
  let(:length) { 10 }
  let(:array_type) { Ronin::Support::Binary::Types::ArrayType.new(type,length) }

  subject { described_class.new(array_type) }

  describe "#initialize" do
    it "must set #type" do
      expect(subject.type).to be(type)
    end

    it "must set #length" do
      expect(subject.length).to eq(length)
    end

    it "must set #array_type" do
      expect(subject.array_type).to eq(array_type)
    end
  end

  describe "#alignment" do
    it "must return #array_type.alignment" do
      expect(subject.alignment).to eq(array_type.alignment)
    end
  end

  describe "#align" do
    let(:new_alignment) { 3 }

    let(:new_type) { subject.align(new_alignment) }

    it "must return the same kind of type" do
      expect(new_type).to be_kind_of(described_class)
    end

    it "must return a copy of the array type" do
      expect(new_type).to_not be(subject)
    end

    it "must preserve #type" do
      expect(new_type.type).to eq(subject.type)
    end

    it "must preserve #length" do
      expect(new_type.length).to eq(subject.length)
    end

    it "must set #alignment to the new alignment" do
      expect(new_type.alignment).to eq(new_alignment)
    end

    it "must change the #alignment of the #array_type" do
      expect(new_type.array_type.alignment).to eq(new_alignment)
    end
  end

  let(:elements) { (1..10).to_a }
  let(:array) do
    Ronin::Support::Binary::Array.new(:uint32,length).tap do |array|
      elements.each_with_index do |element,i|
        array[i] = element
      end
    end
  end
  let(:packed_array) { array.to_s }

  describe "#pack" do
    context "when given a Binary::Array" do
      it "must call #to_s on the given object" do
        expect(subject.pack(array)).to eq(packed_array)
      end
    end

    context "when given an Array" do
      let(:array) { elements }

      it "must pack the Array using #array_type" do
        expect(subject.pack(array)).to eq(subject.array_type.pack(array))
      end
    end
  end

  describe "#unpack" do
    it "must call #struct_class.unpack with the given buffer" do
      binary_array = subject.unpack(packed_array)

      expect(binary_array).to be_kind_of(Ronin::Support::Binary::Array)
      expect(binary_array.to_a).to eq(elements)
    end
  end

  describe "#enqueue_value" do
    let(:values) { [1,2,3] }

    context "when given a Binary::Array" do
      it "must call #to_s on the value and push it onto the list of values" do
        subject.enqueue_value(values,array)

        expect(values.last).to eq(array.to_s)
      end
    end

    context "when given an Array" do
      it "must push the packed Array using #array_type" do
        subject.enqueue_value(values,array)

        expect(values.last).to eq(subject.array_type.pack(elements))
      end
    end
  end

  describe "#dequeue_value" do
    let(:values) { [packed_array,1,2,3] }

    it "must shift the first value off of the list and return a new instance of #struct_class" do
      value = subject.dequeue_value(values)

      expect(value).to be_kind_of(Ronin::Support::Binary::Array)
      expect(value.to_s).to eq(packed_array)
    end
  end

  include_examples "Type examples"
end
