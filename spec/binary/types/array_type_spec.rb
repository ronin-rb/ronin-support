require 'spec_helper'
require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/scalar_type'
require 'ronin/support/binary/types/struct_type'
require 'ronin/support/binary/types'

require_relative 'type_examples'

describe Ronin::Support::Binary::Types::ArrayType do
  let(:size)        { 4       }
  let(:endian)      { :little }
  let(:signed)      { true    }
  let(:pack_string) { 'L<'    }

  let(:type) do
    Ronin::Support::Binary::Types::ScalarType.new(
      size:        size,
      endian:      endian,
      signed:      signed,
      pack_string: pack_string
    )
  end

  let(:length) { 10 }
  subject { described_class.new(type,length) }

  describe "#initialize" do
    it "must set #type" do
      expect(subject.type).to eq(type)
    end

    it "must set #length" do
      expect(subject.length).to eq(length)
    end

    it "must set #size as #type.size * length" do
      expect(subject.size).to eq(type.size * length)
    end

    context "when the given type has a #pack_string" do
      it "must set #pack_string to type.pack_string * length'" do
        expect(subject.pack_string).to eq(type.pack_string * length)
      end
    end
  end

  describe "#uninitialized_value" do
    it "must return an Array of #length of #type.uninitialized_value" do
      expect(subject.uninitialized_value).to eq(
        Array.new(length) { type.uninitialized_value }
      )
    end
  end

  describe "#endian" do
    it "must return #type.endian" do
      expect(subject.endian).to eq(type.endian)
    end
  end

  describe "#signed?" do
    it "must return #type.signed?" do
      expect(subject.signed?).to eq(type.signed?)
    end
  end

  describe "#unsigned?" do
    it "must return #type.unsigned?" do
      expect(subject.unsigned?).to eq(type.unsigned?)
    end
  end

  describe "#pack" do
    let(:array) { (1..10).to_a }

    it "must pack multiple values using Array#pack and #pack_string" do
      expect(subject.pack(array)).to eq(array.pack(subject.pack_string))
    end

    context "when given a multi-dimensional Array of values" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ScalarType.new(
            size:        size,
            endian:      endian,
            signed:      signed,
            pack_string: pack_string
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array) { [(0..9).to_a, (10..19).to_a] }

      it "must flatten then pack the multi-dimensional Array of values" do
        expect(subject.pack(array)).to eq(
          array.flatten.pack(subject.pack_string)
        )
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 3  }
      let(:length3) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::ScalarType.new(
              size:        size,
              endian:      endian,
              signed:      signed,
              pack_string: pack_string
            ),
            length3
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array) do
        [
          [
            (0..9).to_a,
            (10..19).to_a,
            (20..29).to_a
          ],

          [
            (30..39).to_a,
            (40..49).to_a,
            (50..59).to_a
          ]
        ]
      end

      it "must flatten then pack the multi-dimensional Array" do
        expect(subject.pack(array)).to eq(
          array.flatten.pack(subject.pack_string)
        )
      end
    end

    context "when initialized with a StructType" do
      let(:type) do
        Ronin::Support::Binary::Types::StructType.new(
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
            }
          )
        )
      end

      let(:hash1) do
        {
          a: 'A',
          b: -1,
          c: {
            x: -2,
            y: 0x11223344
          }
        }
      end

      let(:hash2) do
        {
          a: 'B',
          b: -2,
          c: {
            x: -3,
            y: 0x55667788
          }
        }
      end

      let(:hash3) do
        {
          a: 'C',
          b: -3,
          c: {
            x: -4,
            y: 0xAAFFBBCC
          }
        }
      end

      let(:length) { 3 }
      let(:array)  { [hash1, hash2, hash3] }

      it "must unpack multiple values and return an Array of Hashes" do
        expect(subject.pack(array)).to eq(
          [
            hash1[:a], hash1[:b], hash1[:c][:x], hash1[:c][:y],
            hash2[:a], hash2[:b], hash2[:c][:x], hash2[:c][:y],
            hash3[:a], hash3[:b], hash3[:c][:x], hash3[:c][:y]
          ].pack(subject.pack_string)
        )
      end
    end
  end

  describe "#unpack" do
    let(:array) { (1..10).to_a }
    let(:data)  { array.pack(subject.pack_string) }

    it "must unpack multiple values using String#unpack and #pack_string" do
      expect(subject.unpack(data)).to eq(data.unpack(subject.pack_string))
    end

    context "when initialized with another ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ScalarType.new(
            size:        size,
            endian:      endian,
            signed:      signed,
            pack_string: pack_string
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array) { [(0..9).to_a, (10..19).to_a] }
      let(:data)  { array.flatten.pack(subject.pack_string) }

      it "must unpack multiple values and return a multi-dimensional Array" do
        expect(subject.unpack(data)).to eq(array)
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 2 }
      let(:length2) { 3  }
      let(:length3) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::ScalarType.new(
              size:        size,
              endian:      endian,
              signed:      signed,
              pack_string: pack_string
            ),
            length3
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array) do
        [
          [
            (0..9).to_a,
            (10..19).to_a,
            (20..29).to_a
          ],

          [
            (30..39).to_a,
            (40..49).to_a,
            (50..59).to_a
          ]
        ]
      end
      let(:data) { array.flatten.pack(subject.pack_string) }

      it "must unpack multiple values and return a multi-dimensional Array" do
        expect(subject.unpack(data)).to eq(array)
      end
    end

    context "when initialized with a StructType" do
      let(:type) do
        Ronin::Support::Binary::Types::StructType.new(
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
            }
          )
        )
      end

      let(:hash1) do
        {
          a: 'A',
          b: -1,
          c: {
            x: -2,
            y: 0x11223344
          }
        }
      end

      let(:hash2) do
        {
          a: 'B',
          b: -2,
          c: {
            x: -3,
            y: 0x55667788
          }
        }
      end

      let(:hash3) do
        {
          a: 'C',
          b: -3,
          c: {
            x: -4,
            y: 0xAAFFBBCC
          }
        }
      end

      let(:length) { 3 }
      let(:array)  { [hash1, hash2, hash3] }

      let(:values) do
        [
          hash1[:a], hash1[:b], hash1[:c][:x], hash1[:c][:y],
          hash2[:a], hash2[:b], hash2[:c][:x], hash2[:c][:y],
          hash3[:a], hash3[:b], hash3[:c][:x], hash3[:c][:y]
        ]
      end
      let(:data) { values.pack(subject.pack_string) }

      it "must unpack multiple values and return an Array of Hashes" do
        expect(subject.unpack(data)).to eq(array)
      end
    end
  end

  describe "#enqueue_value" do
    let(:array)  { (1..10).to_a }
    let(:values) { ['A', 'B'] }

    it "must concat the array onto the given values" do
      subject.enqueue_value(values,array)

      expect(values).to eq(['A', 'B'] + array)
    end

    context "when initialized with an ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ScalarType.new(
            size:        size,
            endian:      endian,
            signed:      signed,
            pack_string: pack_string
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array) { [(0..9).to_a, (10..19).to_a] }

      it "must recursively push the array onto the given values" do
        subject.enqueue_value(values,array)

        expect(values).to eq(['A', 'B'] + array.flatten)
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 3  }
      let(:length3) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::ScalarType.new(
              size:        size,
              endian:      endian,
              signed:      signed,
              pack_string: pack_string
            ),
            length3
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array) do
        [
          [
            (0..9).to_a,
            (10..19).to_a,
            (20..29).to_a
          ],

          [
            (30..39).to_a,
            (40..49).to_a,
            (50..59).to_a
          ]
        ]
      end

      it "must recursively push the array onto the given values" do
        subject.enqueue_value(values,array)

        expect(values).to eq(['A', 'B'] + array.flatten)
      end
    end

    context "when initialized with a StructType" do
      let(:type) do
        Ronin::Support::Binary::Types::StructType.new(
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
            }
          )
        )
      end

      let(:hash1) do
        {
          a: 'A',
          b: -1,
          c: {
            x: -2,
            y: 0x11223344
          }
        }
      end

      let(:hash2) do
        {
          a: 'B',
          b: -2,
          c: {
            x: -3,
            y: 0x55667788
          }
        }
      end

      let(:hash3) do
        {
          a: 'C',
          b: -3,
          c: {
            x: -4,
            y: 0xAAFFBBCC
          }
        }
      end

      let(:length) { 3 }
      let(:array)  { [hash1, hash2, hash3] }

      it "must recursively push the values from the Array of Hashes onto the given values" do
        subject.enqueue_value(values,array)

        expect(values).to eq(
          [
            'A', 'B',
            hash1[:a], hash1[:b], hash1[:c][:x], hash1[:c][:y],
            hash2[:a], hash2[:b], hash2[:c][:x], hash2[:c][:y],
            hash3[:a], hash3[:b], hash3[:c][:x], hash3[:c][:y]
          ]
        )
      end
    end
  end

  describe "#dequeue_value" do
    let(:array)  { (1..10).to_a }
    let(:values) { [*array, 'A', 'B'] }

    it "must shift #length number of values off of the given values" do
      expect(subject.dequeue_value(values)).to eq(array)
    end

    context "when initialized with an ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ScalarType.new(
            size:        size,
            endian:      endian,
            signed:      signed,
            pack_string: pack_string
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array)  { [(0..9).to_a, (10..19).to_a] }
      let(:values) { [*array.flatten, 'A', 'B'] }

      it "must return a multi-dimensional Array of values" do
        expect(subject.dequeue_value(values)).to eq(array)
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 3  }
      let(:length3) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::ScalarType.new(
              size:        size,
              endian:      endian,
              signed:      signed,
              pack_string: pack_string
            ),
            length3
          ),
          length2
        )
      end

      subject { described_class.new(type,length1) }

      let(:array) do
        [
          [
            (0..9).to_a,
            (10..19).to_a,
            (20..29).to_a
          ],

          [
            (30..39).to_a,
            (40..49).to_a,
            (50..59).to_a
          ]
        ]
      end
      let(:values) { [*array.flatten, 'A', 'B'] }

      it "must return a multi-dimensional Array of values" do
        expect(subject.dequeue_value(values)).to eq(array)
      end
    end

    context "when initialized with a StructType" do
      let(:type) do
        Ronin::Support::Binary::Types::StructType.new(
          a: Ronin::Support::Binary::Types::CHAR,
          b: Ronin::Support::Binary::Types::INT16,
          c: Ronin::Support::Binary::Types::StructType.new(
            {
              x: Ronin::Support::Binary::Types::INT32,
              y: Ronin::Support::Binary::Types::UINT32
            }
          )
        )
      end

      let(:hash1) do
        {
          a: 'A',
          b: -1,
          c: {
            x: -2,
            y: 0x11223344
          }
        }
      end

      let(:hash2) do
        {
          a: 'B',
          b: -2,
          c: {
            x: -3,
            y: 0x55667788
          }
        }
      end

      let(:hash3) do
        {
          a: 'C',
          b: -3,
          c: {
            x: -4,
            y: 0xAAFFBBCC
          }
        }
      end

      let(:length) { 3 }
      let(:array)  { [hash1, hash2, hash3] }

      let(:values) do
        [
            hash1[:a], hash1[:b], hash1[:c][:x], hash1[:c][:y],
            hash2[:a], hash2[:b], hash2[:c][:x], hash2[:c][:y],
            hash3[:a], hash3[:b], hash3[:c][:x], hash3[:c][:y],
            'A', 'B'
        ]
      end

      it "must return an Array of Hashes of values" do
        expect(subject.dequeue_value(values)).to eq(array)
      end
    end
  end

  include_examples "Type examples"
end
