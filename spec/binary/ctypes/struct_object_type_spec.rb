require 'spec_helper'
require 'ronin/support/binary/ctypes/struct_object_type'
require 'ronin/support/binary/struct'

require_relative 'type_examples'

describe Ronin::Support::Binary::CTypes::StructObjectType do
  module TestStructObjectType
    class TestStruct < Ronin::Support::Binary::Struct

      member :x, :uint16
      member :y, :int32

    end
  end

  let(:struct_class) { TestStructObjectType::TestStruct }
  let(:struct_members) do
    struct_class.type.members.transform_values(&:type)
  end
  let(:struct_type) do
    Ronin::Support::Binary::CTypes::StructType.build(struct_members)
  end

  subject { described_class.new(struct_class,struct_type) }

  describe "#initialize" do
    it "must set #struct_class" do
      expect(subject.struct_class).to be(struct_class)
    end

    it "must build a #struct_type using the given struct members" do
      expect(subject.struct_type).to be_kind_of(Ronin::Support::Binary::CTypes::StructType)
      expect(subject.struct_type.members.keys).to eq(struct_members.keys)
      expect(subject.struct_type.members.values.map(&:type)).to eq(struct_members.values)
    end
  end

  describe "#size" do
    it "must return #struct_type.size" do
      expect(subject.size).to eq(subject.struct_type.size)
    end
  end

  describe "#alignment" do
    it "must return #struct_type.alignment" do
      expect(subject.alignment).to eq(subject.struct_type.alignment)
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

    it "must preserve #struct_class" do
      expect(new_type.struct_class).to be(struct_class)
    end

    it "must change #alignment" do
      expect(new_type.alignment).to eq(new_alignment)
    end

    it "must change #struct_type.alignment" do
      expect(new_type.struct_type.alignment).to eq(new_alignment)
    end
  end

  describe "#members" do
    it "must return #struct_type.members" do
      expect(subject.members).to eq(subject.struct_type.members)
    end
  end

  let(:x) { 1234 }
  let(:y) { -1   }
  let(:hash) { {x: x, y: y} }

  let(:struct) { struct_class.new(hash) }
  let(:packed_struct) { struct.to_s }

  describe "#pack" do
    context "when given a Binary::Struct class" do
      it "must call #to_s on the given object" do
        expect(subject.pack(struct)).to eq(packed_struct)
      end
    end

    context "when given a Hash" do
      it "must pack the Hash using #struct_type" do
        expect(subject.pack(hash)).to eq(subject.struct_type.pack(hash))
      end
    end

    context "when given an object other than a Binary::Struct or Hash" do
      let(:struct) { Object.new }

      it do
        expect {
          subject.pack(struct)
        }.to raise_error(ArgumentError,"value must be either a #{Ronin::Support::Binary::Struct} or an #{Hash}: #{struct.inspect}")
      end
    end
  end

  describe "#unpack" do
    let(:data) { struct.to_s }

    it "must call #struct_class.new with the given data" do
      struct = subject.unpack(data)

      expect(struct).to be_kind_of(struct_class)
      expect(struct.string).to be(data)
    end
  end

  describe "#enqueue_value" do
    let(:values) { [1,2,3] }

    context "when given a Binary::Struct class" do
      let(:packed_struct) { struct.to_s }

      it "must call #to_s on the value and push it onto the list of values" do
        subject.enqueue_value(values,struct)

        expect(values.last).to eq(struct.to_s)
      end
    end

    context "when given a Hash" do
      it "must push the packed Hash using #struct_type" do
        subject.enqueue_value(values,hash)

        expect(values.last).to eq(subject.struct_type.pack(hash))
      end
    end
  end

  describe "#dequeue_value" do
    let(:values) { [packed_struct,1,2,3] }

    it "must shift the first value off of the list and return a new instance of #struct_class" do
      value = subject.dequeue_value(values)

      expect(value).to be_kind_of(subject.struct_class)
      expect(value.to_s).to eq(packed_struct)
    end
  end

  include_examples "Type examples"
end
