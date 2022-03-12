require 'spec_helper'
require 'ronin/support/binary/types/type'

describe Ronin::Support::Binary::Types::Type do
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

  describe "#[]" do
    context "when a length argument is given" do
      let(:length) { 10 }

      it "must return an ArrayType" do
        expect(subject[length]).to be_kind_of(Ronin::Support::Binary::Types::ArrayType)
      end

      it "must have a #type of self" do
        expect(subject[length].type).to be(subject)
      end

      it "must have a #length of the length argument" do
        expect(subject[length].length).to be(length)
      end
    end

    context "when no argument is given" do
      it "must return an UnboundedArrayType" do
        expect(subject[]).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
      end

      it "must have a #type of self" do
        expect(subject[].type).to be(subject)
      end
    end
  end
end
