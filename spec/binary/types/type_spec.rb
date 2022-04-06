require 'spec_helper'
require 'ronin/support/binary/types/type'

describe Ronin::Support::Binary::Types::Type do
  let(:pack_string) { 'L<'    }

  subject do
    described_class.new(
      pack_string: pack_string
    )
  end

  describe "#initialize" do
    it "must set #pack_string" do
      expect(subject.pack_string).to eq(pack_string)
    end

    context "when the pack_string: keyword is not given" do
      it do
        expect {
          described_class.new()
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#uninitialized_value" do
    it "must return nil by default" do
      expect(subject.uninitialized_value).to be(nil)
    end
  end

  describe "#size" do
    it do
      expect {
        subject.size
      }.to raise_error(NotImplementedError,"#{described_class}#size was not implemented")
    end
  end

  describe "#pack" do
    let(:value) { 0x11223344 }

    it do
      expect {
        subject.pack(value)
      }.to raise_error(NotImplementedError,"#{described_class}#pack was not implemented")
    end
  end

  describe "#unpack" do
    let(:data) { "\x44\x33\x22\x11" }

    it do
      expect {
        subject.unpack(data)
      }.to raise_error(NotImplementedError,"#{described_class}#unpack was not implemented")
    end
  end

  describe "#enqueue_value" do
    let(:values) { [1,2,3] }
    let(:value)  { 42      }

    it do
      expect {
        subject.enqueue_value(values,value)
      }.to raise_error(NotImplementedError,"#{described_class}#enqueue_value was not implemented")
    end
  end

  describe "#dequeue_value" do
    let(:value)  { 42 }
    let(:values) { [value,1,2,3] }

    it do
      expect {
        subject.dequeue_value(values)
      }.to raise_error(NotImplementedError,"#{described_class}#dequeue_value was not implemented")
    end
  end
end
