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
end
