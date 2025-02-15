# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/binary/template'

describe Ronin::Support::Binary::Template do
  let(:type_name) { :uint32 }
  let(:type)      { Ronin::Support::Binary::CTypes::TYPES[type_name] }
  let(:fields)    { [type_name] }

  subject { described_class.new(fields) }

  describe "#initialize" do
    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    it "must default #arch to nil" do
      expect(subject.arch).to be(nil)
    end

    it "must default #type_system to Ronin::Support::Binary::CTypes" do
      expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
    end

    context "when given a single type name" do
      let(:type_name) { :uint32 }
      let(:fields)    { [type_name] }
      let(:type)      { Ronin::Support::Binary::CTypes::TYPES[type_name] }

      it "must set #type_system to Ronin::Support::Binary::CTypes" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
      end

      it "must set #fields" do
        expect(subject.fields).to eq(fields)
      end

      it "must populate #types with Ronin::Support::Binary::CTypes types" do
        expect(subject.types.first).to eq(type)
      end

      it "must set #pack_string to the type's #pack_string" do
        expect(subject.pack_string).to eq(type.pack_string)
      end
    end

    context "when given multiple type names" do
      let(:type_name1) { :uint32 }
      let(:type1)      { Ronin::Support::Binary::CTypes::TYPES[type_name1] }

      let(:type_name2) { :uint64 }
      let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

      let(:fields) { [type_name1, type_name2] }

      it "must set #type_system to Ronin::Support::Binary::CTypes" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
      end

      it "must set #fields" do
        expect(subject.fields).to eq(fields)
      end

      it "must populate #types with the Ronin::Support::Binary::CTypes types" do
        expect(subject.types).to eq([type1, type2])
      end

      it "must concat the type's #pack_string to #pack_string" do
        expect(subject.pack_string).to eq(
          "#{type1.pack_string}#{type2.pack_string}"
        )
      end
    end

    context "when given an Array of the type name and length" do
      let(:length) { 10 }
      let(:fields) { [[type_name, length]] }
      let(:array_type) do
        Ronin::Support::Binary::CTypes::ArrayType.new(type,length)
      end
      let(:array_object_type) do
        Ronin::Support::Binary::CTypes::ArrayObjectType.new(array_type)
      end

      it "must set #type_system to Ronin::Support::Binary::CTypes" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
      end

      it "must add an Ronin::Support::Binary::CTypes::ArrayObjectType to #types" do
        expect(subject.types.first).to be_kind_of(Ronin::Support::Binary::CTypes::ArrayObjectType)
        expect(subject.types.first.type).to eq(type)
        expect(subject.types.first.length).to eq(length)
      end

      it "must set #pack_string to the ArrayObjectType's #pack_string" do
        expect(subject.pack_string).to eq(array_object_type.pack_string)
      end
    end

    context "when given an Array of an Array of the type name and length" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:fields)  { [[[type_name, length2], length1]] }

      let(:sub_array_type) do
        Ronin::Support::Binary::CTypes::ArrayType.new(type,length2)
      end
      let(:array_type) do
        Ronin::Support::Binary::CTypes::ArrayType.new(sub_array_type,length1)
      end
      let(:array_object_type) do
        Ronin::Support::Binary::CTypes::ArrayObjectType.new(array_type)
      end

      it "must set #type_system to Ronin::Support::Binary::CTypes" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
      end

      it "must add a nested Ronin::Support::Binary::CTypes::ArrayObjectType to #types" do
        expect(subject.types.first).to be_kind_of(Ronin::Support::Binary::CTypes::ArrayObjectType)
        expect(subject.types.first.type).to be_kind_of(Ronin::Support::Binary::CTypes::ArrayObjectType)
        expect(subject.types.first.type.type).to eq(type)
        expect(subject.types.first.type.length).to eq(length2)
        expect(subject.types.first.length).to eq(length1)
      end

      it "must set #pack_string to the ArrayObjectType's #pack_string" do
        expect(subject.pack_string).to eq(array_object_type.pack_string)
      end
    end

    context "when given an infinite range" do
      let(:fields) { [type_name..] }
      let(:flexible_array_type) do
        Ronin::Support::Binary::CTypes::FlexibleArrayType.new(type)
      end

      it "must set #type_system to Ronin::Support::Binary::CTypes" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
      end

      it "must add an Ronin::Support::Binary::CTypes::FlexibleArrayType to #types" do
        expect(subject.types.first).to be_kind_of(Ronin::Support::Binary::CTypes::FlexibleArrayType)
        expect(subject.types.first.type).to eq(type)
      end

      it "must set #pack_string to the FlexibleArrayType's #pack_string" do
        expect(subject.pack_string).to eq(flexible_array_type.pack_string)
      end
    end

    context "when given an unknown type name" do
      let(:type_name) { :foo }
      let(:fields)    { [type_name] }

      it do
        expect {
          described_class.new(fields)
        }.to raise_error(ArgumentError,"unknown type: #{type_name.inspect}")
      end
    end

    context "when the `endian: :little` is given" do
      let(:type_name) { :uint32 }
      let(:type)      { Ronin::Support::Binary::CTypes::LittleEndian[type_name] }
      let(:fields)    { [type_name] }
      let(:endian)    { :little     }

      subject { described_class.new(fields, endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to eq(endian)
      end

      it "must set #type_system to Ronin::Support::Binary::CTypes::LittleEndian" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes::LittleEndian)
      end

      it "must populate #types with Ronin::Support::Binary::CTypes::LittleEndian types" do
        expect(subject.types.first).to eq(type)
      end

      it "must populate #pack_string with the LittleEndian type's #pack_string" do
        expect(subject.pack_string).to eq(type.pack_string)
      end
    end

    context "when the `endian: :big` is given" do
      let(:type_name) { :uint32 }
      let(:type)      { Ronin::Support::Binary::CTypes::BigEndian[type_name] }
      let(:fields)    { [type_name] }
      let(:endian)    { :big }

      subject { described_class.new(fields, endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to eq(endian)
      end

      it "must set #type_system to Ronin::Support::Binary::CTypes::BigEndian" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes::BigEndian)
      end

      it "must populate #types with Ronin::Support::Binary::CTypes::BigEndian types" do
        expect(subject.types.first).to eq(type)
      end

      it "must populate #pack_string with the BigEndian type's #pack_string" do
        expect(subject.pack_string).to eq(type.pack_string)
      end
    end

    context "when the `endian: :net` is given" do
      let(:type_name) { :uint32 }
      let(:type)      { Ronin::Support::Binary::CTypes::Network[type_name] }
      let(:fields)    { [type_name] }
      let(:endian)    { :big }

      subject { described_class.new(fields, endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to eq(endian)
      end

      it "must set #type_system to Ronin::Support::Binary::CTypes::Network" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes::Network)
      end

      it "must populate #types with Ronin::Support::Binary::CTypes::Network types" do
        expect(subject.types.first).to eq(type)
      end

      it "must populate #pack_string with the Network type's #pack_string" do
        expect(subject.pack_string).to eq(type.pack_string)
      end
    end

    describe "when an unknown endian: value is given" do
      let(:endian) { :foo }

      it do
        expect {
          described_class.new(fields, endian: endian)
        }.to raise_error(ArgumentError,"unknown endian: #{endian.inspect}")
      end
    end

    context "when the arch: keyword argument is given" do
      let(:type_name) { :uint }
      let(:type)      { Ronin::Support::Binary::CTypes::Arch::X86[type_name] }
      let(:fields)    { [type_name] }
      let(:arch)      { :x86 }

      subject { described_class.new(fields, arch: arch) }

      it "must set #arch" do
        expect(subject.arch).to eq(arch)
      end

      it "must set #type_system to Ronin::Support::Binary::CTypes::Arch::X86" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes::Arch::X86)
      end

      it "must populate #types with the Ronin::Support::Binary::CTypes::Arch:: module's types" do
        expect(subject.types.first).to eq(type)
      end

      it "must populate #pack_string with the Arch:: module's type #pack_string" do
        expect(subject.pack_string).to eq(type.pack_string)
      end
    end

    describe "when an unknown arch: value is given" do
      let(:arch) { :foo }

      it do
        expect {
          described_class.new(fields, arch: arch)
        }.to raise_error(ArgumentError,"unknown architecture: #{arch.inspect}")
      end
    end
  end

  describe ".[]" do
    let(:fields) { [:uint32, :uint64] }

    subject { described_class[*fields] }

    it "must pass multiple fields to #initialize" do
      expect(subject.fields).to eq(fields)
    end

    context "when keyword arguments are given" do
      let(:endian) { :little }
      let(:arch)   { :x86    }

      subject { described_class[*fields, endian: endian, arch: arch] }

      it "must pass any keyword arguments to #initialize" do
        expect(subject.endian).to eq(endian)
        expect(subject.arch).to eq(arch)
      end
    end
  end

  describe "#pack" do
    context "when initialized with one field" do
      let(:type_name) { :uint32 }
      let(:fields)    { [type_name] }
      let(:type)      { Ronin::Support::Binary::CTypes::TYPES[type_name] }

      let(:value) { 42 }

      it "must pack a single value using the field's pack string" do
        expect(subject.pack(value)).to eq(type.pack(value))
      end
    end

    context "when initialized with multiple fields" do
      let(:type_name1) { :uint32 }
      let(:type1)      { Ronin::Support::Binary::CTypes::TYPES[type_name1] }

      let(:type_name2) { :int64 }
      let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

      let(:fields) { [type_name1, type_name2] }

      let(:value1) { 42 }
      let(:value2) { -1 }
      let(:values) { [value1, value2] }

      it "must pack multiple values using the fields' pack strings" do
        expect(subject.pack(*values)).to eq(
          "#{type1.pack(value1)}#{type2.pack(value2)}"
        )
      end

      context "and one of the fields is an Array field" do
        let(:type_name2) { :uint16 }
        let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

        let(:array_length) { 10 }
        let(:array_type) do
          Ronin::Support::Binary::CTypes::ArrayType.new(type2,array_length)
        end

        let(:fields) { [type_name1, [type_name2, array_length]] }

        let(:value1) { 42 }
        let(:value2) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
        let(:values) { [value1, value2] }

        it "must flatten then pack multiple values using the fields' pack strings" do
          expect(subject.pack(*values)).to eq(
            "#{type1.pack(value1)}#{array_type.pack(value2)}"
          )
        end
      end

      context "and the last field is an infinite Range field" do
        let(:type_name2) { :uint16 }
        let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

        let(:flexible_array_type) do
          Ronin::Support::Binary::CTypes::FlexibleArrayType.new(type2)
        end

        let(:fields) { [type_name1, type_name2..] }

        let(:value1) { 42 }
        let(:value2) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
        let(:values) { [value1, value2] }

        it "must pack the remainder of the values using the last field's pack string" do
          expect(subject.pack(*values)).to eq(
            "#{type1.pack(value1)}#{flexible_array_type.pack(value2)}"
          )
        end
      end

      context "and the last field is an infinite Range of an Array field" do
        let(:type_name2) { :uint16 }
        let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

        let(:array_length) { 2 }
        let(:array_type) do
          Ronin::Support::Binary::CTypes::ArrayType.new(type2,array_length)
        end
        let(:flexible_array_type) do
          Ronin::Support::Binary::CTypes::FlexibleArrayType.new(array_type)
        end

        let(:fields) { [type_name1, [type_name2, array_length]..] }

        let(:value1) { 42 }
        let(:value2) { [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]] }
        let(:values) { [value1, value2] }

        it "must pack the last value using the last field's type's #pack method" do
          expect(subject.pack(*values)).to eq(
            "#{type1.pack(value1)}#{flexible_array_type.pack(value2)}"
          )
        end
      end
    end
  end

  describe "#unpack" do
    context "when initialized with one field" do
      let(:type_name) { :uint32 }
      let(:fields)    { [type_name] }
      let(:type)      { Ronin::Support::Binary::CTypes::TYPES[type_name] }

      let(:value) { 42 }

      let(:data) { type.pack(value) }

      it "must unpack a value from the data using the field's pack string" do
        expect(subject.unpack(data)).to eq([value])
      end
    end

    context "when initialized with multiple fields" do
      let(:type_name1) { :uint32 }
      let(:type1)      { Ronin::Support::Binary::CTypes::TYPES[type_name1] }

      let(:type_name2) { :int64 }
      let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

      let(:fields) { [type_name1, type_name2] }

      let(:value1) { 42 }
      let(:value2) { -1 }

      let(:data) { "#{type1.pack(value1)}#{type2.pack(value2)}" }

      it "must unpack values from the data using the fields' pack strings" do
        values = subject.unpack(data)

        expect(values.length).to eq(2)
        expect(values[0]).to eq(value1)
        expect(values[1]).to eq(value2)
      end

      context "and one of the fields is an Array field" do
        let(:type_name2) { :uint16 }
        let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

        let(:array_length) { 10 }
        let(:array_type) do
          Ronin::Support::Binary::CTypes::ArrayType.new(type2,array_length)
        end
        let(:array_object_type) do
          Ronin::Support::Binary::CTypes::ArrayObjectType.new(array_type)
        end

        let(:fields) { [type_name1, [type_name2, array_length]] }

        let(:value1) { 42 }
        let(:value2) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

        let(:data) { "#{type1.pack(value1)}#{array_type.pack(value2)}" }

        it "must flatten then pack multiple values using the fields' pack strings" do
          values = subject.unpack(data)

          expect(values.length).to eq(2)
          expect(values[0]).to eq(value1)
          expect(values[1]).to be_kind_of(Ronin::Support::Binary::Array)
          expect(values[1].string).to eq(
            data[type1.size,array_object_type.size]
          )
        end
      end

      context "and the last field is an infinite Range field" do
        let(:type_name2) { :uint16 }
        let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

        let(:flexible_array_type) do
          Ronin::Support::Binary::CTypes::FlexibleArrayType.new(type2)
        end

        let(:fields) { [type_name1, type_name2..] }

        let(:value1) { 42 }
        let(:value2) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

        let(:data) do
          "#{type1.pack(value1)}#{flexible_array_type.pack(value2)}"
        end

        it "must unpack the remainder of the values using the last field's pack string" do
          values = subject.unpack(data)

          expect(values.length).to eq(2)
          expect(values[0]).to eq(value1)
          expect(values[1]).to eq(value2)
        end
      end

      context "and the last field is an infinite Range of an Array field" do
        let(:type_name2) { :uint16 }
        let(:type2)      { Ronin::Support::Binary::CTypes::TYPES[type_name2] }

        let(:array_length) { 2 }
        let(:array_type) do
          Ronin::Support::Binary::CTypes::ArrayType.new(type2,array_length)
        end
        let(:flexible_array_type) do
          Ronin::Support::Binary::CTypes::FlexibleArrayType.new(array_type)
        end

        let(:fields) { [type_name1, [type_name2, array_length]..] }

        let(:value1) { 42 }
        let(:value2) { [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]] }
        let(:values) { [value1, value2] }

        let(:data) do
          "#{type1.pack(value1)}#{flexible_array_type.pack(value2)}"
        end

        it "must unpack the remainder of the values using the last field's type's #unpack method" do
          values = subject.unpack(data)

          expect(values.length).to eq(2)
          expect(values[0]).to eq(value1)
          expect(values[1].length).to eq(value2.length)
          expect(values[1]).to all(be_kind_of(Ronin::Support::Binary::Array))
          expect(values[1].map(&:to_a)).to eq(value2)
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the #pack_string" do
      expect(subject.to_s).to eq(subject.pack_string)
    end
  end

  describe "#to_str" do
    it "must return the #pack_string" do
      expect(subject.to_str).to eq(subject.pack_string)
    end
  end
end
