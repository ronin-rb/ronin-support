require 'spec_helper'
require 'ronin/support/binary/array_buffer'

describe Ronin::Support::Binary::ArrayBuffer do
  let(:type)   { :uint32 }
  let(:length) { 10 }

  subject { described_class.new(type,length) }

  describe "#initialize" do
    it "must set #type by looking up the type in #type_system" do
      expect(subject.type).to be(subject.type_system[type])
    end

    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    context "when the endian: keyword argument is given" do
      let(:endian) { :little }

      subject { described_class.new(type,length, endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to be(endian)
      end

      it "must set #type_system to the Ronin::Support::Binary::Types:: module" do
        expect(subject.type_system).to be(Ronin::Support::Binary::Types.endian(endian))
      end
    end

    it "must default #arch to nil" do
      expect(subject.arch).to be(nil)
    end

    context "when the arch: keyword argument is given" do
      let(:arch) { :x86 }

      subject { described_class.new(type,length, arch: arch) }

      it "must set #arch" do
        expect(subject.arch).to be(arch)
      end

      it "must set #type_system to the Ronin::Support::Binary::Types::Arch:: module" do
        expect(subject.type_system).to be(Ronin::Support::Binary::Types::Arch[arch])
      end
    end

    it "must default #type_system to Ronin::Support::Binary::Types" do
      expect(subject.type_system).to be(Ronin::Support::Binary::Types)
    end

    context "when an Integer argument is given instead of a String argument" do
      subject { described_class.new(type,length) }

      it "must set #length" do
        expect(subject.length).to eq(length)
      end

      it "must initialize #string with Encoding::ASCII_8BIT" do
        expect(subject.string.encoding).to be(Encoding::ASCII_8BIT)
      end

      it "must initialize #string to length of #size" do
        expect(subject.string.bytesize).to eq(subject.size)
      end

      it "must initialize #string to all null-bytes" do
        expect(subject.string).to eq("\0" * subject.size)
      end

      context "and the type is a multi-byte type" do
        let(:type) { :uint32_le }

        it "must set #size to #length * #type.size" do
          expect(subject.size).to eq(length * subject.type.size)
        end
      end
    end

    context "when a String argument is given instead of a length argument" do
      let(:string) { "A" * length }

      subject { described_class.new(type,string) }

      it "must set #string to the given string value" do
        expect(subject.string).to be(string)
      end

      it "must set #size to the string's byte size" do
        expect(subject.size).to eq(string.bytesize)
      end

      it "must calculate #length by dividing #size by #type.size" do
        expect(subject.length).to eq(subject.size / subject.type.size)
      end

      context "and when a type argument is given" do
        let(:type_name) { :uint32_le }
        let(:type)      { Ronin::Support::Binary::Types[type_name] }

        subject { described_class.new(type_name,string) }

        it "must set #type" do
          expect(subject.type).to eq(type)
        end

        it "must set #length to string.bytesize / type.size" do
          expect(subject.length).to eq(string.bytesize / type.size)
        end
      end
    end

    context "when not given a length or a string argument" do
      let(:arg) { :foo }

      it do
        expect {
          described_class.new(type,arg)
        }.to raise_error(ArgumentError,"string_or_length argument must be either a length (Integer) or a buffer (String): #{arg.inspect}")
      end
    end
  end

  describe "#size" do
    it "must return #type.size * #length" do
      expect(subject.size).to eq(subject.type.size * subject.length)
    end
  end

  describe "#[]" do
    context "when the index has not been previously written to" do
      context "and when #type is a single-byte type" do
        let(:type) { :byte }

        it "must decode a 0 value" do
          expect(subject[1]).to eq(0)
        end
      end

      context "and when #type is a multi-byte type" do
        let(:type) { :uint32_le }

        subject { described_class.new(type,length) }

        it "must decode a 0 value" do
          expect(subject[1]).to eq(0)
        end
      end
    end

    context "when the index has been previously written to" do
      let(:index) { 1  }
      let(:value) { 42 }

      before { subject[index] = value }

      context "and when #type is a single-byte type" do
        let(:type) { :byte }

        it "must decode the previously written value" do
          expect(subject[index]).to eq(value)
        end
      end

      context "and when #type is a multi-byte type" do
        let(:type)  { :uint32_le }
        let(:value) { 0x11223344 }

        subject { described_class.new(type,length) }

        it "must decode the previously written multi-byte value" do
          expect(subject[index]).to eq(value)
        end
      end
    end

    context "when the index is less than 0" do
      let(:index) { -1 }

      it do
        expect {
          subject[index]
        }.to raise_error(IndexError,"index #{index} is out of bounds: 0...#{subject.length}")
      end
    end

    context "when the index is greater or equal to the length of the buffer" do
      let(:index) { subject.length }

      it do
        expect {
          subject[index]
        }.to raise_error(IndexError,"index #{index} is out of bounds: 0...#{subject.length}")
      end
    end
  end

  describe "#[]=" do
    let(:index) { 1    }
    let(:value) { 0x41 }

    context "and when #type is a single-byte type" do
      let(:type) { :byte }

      it "must write the byte value to the given index within #string" do
        subject[index] = value

        expect(subject.string[index]).to eq(value.chr)
      end
    end

    context "and when #type is a multi-byte type" do
      let(:type)  { :uint32_le }
      let(:value) { 0x11223344 }

      subject { described_class.new(type,length) }

      before { subject[index] = value }

      it "must write the multi-byte value to the given index within #string" do
        offset = index*subject.type.size
        size   = subject.type.size

        packed_value = subject.type.pack(value)

        expect(subject.string[offset,size]).to eq(packed_value)
      end
    end

    context "when the index is less than 0" do
      let(:index) { -1 }

      it do
        expect {
          subject[index] = value
        }.to raise_error(IndexError,"index #{index} is out of bounds: 0...#{subject.length}")
      end
    end

    context "when the index is greater or equal to the length of the buffer" do
      let(:index) { subject.length }

      it do
        expect {
          subject[index] = value
        }.to raise_error(IndexError,"index #{index} is out of bounds: 0...#{subject.length}")
      end
    end
  end

  describe "#each" do
    let(:type)   { :int32 }
    let(:values) { [1, 2, 0x11111111, -1] }
    let(:length) { values.length          }

    before do
      values.each_with_index do |value,index|
        subject[index] = value
      end
    end

    context "when a block is given" do
      it "must enumerate over every value in the Array buffer" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*values)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for the #each method" do
        expect(subject.each.to_a).to eq(values)
      end
    end
  end

  describe "#to_s" do
    it "must return #string" do
      expect(subject.to_s).to be(subject.string)
    end
  end

  describe "#to_str" do
    it "must return #string" do
      expect(subject.to_str).to be(subject.string)
    end
  end

  describe "#inspect" do
    it "must return the class name and the buffer string" do
      expect(subject.inspect).to eq("<#{described_class}: #{subject.string.inspect}>")
    end
  end
end
