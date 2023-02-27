require 'spec_helper'
require 'ronin/support/network/public_suffix/suffix'

describe Ronin::Support::Network::PublicSuffix::Suffix do
  let(:name) { 'com' }

  subject { described_class.new(name) }

  describe "#initialize" do
    it "must set #name" do
      expect(subject.name).to eq(name)
    end

    it "must default #type to :icann" do
      expect(subject.type).to be(:icann)
    end

    context "when the :type keyword argument is given" do
      let(:type) { :private }

      subject { described_class.new(name, type: type) }

      it "must set #type" do
        expect(subject.type).to eq(type)
      end
    end
  end

  describe "#icann?" do
    subject { described_class.new(name, type: type) }

    context "when #type is :icann" do
      let(:type) { :icann }

      it "must return true" do
        expect(subject.icann?).to be(true)
      end
    end

    context "when #type is not :icann" do
      let(:type) { :private }

      it "must return false" do
        expect(subject.icann?).to be(false)
      end
    end
  end

  describe "#private?" do
    subject { described_class.new(name, type: type) }

    context "when #type is :private" do
      let(:type) { :private }

      it "must return true" do
        expect(subject.private?).to be(true)
      end
    end

    context "when #type is not :private" do
      let(:type) { :icann }

      it "must return false" do
        expect(subject.private?).to be(false)
      end
    end
  end

  describe "#wildcard?" do
    context "when the suffix name does not contina a '*' character" do
      it "must return false" do
        expect(subject.wildcard?).to be(false)
      end
    end

    context "when the suffix name does contina a '*' character" do
      let(:name) { '*.static.cloud' }

      it "must return true" do
        expect(subject.wildcard?).to be(true)
      end
    end
  end

  describe "#non_wildcard?" do
    context "when the suffix name does not contina a '*' character" do
      it "must return true" do
        expect(subject.non_wildcard?).to be(true)
      end
    end

    context "when the suffix name does contina a '*' character" do
      let(:name) { '*.static.cloud' }

      it "must return false" do
        expect(subject.non_wildcard?).to be(false)
      end
    end
  end

  describe "#==" do
    context "when given another #{described_class} object" do
      let(:name) { 'com'  }
      let(:type) { :icann }

      let(:other_name) { name }
      let(:other_type) { type }
      let(:other) do
        described_class.new(other_name, type: other_type)
      end

      context "but the #name attributes are different" do
        let(:other_name) { 'xyz' }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the #type attributes are different" do
        let(:type) { :private }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end
    end

    context "when given an Object" do
      let(:other) { Object.new }

      it "must return false" do
        expect(subject == other).to eq(false)
      end
    end
  end

  describe "#to_s" do
    it "must return the #name" do
      expect(subject.to_s).to eq(name)
    end
  end
end
