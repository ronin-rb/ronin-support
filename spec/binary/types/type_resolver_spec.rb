require 'spec_helper'
require 'ronin/support/binary/types/type_resolver'
require 'ronin/support/binary/types/native'
require 'ronin/support/binary/struct'
require 'ronin/support/binary/union'

describe Ronin::Support::Binary::Types::TypeResolver do
  let(:types) { Ronin::Support::Binary::Types::Native }

  subject { described_class.new(types) }

  describe "#initialize" do
    it "must set #types" do
      expect(subject.types).to eq(types)
    end
  end

  describe "#resolve" do
    let(:type_name) { :int32 }

    module TestTypesResolver
      class TestStruct < Ronin::Support::Binary::Struct
        member :x, :int32
        member :y, :uint32
      end

      class TestStructWithAlignment < Ronin::Support::Binary::Struct
        align 3

        member :x, :uint8
        member :y, :int32
      end

      class TestStructWithoutPadding < Ronin::Support::Binary::Struct
        padding false
        member :x, :uint8
        member :y, :int32
      end

      class TestUnion < Ronin::Support::Binary::Union
        member :x, :int16
        member :y, :uint32
      end

      class TestUnionWithAlignment < Ronin::Support::Binary::Union
        align 3

        member :x, :int16
        member :y, :uint32
      end
    end

    let(:struct_class) { TestTypesResolver::TestStruct }
    let(:union_class)  { TestTypesResolver::TestUnion  }

    context "when given a Symbol" do
      it "must resolve the type name" do
        type = subject.resolve(type_name)

        expect(type).to eq(types[type_name])
      end
    end

    context "when given a Struct class" do
      it "must return a StructObjectType" do
        type = subject.resolve(struct_class)

        expect(type).to be_kind_of(Ronin::Support::Binary::Types::StructObjectType)
      end

      it "must initialize the StructObjectType with the Struct class" do
        type = subject.resolve(struct_class)

        expect(type.struct_class).to be(struct_class)
      end

      it "must resolve the Struct's member types using the resolver" do
        type = subject.resolve(struct_class)

        expect(type.struct_type.members[:x].type).to eq(subject.resolve(struct_class.members[:x].type_signature))
        expect(type.struct_type.members[:y].type).to eq(subject.resolve(struct_class.members[:y].type_signature))
      end

      context "but the Struct class has a custom .alignment set" do
        let(:struct_class) { TestTypesResolver::TestStructWithAlignment }

        it "must return a StructObjectType with the same alignment" do
          type = subject.resolve(struct_class)

          expect(type.alignment).to eq(struct_class.alignment)
        end
      end

      context "but the Struct class has .padding disabled" do
        let(:struct_class) { TestTypesResolver::TestStructWithoutPadding }

        it "must not add padding to members" do
          type = subject.resolve(struct_class)

          expect(type.size).to eq(
            subject.resolve(struct_class.members[:x].type_signature).size + 
            subject.resolve(struct_class.members[:y].type_signature).size
          )
        end
      end
    end

    context "when given a Union class" do
      it "must return a UnionObjectType" do
        type = subject.resolve(union_class)

        expect(type).to be_kind_of(Ronin::Support::Binary::Types::UnionObjectType)
      end

      it "must initialize the UnionObjectType with the Union class" do
        type = subject.resolve(union_class)

        expect(type.union_class).to be(union_class)
      end

      it "must resolve the Union's member types using the resolver" do
        type = subject.resolve(union_class)

        expect(type.union_type.members[:x].type).to eq(subject.resolve(union_class.members[:x].type_signature))
        expect(type.union_type.members[:y].type).to eq(subject.resolve(union_class.members[:y].type_signature))
      end

      context "but the Union class has a custom .alignment set" do
        let(:union_class) { TestTypesResolver::TestUnionWithAlignment }

        it "must return a UnionObjectType with the same alignment" do
          type = subject.resolve(union_class)

          expect(type.alignment).to eq(union_class.alignment)
        end
      end
    end

    context "when given an Array" do
      let(:length) { 3 }

      context "and it contains a Symbol and a length" do
        it "must return an ArrayObjectType containing the resolved Type and length" do
          type = subject.resolve([type_name, length])

          expect(type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
          expect(type.type).to eq(types[type_name])
          expect(type.length).to eq(length)
        end
      end

      context "and it contains an Array containing a Symbol and a length" do
        let(:length1) { 3 }
        let(:length2) { 2 }

        it "must return an ArrayObjectType containing an ArrayObjectType and the length" do
          type = subject.resolve([[type_name, length2], length1])

          expect(type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
          expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
          expect(type.length).to eq(length1)

          expect(type.type.type).to eq(types[type_name])
          expect(type.type.length).to eq(length2)
        end
      end

      context "and it contains a Struct class" do
        it "must return an ArrayObjectType containing a StructObjectType and the length" do
          type = subject.resolve([struct_class, length])

          expect(type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
          expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::StructObjectType)
          expect(type.length).to eq(length)
        end

        it "must initialize the StructObjectType with the Struct class" do
          type = subject.resolve([struct_class, length])

          expect(type.type.struct_class).to be(struct_class)
        end

        it "must resolve the Struct's member types using the resolver" do
          type = subject.resolve([struct_class, length])
          struct_type = type.type

          expect(struct_type.struct_type.members[:x].type).to eq(subject.resolve(struct_class.members[:x].type_signature))
          expect(struct_type.struct_type.members[:y].type).to eq(subject.resolve(struct_class.members[:y].type_signature))
        end
      end

      context "and it contains a Union class" do
        it "must return an ArrayObjectType containing a UnionObjectType and the length" do
          type = subject.resolve([union_class, length])

          expect(type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
          expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::UnionObjectType)
          expect(type.length).to eq(length)
        end

        it "must initialize the UnionObjectType with the Union class" do
          type = subject.resolve([union_class, length])

          expect(type.type.union_class).to be(union_class)
        end

        it "must resolve the Union's member types using the resolver" do
          type = subject.resolve([union_class, length])
          union_type = type.type

          expect(union_type.union_type.members[:x].type).to eq(subject.resolve(union_class.members[:x].type_signature))
          expect(union_type.union_type.members[:y].type).to eq(subject.resolve(union_class.members[:y].type_signature))
        end
      end

      context "and it contains a Type object and a length" do
        let(:type_object) { types::INT32 }

        it "must return an ArrayObjectType containing the Type and length" do
          type = subject.resolve([type_object, length])

          expect(type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
          expect(type.type).to eq(type_object)
          expect(type.length).to eq(length)
        end
      end
    end

    context "when given a Range" do
      context "and it starts with a Symbol" do
        it "must return an UnboundedArrayType containing the resolved Type" do
          type = subject.resolve(type_name..)

          expect(type).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
          expect(type.type).to eq(types[type_name])
        end
      end

      context "and it starts with an Array" do
        let(:length) { 3 }

        context "and it contains a Symbol and a length" do
          it "must return an ArrayObjectType containing the resolved Type and length" do
            type = subject.resolve([type_name, length]..)

            expect(type).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
            expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
            expect(type.type.type).to eq(types[type_name])
            expect(type.type.length).to eq(length)
          end
        end

        context "and it contains an Array containing a Symbol and a length" do
          let(:length1) { 3 }
          let(:length2) { 2 }

          it "must return an ArrayObjectType containing an ArrayObjectType and the length" do
            type = subject.resolve([[type_name, length2], length1]..)

            expect(type).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
            expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
            expect(type.type.type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
            expect(type.type.length).to eq(length1)

            expect(type.type.type.type).to eq(types[type_name])
            expect(type.type.type.length).to eq(length2)
          end
        end

        context "and it contains a Struct class" do
          let(:struct_class) { TestTypesResolver::TestStruct }

          it "must return an ArrayObjectType containing a StructObjectType and the length" do
            type = subject.resolve([struct_class, length]..)

            expect(type).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
            expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
            expect(type.type.type).to be_kind_of(Ronin::Support::Binary::Types::StructObjectType)
            expect(type.type.length).to eq(length)
          end

          it "must initialize the StructObjectType with the Struct class" do
            type = subject.resolve([struct_class, length]..)

            expect(type.type.type.struct_class).to be(struct_class)
          end

          it "must resolve the Struct's member types using the resolver" do
            type = subject.resolve([struct_class, length]..)
            struct_type = type.type.type

            expect(struct_type.struct_type.members[:x].type).to eq(subject.resolve(struct_class.members[:x].type_signature))
            expect(struct_type.struct_type.members[:y].type).to eq(subject.resolve(struct_class.members[:y].type_signature))
          end
        end

        context "and it contains a Union class" do
          let(:union_class) { TestTypesResolver::TestUnion }

          it "must return an ArrayObjectType containing a UnionObjectType and the length" do
            type = subject.resolve([union_class, length]..)

            expect(type).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
            expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
            expect(type.type.type).to be_kind_of(Ronin::Support::Binary::Types::UnionObjectType)
            expect(type.type.length).to eq(length)
          end

          it "must initialize the UnionObjectType with the Union class" do
            type = subject.resolve([union_class, length]..)

            expect(type.type.type.union_class).to be(union_class)
          end

          it "must resolve the Union's member types using the resolver" do
            type = subject.resolve([union_class, length]..)
            union_type = type.type.type

            expect(union_type.union_type.members[:x].type).to eq(subject.resolve(union_class.members[:x].type_signature))
            expect(union_type.union_type.members[:y].type).to eq(subject.resolve(union_class.members[:y].type_signature))
          end
        end

        context "and it contains a Type object and a length" do
          let(:type_object) { types::INT32 }

          it "must return an ArrayObjectType containing the Type and length" do
            type = subject.resolve([type_object, length]..)

            expect(type).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
            expect(type.type).to be_kind_of(Ronin::Support::Binary::Types::ArrayObjectType)
            expect(type.type.type).to eq(type_object)
            expect(type.type.length).to eq(length)
          end
        end
      end
    end

    context "when given a Class that is not a Struct class" do
      let(:object) { Class.new }

      it do
        expect {
          subject.resolve(object)
        }.to raise_error(ArgumentError,"class must be either a #{Ronin::Support::Binary::Struct} or a #{Ronin::Support::Binary::Union} class")
      end
    end

    context "when given another type of Object" do
      let(:object) { Object.new }

      it do
        expect {
          subject.resolve(object)
        }.to raise_error(ArgumentError,"type type_signature must be a Symbol, Array, Range, #{Ronin::Support::Binary::Struct}, #{Ronin::Support::Binary::Union}, or a #{Ronin::Support::Binary::Types::Type} object: #{object.inspect}")
      end
    end
  end
end
