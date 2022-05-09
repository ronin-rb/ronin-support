require 'spec_helper'
require 'ronin/support/binary/ctypes/scalar_type'

require_relative 'type_examples'
require_relative 'scalar_type_examples'

describe Ronin::Support::Binary::CTypes::ScalarType do
  let(:size)        { 4       }
  let(:endian)      { :little }
  let(:signed)      { true    }
  let(:pack_string) { 'L<'    }

  subject do
    described_class.new(
      size:        size,
      endian:      endian,
      signed:      signed,
      pack_string: pack_string
    )
  end

  describe "#initialize" do
    it "must set #size" do
      expect(subject.size).to eq(size)
    end

    it "must default #alignment to #size" do
      expect(subject.alignment).to eq(subject.size)
    end

    it "must set #endian" do
      expect(subject.endian).to eq(endian)
    end

    it "must set #signed" do
      expect(subject.signed).to eq(signed)
    end

    it "must set #pack_string" do
      expect(subject.pack_string).to eq(pack_string)
    end

    context "when the size: keyword is not given" do
      it do
        expect {
          described_class.new(
            endian: endian,
            signed: signed,
            pack_string: pack_string
          )
        }.to raise_error(ArgumentError)
      end
    end

    context "when the alignment: keyword is given" do
      let(:alignment) { 8 }

      subject do
        described_class.new(
          size:        size,
          alignment:   alignment,
          endian:      endian,
          signed:      signed,
          pack_string: pack_string
        )
      end

      it "must set #alignment" do
        expect(subject.alignment).to eq(alignment)
      end
    end

    context "when the endian: keyword is not given" do
      it do
        expect {
          described_class.new(
            size:   size,
            signed: signed,
            pack_string: pack_string
          )
        }.to raise_error(ArgumentError)
      end
    end

    context "when the signed: keyword is not given" do
      it do
        expect {
          described_class.new(
            size:   size,
            endian: endian,
            pack_string: pack_string
          )
        }.to raise_error(ArgumentError)
      end
    end

    context "when the pack_string: keyword is not given" do
      it do
        expect {
          described_class.new(
            size:   size,
            endian: endian,
            signed: signed,
          )
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#signed?" do
    context "when initialized with `signed: true`" do
      let(:signed) { true }

      it "must return true" do
        expect(subject.signed?).to be(true)
      end
    end

    context "when initialized with `signed: false`" do
      let(:signed) { false }

      it "must return false" do
        expect(subject.signed?).to be(false)
      end
    end
  end

  describe "#unsigned??" do
    context "when initialized with `signed: true`" do
      let(:signed) { true }

      it "must return false" do
        expect(subject.unsigned?).to be(false)
      end
    end

    context "when initialized with `signed: false`" do
      let(:signed) { false }

      it "must return true" do
        expect(subject.unsigned?).to be(true)
      end
    end
  end

  include_examples "Ronin::Support::Binary::CTypes::ScalarType examples"

  describe "#pack" do
    let(:value) { 0x11223344 }

    it "must pack the value using Array#pack and the #pack_string" do
      expect(subject.pack(value)).to eq([value].pack(subject.pack_string))
    end
  end

  describe "#unpack" do
    let(:data) { "\x44\x33\x22\x11" }

    it "must unpack the value using String#unpack1 and the #pack_string" do
      expect(subject.unpack(data)).to eq(data.unpack1(subject.pack_string))
    end
  end

  describe "#enqueue_value" do
    context "when the given values array is empty" do
      let(:values) { [] }
      let(:value)  { 42 }

      it "must add the given value to the given values array" do
        subject.enqueue_value(values,value)

        expect(values.first).to eq(value)
      end
    end

    context "when the given values array is not empty" do
      let(:values) { [1,2,3] }
      let(:value)  { 42      }

      it "must append the given value to the end of the given values array" do
        subject.enqueue_value(values,value)

        expect(values.last).to eq(value)
      end
    end
  end

  describe "#dequeue_value" do
    let(:value)  { 42 }
    let(:values) { [value,1,2,3] }

    it "must shift a single value off of the front of the given values array" do
      expect(subject.dequeue_value(values)).to eq(value)

      expect(values.first).to_not eq(value)
    end
  end

  include_examples "Type examples"
end
