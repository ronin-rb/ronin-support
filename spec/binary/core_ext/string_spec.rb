require 'spec_helper'
require 'ronin/support/binary/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#unpack_original" do
    expect(subject).to respond_to(:unpack_original)
  end

  describe "#unpack" do
    subject { "\x34\x12\x00\x00hello\0" }

    let(:unpacked_values) { [0x1234, "hello"] }

    context "when given only a String" do
      it "must unpack Strings using String#unpack template Strings" do
        expect(subject.unpack('VZ*')).to eq(unpacked_values)
      end
    end

    context "otherwise" do
      it "must unpack Strings using Ronin::Support::Binary::Template" do
        expect(subject.unpack(:uint32_le, :string)).to eq(unpacked_values)
      end
    end
  end

  it "must provide String#unpack1_original" do
    expect(subject).to respond_to(:unpack1_original)
  end

  describe "#unpack1" do
    subject { "\x34\x12\x00\x00" }

    let(:unpacked_value) { 0x1234 }

    context "when given only a String" do
      it "must unpack Strings using the original String#unpack1 method" do
        expect(subject.unpack1('V')).to eq(unpacked_value)
      end
    end

    context "when given a Symbol" do
      it "must unpack Strings using Ronin::Support::Binary::CTypes type" do
        expect(subject.unpack1(:uint32_le)).to eq(unpacked_value)
      end

      context "but the Symbol is an unknown type" do
        let(:type) { :foo }

        it do
          expect {
            subject.unpack1(type)
          }.to raise_error(ArgumentError,"unknown type: #{type.inspect}")
        end
      end
    end

    context "when given another type of Object" do
      let(:type) { Object.new }

      it do
        expect {
          subject.unpack1(type)
        }.to raise_error(ArgumentError,"argument must be either a String or a Symbol: #{type.inspect}")
      end
    end
  end
end
