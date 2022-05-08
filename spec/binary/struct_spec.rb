require 'spec_helper'
require 'ronin/support/binary/struct'

require 'stringio'

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

    class StructWithPlatformSet < Ronin::Support::Binary::Struct
      platform arch: :arm64

      member :foo, :uint16
    end

    class InheritedStructWithPlatformSet < StructWithPlatformSet
    end

    class OverridenInheritedStructWithPlatformSet < InheritedStructWithPlatformSet
      platform arch: :arm
    end

    class AlignedStruct < Ronin::Support::Binary::Struct
      align 8
      member :foo, :uint16
    end

    class InheritedAlignedStruct < AlignedStruct
    end

    class OverridenInheritedAlignedStruct < AlignedStruct
      align 4
    end

    class PaddedStruct < Ronin::Support::Binary::Struct
      padding false
      member :foo, :uint16
    end

    class InheritedPaddedStruct < PaddedStruct
    end

    class OverridenInheritedPaddedStruct < PaddedStruct
      padding true
    end
  end

  let(:struct_class) { TestBinaryStruct::SimpleStruct }

  describe ".type_system" do
    subject { Class.new(described_class) }

    it "must default to Ronin::Support::Binary::Types" do
      expect(subject.type_system).to be(Ronin::Support::Binary::Types)
    end
  end

  describe ".platform" do
    subject { Class.new(described_class) }

    it "must default to {}" do
      expect(subject.platform).to eq({})
    end

    context "when `platform endian: ...` is called within the Struct class" do
      subject { TestBinaryStruct::StructWithPlatformSet }

      it "must populate .platform with the given keywords" do
        expect(subject.platform).to eq(
          {endian: nil, arch: :arm64, os: nil}
        )
      end

      it "must set .type_system using Types.platform(...)" do
        expect(subject.type_system).to be(
          Ronin::Support::Binary::Types.platform(**subject.platform)
        )
      end

      context "and when the Struct class is inherited" do
        subject { TestBinaryStruct::InheritedStructWithPlatformSet }

        it "must inherit the .endian value from the superclass" do
          expect(subject.platform).to be(subject.superclass.platform)
        end

        it "must inherit the .type_system value from the superclass" do
          expect(subject.type_system).to be(subject.superclass.type_system)
        end

        context "but the Struct class overrides the inherited .arch value" do
          subject { TestBinaryStruct::OverridenInheritedStructWithPlatformSet }

          it "must set .endian to the new value" do
            expect(subject.platform).to eq(
              {endian: nil, arch: :arm, os: nil}
            )
          end

          it "must set .type_system to the new Types:: module for the new endian-ness" do
            expect(subject.type_system).to be(
              Ronin::Support::Binary::Types.platform(**subject.platform)
            )
          end

          it "must re-resolve the Struct member types using the new .type_system" do
            member_type_name = subject.members[:foo].type_signature
            struct_type      = subject.type.struct_type

            expect(struct_type.members[:foo].type).to eq(
              subject.type_system[member_type_name]
            )
          end
        end
      end
    end
  end

  describe ".alignment" do
    subject { Class.new(described_class) }

    it "must default to nil" do
      expect(subject.alignment).to be(nil)
    end

    context "when align is called within the Struct class" do
      subject { TestBinaryStruct::AlignedStruct }

      it "must set .alignment to the given alignment value" do
        expect(subject.alignment).to eq(8)
      end

      context "and when the Struct class is inherited" do
        subject { TestBinaryStruct::InheritedAlignedStruct }

        it "must inherit the .alignment value from the superclass" do
          expect(subject.alignment).to be(subject.superclass.alignment)
        end

        context "but the Struct class overrides the inherited .align value" do
          subject { TestBinaryStruct::OverridenInheritedAlignedStruct }

          it "must set .alignment to the new value" do
            expect(subject.alignment).to eq(4)
          end
        end
      end
    end
  end

  describe ".padding" do
    subject { Class.new(described_class) }

    it "must default to true" do
      expect(subject.padding).to be(true)
    end

    context "when padding is called within the Struct class" do
      subject { TestBinaryStruct::PaddedStruct }

      it "must set .padding to the given padding value" do
        expect(subject.padding).to eq(false)
      end

      context "and when the Struct class is inherited" do
        subject { TestBinaryStruct::InheritedPaddedStruct }

        it "must inherit the .padding value from the superclass" do
          expect(subject.padding).to be(subject.superclass.padding)
        end

        context "but the Struct class overrides the inherited .padding value" do
          subject { TestBinaryStruct::OverridenInheritedPaddedStruct }

          it "must set .padding to the new value" do
            expect(subject.padding).to be(true)
          end
        end
      end
    end
  end

  describe ".type_resolver" do
    subject { Class.new(described_class) }

    it "must return a Types::TypeResolver initialized with .type_system" do
      type_resolver = subject.type_resolver

      expect(type_resolver).to be_kind_of(
        Ronin::Support::Binary::Types::TypeResolver
      )
      expect(type_resolver.types).to be(subject.type_system)
    end
  end

  describe ".type" do
    subject { TestBinaryStruct::SimpleStruct }

    it "must resolve a Types::StructObjectType for the Struct class" do
      type = subject.type

      expect(type).to be_kind_of(Ronin::Support::Binary::Types::StructObjectType)
      expect(type.struct_class).to be(subject)
    end
  end

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

  describe ".read_from" do
    subject { struct_class }

    let(:struct) { subject.new(foo: 0xAABB, bar: -1, baz: 0xCCDD) }
    let(:data)   { struct.pack }
    let(:buffer) { "#{data}AAAAAAA" }
    let(:io)     { StringIO.new(buffer) }

    it "must read .size bytes from the IO object" do
      subject.read_from(io)

      expect(io.pos).to eq(struct_class.size)
    end

    it "must return a new Struct instance containing the read data" do
      new_struct = subject.read_from(io)

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

      it "must cache the returned object" do
        expect(subject[member_name]).to be(subject[member_name])
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

      it "must cache the returned object" do
        expect(subject[member_name]).to be(subject[member_name])
      end

      it "must use a ByteSlice with the member's offset and size" do
        struct = subject[member_name]

        expect(struct.string).to be_kind_of(Ronin::Support::Binary::ByteSlice)
        expect(struct.string.offset).to eq(member.offset)
        expect(struct.string.size).to eq(member.size)
      end
    end

    context "when the member name is unknown" do
      let(:name) { :xxx }

      it do
        expect {
          subject[name]
        }.to raise_error(ArgumentError,"no such member: #{name.inspect}")
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

    context "when the member name is unknown" do
      let(:name)  { :xxx }
      let(:value) { 1 }

      it do
        expect {
          subject[name] = value
        }.to raise_error(ArgumentError,"no such member: #{name.inspect}")
      end
    end
  end

  describe "#to_s" do
    it "must return the underlying #string" do
      expect(subject.to_s).to eq(subject.string)
    end
  end
end
