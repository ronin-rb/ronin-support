require 'spec_helper'
require 'ronin/support/binary/ctypes/array_type'
require 'ronin/support/binary/ctypes/int32_type'
require 'ronin/support/binary/ctypes/struct_type'
require 'ronin/support/binary/ctypes'

require_relative 'type_examples'

describe Ronin::Support::Binary::CTypes::ArrayType do
  let(:endian)      { :little }
  let(:pack_string) { 'L<'    }

  let(:type) do
    Ronin::Support::Binary::CTypes::Int32Type.new(
      endian:      endian,
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

    context "when the given type is an UnboundedArrayType" do
      let(:type) do
        Ronin::Support::Binary::CTypes::UnboundedArrayType.new(super())
      end

      it do
        expect {
          described_class.new(type,length)
        }.to raise_error(ArgumentError,"cannot initialize an #{described_class} of #{type.class}")
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

  describe "#alignment" do
    it "must return the #type's #alignemnt" do
      expect(subject.alignment).to eq(type.alignment)
    end

    context "when initialized with the alignment: keyword"  do
      let(:new_alignment) { 3 }

      subject { described_class.new(type,length, alignment: new_alignment) }

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

    it "must return a copy of the array type" do
      expect(new_type).to_not be(subject)
    end

    it "must preserve #type" do
      expect(new_type.type).to eq(subject.type)
    end

    it "must preserve #length" do
      expect(new_type.length).to eq(subject.length)
    end

    it "must set #alignment to the new alignment" do
      expect(new_type.alignment).to eq(new_alignment)
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

    context "but the array has fewer elements than #length" do
      let(:partial_array) { (1..5).to_a }
      let(:array) do
        partial_array + Array.new(5,type.uninitialized_value)
      end
      
      it "must pad the array with uninitialized values from #type" do
        padding = subject.length - array.length

        expect(subject.pack(partial_array)).to eq(
          array.pack(subject.pack_string)
        )
      end
    end

    context "but the array contains nil elements" do
      let(:array_with_nils) { [1, nil, 3, nil, 5, nil, 7, nil, 9, nil] }
      let(:array) do
        array_with_nils.map do |value| 
          value || type.uninitialized_value
        end
      end
      
      it "must replace the nil values with uninitialized values from #type" do
        expect(subject.pack(array_with_nils)).to eq(
          array.pack(subject.pack_string)
        )
      end
    end

    context "when given a multi-dimensional Array of values" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::Int32Type.new(
            endian:      endian,
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
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::ArrayType.new(
            Ronin::Support::Binary::CTypes::Int32Type.new(
              endian:      endian,
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

    context "when initialized with a StringType" do
      let(:type) { Ronin::Support::Binary::CTypes::STRING }

      let(:length) { 5 }
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
        Ronin::Support::Binary::CTypes::StructType.build(
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT16,
            c: Ronin::Support::Binary::CTypes::StructType.build(
                 {
                   x: Ronin::Support::Binary::CTypes::INT32,
                   y: Ronin::Support::Binary::CTypes::UINT32
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
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::Int32Type.new(
            endian:      endian,
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
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::ArrayType.new(
            Ronin::Support::Binary::CTypes::Int32Type.new(
              endian:      endian,
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

    context "when initialized with a StringType" do
      let(:type) { Ronin::Support::Binary::CTypes::STRING }

      let(:length) { 5 }
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

      it "must unpack the given strings as a series of C strings" do
        expect(subject.unpack(data)).to eq(array)
      end
    end

    context "when initialized with a StructType" do
      let(:type) do
        Ronin::Support::Binary::CTypes::StructType.build(
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT16,
            c: Ronin::Support::Binary::CTypes::StructType.build(
                 {
                   x: Ronin::Support::Binary::CTypes::INT32,
                   y: Ronin::Support::Binary::CTypes::UINT32
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

    context "but the array has fewer elements than #length" do
      let(:partial_array) { (1..5).to_a }
      let(:array) do
        partial_array + Array.new(5,type.uninitialized_value)
      end
      
      it "must pad the array with uninitialized values from #type" do
        subject.enqueue_value(values,partial_array)

        expect(values).to eq(['A', 'B'] + array)
      end
    end

    context "but the array contains nil elements" do
      let(:array_with_nils) { [1, nil, 3, nil, 5, nil, 7, nil, 9, nil] }
      let(:array) do
        array_with_nils.map do |value| 
          value || type.uninitialized_value
        end
      end
      
      it "must replace the nil values with uninitialized values from #type" do
        subject.enqueue_value(values,array_with_nils)

        expect(values).to eq(['A', 'B'] + array)
      end
    end

    context "when initialized with an ArrayType" do
      let(:length1) { 2  }
      let(:length2) { 10 }
      let(:type) do
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::Int32Type.new(
            endian:      endian,
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
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::ArrayType.new(
            Ronin::Support::Binary::CTypes::Int32Type.new(
              endian:      endian,
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
        Ronin::Support::Binary::CTypes::StructType.build(
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT16,
            c: Ronin::Support::Binary::CTypes::StructType.build(
                 {
                   x: Ronin::Support::Binary::CTypes::INT32,
                   y: Ronin::Support::Binary::CTypes::UINT32
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
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::Int32Type.new(
            endian:      endian,
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
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::ArrayType.new(
            Ronin::Support::Binary::CTypes::Int32Type.new(
              endian:      endian,
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
        Ronin::Support::Binary::CTypes::StructType.build(
          {
            a: Ronin::Support::Binary::CTypes::CHAR,
            b: Ronin::Support::Binary::CTypes::INT16,
            c: Ronin::Support::Binary::CTypes::StructType.build(
                 {
                   x: Ronin::Support::Binary::CTypes::INT32,
                   y: Ronin::Support::Binary::CTypes::UINT32
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
