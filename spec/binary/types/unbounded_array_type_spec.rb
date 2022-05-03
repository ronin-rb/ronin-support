require 'spec_helper'
require 'ronin/support/binary/types/unbounded_array_type'
require 'ronin/support/binary/types/int32_type'
require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/struct_type'
require 'ronin/support/binary/types'

describe Ronin::Support::Binary::Types::UnboundedArrayType do
  let(:endian)      { :little }
  let(:pack_string) { 'L<'    }

  let(:type) do
    Ronin::Support::Binary::Types::Int32Type.new(
      endian:      endian,
      pack_string: pack_string
    )
  end

  subject { described_class.new(type) }

  describe "#initialize" do
    it "must set #type" do
      expect(subject.type).to eq(type)
    end

    context "when the given type is a ScalarType" do
      context "and when the given type also has a #pack_string" do
        it "must set #pack_string to '\#{type.pack_string}*'" do
          expect(subject.pack_string).to eq("#{type.pack_string}*")
        end
      end
    end

    context "when the given type is an AggregateType" do
      let(:length) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::Int32Type.new(
            endian:      endian,
            pack_string: pack_string
          ),
          length
        )
      end

      it "must set #pack_string to nil" do
        expect(subject.pack_string).to be(nil)
      end
    end

    context "when the given type is an UnboundedArrayType" do
      let(:type) do
        Ronin::Support::Binary::Types::UnboundedArrayType.new(super())
      end

      it do
        expect {
          described_class.new(type)
        }.to raise_error(ArgumentError,"cannot initialize a nested #{described_class}")
      end
    end
  end

  describe "#size" do
    it "must return Float::INFINITY" do
      expect(subject.size).to eq(Float::INFINITY)
    end
  end

  describe "#alignment" do
    it "must return the #type's #alignemnt" do
      expect(subject.alignment).to eq(type.alignment)
    end

    context "when initialized with the alignment: keyword"  do
      let(:new_alignment) { 3 }

      subject { described_class.new(type, alignment: new_alignment) }

      it "must return the initialized custom alignment" do
        expect(subject.alignment).to eq(new_alignment)
      end
    end
  end

  describe "#align" do
    let(:new_alignment) { 3 }

    let(:new_type) { subject.align(new_alignment) }

    it "must return the same kind of type" do
      expect(new_type).to be_kind_of(described_class)
    end

    it "must return a copy of the unbounded array type" do
      expect(new_type).to_not be(subject)
    end

    it "must preserve #type" do
      expect(new_type.type).to eq(subject.type)
    end

    it "must set #alignment to the new alignment" do
      expect(new_type.alignment).to eq(new_alignment)
    end
  end

  describe "#length" do
    it "must return Float::INFINITY" do
      expect(subject.length).to eq(Float::INFINITY)
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
    let(:values) { (1..10).to_a }

    it "must pack multiple values using Array#pack and #pack_string" do
      expect(subject.pack(values)).to eq(values.pack(subject.pack_string))
    end

    context "when initialized with an ArrayType" do
      let(:length) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::Int32Type.new(
            endian:      endian,
            pack_string: pack_string
          ),
          length
        )
      end

      let(:array) { [(0..9).to_a, (10..19).to_a] }

      it "must flatten then pack the multi-dimensional Array of values" do
        expect(subject.pack(array)).to eq(
          array.flatten.pack("#{pack_string}*")
        )
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 3  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::Int32Type.new(
              endian:      endian,
              pack_string: pack_string
            ),
            length2
          ),
          length1
        )
      end

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

      it "must flatten then pack the multi-dimensional Array of values" do
        expect(subject.pack(array)).to eq(
          array.flatten.pack("#{pack_string}*")
        )
      end
    end

    context "when initialized with a StringType" do
      let(:type) { Ronin::Support::Binary::Types::STRING }

      let(:array) do
        [
          "hello world",
          "foo",
          "bar",
          "baz",
          "quix"
        ]
      end

      it "must pack the given strings as a series of C strings" do
        expect(subject.pack(array)).to eq(
          "#{array[0]}\0#{array[1]}\0#{array[2]}\0#{array[3]}\0#{array[4]}\0"
        )
      end
    end

    context "when initialized with a StructType" do
      let(:type) do
        Ronin::Support::Binary::Types::StructType.build(
          {
            a: Ronin::Support::Binary::Types::CHAR,
            b: Ronin::Support::Binary::Types::INT16,
            c: Ronin::Support::Binary::Types::StructType.build(
                 {
                   x: Ronin::Support::Binary::Types::INT32,
                   y: Ronin::Support::Binary::Types::UINT32
                 }
               )
          }
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

      it "must pack the values of the Hashes in the Array" do
        expect(subject.pack(array)).to eq(
          [
            hash1[:a], hash1[:b], hash1[:c][:x], hash1[:c][:y],
            hash2[:a], hash2[:b], hash2[:c][:x], hash2[:c][:y],
            hash3[:a], hash3[:b], hash3[:c][:x], hash3[:c][:y]
          ].pack(type.pack_string * array.length)
        )
      end
    end
  end

  describe "#unpack" do
    let(:data) do
      [
        "\x01\x00\x00\x00",
        "\x02\x00\x00\x00",
        "\x03\x00\x00\x00",
        "\x04\x00\x00\x00",
        "\x05\x00\x00\x00",
        "\x06\x00\x00\x00",
        "\x07\x00\x00\x00",
        "\x08\x00\x00\x00",
        "\x09\x00\x00\x00",
        "\x0a\x00\x00\x00"
      ].join
    end

    it "must unpack multiple values using String#unpack and #pack_string" do
      expect(subject.unpack(data)).to eq(data.unpack(subject.pack_string))
    end

    context "when initialized with another ArrayType" do
      let(:length) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::Int32Type.new(
            endian:      endian,
            pack_string: pack_string
          ),
          length
        )
      end

      let(:array) { [(0..9).to_a, (10..19).to_a] }
      let(:data) do
        array.flatten.pack(type.pack_string * array.length)
      end

      it "must unpack multiple values and return a multi-dimensional Array" do
        expect(subject.unpack(data)).to eq(array)
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 3  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::Int32Type.new(
              endian:      endian,
              pack_string: pack_string
            ),
            length2
          ),
          length1
        )
      end

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

      let(:data) do
        array.flatten.pack(type.pack_string * array.length)
      end

      it "must unpack multiple values and return a multi-dimensional Array" do
        expect(subject.unpack(data)).to eq(array)
      end
    end

    context "when initialized with a StringType" do
      let(:type) { Ronin::Support::Binary::Types::STRING }

      let(:array) do
        [
          "hello world",
          "foo",
          "bar",
          "baz",
          "quix"
        ]
      end
      let(:data) { array.pack(type.pack_string * array.length) }

      it "must pack the given strings as a series of C strings" do
        expect(subject.unpack(data)).to eq(array)
      end
    end

    context "when initialized with a StructType" do
      let(:type) do
        Ronin::Support::Binary::Types::StructType.build(
          {
            a: Ronin::Support::Binary::Types::CHAR,
            b: Ronin::Support::Binary::Types::INT16,
            c: Ronin::Support::Binary::Types::StructType.build(
                 {
                    x: Ronin::Support::Binary::Types::INT32,
                    y: Ronin::Support::Binary::Types::UINT32
                 }
               )
          }
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
      let(:data) do
        values.pack(type.pack_string * array.length)
      end

      it "must unpack multiple values and return an Array of Hashes" do
        expect(subject.unpack(data)).to eq(array)
      end
    end
  end

  describe "#enqueue_value" do
    let(:array)  { (1..10).to_a }
    let(:values) { ['A', 'B']   }

    it "must concat the array onto the end of the given values" do
      subject.enqueue_value(values,array)

      expect(values).to eq(['A', 'B'] + array)
    end

    context "when initialized with an ArrayType" do
      let(:length) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::Int32Type.new(
            endian:      endian,
            pack_string: pack_string
          ),
          length
        )
      end

      let(:array) { [(0..9).to_a, (10..19).to_a] }

      it "must flatten then push the array onto the end of the given values" do
        subject.enqueue_value(values,array)

        expect(values).to eq(['A', 'B'] + array.flatten)
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 3  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::Int32Type.new(
              endian:      endian,
              pack_string: pack_string
            ),
            length2
          ),
          length1
        )
      end

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

      it "must flatten then push the array onto the end of the given values" do
        subject.enqueue_value(values,array)

        expect(values).to eq(['A', 'B'] + array.flatten)
      end
    end
  end

  describe "#dequeue_value" do
    let(:array)  { (1..10).to_a }
    let(:values) { [*array] }

    it "must shift #length number of values off of the given values" do
      expect(subject.dequeue_value(values)).to eq(array)
    end

    context "when initialized with an ArrayType" do
      let(:length) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::Int32Type.new(
            endian:      endian,
            pack_string: pack_string
          ),
          length
        )
      end

      let(:array)  { [(0..9).to_a, (10..19).to_a] }
      let(:values) { array.flatten }

      it "must return a multi-dimensional Array of values" do
        expect(subject.dequeue_value(values)).to eq(array)
      end
    end

    context "when initialized with an ArrayType of another ArrayType" do
      let(:length1) { 3  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::Types::ArrayType.new(
          Ronin::Support::Binary::Types::ArrayType.new(
            Ronin::Support::Binary::Types::Int32Type.new(
              endian:      endian,
              pack_string: pack_string
            ),
            length2
          ),
          length1
        )
      end

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
      let(:values) { array.flatten }

      it "must return a multi-dimensional Array of values" do
        expect(subject.dequeue_value(values)).to eq(array)
      end
    end
  end

  describe "#[]" do
    context "when a length argument is given" do
      it do
        expect {
          subject[42]
        }.to raise_error(ArgumentError,"cannot initialize an #{Ronin::Support::Binary::Types::ArrayType} of #{described_class}")
      end
    end

    context "when no argument is given" do
      it do
        expect {
          subject[]
        }.to raise_error(ArgumentError,"cannot initialize a nested #{described_class}")
      end
    end
  end
end
