require 'spec_helper'
require 'ronin/support/binary/byte_slice'

describe Ronin::Support::Binary::ByteSlice do
  let(:string) { "foo bar baz qux" }
  let(:offset) { 4 }
  let(:length) { 7 }

  describe "#initialize" do
    context "when given a String" do
      subject { described_class.new(string, offset: offset, length: length) }

      it "must set #string to the given string" do
        expect(subject.string).to be(string)
      end

      it "must set #offset to the given offet" do
        expect(subject.offset).to eq(offset)
      end

      it "must set #length to the given length" do
        expect(subject.length).to eq(length)
      end

      context "but the offset is negative" do
        let(:offset) { -1 }

        it do
          expect {
            described_class.new(string, offset: offset, length: length)
          }.to raise_error(IndexError,"offset #{offset} or length #{length} is out of bounds: 0...#{string.length}")
        end
      end

      context "but the offset is out of bounds" do
        let(:offset) { string.length }

        it do
          expect {
            described_class.new(string, offset: offset, length: length)
          }.to raise_error(IndexError,"offset #{offset} or length #{length} is out of bounds: 0...#{string.length}")
        end
      end

      context "but the offset+length is out of bounds" do
        let(:offset) { string.length - length + 1 }

        it do
          expect {
            described_class.new(string, offset: offset, length: length)
          }.to raise_error(IndexError,"offset #{offset} or length #{length} is out of bounds: 0...#{string.length}")
        end
      end
    end

    context "when given another ByteSlice" do
      let(:byte_slice) do
        described_class.new(string, offset: offset, length: length)
      end

      let(:sub_offset) { 4 }
      let(:sub_length) { 3 }

      subject do
        described_class.new(byte_slice, offset: sub_offset, length: sub_length)
      end

      it "must set #offset to the ByteSlice's #offset + the given offset" do
        expect(subject.offset).to eq(byte_slice.offset + sub_offset)
      end

      it "must set #length to the given length" do
        expect(subject.length).to eq(sub_length)
      end

      context "but the offset is negative" do
        let(:sub_offset) { -1 }

        it do
          expect {
            described_class.new(
              byte_slice, offset: sub_offset, length: sub_length
            )
          }.to raise_error(IndexError,"offset #{sub_offset} or length #{sub_length} is out of bounds: 0...#{length}")
        end
      end

      context "but the offset is out of the ByteSlice's bounds" do
        let(:sub_offset) { length }

        it do
          expect {
            described_class.new(
              byte_slice, offset: sub_offset, length: sub_length
            )
          }.to raise_error(IndexError,"offset #{sub_offset} or length #{sub_length} is out of bounds: 0...#{length}")
        end
      end

      context "but the offset+length is out of the ByteSlice's bounds" do
        let(:sub_offset) { string.length - length + 1 }

        it do
          expect {
            described_class.new(
              byte_slice, offset: sub_offset, length: sub_length
            )
          }.to raise_error(IndexError,"offset #{sub_offset} or length #{sub_length} is out of bounds: 0...#{length}")
        end
      end
    end

    context "when given another kind of Object" do
      let(:object) { Object.new }

      it do
        expect {
          described_class.new(object, offset: offset, length: length)
        }.to raise_error(ArgumentError,"string was not a String or a #{described_class}: #{object.inspect}")
      end
    end
  end

  describe "#[]" do
    context "when initialized with a String" do
      subject { described_class.new(string, offset: offset, length: length) }

      context "when a single Integer is given" do
        let(:index) { 1 }

        it "must add the offset to the index" do
          expect(subject[index]).to eq(string[offset+index])
        end
      end

      context "when index and length Integers are given" do
        let(:index) { 1 }
        let(:count) { 2 }

        it "must add the offset to the index and read length number of chars" do
          expect(subject[index,count]).to eq(string[offset+index,count])
        end
      end

      context "when a Range is given" do
        let(:range) { 1..3 }

        it "must add the offset to the Range's beginning and read till the Range's end" do
          expect(subject[range]).to eq(
            string[offset+range.begin...offset+range.end]
          )
        end
      end
    end

    context "when initialized with a ByteSlice" do
      let(:byte_slice) do
        described_class.new(string, offset: offset, length: length)
      end

      let(:sub_offset) { 4 }
      let(:sub_length) { 3 }

      subject do
        described_class.new(byte_slice, offset: sub_offset, length: sub_length)
      end

      context "when a single Integer is given" do
        let(:index) { 1 }

        it "must add the two offsets to the index" do
          expect(subject[index]).to eq(string[offset+sub_offset+index])
        end
      end

      context "when index and length Integers are given" do
        let(:index) { 1 }
        let(:count) { 2 }

        it "must add the two offsets to the index and read length number of chars" do
          expect(subject[index,count]).to eq(
            string[offset+sub_offset+index,count]
          )
        end
      end

      context "when a Range is given" do
        let(:range)  { (1..3) }

        it "must add the two offsets to the Range's beginning and read till the Range's end" do
          expect(subject[range]).to eq(
            string[offset+sub_offset+range.begin...offset+sub_offset+range.end]
          )
        end
      end
    end
  end

  describe "#[]=" do
    context "when initialized with a String" do
      subject { described_class.new(string, offset: offset, length: length) }

      context "when a single Integer is given" do
        let(:index) { 1   }
        let(:char)  { 'A' }

        before { subject[index] = char }
        
        it "must set the character at that index plus the offset" do
          expect(string[offset+index]).to eq(char)
        end
      end

      context "when index and length Integers are given" do
        let(:index) { 1 }
        let(:count) { 2 }
        let(:chars) { 'A' * count }

        before { subject[index,count] = chars }
        
        it "must set the characters at that index plus the offset" do
          expect(string[offset+index,count]).to eq(chars)
        end
      end

      context "when a Range is given" do
        let(:range) { 1..3 }
        let(:chars) { 'A' * (range.end-range.begin) }

        before { subject[range] = chars }
        
        it "must set the characters between the Range's beginning plus the offset and read till the Range's end plus the offset" do
          expect(string[range.begin+offset,range.end-range.begin]).to eq(chars)
        end
      end
    end

    context "when initialized with a ByteSlice" do
      let(:byte_slice) do
        described_class.new(string, offset: offset, length: length)
      end

      let(:sub_offset) { 4 }
      let(:sub_length) { 3 }

      subject do
        described_class.new(byte_slice, offset: sub_offset, length: sub_length)
      end

      context "when a single Integer is given" do
        let(:index) { 1   }
        let(:char)  { 'A' }

        before { subject[index] = char }
        
        it "must set the character at that the index plus the two offsets" do
          expect(string[offset+sub_offset+index]).to eq(char)
        end
      end

      context "when index and length Integers are given" do
        let(:index) { 1 }
        let(:count) { 2 }
        let(:chars) { 'A' * count }

        before { subject[index,count] = chars }
        
        it "must set the characters at that the index plus the two offsets" do
          expect(string[offset+sub_offset+index,count]).to eq(chars)
        end
      end

      context "when a Range is given" do
        let(:range) { 1..3 }
        let(:chars) { 'A' * (range.end-range.begin) }

        before { subject[range] = chars }
        
        it "must set the characters between the Range's beginning plus the two offsets and read till the Range's end plus the two offsets" do
          expect(string[range.begin+offset+sub_offset,range.end-range.begin]).to eq(chars)
        end
      end
    end
  end

  describe "#byteslice" do
    let(:byte_slice) do
      described_class.new(string, offset: offset, length: length)
    end

    let(:sub_offset) { 4 }
    let(:sub_length) { 3 }

    subject { byte_slice.byteslice(sub_offset,sub_length) }

    it "must return a new #{described_class}" do
      expect(subject).to be_kind_of(described_class)
      expect(subject).to_not be(byte_slice)
    end

    it "must set the new #{described_class}'s #offset to the combination of the previous offset and the new offset" do
      expect(subject.offset).to eq(offset+sub_offset)
    end

    it "must set the new #{described_class}'s #length" do
      expect(subject.length).to eq(sub_length)
    end
  end

  subject { described_class.new(string, offset: offset, length: length) }

  describe "#index" do
    it "must search for the string and return an index relative to the byte slice" do
      char  = subject[3]
      index = subject.index(char)

      expect(subject[index]).to eq(char)
    end

    it "must search for the string starting at the given offset" do
      char  = subject[0]
      index = subject.index(char)

      expect(index).to eq(0)
    end

    context "when an offset argument is given" do
      let(:index_offset) { 1 }

      it "must start searching relative to the given offset" do
        char  = 'b'
        index = subject.index(char,index_offset)

        expect(index).to be > 0
      end
    end

    context "when the search string cannot be found" do
      it "must return nil" do
        expect(subject.index('X')).to be(nil)
      end
    end

    context "when the search string is exists beyond the byte slice's boundaries" do
      it "must return nil" do
        expect(subject.index(string.split.last)).to be(nil)
      end
    end
  end

  describe "#to_s" do
    context "when #offset is 0" do
      let(:offset) { 0 }

      context "and when #length is equal to the #string's length in bytes" do
        let(:length) { string.bytesize }

        it "must return the full #string" do
          expect(subject.to_s).to eq(string)
        end
      end

      context "but #length is less than the #string's length in bytes" do
        let(:length) { string.bytesize - 1 }

        it "must return the substring starting at 0 of #length bytes" do
          expect(subject.to_s).to eq(string[0,length])
        end
      end
    end

    context "when #offset is greater than 0" do
      let(:offset) { 1 }
      let(:length) { string.bytesize - offset - 1 }

      context "and #length is less than the #string's length in bytes" do
        it "must return the substring starting at #offset of #length bytes" do
          expect(subject.to_s).to eq(string[offset,length])
        end
      end
    end
  end

  describe "#to_str" do
    context "when #offset is 0" do
      let(:offset) { 0 }

      context "and when #length is equal to the #string's length in bytes" do
        let(:length) { string.bytesize }

        it "must return the full #string" do
          expect(subject.to_str).to eq(string)
        end
      end

      context "but #length is less than the #string's length in bytes" do
        let(:length) { string.bytesize - 1 }

        it "must return the substring starting at 0 of #length bytes" do
          expect(subject.to_str).to eq(string[0,length])
        end
      end
    end

    context "when #offset is greater than 0" do
      let(:offset) { 1 }
      let(:length) { string.bytesize - offset - 1 }

      context "and #length is less than the #string's length in bytes" do
        it "must return the substring starting at #offset of #length bytes" do
          expect(subject.to_str).to eq(string[offset,length])
        end
      end
    end
  end
end
