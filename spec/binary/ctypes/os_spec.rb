require 'spec_helper'
require 'ronin/support/binary/ctypes/os'
require 'ronin/support/binary/ctypes/arch/arm64'
require 'ronin/support/binary/ctypes/array_type'

describe Ronin::Support::Binary::CTypes::OS do
  let(:types) { Ronin::Support::Binary::CTypes::Arch::ARM64 }

  subject { described_class.new(types) }

  describe "#initialize" do
    it "must set #types" do
      expect(subject.types).to be(types)
    end

    it "must initialize #typedefs to {}" do
      expect(subject.typedefs).to eq({})
    end
  end

  describe "#[]" do
    context "when a base type name is given" do
      let(:name) { :uint32 }

      it "must return the type from the #types module" do
        expect(subject[name]).to eq(types[name])
      end

      context "but it was previously overridden by another typedef" do
        let(:name) { :long }

        before { subject.typedef :int32, name }

        it "must return the new type from #typedefs" do
          expect(subject[name]).to eq(subject.typedefs[name])
        end
      end
    end

    context "when a typedef name is given" do
      let(:name) { :foo_t }

      before { subject.typedef(:uint, name) }

      it "must return the typedef from #typedefs" do
        expect(subject[name]).to eq(subject.typedefs[name])
      end
    end
  end

  describe "#typedef" do
    context "when given a Symbol" do
      let(:type)     { :int   }
      let(:new_name) { :foo_t }

      before { subject.typedef(type, new_name) }

      it "must resolve the type and add it to #typedefs with the new name" do
        expect(subject.typedefs[new_name]).to eq(types[type])
      end
    end

    context "when given a Type object" do
      let(:type) do
        Ronin::Support::Binary::CTypes::ArrayType.new(types::UCHAR,4)
      end
      let(:new_name) { :foo_t }

      before { subject.typedef(type, new_name) }

      it "must add the Type object to #typedefs with the new name" do
        expect(subject.typedefs[new_name]).to eq(type)
      end
    end

    context "when given another kind of Object" do
      let(:object) { Object.new }

      it do
        expect {
          subject.typedef(object,:int)
        }.to raise_error(ArgumentError,"type must be either a Symbol or a #{Ronin::Support::Binary::CTypes::Type}: #{object.inspect}")
      end
    end
  end
end
