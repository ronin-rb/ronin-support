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

  describe "#to_s" do
    context "when #string is a String" do
      subject { described_class.new(string) }

      it "must return #string" do
        expect(subject.to_s).to eq(subject.string)
      end
    end

    context "when #string is a Ronin::Support::Binary::ByteSlice" do
      let(:byte_slice) do
        Ronin::Support::Binary::ByteSlice.new(string, offset: 4,
                                                      length: 3)
      end

      subject { described_class.new(byte_slice) }

      it "must return #string as a String" do
        expect(subject.to_s).to eq(byte_slice.to_s)
      end
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
