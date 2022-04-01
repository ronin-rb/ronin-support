require 'spec_helper'
require 'ronin/support/binary/types/struct_type'
require 'ronin/support/binary/types'

require_relative 'type_examples'

describe Ronin::Support::Binary::Types::StructType do
  let(:members) do
    {
      a: Ronin::Support::Binary::Types::CHAR,
      b: Ronin::Support::Binary::Types::INT16,
      c: Ronin::Support::Binary::Types::UINT32
    }
  end

  subject { described_class.new(members) }

  describe "#initialize" do
    context "when given an empty Hash" do
      subject { described_class.new({}) }

      it "must set #members to {}" do
        expect(subject.members).to eq({})
      end

      it "must set #size to 0" do
        expect(subject.size).to eq(0)
      end

      it "must set #pack_string to ''" do
        expect(subject.pack_string).to eq('')
      end
    end

    context "when given a Hash of names and types" do
      subject { described_class.new(members) }

      it "must set #members to the given members" do
        expect(subject.members).to eq(members)
      end

      it "must set #size to the sum of the members type's sizes" do
        expect(subject.size).to eq(members.values.map(&:size).sum)
      end

      context "when all of the given types have a #pack_string" do
        it "must #pack_string to the combination of all type's #pack_string" do
          expect(subject.pack_string).to eq(
            members.values.map(&:pack_string).join
          )
        end
      end

      context "when one ofthe types does not have a #pack_string" do
        let(:members) do
          {
            a: Ronin::Support::Binary::Types::CHAR,
            b: Ronin::Support::Binary::Types::INT16,
            c: Ronin::Support::Binary::Types::UnboundedArrayType.new(
                 Ronin::Support::Binary::Types::INT32[3]
               )
          }
        end

        it "must set #pack_string to nil" do
          expect(subject.pack_string).to be(nil)
        end
      end

      context "when one of the fields is a Ronin::Support::Binary::Types::UnboundedArrayType" do
        let(:members) do
          {
            a: Ronin::Support::Binary::Types::CHAR,
            b: Ronin::Support::Binary::Types::INT16,
            c: Ronin::Support::Binary::Types::UINT32[]
          }
        end

        it "must set #size to Float::INFINITY" do
          expect(subject.size).to eq(Float::INFINITY)
        end
      end
    end
  end

  describe "#uninitialized_value" do
    it "must return a Hash of the members type's #uninitialized_value" do
      expect(subject.uninitialized_value).to eq(
        {
          a: members[:a].uninitialized_value,
          b: members[:b].uninitialized_value,
          c: members[:c].uninitialized_value
        }
      )
    end
  end

  describe "#length" do
    it "must return the number of values within #members" do
      expect(subject.length).to eq(members.length)
    end
  end

  describe "#pack" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1122
      }
    end

    it "must pack a hash of values using Array#pack and #pack_string" do
      expect(subject.pack(hash)).to eq(
        [hash[:a], hash[:b], hash[:c]].pack(subject.pack_string)
      )
    end

    context "when one of the #members is an AggregateType" do
      let(:array_length) { 10 }
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[array_length]
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

    context "when the last value in #members is an UnboundedArrayType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[]
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
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
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
            y: 0x11223344
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
  end

  describe "#unpack" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1122
      }
    end
    let(:data) do
      [hash[:a], hash[:b], hash[:c]].pack(subject.pack_string)
    end

    it "must unpack a Hash using String#unpack and #pack_string" do
      expect(subject.unpack(data)).to eq(hash)
    end

    context "when one of the #members is an AggregateType" do
      let(:array_length) { 10 }
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[array_length]
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

    context "when the last value in #members is an UnboundedArrayType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[]
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
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
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
            y: 0x11223344
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
  end

  describe "#enqueue_value" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1122
      }
    end
    let(:values) { ['A', 'B'] }

    it "must push the values of the Hash to the given values" do
      subject.enqueue_value(values,hash)

      expect(values).to eq(['A', 'B', hash[:a], hash[:b], hash[:c]])
    end

    context "when one of the #members is an AggregateType" do
      let(:array_length) { 10 }
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[array_length]
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

    context "when the last value in #members is an UnboundedArrayType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[]
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
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
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
            y: 0x11223344
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
  end

  describe "#dequeue_value" do
    let(:hash) do
      {
        a: 'A',
        b: -1,
        c: 0x1122
      }
    end
    let(:values) do
      [hash[:a], hash[:b], hash[:c], 'A', 'B']
    end

    it "must shift the values for #members off of the given values" do
      expect(subject.dequeue_value(values)).to eq(hash)
    end

    context "when one of the #members is an AggregateType" do
      let(:array_length) { 10 }
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[array_length]
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

    context "when the last value in #members is an UnboundedArrayType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::UINT32[]
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
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
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
            y: 0x11223344
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
