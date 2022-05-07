require 'spec_helper'
require 'ronin/support/binary/memory'

describe Ronin::Support::Binary::Memory do
  let(:size) { 10 }

  describe "#initialize" do
    subject { described_class.new(size) }

    context "when an Integer argument is given instead of a String argument" do
      subject { described_class.new(size) }

      it "must set #size" do
        expect(subject.size).to eq(size)
      end

      it "must initialize #string with Encoding::ASCII_8BIT" do
        expect(subject.string.encoding).to be(Encoding::ASCII_8BIT)
      end

      it "must initialize #string to the given size" do
        expect(subject.string.bytesize).to eq(size)
      end

      it "must initialize #string to all null-bytes" do
        expect(subject.string).to eq("\0" * size)
      end
    end

    context "when a String argument is given instead of a size argument" do
      let(:string) { "A" * size }

      subject { described_class.new(string) }

      it "must set #string to the given string value" do
        expect(subject.string).to be(string)
      end

      it "must set #size to the string's byte size" do
        expect(subject.size).to eq(string.bytesize)
      end
    end

    context "when a Ronin::Support::Binary::ByteSlice is given instead of a String" do
      let(:offset) { 4 }
      let(:length) { 10 }
      let(:string) { ('A' * offset) + ("B" * length) + ('C' * offset) }

      let(:byte_slice) do
        Ronin::Support::Binary::ByteSlice.new(string, offset: offset,
                                                      length: length)
      end

      subject { described_class.new(byte_slice) }

      it "must set #string to the ByteSlice object" do
        expect(subject.string).to be(byte_slice)
      end

      it "must set #size to the ByteSlice's size in bytes" do
        expect(subject.size).to eq(byte_slice.bytesize)
      end
    end

    context "when not given a size or a string argument" do
      let(:arg) { :foo }

      it do
        expect {
          described_class.new(arg)
        }.to raise_error(ArgumentError,"first argument must be either a size (Integer) or a buffer (String): #{arg.inspect}")
      end
    end
  end

  let(:string) { "foo bar baz" }

  subject { described_class.new(string) }

  describe "#[]" do
    context "when a single Integer is given" do
      let(:index) { 1 }

      it "must return the character at the given index" do
        expect(subject[index]).to eq(string[index])
      end
    end

    context "and when an index Integer and a length Integer is given" do
      let(:index)  { 1 }
      let(:length) { 3 }

      it "must return the substring of length starting at the given index" do
        expect(subject[index,length]).to eq(string[index,length])
      end
    end

    context "and when an Integer and a length of Float::INFINITY is given" do
      let(:index) { 1 }
      let(:count) { Float::INFINITY }

      it "must return the substring starting at the index to the end of the string" do
        expect(subject[index,count]).to eq(string[index,subject.size-index])
      end

      context "but when the underlying string has grown in length" do
        let(:new_string) { " AAAA" }

        it "must return the substring starting at the index to the end of the underlying string" do
          expect(subject[index,count]).to eq(string[index,subject.size-index])

          string << new_string

          expect(subject[index,count]).to eq(string[index,string.bytesize-index])
        end
      end
    end

    context "when given a Range" do
      let(:range) { 1..3 }

      it "must return the substring between the given indexes" do
        expect(subject[range]).to eq(string[range])
      end
    end
  end

  describe "#[]=" do
    context "when a single Integer is given" do
      let(:index) { 1 }

      context "and a character value" do
        let(:value) { 0x41.chr }

        before { subject[index] = value }

        it "must write the character value to the given index within #string" do
          expect(subject.string[index]).to eq(value)
        end
      end
    end

    context "and when an index Integer and a length Integer is given" do
      let(:index)  { 1 }
      let(:length) { 3 }

      context "and a String value" do
        let(:value) { 'A' * length }

        before { subject[index,length] = value }

        it "must copy the String value into the String at the given index" do
          expect(subject.string[index,length]).to eq(value)
        end
      end
    end

    context "and when an Integer and a length of Float::INFINITY is given" do
      let(:index) { 1 }
      let(:count) { string.length - index }
      let(:chars) { 'A' * count }

      before { subject[index,Float::INFINITY] = chars }

      it "must overwrite the bytes starting at the index and to the end of the string" do
        expect(subject.string[index,count]).to eq(chars)
      end

      context "but when the underlying string has grown in length" do
        let(:new_string) { " AAAA" }

        it "must overwrite the bytes starting at the index and to the end of the string" do
          expect(subject.string[index,count]).to eq(chars)
          expect(subject[index,count]).to eq(string[index,subject.size-index])

          string << new_string
          subject[index,Float::INFINITY] = chars

          expect(subject.string[index,count]).to eq(chars)
        end
      end
    end

    context "when given a Range argument" do
      let(:range) { (1..3) }

      context "when a String value" do
        let(:value) { 'A' * range.count }

        before { subject[range] = value }

        it "must copy the String value into the String at the range of indexes" do
          expect(subject.string[range]).to eq(value)
        end
      end
    end
  end

  describe "#byteslice" do
    let(:memory) { described_class.new(string) }

    let(:offset) { 4 }
    let(:length) { 3 }

    subject { memory.byteslice(offset,length) }

    it "must return a new Ronin::Support::Binary::ByteSlice" do
      expect(subject).to be_kind_of(Ronin::Support::Binary::ByteSlice)
    end

    it "must set the new ByteSlice's #offset to the given offset" do
      expect(subject.offset).to eq(offset)
    end

    it "must set the new ByteSlice's #length" do
      expect(subject.length).to eq(length)
    end
  end

  describe "#clear" do
    let(:size)   { 10 }
    let(:string) { 'A' * size }

    subject { described_class.new(string) }

    it "must set every byte in the underlying String to 0" do
      subject.clear

      expect(string).to eq("\0" * size)
    end

    it "must return self" do
      expect(subject.clear).to be(subject)
    end
  end

  describe "#pack" do
    context "when #string is a String" do
      subject { described_class.new(string) }

      it "must return #string" do
        expect(subject.pack).to eq(subject.string)
      end
    end

    context "when #string is a Ronin::Support::Binary::ByteSlice" do
      let(:byte_slice) do
        Ronin::Support::Binary::ByteSlice.new(string, offset: 4,
                                                      length: 3)
      end

      subject { described_class.new(byte_slice) }

      it "must return #string as a String" do
        expect(subject.pack).to eq(byte_slice.to_s)
      end
    end
  end

  describe "#size" do
    it "must return the byte size of the underlying string" do
      expect(subject.size).to eq(string.bytesize)
    end

    context "but when the underlying string has grown in length" do
      let(:new_string) { " AAAA" }

      before { string << new_string }

      it "must return the new byte size of the underlying string" do
        previous_bytesize = string.bytesize

        string << new_string

        expect(subject.size).to be > previous_bytesize
      end
    end
  end

  describe "#read_from" do
    let(:size) { 10 }

    subject { described_class.new(size) }

    let(:new_buffer) { "0123456789" }
    let(:io) { StringIO.new("#{new_buffer}AAAAA") }

    it "must read #size bytes from the given IO object" do
      subject.read_from(io)

      expect(io.pos).to eq(subject.size)
    end

    it "must copy the read data into the underlying string" do
      subject.read_from(io)

      expect(subject.string).to_not be(new_buffer)
      expect(subject.string).to eq(new_buffer)
    end
  end

  describe "#to_s" do
    it "must call #pack" do
      expect(subject.to_s).to eq(subject.pack)
    end
  end

  describe "#to_str" do
    context "when #string is a String" do
      subject { described_class.new(string) }

      it "must return #string" do
        expect(subject.to_str).to eq(subject.string)
      end
    end

    context "when #string is a Ronin::Support::Binary::ByteSlice" do
      let(:byte_slice) do
        Ronin::Support::Binary::ByteSlice.new(string, offset: 4,
                                                      length: 3)
      end

      subject { described_class.new(byte_slice) }

      it "must return #string as a String" do
        expect(subject.to_str).to eq(byte_slice.to_s)
      end
    end
  end
end
