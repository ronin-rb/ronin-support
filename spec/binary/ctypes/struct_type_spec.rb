require 'spec_helper'
require 'ronin/support/binary/ctypes/struct_type'
require 'ronin/support/binary/ctypes'

require_relative 'type_examples'

describe Ronin::Support::Binary::CTypes::StructType do
  describe described_class::Member do
    let(:offset) { 3 }
    let(:type)   { Ronin::Support::Binary::CTypes::UINT16 }

    subject { described_class.new(offset,type) }

    describe "#initialize" do
      it "must set #offset" do
        expect(subject.offset).to eq(offset)
      end

      it "must set #type" do
        expect(subject.type).to eq(type)
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
        a: described_class::Member.new(
             0, Ronin::Support::Binary::CTypes::CHAR
           ),
        b: described_class::Member.new(
             2, Ronin::Support::Binary::CTypes::INT16
           ),
        c: described_class::Member.new(
             4, Ronin::Support::Binary::CTypes::UINT32
           ),
        d: described_class::Member.new(
             8, Ronin::Support::Binary::CTypes::INT64
           )
      }
    end

    let(:size)      { members.values.last.offset + members.values.last.size }
    let(:alignment) { members.values.map(&:alignment).max }

    let(:pack_string) do
      members.values.map { |member| member.type.pack_string }.join
    end

    subject do
      described_class.new(members, size:        size,
                                   alignment:   alignment,
                                   pack_string: pack_string)
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

    it "must set #pack_string" do
      expect(subject.pack_string).to eq(pack_string)
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

      it "must set #pack_string to ''" do
        expect(subject.pack_string).to eq('')
      end
    end

    context "when given a Hash of names and types" do
      subject { described_class.build(members) }

      it "must populate #members with Members containing the offset and type" do
        expect(subject.members.keys).to eq(members.keys)
        expect(subject.members.values).to all(be_kind_of(described_class::Member))

        expect(subject.members[:a].offset).to eq(0)
        expect(subject.members[:a].type).to eq(members[:a])

        expect(subject.members[:b].offset).to eq(members[:a].size)
        expect(subject.members[:b].type).to eq(members[:b])

        expect(subject.members[:c].offset).to eq(members[:a].size + members[:b].size)
        expect(subject.members[:c].type).to eq(members[:c])

        expect(subject.members[:d].offset).to eq(members[:a].size + members[:b].size + members[:c].size)
        expect(subject.members[:d].type).to eq(members[:d])
      end

      context "when one of the members offset is not divisible by it's type's alignment" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::UINT32
          }
        end

        it "must add padding to the member's offset to align it" do
          expect(subject.members[:a].offset).to eq(0)
          expect(subject.members[:b].offset).to eq(members[:a].size + 3)
        end

        context "but `padding: false` is also given" do
          subject { described_class.build(members, padding: false) }

          it "must not add padding to members" do
            expect(subject.members[:a].offset).to eq(0)
            expect(subject.members[:b].offset).to eq(members[:a].size)
          end
        end
      end

      it "must set #size to the sum of the members type's sizes" do
        expect(subject.size).to eq(members.values.map(&:size).sum)
      end

      it "must set #alignment to the largest alignment of it's #members" do
        expect(subject.alignment).to eq(members.values.map(&:alignment).max)
      end

      context "but when the `alignment:` keyword is given" do
        let(:new_alignment) { 3 }

        subject { described_class.build(members, alignment: new_alignment) }

        it "must override the struct type's alignment" do
          expect(subject.alignment).to eq(new_alignment)
        end
      end

      context "when all of the given types have a #pack_string" do
        it "must #pack_string to the combination of all type's #pack_string" do
          expect(subject.pack_string).to eq(
            members.values.map(&:pack_string).join
          )
        end

        context "but one of the members offset is not divisible by it's type's alignment" do
          let(:members) do
            {
              a: Ronin::Support::Binary::CTypes::CHAR,
              b: Ronin::Support::Binary::CTypes::UINT32
            }
          end

          it "must add 'x' characters before the member's #pack_string to align it" do
            expect(subject.pack_string).to eq(
              "#{members[:a].pack_string}xxx#{members[:b].pack_string}"
            )
          end
        end
      end

      context "when one of the types does not have a #pack_string" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::INT32,
            b: Ronin::Support::Binary::CTypes::FlexibleArrayType.new(
                 Ronin::Support::Binary::CTypes::INT32[3]
               )
          }
        end

        it "must set #pack_string to nil" do
          expect(subject.pack_string).to be(nil)
        end
      end

      context "when one of the members is a Ronin::Support::Binary::CTypes::FlexibleArrayType" do
        let(:members) do
          {
            a: Ronin::Support::Binary::CTypes::INT16,
            b: Ronin::Support::Binary::CTypes::INT16,
            c: Ronin::Support::Binary::CTypes::UINT32[]
          }
        end

        it "must omit the FlexibleArrayType member size from #size" do
          expect(subject.size).to eq(
            members[:a].size + members[:b].size
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

    it "must preserve #pack_string" do
      expect(new_type.pack_string).to eq(subject.pack_string)
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

    it "must pack a hash of values using Array#pack and #pack_string" do
      expect(subject.pack(hash)).to eq(
        [hash[:a], hash[:b], hash[:c], hash[:d]].pack(subject.pack_string)
      )
    end

    context "but some of the member fields are missing from the given hash" do
      let(:hash) do
        {
          a: 'A',
          c: 0x1122
        }
      end

      it "must leave those member fields zerod in the resulting binary data" do
        expect(subject.pack(hash)).to eq(
          [
            hash[:a],
            subject.members[:b].type.uninitialized_value,
            hash[:c],
            subject.members[:d].type.uninitialized_value
          ].pack(subject.pack_string)
        )
      end
    end

    context "but some of the member fields in the given hash are nil" do
      let(:hash) do
        {
          a: 'A',
          b: nil,
          c: 0x1122,
          d: nil
        }
      end

      it "must replace the nil values with #uninitialized_value from the missing member" do
        expect(subject.pack(hash)).to eq(
          [
            hash[:a],
            subject.members[:b].type.uninitialized_value,
            hash[:c],
            subject.members[:d].type.uninitialized_value
          ].pack(subject.pack_string)
        )
      end
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

      let(:hash) do
        {
          a: 'A',
          b: -1,
          c: [
            0x0000, 0x1111, 0x2222, 0x3333, 0x4444,
            0x5555, 0x6666, 0x7777, 0x8888, 0x9999
          ]
        }
      end

      it "must flatten then pack the Hash of Arrays of values" do
        expect(subject.pack(hash)).to eq(
          [hash[:a], hash[:b], *hash[:c]].pack(subject.pack_string)
        )
      end
    end

    context "when the last value in #members is an FlexibleArrayType" do
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

      it "must flatten then pack the Hash of Arrays of values" do
        expect(subject.pack(hash)).to eq(
          [hash[:a], hash[:b], *hash[:c]].pack(subject.pack_string)
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

      it "must flatten then pack the Hash of Hashes of values" do
        expect(subject.pack(hash)).to eq(
          [
            hash[:a], hash[:b], hash[:c][:x], hash[:c][:y]
          ].pack(subject.pack_string)
        )
      end
    end

    context "when one of the #members is another UnionType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::CTypes::CHAR,
          b: Ronin::Support::Binary::CTypes::INT8,
          c: Ronin::Support::Binary::CTypes::UnionType.build(
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
            x: 0,
            y: 0xffff
          }
        }
      end
      let(:data) { subject.pack(hash) }

      let(:unpacked_hash) do
        {
          a: 'A',
          b: -1,
          c: {
            x: -1,
            y: 0xffff
          }
        }
      end

      it "must pack each value in the Hash with it's according member type" do
        expect(subject.pack(hash)).to eq(
          subject.members[:a].type.pack(hash[:a]) +
          subject.members[:b].type.pack(hash[:b]) +
          subject.members[:c].type.pack(hash[:c])
        )
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
        }.to raise_error(ArgumentError,"unknown struct members: #{unknown_member1.inspect}, #{unknown_member2.inspect}")
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
      [hash[:a], hash[:b], hash[:c], hash[:d]].pack(subject.pack_string)
    end

    it "must unpack a Hash using String#unpack and #pack_string" do
      expect(subject.unpack(data)).to eq(hash)
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

      let(:hash) do
        {
          a: 'A',
          b: -1,
          c: [
            0x0000, 0x1111, 0x2222, 0x3333, 0x4444,
            0x5555, 0x6666, 0x7777, 0x8888, 0x9999
          ]
        }
      end
      let(:data) do
        [hash[:a], hash[:b], *hash[:c]].pack(subject.pack_string)
      end

      it "must unpack multiple values and return a Hash of Arrays of values" do
        expect(subject.unpack(data)).to eq(hash)
      end
    end

    context "when the last value in #members is an FlexibleArrayType" do
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
      let(:data) do
        [hash[:a], hash[:b], *hash[:c]].pack(subject.pack_string)
      end

      it "must unpack multiple values and return a Hash of Arrays of values" do
        expect(subject.unpack(data)).to eq(hash)
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
        [
          hash[:a], hash[:b], hash[:c][:x], hash[:c][:y]
        ].pack(subject.pack_string)
      end

      it "must unpack multiple values and return a Hash of Hashes of values" do
        expect(subject.unpack(data)).to eq(hash)
      end
    end

    context "when one of the #members is another UnionType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::CTypes::CHAR,
          b: Ronin::Support::Binary::CTypes::INT8,
          c: Ronin::Support::Binary::CTypes::UnionType.build(
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
            x: 0,
            y: 0xffff
          }
        }
      end
      let(:data) { subject.pack(hash) }

      let(:unpacked_hash) do
        {
          a: 'A',
          b: -1,
          c: {
            x: -1,
            y: 0xffff
          }
        }
      end

      it "must unpack multiple values and return a Hash of Hashes of values" do
        expect(subject.unpack(data)).to eq(unpacked_hash)
      end
    end
  end

  describe "#enqueue_value" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1234,
        d: -2
      }
    end
    let(:values) { ['A', 'B'] }

    it "must push the values of the Hash to the given values" do
      subject.enqueue_value(values,hash)

      expect(values).to eq(['A', 'B', hash[:a], hash[:b], hash[:c], hash[:d]])
    end

    context "if some of the member fields are missing from the given hash" do
      let(:hash) do
        {
          a: 'A',
          c: 0x1122
        }
      end

      it "must enqueue #uninitialized_value values for the missing members" do
        subject.enqueue_value(values,hash)

        expect(values).to eq(
          [
            'A', 'B',
            hash[:a],
            subject.members[:b].type.uninitialized_value,
            hash[:c],
            subject.members[:d].type.uninitialized_value
          ]
        )
      end
    end

    context "but some of the member fields in the given hash are nil" do
      let(:hash) do
        {
          a: 'A',
          b: nil,
          c: 0x1122,
          d: nil
        }
      end

      it "must replace the nil values with #uninitialized_value from the missing member" do
        subject.enqueue_value(values,hash)

        expect(subject.pack(hash)).to eq(
          [
            hash[:a],
            subject.members[:b].type.uninitialized_value,
            hash[:c],
            subject.members[:d].type.uninitialized_value
          ].pack(subject.pack_string)
        )
      end
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

      let(:hash) do
        {
          a: 'A',
          b: -1,
          c: [
            0x0000, 0x1111, 0x2222, 0x3333, 0x4444,
            0x5555, 0x6666, 0x7777, 0x8888, 0x9999
          ]
        }
      end

      it "must push all values and Array elements to the given values" do
        subject.enqueue_value(values,hash)

        expect(values).to eq(['A', 'B', hash[:a], hash[:b], *hash[:c]])
      end
    end

    context "when the last value in #members is an FlexibleArrayType" do
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

      it "must push all values and Array elements to the given values" do
        subject.enqueue_value(values,hash)

        expect(values).to eq(['A', 'B', hash[:a], hash[:b], *hash[:c]])
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

      it "must recursively push the values of all Hashes to the given values" do
        subject.enqueue_value(values,hash)

        expect(values).to eq(
          ['A', 'B', hash[:a], hash[:b], hash[:c][:x], hash[:c][:y]]
        )
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
        }.to raise_error(ArgumentError,"unknown struct members: #{unknown_member1.inspect}, #{unknown_member2.inspect}")
      end
    end
  end

  describe "#dequeue_value" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1122,
        d: -2
      }
    end
    let(:values) do
      [hash[:a], hash[:b], hash[:c], hash[:d], 'A', 'B']
    end

    it "must shift the values for #members off of the given values" do
      expect(subject.dequeue_value(values)).to eq(hash)
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

      let(:hash) do
        {
          a: 'A',
          b: -1,
          c: [
            0x0000, 0x1111, 0x2222, 0x3333, 0x4444,
            0x5555, 0x6666, 0x7777, 0x8888, 0x9999
          ]
        }
      end
      let(:values) do
        [hash[:a], hash[:b], *hash[:c], 'A', 'B']
      end

      it "must return a Hash of values containing an Array of values" do
        expect(subject.dequeue_value(values)).to eq(hash)
      end
    end

    context "when the last value in #members is an FlexibleArrayType" do
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
      let(:values) do
        [hash[:a], hash[:b], *hash[:c]]
      end

      it "must return a Hash of values containing an Array of values" do
        expect(subject.dequeue_value(values)).to eq(hash)
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
      let(:values) do
        [hash[:a], hash[:b], hash[:c][:x], hash[:c][:y], 'A', 'B']
      end

      it "must return a Hash of values containing another Hashes of values" do
        expect(subject.dequeue_value(values)).to eq(hash)
      end
    end
  end

  include_examples "Type examples"
end
