require 'spec_helper'
require 'ronin/support/binary/ctypes/enum_type'
require 'ronin/support/binary/ctypes'

require_relative 'type_examples'

describe Ronin::Support::Binary::CTypes::EnumType do
  it { expect(described_class).to be < Ronin::Support::Binary::CTypes::Type }

  let(:int_type) { Ronin::Support::Binary::CTypes::INT32 }
  let(:mapping) do
    {
      zero: 0,
      one:  1,
      two:  2
    }
  end

  subject { described_class.new(int_type,mapping) }

  describe "#initialize" do
    it "must set #int_type" do
      expect(subject.int_type).to be(int_type)
    end

    it "must set #mapping" do
      expect(subject.mapping).to eq(mapping)
    end

    it "must set #reverse_mapping based on #mapping" do
      expect(subject.reverse_mapping).to eq(mapping.invert)
    end
  end

  describe "#uninitialized_value" do
    it "must return the Symbol which maps to 0" do
      expect(subject.uninitialized_value).to eq(:zero)
    end

    context "when #mapping does not contain a Symbol that maps to 0" do
      let(:mapping) do
        {one: 1, two: 2}
      end

      it "must return 0" do
        expect(subject.uninitialized_value).to eq(0)
      end
    end
  end

  describe "#size" do
    it "must return #int_type's #size" do
      expect(subject.size).to eq(int_type.size)
    end
  end

  describe "#alignment" do
    it "must return #int_type's #alignment" do
      expect(subject.alignment).to eq(int_type.alignment)
    end
  end

  describe "#align" do
    let(:new_alignment) { 8 }
    let(:new_enum)      { subject.align(new_alignment) }

    it "must return a new #{described_class}" do
      expect(new_enum).to be_kind_of(described_class)
      expect(new_enum).to_not be(subject)
    end

    it "must also create a copy of #int_type with a different alignment" do
      expect(new_enum.int_type).to be_kind_of(int_type.class)
      expect(new_enum.int_type).to_not be(int_type)
      expect(new_enum.int_type.alignment).to eq(new_alignment)
    end

    it "must not change #mapping" do
      expect(new_enum.mapping).to eq(mapping)
    end
  end

  describe "#pack" do
    context "when given a Symbol" do
      context "and when the Symbol is in #mapping" do
        let(:symbol) { :two }

        it "must pack the integer value for the given Symbol" do
          expect(subject.pack(symbol)).to eq(int_type.pack(mapping[symbol]))
        end
      end

      context "but the Symbol is not in #mapping" do
        let(:symbol) { :xxx }

        it do
          expect {
            subject.pack(symbol)
          }.to raise_error(ArgumentError,"invalid enum value: #{symbol.inspect}")
        end
      end
    end

    context "when given an Integer" do
      let(:integer) { 42 }

      it "must pack the given Integer value" do
        expect(subject.pack(integer)).to eq(int_type.pack(integer))
      end
    end

    context "when given another kind of Object" do
      let(:value) { Object.new }

      it do
        expect {
          subject.pack(value)
        }.to raise_error(ArgumentError,"enum value must be a Symbol or an Integer: #{value.inspect}")
      end
    end
  end

  describe "#unpack" do
    context "when the packed value maps to an Integer in #reverse_mapping" do
      let(:symbol)  { :one }
      let(:integer) { mapping[symbol] }
      let(:data)    { int_type.pack(integer) }

      it "must return the associated Symbol value" do
        expect(subject.unpack(data)).to be(symbol)
      end
    end

    context "when the packed value does not map to an Integer in #reverse_mapping" do
      let(:integer) { 42 }
      let(:data)    { int_type.pack(integer) }

      it "must return the unpacked integer anyways" do
        expect(subject.unpack(data)).to eq(integer)
      end
    end
  end

  describe "#enqueue_value" do
    let(:values) { ['A', 'B'] }
    let(:value)  { :one }

    it "must call #int_type's #enqueue_value" do
      subject.enqueue_value(values,value)

      expect(values).to eq(['A', 'B', value])
    end
  end

  describe "#dequeue_value" do
    let(:value)  { :one }
    let(:values) { [value, 'A', 'B'] }

    it "must call #int_type's #enqueue_value" do
      expect(subject.dequeue_value(values)).to eq(value)
    end
  end

  include_examples "Type examples"
end
