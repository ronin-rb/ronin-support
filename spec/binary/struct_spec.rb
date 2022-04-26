require 'spec_helper'
require 'ronin/support/binary/struct'

describe Ronin::Support::Binary::Struct do
  module TestBinaryStruct
    class SimpleStruct < Ronin::Support::Binary::Struct
      member :foo, :uint16
      member :bar, :int32
      member :baz, :uint64
    end

    class InheritedStruct < SimpleStruct
    end

    class InheritedStructWithItsOwnMembers < SimpleStruct
      member :qux, :float32
    end

    class StructWithAnArray < Ronin::Support::Binary::Struct
      member :foo, :uint16
      member :bars, [:int32, 3]
      member :baz, :uint64
    end

    class StructWithUnboundedArray < Ronin::Support::Binary::Struct
      member :foo, :uint16
      member :bar, :int32
      member :baz, (:uint64..)
    end

    class SubStruct < Ronin::Support::Binary::Struct
      member :x, :uint32
      member :y, :int32
    end

    class NestedStruct < Ronin::Support::Binary::Struct
      member :foo, :uint16
      member :bar, SubStruct
      member :baz, :uint64
    end
  end

  let(:struct_class) { TestBinaryStruct::SimpleStruct }

  describe ".members" do
    context "when the struct class has no members defined" do
      subject { Class.new(described_class) }

      it "must return an empty Hash" do
        expect(subject.members).to eq({})
      end
    end

    context "when the struct class does have members defined" do
      subject { TestBinaryStruct::SimpleStruct }

      it "must return a Hash containing the member names and #{described_class}::Member objects" do
        expect(subject.members.keys).to eq([:foo, :bar, :baz])
        expect(subject.members[:foo]).to be_kind_of(described_class::Member)
        expect(subject.members[:bar]).to be_kind_of(described_class::Member)
        expect(subject.members[:baz]).to be_kind_of(described_class::Member)
      end
    end

    context "when the struct class inherits from another struct class" do
      subject { TestBinaryStruct::InheritedStruct }

      it "must inherit the members defined in the superclass" do
        expect(subject.members.keys).to eq([:foo, :bar, :baz])
        expect(subject.members[:foo]).to be_kind_of(described_class::Member)
        expect(subject.members[:bar]).to be_kind_of(described_class::Member)
        expect(subject.members[:baz]).to be_kind_of(described_class::Member)
      end

      context "and the struct class defines it's own members" do
        subject { TestBinaryStruct::InheritedStructWithItsOwnMembers }

        let(:struct_superclass) { subject.superclass }

        it "must inherit the members defined in the superclass" do
          expect(subject.members.keys).to include(:foo, :bar, :baz)
          expect(subject.members[:foo]).to be_kind_of(described_class::Member)
          expect(subject.members[:bar]).to be_kind_of(described_class::Member)
          expect(subject.members[:baz]).to be_kind_of(described_class::Member)
        end

        it "must define it's members in the struct class" do
          expect(subject.members.keys).to include(:qux)
          expect(subject.members[:qux]).to be_kind_of(described_class::Member)
        end

        it "must not pollute the struct's superclass with it's own members" do
          expect(struct_superclass.members.keys).to include(:foo, :bar, :baz)
          expect(struct_superclass.members[:foo]).to be_kind_of(described_class::Member)
          expect(struct_superclass.members[:bar]).to be_kind_of(described_class::Member)
          expect(struct_superclass.members[:baz]).to be_kind_of(described_class::Member)
        end
      end
    end
  end

  describe ".member" do
    subject do
      Class.new(described_class) do
        member :foo, :int
      end
    end

    let(:name) { :foo }
    let(:type) { :int }

    it "must add a #{described_class}::Member to .members" do
      expect(subject.members[name]).to be_kind_of(described_class::Member)
    end

    let(:value) { 42 }

    it "must define a reader method for the member" do
      expect(subject.instance_methods).to include(name)

      instance = subject.new(name => value)

      expect(instance.send(name)).to eq(value)
    end

    it "must define a writer method for the member" do
      expect(subject.instance_methods).to include(:"#{name}=")

      instance = subject.new
      instance.send(:"#{name}=",value)

      expect(instance.send(name)).to eq(value)
    end
  end

  describe ".has_member?" do
    subject { struct_class }

    context "when given a name of a defined member" do
      it "must return true" do
        expect(subject.has_member?(:foo)).to be(true)
      end
    end

    context "when the given name does not map to a defined member" do
      it "must return false" do
        expect(subject.has_member?(:xxx)).to be(false)
      end
    end
  end

  describe "#initialize" do
    context "when given no arguments" do
      subject { struct_class.new }

      it "must initialize #string to a zero buffer the size of the struct" do
        expect(subject.string).to eq(
          ("\0" * struct_class.size).encode(Encoding::ASCII_8BIT)
        )
      end
    end
  end

  describe ".unpack" do
    subject { struct_class }

    let(:data) { struct_class.new(foo: 1, bar: -2, baz: 42).to_s }

    it "must create a new #{described_class} instance with the given data" do
      new_struct = subject.unpack(data)

      expect(new_struct).to be_kind_of(struct_class)
      expect(new_struct.string).to eq(data)
    end
  end

  subject { struct_class.new }

  describe "#[]" do
    context "when the member's type is a Types::ScalarType" do
      context "and the memory has not been written to yet" do
        it "must return the zero-value of the scalar type" do
          expect(subject[:bar]).to eq(0)
        end
      end

      context "but the memory has been previously written to" do
        let(:new_value) { 42 }

        before { subject[:bar] = new_value }

        it "must return the previously written value" do
          expect(subject[:bar]).to eq(new_value)
        end
      end
    end

    context "when the member's type is an Types::ArrayObjectType" do
      let(:struct_class) { TestBinaryStruct::StructWithAnArray }

      let(:struct_type) { struct_class.type }
      let(:member_name) { :bars }
      let(:member)      { struct_type.members[member_name] }

      it "must return a Binary::Array object" do
        expect(subject[member_name]).to be_kind_of(Ronin::Support::Binary::Array)
      end

      it "must use a ByteSlice with the member's offset and size" do
        array = subject[member_name]

        expect(array.string).to be_kind_of(Ronin::Support::Binary::ByteSlice)
        expect(array.string.offset).to eq(member.offset)
        expect(array.string.size).to eq(member.size)
      end
    end

    context "when the member's type is a Types::StructObjectType" do
      let(:struct_class) { TestBinaryStruct::NestedStruct }

      let(:struct_type) { struct_class.type }
      let(:member_name) { :bar }
      let(:member)      { struct_type.members[member_name] }

      it "must return an instance of the nested Struct class" do
        expect(subject[member_name]).to be_kind_of(member.type.struct_class)
      end

      it "must use a ByteSlice with the member's offset and size" do
        struct = subject[member_name]

        expect(struct.string).to be_kind_of(Ronin::Support::Binary::ByteSlice)
        expect(struct.string.offset).to eq(member.offset)
        expect(struct.string.size).to eq(member.size)
      end
    end
  end

  describe "#[]=" do
    let(:struct_type) { struct_class.type }

    let(:member_name) { :bar }
    let(:member)      { struct_type.members[member_name] }

    context "when the member's type is a scalar" do
      let(:value) { 42 }

      before { subject[member_name] = value }

      it "must write the packed value to the member's offset within #string" do
        field = subject.string[member.offset,member.size]

        expect(field).to eq(member.type.pack(value))
      end
    end

    context "when the member's type is an Types::ArrayObjectType" do
      let(:struct_class) { TestBinaryStruct::StructWithAnArray }
      let(:struct_type)  { struct_class.type }

      let(:member_name) { :bars }
      let(:member)      { struct_type.members[member_name] }

      let(:values) { [0, 1, -2] }

      context "and when given a literal Array of values" do
        let(:packed_values) { member.type.pack(values) }

        before { subject[member_name] = values }

        it "must pack the values using Types::ArrayObjectType and write them to the member's offset/size" do
          expect(subject.string[member.offset,member.size]).to eq(packed_values)
        end
      end

      context "and when given another Binary::Array value" do
        let(:array) do
          Ronin::Support::Binary::Array.new(member.type.type, member.type.length).tap do |array|
            array[0] = values[0]
            array[1] = values[1]
            array[2] = values[2]
          end
        end

        before { subject[member_name] = array }

        it "must write the contents of the Binary::Array to the member's offset/size" do
          expect(subject.string[member.offset,member.size]).to eq(array.string)
        end
      end
    end

    context "when the member's type is a Types::StructObjectType" do
      let(:struct_class) { TestBinaryStruct::NestedStruct }

      let(:struct_type) { struct_class.type }
      let(:member_name) { :bar }
      let(:member)      { struct_type.members[member_name] }

      let(:x)    { 42 }
      let(:y)    { -1 }
      let(:hash) { {x: x, y: y} }

      context "and when given a literal Hash of values" do
        let(:packed_hash) { member.type.pack(hash) }

        before { subject[member_name] = hash }

        it "must pack the values using Types::StructObjectType and write them to the member's offset/size" do
          expect(subject.string[member.offset,member.size]).to eq(packed_hash)
        end
      end

      context "and when given another Binary::Struct value" do
        let(:substruct_class) { member.type.struct_class  }
        let(:substruct)       { substruct_class.new(hash) }

        before { subject[member_name] = substruct }

        it "must write the contents of the Struct object to the member's offset/size" do
          expect(subject.string[member.offset,member.size]).to eq(substruct.string)
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the underlying #string" do
      expect(subject.to_s).to eq(subject.string)
    end
  end
end
