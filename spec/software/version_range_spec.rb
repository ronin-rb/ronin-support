require 'spec_helper'
require 'ronin/support/software/version_range'

describe Ronin::Support::Software::VersionRange do
  let(:constraint1) { '>= 1.2.3' }
  let(:constraint2) { '< 2.0.0' }
  let(:string)      { "#{constraint1}, #{constraint2}" }

  subject { described_class.new(string) }

  describe "#initialize" do
    it "must set #string to the given version range string" do
      expect(subject.string).to eq(string)
    end

    it "must parse and populate #constraints" do
      expect(subject.constraints).to be_kind_of(Array)
      expect(subject.constraints.length).to eq(2)
      expect(subject.constraints[0]).to be_kind_of(Ronin::Support::Software::VersionConstraint)
      expect(subject.constraints[0].string).to eq(constraint1)
      expect(subject.constraints[1]).to be_kind_of(Ronin::Support::Software::VersionConstraint)
      expect(subject.constraints[1].string).to eq(constraint2)
    end
  end

  describe ".parse" do
    subject { described_class.parse(string) }

    it "must return a new #{described_class} with the given version range string" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.string).to eq(string)
    end
  end

  describe "#include?" do
    context "when the given version satisfies all of the version constraints" do
      let(:other_version) do
        Ronin::Support::Software::Version.new('1.10.0')
      end

      it "must return true" do
        expect(subject.include?(other_version)).to be(true)
      end
    end

    context "when the given version does not satisfy all of the version constraints" do
      let(:other_version) do
        Ronin::Support::Software::Version.new('2.0.1')
      end

      it "must return false" do
        expect(subject.include?(other_version)).to be(false)
      end
    end
  end

  describe "#==" do
    context "when given another #{described_class}" do
      context "and all of the other #constraints are equal" do
        let(:other) { described_class.new(string) }

        it "must return true" do
          expect(subject == other).to be(true)
        end
      end

      context "but one of the constraints is different" do
        let(:other_constraint1) { constraint1 }
        let(:other_constraint2) { '< 2.0.1' }
        let(:other_string)      { "#{other_constraint1}, #{other_constraint2}" }
        let(:other)             { described_class.new(other_string) }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the other #{described_class} has fewer version constraints" do
        let(:other_string) { ">= 1.2.3" }
        let(:other)        { described_class.new(other_string) }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end
    end

    context "when given another kind of object" do
      let(:other) { Object.new }

      it "must return false" do
        expect(subject == other).to be(false)
      end
    end
  end
end
