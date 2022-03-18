require 'spec_helper'
require 'ronin/support/binary/types/struct_type'
require 'ronin/support/binary/types'

describe Ronin::Support::Binary::Types::StructType do
  let(:members) do
    {
      a: Ronin::Support::Binary::Types::Char,
      b: Ronin::Support::Binary::Types::Int16,
      c: Ronin::Support::Binary::Types::UInt32
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

      it "must set #size to the sum of the type's sizes" do
        expect(subject.size).to eq(members.values.map(&:size).sum)
      end

      it "must #pack_string to the combination of all type's #pack_string" do
        expect(subject.pack_string).to eq(
          members.values.map(&:pack_string).join
        )
      end

      context "when one of the fields is a Ronin::Support::Binary::Types::UnboundedArrayType" do
        let(:members) do
          {
            a: Ronin::Support::Binary::Types::Char,
            b: Ronin::Support::Binary::Types::Int16,
            c: Ronin::Support::Binary::Types::UInt32[]
          }
        end

        it "must set #size to Float::INFINITY" do
          expect(subject.size).to eq(Float::INFINITY)
        end
      end
    end
  end

  describe "#initialize_value" do
    it "must return a Hash of the struct's type's #initialize_value" do
      expect(subject.initialize_value).to eq(
        {
          a: members[:a].initialize_value,
          b: members[:b].initialize_value,
          c: members[:c].initialize_value
        }
      )
    end
  end

  describe "#length" do
    it "must return the number of values within #members" do
      expect(subject.length).to eq(members.length)
    end
  end

  describe "#total_length" do
    context "when none of the #members are AggregateTypes" do
      it "must return #length" do
        expect(subject.total_length).to eq(subject.length)
      end
    end

    context "when one of the #members is an AggregateType" do
      let(:array_length) { 10 }
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::Char,
          b: Ronin::Support::Binary::Types::Int16,
          c: Ronin::Support::Binary::Types::UInt32[array_length]
        }
      end

      it "must add the AggregateType's #total_length to the count of members" do
        expect(subject.total_length).to eq(
          1 + 1 + members[:c].total_length
        )
      end
    end

    context "when one of the #members is an UnboundedArrayType" do
      let(:members) do
        {
          a: Ronin::Support::Binary::Types::Char,
          b: Ronin::Support::Binary::Types::Int16,
          c: Ronin::Support::Binary::Types::UInt32[]
        }
      end

      it "must return Float::INFINITY" do
        expect(subject.total_length).to eq(Float::INFINITY)
      end
    end
  end
end
