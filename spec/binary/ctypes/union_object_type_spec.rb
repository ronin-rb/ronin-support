require 'spec_helper'
require 'ronin/support/binary/ctypes/union_object_type'
require 'ronin/support/binary/union'

require_relative 'type_examples'

describe Ronin::Support::Binary::CTypes::UnionObjectType do
  module TestUnionObjectType
    class TestUnion < Ronin::Support::Binary::Union

      member :x, :uint16
      member :y, :int32

    end
  end

  let(:union_class) { TestUnionObjectType::TestUnion }
  let(:union_members) do
    union_class.type.members.transform_values(&:type)
  end
  let(:union_type) do
    Ronin::Support::Binary::CTypes::UnionType.build(union_members)
  end

  subject { described_class.new(union_class,union_type) }

  describe "#initialize" do
    it "must set #union_class" do
      expect(subject.union_class).to be(union_class)
    end

    it "must build a #union_type using the given union members" do
      expect(subject.union_type).to be_kind_of(Ronin::Support::Binary::CTypes::UnionType)
      expect(subject.union_type.members.keys).to eq(union_members.keys)
      expect(subject.union_type.members.values.map(&:type)).to eq(union_members.values)
    end
  end

  describe "#size" do
    it "must return #union_type.size" do
      expect(subject.size).to eq(subject.union_type.size)
    end
  end

  describe "#alignment" do
    it "must return #union_type.alignment" do
      expect(subject.alignment).to eq(subject.union_type.alignment)
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

    it "must preserve #union_class" do
      expect(new_type.union_class).to be(union_class)
    end

    it "must change #alignment" do
      expect(new_type.alignment).to eq(new_alignment)
    end

    it "must change #union_type.alignment" do
      expect(new_type.union_type.alignment).to eq(new_alignment)
    end
  end

  describe "#members" do
    it "must return #union_type.members" do
      expect(subject.members).to eq(subject.union_type.members)
    end
  end

  let(:x) { 1234 }
  let(:y) { -1   }
  let(:hash) { {x: x, y: y} }

  let(:union) { union_class.new(hash) }
  let(:packed_union) { union.to_s }

  describe "#pack" do
    context "when given a Binary::Union class" do
      it "must call #to_s on the given object" do
        expect(subject.pack(union)).to eq(packed_union)
      end
    end

    context "when given a Hash" do
      it "must pack the Hash using #union_type" do
        expect(subject.pack(hash)).to eq(subject.union_type.pack(hash))
      end
    end

    context "when given an object other than a Binary::Union or Hash" do
      let(:union) { Object.new }

      it do
        expect {
          subject.pack(union)
        }.to raise_error(ArgumentError,"value must be either a #{Ronin::Support::Binary::Union} or an #{Hash}: #{union.inspect}")
      end
    end
  end

  describe "#unpack" do
    let(:data) { union.to_s }

    it "must call #union_class.new with the given data" do
      union = subject.unpack(data)

      expect(union).to be_kind_of(union_class)
      expect(union.string).to be(data)
    end
  end

  describe "#enqueue_value" do
    let(:values) { [1,2,3] }

    context "when given a Binary::Union class" do
      let(:packed_union) { union.to_s }

      it "must call #to_s on the value and push it onto the list of values" do
        subject.enqueue_value(values,union)

        expect(values.last).to eq(union.to_s)
      end
    end

    context "when given a Hash" do
      it "must push the packed Hash using #union_type" do
        subject.enqueue_value(values,hash)

        expect(values.last).to eq(subject.union_type.pack(hash))
      end
    end
  end

  describe "#dequeue_value" do
    let(:values) { [packed_union,1,2,3] }

    it "must shift the first value off of the list and return a new instance of #union_class" do
      value = subject.dequeue_value(values)

      expect(value).to be_kind_of(subject.union_class)
      expect(value.to_s).to eq(packed_union)
    end
  end

  include_examples "Type examples"
end
