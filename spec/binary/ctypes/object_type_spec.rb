require 'spec_helper'
require 'ronin/support/binary/ctypes/object_type'

describe Ronin::Support::Binary::CTypes::ObjectType do
  let(:size) { 42 }

  subject { described_class.new(size) }

  describe "#initialize" do
    it "must set #size" do
      expect(subject.size).to eq(size)
    end

    it "must set #pack_string to 'a\#{size}'" do
      expect(subject.pack_string).to eq("a#{size}")
    end

    context "when the given size is Float::INFINITY" do
      let(:size) { Float::INFINITY }

      it "must set #pack_string to 'a*'" do
        expect(subject.pack_string).to eq('a*')
      end
    end
  end

  describe "#size" do
    it "must return the size of the memory mapped type" do
      expect(subject.size).to eq(size)
    end
  end
end
