require 'spec_helper'
require 'ronin/support/binary/ctypes/mixin'

describe Ronin::Support::Binary::CTypes::Mixin do
  let(:test_class) do
    Class.new do
      include Ronin::Support::Binary::CTypes::Mixin

      def initialize(**kwargs)
        initialize_type_system(**kwargs)
      end
    end
  end

  describe "#initialize_type_system" do
    context "when the endian: keyword argument is given" do
      let(:endian) { :little }

      subject { test_class.new(endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to be(endian)
      end

      it "must set #type_system using Ronin::Support::Binary::CTypes.platform(endian: ...)" do
        expect(subject.type_system).to be(
          Ronin::Support::Binary::CTypes.platform(endian: endian)
        )
      end
    end

    context "when the arch: keyword argument is given" do
      let(:arch) { :x86 }

      subject { test_class.new(arch: arch) }

      it "must set #arch" do
        expect(subject.arch).to be(arch)
      end

      it "must set #type_system using Ronin::Support::Binary::CTypes.platform(arch: ...)" do
        expect(subject.type_system).to be(
          Ronin::Support::Binary::CTypes.platform(arch: arch)
        )
      end
    end

    context "when the os: keyword argument is given" do
      let(:os) { :linux }

      subject { test_class.new(os: os) }

      it "must set #os" do
        expect(subject.os).to be(os)
      end

      it "must set #type_system using Ronin::Support::Binary::CTypes.platform(arch: ...)" do
        expect(subject.type_system).to be_kind_of(
          Ronin::Support::Binary::CTypes::OS::Linux
        )
        expect(subject.type_system.types).to be(Ronin::Support::Binary::CTypes)
      end
    end

    context "when given no keyword arguments" do
      subject { test_class.new }

      it "must default #endian to nil" do
        expect(subject.endian).to be(nil)
      end

      it "must default #arch to nil" do
        expect(subject.arch).to be(nil)
      end

      it "must default #type_system to Ronin::Support::Binary::CTypes" do
        expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
      end
    end
  end
end
