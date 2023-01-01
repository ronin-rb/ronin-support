require 'spec_helper'
require 'ronin/support/binary/ctypes/union_type'
require 'ronin/support/binary/ctypes'

require_relative 'type_examples'

describe Ronin::Support::Binary::CTypes::UnionType do
  describe described_class::Member do
    let(:type)   { Ronin::Support::Binary::CTypes::UINT16 }

    subject { described_class.new(type) }

    describe "#initialize" do
      it "must set #type" do
        expect(subject.type).to eq(type)
      end
    end

    describe "#offset" do
      it "must return 0" do
        expect(subject.offset).to eq(0)
      end
    end

    describe "#size" do
      it "must return #type.size" do
        expect(subject.size).to eq(type.size)
      end
    end

    describe "#alignment" do
      it "must return #type.alignment" do
        expect(subject.alignment).to eq(type.alignment)
      end
    end
  end

  describe "#initialize" do
    let(:members) do
      {
        a: described_class::Member.new(Ronin::Support::Binary::CTypes::CHAR),
        b: described_class::Member.new(Ronin::Support::Binary::CTypes::INT16),
        c: described_class::Member.new(Ronin::Support::Binary::CTypes::UINT32),
        d: described_class::Member.new(Ronin::Support::Binary::CTypes::INT64)
      }
    end

    let(:size)      { members.values.map(&:size).max      }
    let(:alignment) { members.values.map(&:alignment).max }

    subject do
      described_class.new(members, size:        size,
                                   alignment:   alignment)
    end

    it "must set #members" do
      expect(subject.members).to eq(members)
    end

    it "must set #size" do
      expect(subject.size).to eq(size)
    end

    it "must set #alignment" do
      expect(subject.alignment).to eq(alignment)
    end

    it "must set #pack_string to nil" do
      expect(subject.pack_string).to be(nil)
    end
  end

  describe ".build" do
    context "when given an empty Hash" do
      subject { described_class.build({}) }

      it "must set #members to {}" do
        expect(subject.members).to eq({})
      end

      it "must set #size to 0" do
        expect(subject.size).to eq(0)
      end

      it "must set #alignment to 0" do
        expect(subject.alignment).to eq(0)
      end

      it "must set #pack_string to nil" do
        expect(subject.pack_string).to be(nil)
      end
    end

    context "when given a Hash of names and types" do
      subject { described_class.build(members) }

      it "must populate #members with Members containing the offset and type" do
        expect(subject.members.keys).to eq(members.keys)
        expect(subject.members.values).to all(be_kind_of(described_class::Member))

        expect(subject.members[:a].type).to eq(members[:a])
        expect(subject.members[:b].type).to eq(members[:b])
        expect(subject.members[:c].type).to eq(members[:c])
        expect(subject.members[:d].type).to eq(members[:d])
      end

      it "must set #size to the largest of the members type's sizes" do
        expect(subject.size).to eq(members.values.map(&:size).max)
      end

      it "must set #alignment to the largest of the members type's alignments" do
        expect(subject.alignment).to eq(members.values.map(&:alignment).max)
      end

      context "but when the `alignment:` keyword is given" do
        let(:new_alignment) { 3 }

        subject { described_class.build(members, alignment: new_alignment) }

        it "must override the struct type's alignment" do
          expect(subject.alignment).to eq(new_alignment)
        end
      end

      it "must set #pack_string to nil" do
        expect(subject.pack_string).to be(nil)
      end

      context "when one of the fields is a Ronin::Support::Binary::CTypes::UnboundedArrayType" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT16,
            c: Ronin::Support::Binary::CTypes::UINT32[]
          }
        end

        it "must omit the UnboundedArrayType member size from #size" do
          expect(subject.size).to eq(
            [members[:a].size, members[:b].size].max
          )
        end
      end
    end
  end

  let(:members) do
    {
      a: Ronin::Support::Binary::CTypes::CHAR,
      b: Ronin::Support::Binary::CTypes::INT8,
      c: Ronin::Support::Binary::CTypes::UINT16,
      d: Ronin::Support::Binary::CTypes::INT16
    }
  end

  subject { described_class.build(members) }

  describe "#uninitialized_value" do
    it "must return a Hash of the members type's #uninitialized_value" do
      expect(subject.uninitialized_value).to eq(
        {
          a: members[:a].uninitialized_value,
          b: members[:b].uninitialized_value,
          c: members[:c].uninitialized_value,
          d: members[:c].uninitialized_value
        }
      )
    end
  end

  describe "#length" do
    it "must return the number of values within #members" do
      expect(subject.length).to eq(members.length)
    end
  end

  describe "#align" do
    let(:new_alignment) { 3 }

    let(:new_type) { subject.align(new_alignment) }

    it "must return the same kind of type" do
      expect(new_type).to be_kind_of(described_class)
    end

    it "must return a copy of the struct type" do
      expect(new_type).to_not be(subject)
    end

    it "must preserve #members" do
      expect(new_type.members).to eq(subject.members)
    end

    it "must preserve #size" do
      expect(new_type.size).to eq(subject.size)
    end

    it "must set #alignment to the new alignment" do
      expect(new_type.alignment).to eq(new_alignment)
    end
  end

  describe "#pack" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1122,
        d: -2
      }
    end

    context "when given an empty Hash" do
      it "must return a String of #size containing all null bytes" do
        expect(subject.pack({})).to eq(
          ("\0" * subject.size).encode(Encoding::ASCII_8BIT)
        )
      end
    end

    context "when given a Hash containing one key and value" do
      let(:key)   { :c }
      let(:value) { 0x1122 }
      let(:hash)  { {key => value} }

      let(:member) { subject.members[key] }
      let(:type)   { member.type }

      let(:zero_padding) { subject.size - type.size }

      it "must pack the value using the member type and write it to the beginning of the String" do
        expect(subject.pack(hash)).to eq(
          type.pack(value) + ("\0" * zero_padding).encode(Encoding::ASCII_8BIT)
        )
      end

      context "and when the corresponding member type is an AggregateType" do
        let(:array_length) { 10 }
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT8,
            c: Ronin::Support::Binary::CTypes::UINT16[array_length]
          }
        end

        let(:key) { :c }
        let(:value) do
          [
            0x0000, 0x1111, 0x2222, 0x3333, 0x4444,
            0x5555, 0x6666, 0x7777, 0x8888, 0x9999
          ]
        end

        it "must pack the value using the member's AggregateType" do
          expect(subject.pack(hash)).to eq(type.pack(value))
        end
      end

      context "and when the member type is an UnboundedArrayType" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT8,
            c: Ronin::Support::Binary::CTypes::UINT16[]
          }
        end

        let(:key)   { :c }
        let(:value) { [*0x00..0x10] }
        let(:hash)  { {key => value} }

        it "must pack the value using the member's UnboundedArrayType" do
          expect(subject.pack(hash)).to eq(type.pack(value))
        end
      end

      context "when one of the #members is another StructType" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT8,
            c: Ronin::Support::Binary::CTypes::StructType.build(
                 {
                   x: Ronin::Support::Binary::CTypes::INT16,
                   y: Ronin::Support::Binary::CTypes::UINT16
                 }
               )
          }
        end

        let(:key) { :c }
        let(:value) do
          {
            x: -2,
            y: 0x1234
          }
        end

        it "must pack the value using the member's StructType" do
          expect(subject.pack(hash)).to eq(type.pack(value))
        end
      end
    end

    context "when given a Hash containing multiple keys and values" do
      context "and when the last value's member's type is smaller than the previous value's member's type" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::INT32,
            b: Ronin::Support::Binary::CTypes::UINT16
          }
        end

        let(:type1) { subject.members[:a].type }
        let(:type2) { subject.members[:b].type }

        let(:value1) { -1 }
        let(:value2) { 2  }
        let(:hash) do
          {
            a: value1,
            b: value2
          }
        end

        it "must overwrite the leading bytes of the previous packed value" do
          expect(subject.pack(hash)).to eq(
            type2.pack(value2) + type1.pack(value1)[type2.size..]
          )
        end
      end

      context "and when the last value's member's type is equal to the previous value's member's type" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::INT32,
            b: Ronin::Support::Binary::CTypes::UINT32
          }
        end

        let(:type1) { subject.members[:a].type }
        let(:type2) { subject.members[:b].type }

        let(:value1) { -1 }
        let(:value2) { 2  }
        let(:hash) do
          {
            a: value1,
            b: value2
          }
        end

        it "must overwrite all of the bytes of the previous packed value" do
          expect(subject.pack(hash)).to eq(type2.pack(value2))
        end
      end

      context "and when the last value's member's type is larger than the previous value's member's type" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::INT16,
            b: Ronin::Support::Binary::CTypes::UINT32
          }
        end

        let(:type1) { subject.members[:a].type }
        let(:type2) { subject.members[:b].type }

        let(:value1) { -1 }
        let(:value2) { 2  }
        let(:hash) do
          {
            a: value1,
            b: value2
          }
        end

        it "must overwrite the leading bytes of the previous packed value" do
          expect(subject.pack(hash)).to eq(type2.pack(value2))
        end

        it "must return a larger String than the previous packed value" do
          expect(subject.pack(hash).length).to be > type1.pack(value1).length
        end
      end
    end

    context "when the hash contains an unknown member name" do
      let(:unknown_member1) { :foo }
      let(:unknown_member2) { :bar }

      let(:hash) do
        {
          a: 'A',
          b: -1,
          unknown_member1 => 'xxx',
          c: 0x1122,
          d: -2,
          unknown_member2 => 'xxx'
        }
      end

      it do
        expect {
          subject.pack(hash)
        }.to raise_error(ArgumentError,"unknown union members: #{unknown_member1.inspect}, #{unknown_member2.inspect}")
      end
    end
  end

  describe "#unpack" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1122,
        d: -2
      }
    end

    let(:data) do
      ("\xFF" * subject.size).force_encoding(Encoding::ASCII_8BIT)
    end

    it "must unpack a Hash containing unpacked values for each member's type" do
      expect(subject.unpack(data)).to eq(
        {
          a: "\xFF".force_encoding(Encoding::ASCII_8BIT),
          b: -1,
          c: 0xffff,
          d: -1
        }
      )
    end

    context "when one of the #members is an AggregateType" do
      let(:array_length) { 10 }
      let(:members) do
        {
          a: Ronin::Support::Binary::CTypes::CHAR,
          b: Ronin::Support::Binary::CTypes::INT8,
          c: Ronin::Support::Binary::CTypes::UINT16[array_length]
        }
      end

      it "must unpack multiple values and return a Hash of Arrays of values" do
        expect(subject.unpack(data)).to eq(
          {
            a: "\xFF".force_encoding(Encoding::ASCII_8BIT),
            b: -1,
            c: [65535] * array_length
          }
        )
      end
    end

    context "when the last value in #members is an UnboundedArrayType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::CTypes::CHAR,
          b: Ronin::Support::Binary::CTypes::INT8,
          c: Ronin::Support::Binary::CTypes::UINT16[]
        }
      end

      let(:hash) do
        {
          a: 'A',
          b: -1,
          c: [*0x00..0x10]
        }
      end

      let(:unbounded_array_subtype) { subject.members[:c].type.type }
      let(:unbounded_array_length)  { 10 }
      let(:data_size) { unbounded_array_subtype.size * unbounded_array_length }
      let(:data) do
        ("\xFF" * data_size).force_encoding(Encoding::ASCII_8BIT)
      end

      it "must unpack multiple values and return a Hash of Arrays of values" do
        expect(subject.unpack(data)).to eq(
          {
            a: "\xFF".force_encoding(Encoding::ASCII_8BIT),
            b: -1,
            c: [65535] * unbounded_array_length
          }
        )
      end
    end

    context "when one of the #members is another StructType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::CTypes::CHAR,
          b: Ronin::Support::Binary::CTypes::INT8,
          c: Ronin::Support::Binary::CTypes::StructType.build(
               {
                 x: Ronin::Support::Binary::CTypes::INT16,
                 y: Ronin::Support::Binary::CTypes::UINT16
               }
             )
        }
      end

      let(:hash) do
        {
          a: 'A',
          b: -1,
          c: {
            x: -2,
            y: 0x1234
          }
        }
      end

      let(:data) do
        ("\xFF" * subject.size).force_encoding(Encoding::ASCII_8BIT)
      end

      it "must unpack multiple values and return a Hash of Hashes of values" do
        expect(subject.unpack(data)).to eq(
          {
            a: "\xFF".force_encoding(Encoding::ASCII_8BIT),
            b: -1,
            c: {
              x: -1,
              y: 0xffff
            }
          }
        )
      end
    end
  end

  include_examples "Type examples"
end
