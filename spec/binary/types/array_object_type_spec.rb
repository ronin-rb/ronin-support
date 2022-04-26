require 'spec_helper'
require 'ronin/support/binary/types/array_object_type'
require 'ronin/support/binary/types/uint32_type'
require 'ronin/support/binary/array'

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

  subject { described_class.new(type,length) }

  describe "#initialize" do
    it "must set #type" do
      expect(subject.type).to be(type)
    end

    it "must set #length" do
      expect(subject.length).to eq(length)
    end

    it "must build a #array_type using the #type and #length" do
      expect(subject.array_type).to be_kind_of(Ronin::Support::Binary::Types::ArrayType)
      expect(subject.array_type.type).to be(type)
      expect(subject.array_type.length).to eq(length)
    end
  end

  describe "#alignment" do
    it "must return #type.alignment" do
      expect(subject.alignment).to eq(type.alignment)
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
end